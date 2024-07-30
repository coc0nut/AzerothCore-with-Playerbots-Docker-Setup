#!/bin/bash

read -sp "Enter mysql password: " password
echo ""

function ask_user() {
    read -p "$1 (recover/backup): " choice
    case "$choice" in
        recover|Recover )
        read -p "Enter the date to recover (YYYY-MM-DD): " recover_date
        mysql -h127.0.0.1 -P3306 -uroot -p$password acore_auth < ./sql_dumps/acore_auth/acore_auth-$recover_date.sql
        mysql -h127.0.0.1 -P3306 -uroot -p$password acore_characters < ./sql_dumps/acore_characters/acore_characters-$recover_date.sql
        mysql -h127.0.0.1 -P3306 -uroot -p$password acore_world < ./sql_dumps/acore_world/acore_world-$recover_date.sql
        mysql -h127.0.0.1 -P3306 -uroot -p$password acore_playerbots < ./sql_dumps/acore_playerbots/acore_playerbots-$recover_date.sql
        docker restart ac-worldserver
        ;;
        backup|Backup )
        if [[ ! -d sql_dumps ]]; then
            mkdir -p sql_dumps/acore_auth sql_dumps/acore_characters sql_dumps/acore_world sql_dumps/acore_playerbots    
            mysqldump -h127.0.0.1 -P3306 -uroot -p$password acore_auth > ./sql_dumps/acore_auth/acore_auth-$(date +%F).sql
            mysqldump -h127.0.0.1 -P3306 -uroot -p$password acore_characters > ./sql_dumps/acore_characters/acore_characters-$(date +%F).sql
            mysqldump -h127.0.0.1 -P3306 -uroot -p$password acore_world > ./sql_dumps/acore_world/acore_world-$(date +%F).sql
            mysqldump -h127.0.0.1 -P3306 -uroot -p$password acore_playerbots > ./sql_dumps/acore_playerbots/acore_playerbots-$(date +%F).sql
        ;;
    esac
}

ask_user 'Type recover or backup.'

