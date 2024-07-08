#!/bin/bash

ask_user() {
    read -p "$1 (y/n): " choice
    case "$choice" in
        y|Y ) return 0;;
        * ) return 1;;
    esac
}

if ask_user "Download and install AzerothCore Playerbots? (Skip if you only want to install modules.)"; then

    git clone https://github.com/liyunfan1223/azerothcore-wotlk.git --branch=Playerbot
    cp src/.env azerothcore-wotlk/
    cp src/*.yml azerothcore-wotlk/
    cd azerothcore-wotlk/modules
    git clone https://github.com/liyunfan1223/mod-playerbots.git --branch=master
    cd ..

else
    if [ -d "azerothcore-wotlk" ]; then
        cp src/.env azerothcore-wotlk/
        cp src/*.yml azerothcore-wotlk/
        cd azerothcore-wotlk
    else
        echo "You need to install AzerothCore! Aborting..."
        exit 1
    fi
fi

if ask_user "Install modules?"; then

    cd modules

    install_mod() {
    local mod_name=$1
    local repo_url=$2

    if [ -d "${mod_name}" ]; then
        echo "${mod_name} exists. Skipping..."
    else
        if ask_user "Install ${mod_name}?"; then
            git clone "${repo_url}"
        fi
    fi
    }

    install_mod "mod-aoe-loot" "https://github.com/azerothcore/mod-aoe-loot.git"
    install_mod "mod-learn-spells" "https://github.com/azerothcore/mod-learn-spells.git"
    install_mod "mod-premium" "https://github.com/azerothcore/mod-premium.git"
    install_mod "mod-fireworks-on-level" "https://github.com/azerothcore/mod-fireworks-on-level.git"

    cd ..

fi

base_dir="modules"
destination_dir="data/sql/custom"

world=$destination_dir"/db_world/"
chars=$destination_dir"/db_characters/"
auth=$destination_dir"/db_auth/"

sql_dirs=$(find $base_dir -type f -name "*.sql" -exec dirname {} \; | sort -u)

echo "Found SQL directories:"
echo "$sql_dirs"

echo "$sql_dirs" | while read -r dir; do
    echo "Processing directory: $dir"

    last_dir=$(basename "$dir")
    second_last_dir=$(basename "$(dirname "$dir")")

    if [[ "$last_dir" == *"char"* ]] || ([[ "$last_dir" == *"base"* ]] && [[ "$second_last_dir" == *"char"* ]]); then
        echo "Copying SQL files to $destination_dir/db_characters"
        for file in $dir/*.sql; do
            if [[ ! -f "$chars/$(basename "$file")" ]]; then
                cp "$file" "$chars"
            else
                echo "File exists in $world, skipping $(basename "$file")"
            fi
        done

    elif [[ "$last_dir" == *"world"* ]] || ([[ "$last_dir" == *"base"* ]] && [[ "$second_last_dir" == *"world"* ]]); then
        echo "Copying SQL files to $destination_dir/db_world"
        for file in $dir/*.sql; do
            if [[ ! -f "$world/$(basename "$file")" ]]; then
                cp "$file" "$world"
            else
                echo "File exists in $world, skipping $(basename "$file")"
            fi
        done
    fi
done

docker compose up -d --build


exit 0