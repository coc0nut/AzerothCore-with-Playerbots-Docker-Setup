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
   && cd AzerothCore && chmod +x acore_setup.sh && ./acore_setup.sh
   ```

2. Follow the steps "Creating an account" and "Access atabase and update realmlist" on [Azeroth Core - Docker setup](https://www.azerothcore.org/wiki/install-with-docker)
```bash
docker attach ac-worldserver # to attach to the server console
````
```
AC> account create username password
AC> account set gmlevel username 3 -1
```
Then log into the database with HeidiSQL:
In a query window, copy
```sql
USE acore_auth;
SELECT * FROM realmlist;
UPDATE realmlist SET address='your_desired_ip';
```
and run it...
