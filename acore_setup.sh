#!/bin/bash

function ask_user() {
    read -p "$1 (y/n): " choice
    case "$choice" in
        y|Y ) return 0;;
        * ) return 1;;
    esac
}

sed -i "s|^TZ=.*$|TZ=$(cat /etc/timezone)|" src/.env

if [ -d "azerothcore-wotlk" ]; then
    cp src/.env azerothcore-wotlk/
    cp src/*.yml azerothcore-wotlk/
    cd azerothcore-wotlk
    if [ ! -d "wotlk" ]; then 
        mkdir -p wotlk/etc
    fi
else
    if ask_user "Download and install AzerothCore Playerbots?"; then
        git clone https://github.com/liyunfan1223/azerothcore-wotlk.git --branch=Playerbot
        cp src/.env azerothcore-wotlk/
        cp src/*.yml azerothcore-wotlk/
        cd azerothcore-wotlk/modules
        git clone https://github.com/liyunfan1223/mod-playerbots.git --branch=master
        cd ..
        if [ ! -d "wotlk" ]; then 
            mkdir -p wotlk/etc
        fi
    else
        echo "Aborting..."
        exit 1
    fi
fi

if ask_user "Install modules?"; then

    cd modules

    function install_mod() {
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
        echo "Copying SQL files to $chars"
        for file in $dir/*.sql; do
            if [[ ! -f "$chars/$(basename "$file")" ]]; then
                cp "$file" "$chars"
            else
                echo "skipping $(basename "$file"), file exists in $chars."
            fi
        done

    elif [[ "$last_dir" == *"world"* ]] || ([[ "$last_dir" == *"base"* ]] && [[ "$second_last_dir" == *"world"* ]]); then
        echo "Copying SQL files to $world"
        for file in $dir/*.sql; do
            if [[ ! -f "$world/$(basename "$file")" ]]; then
                cp "$file" "$world"
            else
                echo "skipping $(basename "$file"), file exists in $world."
            fi
        done
    fi
done

docker compose up -d --build

cd ..

# Directory for custom SQL files
custom_sql_dir="src/sql"
auth="acore_auth"
world="acore_world"
chars="acore_characters"

ip_address=$(hostname -I | awk '{print $1}')

# Temporary SQL file
temp_sql_file="/tmp/temp_custom_sql.sql"

# Function to execute SQL files with IP replacement
function execute_sql() {
    local db_name=$1
    local sql_files=("$custom_sql_dir/$db_name"/*.sql)

    if [ -e "${sql_files[0]}" ]; then
        for custom_sql_file in "${sql_files[@]}"; do
            echo "Executing $custom_sql_file"
            temp_sql_file=$(mktemp)
            if [[ "$(basename "$custom_sql_file")" == "update_realmlist.sql" ]]; then
                sed -e "s/{{IP_ADDRESS}}/$ip_address/g" "$custom_sql_file" > "$temp_sql_file"
            else
                cp "$custom_sql_file" "$temp_sql_file"
            fi
            mysql -h "$ip_address" -uroot -ppassword "$db_name" < "$temp_sql_file"
        done
    else
        echo "No SQL files found in $custom_sql_dir/$db_name, skipping..."
    fi
}

# Run custom SQL files
echo "Running custom SQL files..."
execute_sql "$auth"
execute_sql "$world"
execute_sql "$chars"

# Clean up temporary file
rm "$temp_sql_file"

echo ""
echo "NOTE:"
echo ""
echo "1. Execute 'docker attach ac-worldserver'"
echo "2. 'account create username password' creates an account."
echo "3. 'account set gmlevel username 3 -1' sets the account as gm for all servers."
echo "4. Ctrl+p Ctrl+q will take you out of the world console."
echo "5. Edit your gameclients realmlist.wtf and set it to $ip_address."
echo "6. Now login to wow with 3.3.5a client!"

exit 0
