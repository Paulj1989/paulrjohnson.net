-- build/redirects.lua
-- Generates redirects for blog posts and categories
local system = require("pandoc.system")
-- Helper function to check if a path is a directory
local function is_dir(path)
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
    if not file_exists(file_path) then
        return {}
    end
    local lines = {}
    local file = io.open(file_path, "r")
    for line in file:lines() do
        table.insert(lines, line)
    end
    file:close()
    return lines
end

-- Extract categories from a blog post
local function extract_categories(post_path)
    local qmd_path = post_path .. "/index.qmd"
    if not file_exists(qmd_path) then
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
    local project_root = system.get_working_directory()
    local blog_dir = project_root .. "/blog"
    if not is_dir(blog_dir) then
        print("🔁 Redirect generation skipped: no 'blog' folder found.")
        return doc
    end

    local redirects = {}
    local all_categories = {}
    local category_count = 0

    -- Read manual redirects
    local manual_redirects = read_lines(project_root .. "/build/_manualredirects")
    for _, line in ipairs(manual_redirects) do
        table.insert(redirects, line)
    end

    -- Generate blog post redirects and collect categories
    local handle = io.popen('find "' .. blog_dir .. '" -type d -depth 1')
    local blog_posts = {}
    for post_path in handle:lines() do
        local post_name = post_path:match("([^/]+)$")
        -- Skip index.qmd and _metadata.yml by checking if it's a proper post
        if post_name and post_name:match("^%d%d%d%d%-%d%d%-%d%d%-") then
            local title_slug = post_name:gsub("^%d%d%d%d%-%d%d%-%d%d%-", "")
            local old = "/blog/" .. title_slug
            local new = "/blog/" .. post_name
            table.insert(redirects, old .. " " .. new)
            table.insert(blog_posts, post_path)

            -- Extract categories
            local post_categories = extract_categories(post_path)
            for _, cat in ipairs(post_categories) do
                if not all_categories[cat] then
                    all_categories[cat] = true
                    category_count = category_count + 1
                end
            end
        end
    end
    handle:close()

    -- Generate category redirects
    for category, _ in pairs(all_categories) do
        local encoded_category = category:gsub(" ", "%%20")
        local tag = category:lower():gsub(" ", "-")
        table.insert(redirects, "/tags/" .. tag .. " " .. "/blog/#category=" .. encoded_category)
    end

    -- Write _redirects file
    local out_file = project_root .. "/_redirects"
    local f = io.open(out_file, "w")
    for _, line in ipairs(redirects) do
        f:write(line .. "\n")
    end
    f:close()

    print("✅ Redirects written to _redirects (" ..
        #redirects ..
        " entries, " ..
        #blog_posts .. " posts, " .. #manual_redirects .. " manual, " .. category_count .. " categories)")
    return doc
end
