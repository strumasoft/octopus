#!/bin/bash

# Usage: bash resty.sh download
# Usage: bash resty.sh modify
# Usage: bash resty.sh remove


download() {
  curl -O https://raw.githubusercontent.com/openresty/lua-resty-string/master/lib/resty/md5.lua
  curl -O https://raw.githubusercontent.com/openresty/lua-resty-string/master/lib/resty/sha.lua
  curl -O https://raw.githubusercontent.com/openresty/lua-resty-string/master/lib/resty/sha1.lua
  curl -O https://raw.githubusercontent.com/openresty/lua-resty-string/master/lib/resty/sha256.lua
  curl -O https://raw.githubusercontent.com/spacewander/lua-resty-rsa/master/lib/resty/rsa.lua
  curl -O https://raw.githubusercontent.com/openresty/lua-resty-mysql/master/lib/resty/mysql.lua
}

modify() {
  ssl_3_files=("md5" "sha1" "sha256")
  for file in "${ssl_3_files[@]}"; do
    sed -i 's/ffi\.C/ffi.load("ssl.so.3")/g' "$file.lua"
  done
  
  ssl_1_1_files=("rsa")
  for file in "${ssl_1_1_files[@]}"; do
    sed -i 's/ffi\.C/ffi.load("ssl.so.1.1")/g' "$file.lua"
  done
}

remove() {
  rm *.lua
}

main() {
  case $1 in
    download)
      download
      ;;
    modify)
      modify
      ;;
    remove)
      remove
      ;;
    *)
      SH=bash
      echo "Usage: $SH $0 download"
      echo "Usage: $SH $0 modify"
      echo "Usage: $SH $0 remove"
      exit 0
      ;;
  esac
}

main "$@"