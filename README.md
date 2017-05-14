# Octopus - The Lua Web Framework

Wiki
===============================

[Extension](https://github.com/cyberz-eu/octopus/wiki/Extension)

[Graphical widget](https://github.com/cyberz-eu/octopus/wiki/Graphical-widget)

[Object relational mapping](https://github.com/cyberz-eu/octopus/wiki/Object-relational-mapping)

[Security](https://github.com/cyberz-eu/octopus/wiki/Security)

[Editor](https://github.com/cyberz-eu/octopus/wiki/Editor)

[Revision control](https://github.com/cyberz-eu/octopus/wiki/Revision-control)

[Database administration](https://github.com/cyberz-eu/octopus/wiki/Database-administration)


Introduction
============

Octopus is automated process for creating configuration for the excellent [lua-nginx-module](https://github.com/openresty/lua-nginx-module). It can host many aplications/sites. Every aplication/site hosted by octopus is made up of a number of extensions, where every extension is aggregation of logically connected files.

The heart of the system is the build process who creates all the necessary nginx configurations, create widgets, creates type system and autowire modules in dependency injection style.
[build.lua](bin/unix/build.lua) together with [config.lua](extensions/config.lua) are responsible for configurating the build/generation process, while [server.sh](bin/unix/server.sh) is responsible for the actual building, installing, starting, stoping and restarting the server:

```bash
# go to bin directory
cd bin/unix
# install nginx
. ./server.sh install
# build octopus and restart server
. ./server.sh restart
# build
. ./server.sh build
# start server
. ./server.sh start
# stop server
. ./server.sh stop
```

Prerequisites
============

```
sudo apt-get install libssl-dev
sudo apt-get install gcc g++ build-essential
```

Set Up
============

Minimum set up script:

```bash
cd bin/unix
. ./server.sh install
. ./server.sh restart
```
then just open [localhost:8787](http://localhost:8787)

Database, users and security
============

* Set up database connection - databaseConnection object in [config.lua](extensions/config.lua)
* Import test user from security extension [import.lua](extensions/security/src/import.lua) file in [localhost:8787/database](http://localhost:8787/database)
```lua
db:dropAllTables()
db:createAllTables()
db:import("securityImport")
db:import("shopImport")
```
* Enable security - set `requireSecurity = true` in globalParameters object in [config.lua](extensions/config.lua) and edit database connection parameters

Copyright and License
=====================

Copyright (C) 2017, Lazar Gyulev

All rights reserved. BSD license.
