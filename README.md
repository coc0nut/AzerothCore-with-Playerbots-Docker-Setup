# AzerothCore with Playerbots



Script installing AzerothCore with Playerbots

Includes:
- [Azeroth Core - Playerbots branch](https://github.com/liyunfan1223/azerothcore-wotlk.git)
- [mod-playerbots](https://github.com/liyunfan1223/mod-playerbots)
- [mod-aoe-loot](https://github.com/azerothcore/mod-aoe-loot)
- [mod-learn-spells](https://github.com/azerothcore/mod-learn-spells)
- [mod-junk-to-gold](https://github.com/noisiver/mod-junk-to-gold.git)

Prerequisits: 
  1. Debian 12/Ubuntu with Docker installed.

---

Steps:

1. ```bash
   git clone https://github.com/coc0nut/AzerothCore.git \
   && cd AzerothCore && chmod +x *.sh && ./acore_setup.sh
   ```

2. Follow the steps "Creating an account" and "Access database and update realmlist"
on [Azeroth Core - Docker setup](https://www.azerothcore.org/wiki/install-with-docker)
```bash
docker attach ac-worldserver # to attach to the server console
````
```
AC> account create username password
AC> account set gmlevel username 3 -1
```
Then log into the database with HeidiSQL:
In a query window, run the following sql:
```sql
USE acore_auth;
SELECT * FROM realmlist;
UPDATE realmlist SET address='your_desired_ip';
```

Edit your wow_client_3.3.5a\Data\enUS\realmlist.wtf and type in the ip address you chose...

To reinstall, run `./reinstall.sh`

To uninstall, run `./uninstall.sh`
