# AzerothCore with Playerbots Docker setup (installscript)

Script installing AzerothCore with Playerbots on Docker

This is not a fork! Its just scripts to manage the game.

Includes:
- [MariaDB-Client]() (This is only client and will install only if you dont have the mysql command...)
- [Docker](https://docker.com) (Will install if Docker is not installed.)
- [Azeroth Core - Playerbots branch](https://github.com/liyunfan1223/azerothcore-wotlk.git)
- [mod-playerbots](https://github.com/liyunfan1223/mod-playerbots)
- [mod-aoe-loot](https://github.com/azerothcore/mod-aoe-loot) (optional)
- [mod-learn-spells](https://github.com/noisiver/mod-learn-spells) (optional)
- [mod-fireworks-on-level](https://github.com/azerothcore/mod-fireworks-on-level.git) (optional)
- [mod-individual-progression](https://github.com/ZhengPeiRu21/mod-individual-progression.git) (optional)

Prerequisits: 
  1. Debian 12 Bookworm


Reference:
[Azeroth Core](https://www.azerothcore.org/wiki/home)

---

### Steps:

1.
> Be sure to set correct timezone on your debian before you start.
 ```bash
 git clone https://github.com/coc0nut/AzerothCore-with-Playerbots-Docker-Setup.git \
 && cd AzerothCore-with-Playerbots-Docker-Setup && chmod +x *.sh && ./setup.sh
 ```

2. 
```
NOTE:

1. Execute 'docker attach ac-worldserver'
2. 'account create username password' creates an account.
3. 'account set gmlevel username 3 -1' sets the account as gm for all servers.
4. Ctrl+p Ctrl+q will take you out of the world console.
5. Now login to wow on $(hostname -I | awk '{print $1}') with 3.3.5a client!
6. All the configs for the server and modules is copied to a folder named wotlk. This is where you edit playerbots and server configuration.
```
See [Azeroth Core - Docker setup](https://www.azerothcore.org/wiki/install-with-docker) for more info.

3.
```shell
AC> account create username password
AC> account set gmlevel username 3 -1
```

4.
Edit your wow_client_3.3.5a\Data\enUS\realmlist.wtf and type in the ip address you get in the end of installing...
`set realmlist dockerhost_ip`

**Change dockerhost_ip to the ip that the machine that runs the docker containers has.**

To uninstall and start fresh, run `./uninstall.sh`

To clear the `data/sql/custom` folders run `./clear_custom_sql.sh`

## Usage

### Update

- To update and get the latest versions, you can run `./uninstall.sh` without deleting the volumes and run `./setup.sh` again.
It will prompt you if you want to delete the volumes. (Dont let the warnings scare you :)

- You can add modules to the `setup.sh` file by scrolling to the "install_mod" section and add the entries you'd like. **Or** you could do it manually by putting the modules folders into the `azerothcore-wotlk/modules`folder. `setup.sh` will automatically add the sql. See [How do I install modules?](https://www.azerothcore.org/wiki/install-with-docker#how-do-i-install-modules) for more info.

- Running `setup.sh` will not install anything over again unless you delete a modules folder or the `azerothcore-wotlk` folder before. You can run it if you only want to install new modules youve added, it will skip if you already downloaded the repos.

- If you delete modules, remember to run `clear_custom_sql.sh` first and remove the respective tables in the db.

### Backup & Recovery

- You can backup and recover the databases by running `./sqldump.sh`. It will place the backups in `sql_dumps` folder... On recovery, you will be prompted to enter a date (given you back up once a day at maximum.)

---                                                                                                             
