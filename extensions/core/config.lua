local config = {} -- extension configuration

config.module = {
  {name = "builder", script = "builder.lua"},
  {name = "cookie", script = "cookie.lua"},
  {name = "crypto", script = "rocky/crypto.lua"},
  {name = "database", script = "database.lua"},
  {name = "date", script = "date.lua"},
  {name = "eval", script = "eval.lua"},
  {name = "exception", script = "exception.lua"},
  {name = "exit", script = "exit.lua"},
  {name = "fileutil", script = "fileutil.lua"},
  {name = "http", script = "http.lua"},
  {name = "http_headers", script = "http_headers.lua"},
  {name = "json", script = "json.lua"},
  {name = "param", script = "param.lua"},
  {name = "parse", script = "parse.lua"},
  {name = "persistence", script = "persistence.lua"},
  {name = "stacktrace", script = "stacktrace.lua"},
  {name = "template", script = "template.lua"},
  {name = "upload", script = "upload.lua"},
  {name = "utf8", script = "utf8.lua"},
  {name = "utf8data", script = "utf8data.lua"},
  {name = "util", script = "util.lua"},
  {name = "uuid", script = "uuid.lua"},

  {name = "resty.md5", script = "resty/md5.lua"},
  {name = "resty.mysql", script = "resty/mysql.lua"},
  {name = "resty.rsa", script = "resty/rsa.lua"},
  {name = "resty.sha", script = "resty/sha.lua"},
  {name = "resty.sha1", script = "resty/sha1.lua"},
  {name = "resty.sha256", script = "resty/sha256.lua"},

  {name = "rocky.crypto", script = "rocky/crypto.lua"},
  {name = "rocky.luaorm", script = "rocky/luaorm.lua"},
  {name = "rocky.ngxssl", script = "rocky/ngxssl.lua"},
  {name = "rocky.postgresql", script = "rocky/postgresql.lua"},
  {name = "rocky.typedef", script = "rocky/typedef.lua"},
}

config.javascript = {
  {name = "parse", script = "js/parse.js"},
  {name = "widget", script = "js/widget.js"}
}

return config -- return extension configuration