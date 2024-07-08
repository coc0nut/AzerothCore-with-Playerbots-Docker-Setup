#!/bin/bash

ask_user() {
    read -p "$1 (y/n): " choice
    case "$choice" in
        y|Y ) return 0;;
        * ) return 1;;
    esac
}

git clone https://github.com/liyunfan1223/azerothcore-wotlk.git --branch=Playerbot

if ask_user "Install modules?"; then
    cd azerothcore-wotlk/modules

    git clone https://github.com/liyunfan1223/mod-playerbots.git --branch=master
    git clone https://github.com/azerothcore/mod-aoe-loot.git
    git clone https://github.com/azerothcore/mod-learn-spells.git
    git clone https://github.com/noisiver/mod-junk-to-gold.git

    cd ..
else
    echo "Skipping modules..."
    cd azerothcore-wotlk
fi

base_dir="modules"
destination_dir="data/sql/custom"

world=$destination_dir"/db_world/"
chars=$destination_dir"/db_characters/"
auth=$destination_dir"/db_auth/"

rm -rf $world/*.sql
rm -rf $chars/*.sql
rm -rf $auth/*.sql

sql_dirs=$(find $base_dir -type f -name "*.sql" -exec dirname {} \; | sort -u)

echo "Found SQL directories:"
echo "$sql_dirs"

echo "$sql_dirs" | while read -r dir; do
    echo "Processing directory: $dir"

    last_dir=$(basename "$dir")
    second_last_dir=$(basename "$(dirname "$dir")")

    if [[ "$last_dir" == *"char"* ]] || ([[ "$last_dir" == *"base"* ]] && [[ "$second_last_dir" == *"char"* ]]); then
            echo "Copying SQL files to $destination_dir/db_characters"
            cp $dir/*.sql $chars

    elif [[ "$last_dir" == *"world"* ]] || ([[ "$last_dir" == *"base"* ]] && [[ "$second_last_dir" == *"world"* ]]); then
            echo "Copying SQL files to $destination_dir/db_world"
            cp $dir/*.sql $world
    fi
done

sed -i '52i\      - ./modules:/azerothcore/modules' docker-compose.yml
sed -i '91i\      - ./modules:/azerothcore/modules' docker-compose.yml

docker compose up -d --build
