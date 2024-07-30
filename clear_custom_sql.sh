#!/bin/bash

destination_dir="data/sql/custom"

world=$destination_dir"/db_world/"
chars=$destination_dir"/db_characters/"
auth=$destination_dir"/db_auth/"

cd azerothcore-wotlk

rm -rf $world/*.sql
rm -rf $chars/*.sql
rm -rf $auth/*.sql

cd ..

exit 0