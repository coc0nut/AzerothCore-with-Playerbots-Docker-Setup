# AzerothCore with Playerbots Docker setup (installscript)

Script installing AzerothCore with Playerbots on Docker

Includes:
- [Azeroth Core - Playerbots branch](https://github.com/liyunfan1223/azerothcore-wotlk.git)
- [mod-playerbots](https://github.com/liyunfan1223/mod-playerbots)
- [mod-aoe-loot](https://github.com/azerothcore/mod-aoe-loot)
- [mod-learn-spells](https://github.com/azerothcore/mod-learn-spells)
- [mod-fireworks-on-level](https://github.com/azerothcore/mod-fireworks-on-level.git)

Prerequisits: 
  1. Debian 12/Ubuntu with Docker installed.

Reference:
[Azeroth Core](https://www.azerothcore.org/wiki/home)

---

Steps:

1.
 ```bash
 git clone https://github.com/coc0nut/AzerothCore-with-Playerbots-Docker-Setup.git \
 && cd AzerothCore-with-Playerbots-Docker-Setup.git && chmod +x *.sh && ./acore_setup.sh
 ```

2. 
```
NOTE:

1. Execute 'docker attach ac-worldserver'
2. 'account create username password' creates an account.
3. 'account set gmlevel username 3 -1' sets the account as gm for all servers.
4. Ctrl+p Ctrl+q will take you out of the world console.
5. Now login to wow on $(hostname -I | awk '{print $1}') with 3.3.5a client!
```
See [Azeroth Core - Docker setup](https://www.azerothcore.org/wiki/install-with-docker) for more info.

3.
```shell
AC> account create username password
AC> account set gmlevel username 3 -1
```

4.
Edit your wow_client_3.3.5a\Data\enUS\realmlist.wtf and type in the ip address you chose...
`set realmlist dockerhost_ip`

**Change dockerhost_ip to the ip that the machine that runs the docker containers has.**

To uninstall and start fresh, run `./acore_uninstall.sh`

To clear the data/sql/custom folders run `./acore_clear_sql.sh`
