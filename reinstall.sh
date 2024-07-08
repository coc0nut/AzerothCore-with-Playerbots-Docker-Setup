#!/bin/bash

cd azerothcore-wotlk

ask_user() {
    read -p "$1 (y/n): " choice
    case "$choice" in
        y|Y ) return 0;;
        * ) return 1;;
    esac
}

if ask_user "Stop all AzerothCore containers?"; then

        docker compose down
else
        echo "Skipping compose down..."
fi

if ask_user "System prune docker and delete everything that isnt running?"; then

        docker system prune -a
else
        echo "Skipping system prune..."
fi

if ask_user "Delete the AzerothCore docker volumes?"; then
        docker volume rm azerothcore-wotlk_ac-client-data
        docker volume rm azerothcore-wotlk_ac-database
else
        echo "Skipping volume delete..."
fi

# directories
base_dir="modules"
destination_dir="data/sql/custom"

world=$destination_dir"/db_world/"
chars=$destination_dir"/db_characters/"
auth=$destination_dir"/db_auth/"

if ask_user "Clear the data/sql/custom folders for sql files?"; then
        # clear data/sql/custom/ folders
        rm -rf $world/*.sql
        rm -rf $chars/*.sql
        rm -rf $auth/*.sql
else
        echo "Skipping clearing folder..."
fi

if ask_user "Find all sql files in modules folders and put them in data/sql/custom folders?"; then
        # Find directories containing .sql files in the modules folder
        sql_dirs=$(find $base_dir -type f -name "*.sql" -exec dirname {} \; | sort -u)

        # Print the found directories
        echo "Found SQL directories:"
        echo "$sql_dirs"

        # Iterate over each line in sql_dirs
        echo "$sql_dirs" | while read -r dir;
        do

                echo "Processing directory: $dir"

                # Get the last and second last directory names without the full path
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
else
        echo "Skipping sql copy..."
fi

tree $destination_dir

if ask_user "Rebuild?"; then
        docker compose up -d --build && docker attach ac-worldserver
else
        echo "Skipping build..."
fi
