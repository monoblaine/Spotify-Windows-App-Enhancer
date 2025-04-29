#!/bin/bash

# =================================================================================
# Spotify Windows App Enhancer
# =================================================================================
#
# 1. Changes the font family.
# 2. Adds a keyboard accelerator (End) to context menus with "Add to queue" option.
# 3. Works on v1.2.61.443
# 4. Will break on each update because of the changes in minified code.
# =================================================================================

font_family="Dubuntu Sans"
path_to_spa_folder="$APPDATA\\Spotify\\Apps\\"
spa_file_name="xpui.spa"
spa_folder_name=xpui
css1="pip-mini-player.css"
css2="xpui.css"
js="xpui.js"

search_pattern () {
    pattern=$1
    text=$2
    if [[ -z "$(cat $js | grep "$pattern")" ]]; then
        echo ==============================================================================
        echo $text
        echo ==============================================================================
        read -p "Unable find this text. Should I continue? (Y/N): " confirm &&
        if [[ $confirm != [yY] && $confirm != [yY][eE][sS] ]]; then
            exit 1
        fi
    fi
}

cd "$path_to_spa_folder" &&
cp $spa_file_name $spa_file_name.bak &&
unzip -q $spa_file_name -d $spa_folder_name &&
rm $spa_file_name &&
cd $spa_folder_name &&
perl -0777 -pi -e 's/--encore-body-font-stack:[\w\W]+?;/--encore-body-font-stack:"'"$font_family"'";/g'         "$css1" &&
perl -0777 -pi -e 's/--encore-title-font-stack:[\w\W]+?;/--encore-title-font-stack:"'"$font_family"'";/g'       "$css1" &&
perl -0777 -pi -e 's/--encore-variable-font-stack:[\w\W]+?;/--encore-variable-font-stack:"'"$font_family"'";/g' "$css1" &&
perl -0777 -pi -e 's/font-weight:800;text-wrap:balance/font-weight:400;text-wrap:balance/g'                   "$css1" &&

perl -0777 -pi -e 's/--encore-body-font-stack:[\w\W]+?;/--encore-body-font-stack:"'"$font_family"'";/g'         "$css2" &&
perl -0777 -pi -e 's/--encore-title-font-stack:[\w\W]+?;/--encore-title-font-stack:"'"$font_family"'";/g'       "$css2" &&
perl -0777 -pi -e 's/--encore-variable-font-stack:[\w\W]+?;/--encore-variable-font-stack:"'"$font_family"'";/g' "$css2" &&
perl -0777 -pi -e 's/font-weight:800;text-wrap:balance/font-weight:400;text-wrap:balance/g'                   "$css2" &&

# t===i.O.UP&&(0,r.MS)(o,u(e,o,i.O.UP,n))
# t===i.O.END&&(0,r.MS)(o,u(e,o,i.O.END,n)),t===i.O.UP&&(0,r.MS)(o,u(e,o,i.O.UP,n))
text='t===i.O.UP&&(0,r.MS)(o,u(e,o,i.O.UP,n))' &&
pattern='t===i\.O\.UP&&(0,r\.MS)(o,u(e,o,i\.O\.UP,n))' &&
search_pattern "$pattern" "$text" &&
sed -i 's/'"$pattern"'/t===i.O.END\&\&(0,r.MS)(o,u(e,o,i.O.END,n)),t===i.O.UP\&\&(0,r.MS)(o,u(e,o,i.O.UP,n))/' $js &&

# if(n===i.O.UP){const t=a.querySelectorAll(':scope > li[role="presentation"]');
# if(n===i.O.END)[...a.querySelectorAll(':scope > li[role="presentation"] > button > span')].filter(el=>el.textContent==='Add to queue')[0]?.parentElement.click();else if(n===i.O.UP){const t=a.querySelectorAll(':scope > li[role="presentation"]');
text='if(n===i.O.UP){const t=a.querySelectorAll('\'':scope > li[role="presentation"]'\'');' &&
pattern='if(n===i.O.UP){const t=a.querySelectorAll('\'':scope > li\[role="presentation"]'\'');' &&
search_pattern "$pattern" "$text" &&
sed -i 's/'"$pattern"'/if(n===i.O.END)[...a.querySelectorAll('\'':scope > li[role="presentation"] > button > span'\'')].filter(el=>el.textContent==='\''Add to queue'\'')[0]?.parentElement.click();else if(n===i.O.UP){const t=a.querySelectorAll('\'':scope > li[role="presentation"]'\'');/' $js &&

# f.current?.contains(e.target)&&("ArrowUp"!==e.key
# f.current?.contains(e.target)&&("End"!==e.key&&"ArrowUp"!==e.key
text='f.current?.contains(e.target)&&("ArrowUp"!==e.key' &&
pattern='f\.current?\.contains(e\.target)&&("ArrowUp"!==e\.key' &&
search_pattern "$pattern" "$text" &&
sed -i 's/'"$pattern"'/f.current?.contains(e.target)\&\&("End"!==e.key\&\&"ArrowUp"!==e.key/' $js &&

# ,"ArrowRight"===e.key&&(0,a.YR)(f.current,r.O.RIGHT)
# ,"ArrowRight"===e.key&&(0,a.YR)(f.current,r.O.RIGHT),"End"===e.key&&(0,a.YR)(f.current,r.O.END)
text=',"ArrowRight"===e.key&&(0,a.YR)(f.current,r.O.RIGHT)' &&
pattern=',"ArrowRight"===e\.key&&(0,a\.YR)(f\.current,r\.O\.RIGHT)' &&
search_pattern "$pattern" "$text" &&
sed -i 's/'"$pattern"'/,"ArrowRight"===e.key\&\&(0,a.YR)(f.current,r.O.RIGHT),"End"===e.key\&\&(0,a.YR)(f.current,r.O.END)/' $js &&

"${PROGRAMFILES//\\/\/}/7-Zip/7z.exe" a -r -mx5 -tzip ../xpui.spa * &&
cd .. &&
rm -rf $spa_folder_name
