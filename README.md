# AzerothCore
Scripts installing azerothcore with playerbots

Prerequisits: 
  1. Debian 12/Ubuntu with Docker installed.

Steps:
1. `git clone `

2. `cd AzerothCore && ./acore_setup.sh`

3. `docker attach ac-worldserver`
  3.1. `account create <your username> <your password>`
  3.2. `account set gmlevel <your username> 3 -1` (optional)
