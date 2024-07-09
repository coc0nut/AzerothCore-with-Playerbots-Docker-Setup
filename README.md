# AzerothCore with Playerbots Docker setup (installscript)

Script installing AzerothCore with Playerbots, mod-aoe-loot and mod-learn-spells on Docker

Includes:
- [Azeroth Core - Playerbots branch](https://github.com/liyunfan1223/azerothcore-wotlk.git)
- [mod-playerbots](https://github.com/liyunfan1223/mod-playerbots)
- [mod-aoe-loot](https://github.com/azerothcore/mod-aoe-loot)
- [mod-learn-spells](https://github.com/azerothcore/mod-learn-spells)

Prerequisits: 
  1. Debian 12/Ubuntu with Docker installed.

---

Steps:

1.
 ```bash
 git clone https://github.com/coc0nut/AzerothCore.git \
 && cd AzerothCore && chmod +x *.sh && ./acore_setup.sh
 ```

2. Follow the steps "Creating an account" on [Azeroth Core - Docker setup](https://www.azerothcore.org/wiki/install-with-docker)
```bash
docker attach ac-worldserver
```
3.
```shell
AC> account create username password
AC> account set gmlevel username 3 -1
```

4.
Edit your wow_client_3.3.5a\Data\enUS\realmlist.wtf and type in the ip address you chose...
`set realmlist dockerhost_ip`

**Change dockerhost_ip to the ip that the machine that runs the docker containers has.**

`hostname -I | awk '{print $1}` will give you the ip address...

To uninstall and start fresh, run `./acore_uninstall.sh`

To clear the data/sql/custom folders run `./acore_clear_sql.sh`
