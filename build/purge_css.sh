#!/bin/bash
# purge_css.sh
if [[ -z "$QUARTO_PROJECT_RENDER_ALL" ]]; then
exit
fi

echo "$(date +'%Y-%m-%dT%H:%M:%S') - $0 - CSS purge and minification..."

# CSS purging with local purgecss
mkdir -p ./temp_purgecss
find ./_site -type f -name "*.css" \
-exec echo {} \; \
-exec npx purgecss --css {} --content "./_site/**/*.js" "./_site/**/*.html" -o ./temp_purgecss \; \
-exec bash -c ' mv "./temp_purgecss/`basename {}`" "`dirname {}`" ' \;
rmdir ./temp_purgecss

# Minification of JS files with local uglify-js
find ./_site -type f \
-name "*.js" ! -name "*.min.*" ! -name "vfs_fonts*" \
-exec echo {} \; \
-exec npx uglifyjs -o {}.min {} \; \
-exec rm {} \; \
-exec mv {}.min {} \;

# Minification of CSS files with local uglifycss
find ./_site -type f \
-name "*.css" ! -name "*.min.*" \
-exec echo {} \; \
-exec npx uglifycss --output {}.min {} \; \
-exec rm {} \; \
-exec mv {}.min {} \;

echo "$(date +'%Y-%m-%dT%H:%M:%S') - $0 - End."
