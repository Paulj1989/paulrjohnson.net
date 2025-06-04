-- build/redirects.lua
-- Generates redirects for blog posts and categories
local system = require("pandoc.system")

-- Toggle for debug output
local DEBUG = false

if not os.getenv("QUARTO_PROJECT_RENDER_ALL") then
    print("Skipping redirects...")
    os.exit()
end

local function debug_log(message)
    if DEBUG then
        io.stderr:write("[Redirects Debug] " .. message .. "\n")
    end
end

local function is_dir(path)
    local handle = io.popen('[ -d "' .. path ..
        '" ] && echo "yes" || echo "no"')
    local result = handle:read("*a"):gsub("%s+", "")
    handle:close()
    return result == "yes"
end

local function file_exists(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        return true
    end
    return false
end

local function read_lines(file_path)
    debug_log("Attempting to read: " .. file_path)
    if not file_exists(file_path) then
        debug_log("File not found: " .. file_path)
        return {}
    end

    local lines = {}
    local file = io.open(file_path, "r")
    for line in file:lines() do
        table.insert(lines, line)
    end
    file:close()
    debug_log("Read " .. #lines .. " lines from: " .. file_path)
    return lines
end

local function extract_categories(post_path)
    local qmd_path = post_path .. "/index.qmd"
    if not file_exists(qmd_path) then
        debug_log("Blog post .qmd not found: " .. qmd_path)
        return {}
    end

    local content = read_lines(qmd_path)
    local categories = {}

    for _, line in ipairs(content) do
        local cat_match = line:match("^categories:%s*%[(.+)%]")
        if cat_match then
            for cat in cat_match:gmatch("([^,]+)") do
                cat = cat:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace
                table.insert(categories, cat)
            end
            break
        end
    end
    return categories
end

local function load_manual_redirects(project_root)
    local manual_paths = {
        project_root .. "/assets/_manualredirects",
        project_root .. "/build/_manualredirects"
    }

    for _, path in ipairs(manual_paths) do
        if file_exists(path) then
            debug_log("Found manual redirects at: " .. path)
            return read_lines(path)
        end
    end
    return {}
end

local function process_blog_posts(blog_dir)
    debug_log("Looking for blog posts in: " .. blog_dir)

    local redirects = {}
    local blog_posts = {}
    local all_categories = {}

    local dir_cmd = 'find "' .. blog_dir ..
        '" -maxdepth 1 -mindepth 1 -type d'
    debug_log("Running directory listing command: " .. dir_cmd)

    local handle = io.popen(dir_cmd)
    for post_path in handle:lines() do
        local post_name = post_path:match("([^/]+)$")
        debug_log("Found potential blog post: " ..
            (post_name or "unnamed"))

        -- Process only directories matching date pattern
        if post_name and post_name:match("^%d%d%d%d%-%d%d%-%d%d%-") then
            local title_slug = post_name:gsub("^%d%d%d%d%-%d%d%-%d%d%-", "")
            local old = "/blog/" .. title_slug
            local new = "/blog/" .. post_name

            table.insert(redirects, old .. " " .. new)
            table.insert(blog_posts, post_path)
            debug_log("Added redirect: " .. old .. " → " .. new)

            -- Collect categories
            local post_categories = extract_categories(post_path)
            for _, cat in ipairs(post_categories) do
                debug_log("Found category: " .. cat)
                all_categories[cat] = true
            end
        end
    end
    handle:close()

    return redirects, blog_posts, all_categories
end

local function generate_category_redirects(all_categories)
    local redirects = {}
    local category_count = 0

    debug_log("Generating category redirects")
    for category, _ in pairs(all_categories) do
        local encoded_category = category:gsub(" ", "%%20")
        local tag = category:lower():gsub(" ", "-")
        table.insert(redirects, "/tags/" .. tag .. " " ..
            "/blog/#category=" .. encoded_category)
        debug_log("Added category redirect: /tags/" .. tag)
        category_count = category_count + 1
    end

    return redirects, category_count
end

local function write_redirects_file(project_root, redirects)
    local out_file = project_root .. "/_redirects"
    debug_log("Writing redirects to: " .. out_file)

    local f = io.open(out_file, "w")
    if f then
        for _, line in ipairs(redirects) do
            f:write(line .. "\n")
        end
        f:close()
        debug_log("Successfully wrote " .. #redirects .. " redirects")
        return true
    else
        io.stderr:write("ERROR: Could not open output file for writing: " ..
            out_file .. "\n")
        return false
    end
end

function Pandoc(doc)
    debug_log("Starting redirect generation...")

    local project_root = system.get_working_directory()
    debug_log("Working directory: " .. project_root)

    -- Check Netlify environment (preserved for potential future use)
    local netlify_build_dir = os.getenv("NETLIFY") and
        os.getenv("NETLIFY_BUILD_BASE")
    if netlify_build_dir then
        debug_log("Running in Netlify environment: " .. netlify_build_dir)
    end

    local blog_dir = project_root .. "/blog"
    debug_log("Blog directory path: " .. blog_dir)

    if not is_dir(blog_dir) then
        debug_log("Blog directory not found, skipping redirect generation")
        return doc
    end

    -- Load manual redirects
    local manual_redirects = load_manual_redirects(project_root)
    debug_log("Added " .. #manual_redirects .. " manual redirects")

    -- Process blog posts
    local post_redirects, blog_posts, all_categories =
        process_blog_posts(blog_dir)

    -- Generate category redirects
    local category_redirects, category_count =
        generate_category_redirects(all_categories)

    -- Combine all redirects
    local all_redirects = {}
    for _, redirect in ipairs(manual_redirects) do
        table.insert(all_redirects, redirect)
    end
    for _, redirect in ipairs(post_redirects) do
        table.insert(all_redirects, redirect)
    end
    for _, redirect in ipairs(category_redirects) do
        table.insert(all_redirects, redirect)
    end

    -- Write redirects file
    if write_redirects_file(project_root, all_redirects) then
        debug_log("Redirect generation complete")
        print("Redirects written to _redirects (" ..
            #all_redirects ..
            " entries, " ..
            #blog_posts .. " posts, " .. #manual_redirects ..
            " manual, " .. category_count .. " categories)")
    end

    return doc
end
