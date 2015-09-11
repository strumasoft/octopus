Octopus - The Lua Web Platform
==============================

Created by [cyberz.eu](http://cyberz.eu)

Documentation at [cyberz.eu](http://cyberz.eu/documentation)

Introduction
============

Octopus is automated process for creating configuration for the excellent nginx [HttpLuaModule](http://wiki.nginx.org/HttpLuaModule). It can host many aplications/sites. Every aplication/site hosted by octopus is made up of a number of extensions, where every extension is aggregation of logically connected files.

The heart of the system is the build process who creates all the necessary nginx configurations, create widgets, creates type system and autowire modules in dependency injection style.

Under `bin/unix` there is a file called `build.lua` where all the aplications/sites that will be hosted are named. All extensions of a single aplication/site have configuration, check `extensions/config_unix.lua`, that is poined in the `build.lua` file. Building octopus happens in a sigle command:

```bash
# build octopus
lua build.lua
```

Also in the same direcotry `bin/unix` there is a file called `server.sh` which is responsible for installing, starting, stoping and restarting the server:

```bash
# install nginx
. ./server.sh install
# build octopus and restart server
. ./server.sh restart
# start server
. ./server.sh start
# stop server
. ./server.sh stop
```

Copyright and License
=====================

Copyright (C) 2015, Lazar Gyulev, cyberz.eu@gmail.com, www.cyberz.eu

All rights reserved. BSD license.