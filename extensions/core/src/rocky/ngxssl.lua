-- Copyright (C) 2024, StrumaSoft
--
-- Credits:
--   https://github.com/fffonion/lua-resty-openssl
--
-- Requires:
--   LuaJIT FFI
--   OpenSSL


local ffi = require "ffi"
ffi.cdef [[
  // Nginx seems to always config _FILE_OFFSET_BITS=64, this should always be 8 byte
  typedef long long off_t;
  typedef unsigned int socklen_t; // windows uses int, same size
  typedef unsigned short in_port_t;

  typedef struct ssl_st SSL;
  typedef struct ssl_ctx_st SSL_CTX;

  typedef long (*ngx_recv_pt)(void *c, void *buf, size_t size);
  typedef long (*ngx_recv_chain_pt)(void *c, void *in,
      off_t limit);
  typedef long (*ngx_send_pt)(void *c, void *buf, size_t size);
  typedef void *(*ngx_send_chain_pt)(void *c, void *in,
      off_t limit);

  typedef struct {
    size_t             len;
    void               *data;
  } ngx_str_t;

  typedef struct {
    SSL             *connection;
    SSL_CTX         *session_ctx;
    // trimmed
  } ngx_ssl_connection_s;
  
  typedef struct {
    ngx_str_t           src_addr;
    ngx_str_t           dst_addr;
    in_port_t           src_port;
    in_port_t           dst_port;
  } ngx_proxy_protocol_t;

  typedef struct {
    void               *data;
    void               *read;
    void               *write;

    int                 fd;

    ngx_recv_pt         recv;
    ngx_send_pt         send;
    ngx_recv_chain_pt   recv_chain;
    ngx_send_chain_pt   send_chain;

    void               *listening;

    off_t               sent;

    void               *log;

    void               *pool;

    int                 type;

    void                *sockaddr;
    socklen_t           socklen;
    ngx_str_t           addr_text;

    ngx_proxy_protocol_t  *proxy_protocol;

    ngx_ssl_connection_s  *ssl;
    // trimmed
  } ngx_connection_s;
  
  typedef struct {
    ngx_connection_s                *connection;
    // trimmed
  } ngx_peer_connection_s;


  /***** http *****/

  typedef
    int (*ngx_http_lua_socket_tcp_retval_handler_masked)(void *r, void *u, void *L);

  typedef void (*ngx_http_lua_socket_tcp_upstream_handler_pt_masked)
    (void *r, void *u);
      
  typedef struct {
    ngx_http_lua_socket_tcp_retval_handler_masked          read_prepare_retvals;
    ngx_http_lua_socket_tcp_retval_handler_masked          write_prepare_retvals;
    ngx_http_lua_socket_tcp_upstream_handler_pt_masked     read_event_handler;
    ngx_http_lua_socket_tcp_upstream_handler_pt_masked     write_event_handler;

    void                            *udata_queue; // 0.10.19

    void                            *socket_pool;

    void                            *conf;
    void                            *cleanup;
    void                            *request;
    ngx_peer_connection_s            peer;
    // trimmed
  } ngx_http_lua_socket_tcp_upstream_s;
      
  typedef struct ngx_http_lua_socket_tcp_upstream_s ngx_http_lua_socket_tcp_upstream_t;
  
  
  /***** stream *****/
  
  typedef
    int (*ngx_stream_lua_socket_tcp_retval_handler)(void *r, void *u, void *L);

  typedef void (*ngx_stream_lua_socket_tcp_upstream_handler_pt)
    (void *r, void *u);

  typedef struct {
    ngx_stream_lua_socket_tcp_retval_handler            read_prepare_retvals;
    ngx_stream_lua_socket_tcp_retval_handler            write_prepare_retvals;
    ngx_stream_lua_socket_tcp_upstream_handler_pt       read_event_handler;
    ngx_stream_lua_socket_tcp_upstream_handler_pt       write_event_handler;

    void                    *socket_pool;

    void                    *conf;
    void                    *cleanup;
    void                    *request;

    ngx_peer_connection_s            peer;
    // trimmed
  } ngx_stream_lua_socket_tcp_upstream_s;
  
  typedef struct ngx_stream_lua_socket_tcp_upstream_s ngx_stream_lua_socket_tcp_upstream_t;
]]

local SOCKET_CTX_INDEX = 1
local function get_ngx_ssl_from_socket_ctx (sock)
  local u = sock[SOCKET_CTX_INDEX]
  if u == nil then
    return nil, "lua_socket_tcp_upstream_t not found"
  end

  if ngx.config.subsystem  == "stream" then
    u = ffi.cast("ngx_stream_lua_socket_tcp_upstream_s*", u)
  else -- http
    u = ffi.cast("ngx_http_lua_socket_tcp_upstream_s*", u)
  end

  local p = u.peer

  if p == nil then
    return nil, "u.peer is nil"
  end

  local uc = p.connection
  if uc == nil then
    return nil, "u.peer.connection is nil"
  end

  local ngx_ssl = uc.ssl
  if ngx_ssl == nil then
    return nil, "u.peer.connection.ssl is nil"
  end
  return ngx_ssl
end

local get_socket_ssl = function (sock)
  local ssl, err = get_ngx_ssl_from_socket_ctx(sock)
  if err then
    return nil, err
  end

  return ssl.connection
end

local get_socket_ssl_ctx = function (sock)
  local ssl, err = get_ngx_ssl_from_socket_ctx(sock)
  if err then
    return nil, err
  end

  return ssl.session_ctx
end


return {
  get_socket_ssl = get_socket_ssl,
  get_socket_ssl_ctx = get_socket_ssl_ctx,
}