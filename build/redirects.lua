-- build/redirects.lua
-- Generates redirects for blog posts and categories
local system = require("pandoc.system")

-- Helper function for debugging
local function debug_log(message)
    print("[Redirects Debug] " .. message)
end

-- Helper function to check if a path is a directory
local function is_dir(path)
    debug_log("Checking if directory exists: " .. path)
    local handle = io.popen('[ -d "' .. path .. '" ] && echo "yes" || echo "no"')
    local result = handle:read("*a"):gsub("%s+", "")
    handle:close()
    return result == "yes"
end

-- Helper function to check if a file exists
local function file_exists(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        return true
    end
    return false
end

-- Helper function to read lines from a file
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

-- Extract categories from a blog post
local function extract_categories(post_path)
    local qmd_path = post_path .. "/index.qmd"
    if not file_exists(qmd_path) then
        debug_log("Blog post QMD not found: " .. qmd_path)
        return {}
    end
    local content = read_lines(qmd_path)
    local categories = {}
    for _, line in ipairs(content) do
        local cat_match = line:match("^categories:%s*%[(.+)%]")
        if cat_match then
            for cat in cat_match:gmatch("([^,]+)") do
                -- Trim whitespace
                cat = cat:gsub("^%s*(.-)%s*$", "%1")
                table.insert(categories, cat)
            end
            break
        end
    end
    return categories
end

function Pandoc(doc)
    debug_log("Starting redirect generation...")

    -- Get correct absolute paths
    local project_root = system.get_working_directory()
    debug_log("Working directory: " .. project_root)

    -- Check if we're in a Netlify environment and adjust paths if needed
    local netlify_build_dir = os.getenv("NETLIFY") and os.getenv("NETLIFY_BUILD_BASE")
    if netlify_build_dir then
        debug_log("Running in Netlify environment: " .. netlify_build_dir)
        -- Additional path adjustment logic can go here if needed
    end

    local blog_dir = project_root .. "/blog"
    debug_log("Blog directory path: " .. blog_dir)

    if not is_dir(blog_dir) then
        debug_log("Blog directory not found, skipping redirect generation")
        return doc
    end

    local redirects = {}
    local all_categories = {}
    local category_count = 0

    -- Try both possible locations for manual redirects
    local manual_redirects = {}
    local manual_paths = {
        project_root .. "/assets/_manualredirects",
        project_root .. "/build/_manualredirects"
    }

    for _, path in ipairs(manual_paths) do
        if file_exists(path) then
            debug_log("Found manual redirects at: " .. path)
            manual_redirects = read_lines(path)
            break
        end
    end

    for _, line in ipairs(manual_redirects) do
        table.insert(redirects, line)
    end
    debug_log("Added " .. #manual_redirects .. " manual redirects")

    -- Generate blog post redirects and collect categories
    debug_log("Looking for blog posts in: " .. blog_dir)
    local blog_posts = {}

    -- Use 2-step approach to list directories for better compatibility
    local dir_cmd = 'find "' .. blog_dir .. '" -maxdepth 1 -mindepth 1 -type d'
    debug_log("Running directory listing command: " .. dir_cmd)

    local handle = io.popen(dir_cmd)
    for post_path in handle:lines() do
        local post_name = post_path:match("([^/]+)$")
        debug_log("Found potential blog post: " .. (post_name or "unnamed"))

        -- Skip directories that don't match our date pattern
        if post_name and post_name:match("^%d%d%d%d%-%d%d%-%d%d%-") then
            local title_slug = post_name:gsub("^%d%d%d%d%-%d%d%-%d%d%-", "")
            local old = "/blog/" .. title_slug
            local new = "/blog/" .. post_name

            table.insert(redirects, old .. " " .. new)
            table.insert(blog_posts, post_path)
            debug_log("Added redirect: " .. old .. " → " .. new)

            -- Extract categories
            local post_categories = extract_categories(post_path)
            for _, cat in ipairs(post_categories) do
                debug_log("Found category: " .. cat)
                if not all_categories[cat] then
                    all_categories[cat] = true
                    category_count = category_count + 1
                end
            end
        end
    end
    handle:close()

    -- Generate category redirects
    debug_log("Generating " .. category_count .. " category redirects")
    for category, _ in pairs(all_categories) do
        local encoded_category = category:gsub(" ", "%%20")
        local tag = category:lower():gsub(" ", "-")
        table.insert(redirects, "/tags/" .. tag .. " " .. "/blog/#category=" .. encoded_category)
        debug_log("Added category redirect: /tags/" .. tag)
    end

    -- Write _redirects file
    local out_file = project_root .. "/_redirects"
    debug_log("Writing redirects to: " .. out_file)

    local f = io.open(out_file, "w")
    if f then
        for _, line in ipairs(redirects) do
            f:write(line .. "\n")
        end
        f:close()
        debug_log("Successfully wrote " .. #redirects .. " redirects")
    else
        debug_log("ERROR: Could not open output file for writing: " .. out_file)
    end

    debug_log("Redirect generation complete")
    print("✅ Redirects written to _redirects (" ..
        #redirects ..
        " entries, " ..
        #blog_posts .. " posts, " .. #manual_redirects .. " manual, " .. category_count .. " categories)")

    return doc
end
