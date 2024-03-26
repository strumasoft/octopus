#! /bin/bash


### prerequisites ###
# sudo apt-get install libssl-dev gcc g++ build-essential libtool zlib1g


# cd /octopus/bin/unix
current_dir=$(pwd)

export destination_folder="$current_dir/downloads"
export luajit_install="$current_dir/luajit"
export lib_dir="$current_dir/lib"
export ace_dir="$current_dir/../../extensions/baseline/static/ace"
export nginx_install="$current_dir"

export LUAJIT_BIN=$luajit_install/bin
export LUAJIT_LIB=$luajit_install/lib
export LUAJIT_INC=$luajit_install/include/luajit-2.1


function download_archive {
  file_name="$destination_folder/$1.$2"
  url=$3

  wget -c -O "$file_name" $url
  tar -xzf "$file_name" -C $destination_folder
}


function download_repo_and_install {
  owner=$1
  repo=$2
  version=$3
  folder=$4
  install_dir=$5
  download_archive $repo tar.gz "https://github.com/$owner/$repo/archive/refs/tags/v$version.tar.gz"
  cp -R "$destination_folder/$repo-$version/$folder"/* $install_dir
}


function nginx_install {
  # make new dirs
  rm -rf logs
  mkdir logs
  rm -rf $destination_folder
  mkdir $destination_folder
  rm -rf $luajit_install
  mkdir $luajit_install
  rm -rf $lib_dir
  mkdir $lib_dir
  rm -rf $ace_dir
  mkdir $ace_dir


  # libraries
  download_repo_and_install ajaxorg ace-builds 1.32.3 src-min $ace_dir
  download_repo_and_install openresty lua-resty-core 0.1.28 lib $lib_dir
  download_repo_and_install openresty lua-resty-lrucache 0.13 lib $lib_dir


  # nginx
  nginx=nginx
  nginx_version=1.25.3
  nginx_url=http://nginx.org/download/nginx-$nginx_version.tar.gz
  download_archive $nginx tar.gz $nginx_url


  # ngx_devel_kit
  ngx_devel_kit=ngx_devel_kit
  ngx_devel_kit_version=0.3.3
  ngx_devel_kit_url=https://github.com/vision5/ngx_devel_kit/archive/refs/tags/v$ngx_devel_kit_version.tar.gz
  download_archive $ngx_devel_kit tar.gz $ngx_devel_kit_url


  # lua-nginx-module
  lua_nginx_module=lua-nginx-module
  lua_nginx_module_version=0.10.26
  lua_nginx_module_url=https://github.com/openresty/lua-nginx-module/archive/refs/tags/v$lua_nginx_module_version.tar.gz
  download_archive $lua_nginx_module tar.gz $lua_nginx_module_url


  # install PCRE
  pcre=pcre
  pcre_version=8.45
  pcre_url=https://netix.dl.sourceforge.net/project/pcre/pcre/$pcre_version/pcre-$pcre_version.tar.gz
  download_archive $pcre tar.gz $pcre_url


  # install zlib
  zlib=zlib
  zlib_version=1.3.1
  zlib_url=https://github.com/madler/zlib/archive/refs/tags/v$zlib_version.tar.gz
  download_archive $zlib tar.gz $zlib_url


  # install lfs
  # config/lfs.config
  lfs=luafilesystem
  lfs_version=1_8_0
  lfs_url=https://github.com/keplerproject/luafilesystem/archive/refs/tags/v$lfs_version.tar.gz
  download_archive $lfs tar.gz $lfs_url
  cd $destination_folder/$lfs-$lfs_version
  cat $nginx_install/config/lfs.config > config
  make
  make install


  # install LuaJIT
  luajit=luajit2
  luajit_version=2.1-20231117
  luajit_url=https://github.com/openresty/luajit2/archive/refs/tags/v$luajit_version.tar.gz
  download_archive $luajit tar.gz $luajit_url
  cd $destination_folder/$luajit-$luajit_version
  make
  make install PREFIX=$luajit_install


  # install nginx
  cd "$destination_folder/$nginx-$nginx_version"
  ./configure --prefix=$nginx_install \
    --sbin-path=$nginx_install/nginx \
    --conf-path=$nginx_install/nginx.conf \
    --pid-path=$nginx_install/nginx.pid \
    --with-pcre=../$pcre-$pcre_version \
    --with-zlib=../$zlib-$zlib_version \
    --with-http_ssl_module \
    --add-module=../$ngx_devel_kit-$ngx_devel_kit_version \
    --add-module=../$lua_nginx_module-$lua_nginx_module_version
  make -j2
  make install


  # return back to woring directory
  cd "$current_dir"
}


function nginx_start {
  export LD_LIBRARY_PATH="$LUAJIT_LIB":$LD_LIBRARY_PATH
  ./nginx -c nginx.conf
}


function nginx_stop {
  export LD_LIBRARY_PATH="$LUAJIT_LIB":$LD_LIBRARY_PATH
  ./nginx -s stop
}


# $1 is the name of the build
function nginx_build {
  $LUAJIT_BIN/luajit build.lua $1
}


function nginx_clear {
  $LUAJIT_BIN/luajit build.lua clear
}


# $1 is the name of the build
function nginx_restart {
  $LUAJIT_BIN/luajit build.lua $1

  if [ $? -eq 0 ]; then
    export LD_LIBRARY_PATH="$LUAJIT_LIB":$LD_LIBRARY_PATH
    ./nginx -s stop
    ./nginx -c nginx.conf

    echo "" > logs/error.log
    echo "" > logs/access.log
    tail -f logs/error.log
  fi
}


# crontab -e
# */5 * * * * /octopus/bin/unix/server.sh reload
function nginx_reload {
  if [ -f server.reload ]; then
    export LD_LIBRARY_PATH="$LUAJIT_LIB":$LD_LIBRARY_PATH
    ./nginx -s stop
    ./nginx -c nginx.conf
    
    rm server.reload
  fi
}


if [ -z "$1" ]; then
  echo "no operation!"
elif [ "$1" == "install" ]; then
  echo "install server..."
  nginx_install
elif [ "$1" == "build" ]; then
  echo "build server..."
  nginx_build $2
elif [ "$1" == "clear" ]; then
  echo "clear server..."
  nginx_clear
elif [ "$1" == "stop" ]; then
  echo "stop server..."
  nginx_stop
elif [ "$1" == "start" ]; then
  echo "start server..."
  nginx_start
elif [ "$1" == "restart" ]; then
  echo "restart server..."
  nginx_restart $2
elif [ "$1" == "reload" ]; then
  echo "reload server..."
  nginx_reload
else
  echo "unknown operation!"
fi
