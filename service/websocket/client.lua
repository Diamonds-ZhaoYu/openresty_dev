-- Copyright (C) 2018 by chrono

local client = require "resty.websocket.client"

local wb, err = client.new{
    timeout = 5000,
    max_payload_len = 1024 * 64,
    }

local ok, err = wb:connect("ws://127.0.0.1:86/srv")
if not ok then
    ngx.say("failed to connect: ", err)
    return
end

ngx.say("connect ok")

local data, typ, bytes, err

bytes, err = wb:send_ping()
if not bytes then
    ngx.say("failed to ping: ", err)
    return
end

data, typ, err = wb:recv_frame()

if not data then
    ngx.log(ngx.ERR, "failed to recv: ", err)
    return
end

if typ == "pong" then
    ngx.say("recv pong")
end

bytes, err = wb:send_text("hello wb")
if not bytes then
    ngx.say("failed to send: ", err)
    return
end

data, typ, err = wb:recv_frame()

if not data then
    ngx.log(ngx.ERR, "failed to recv: ", err)
    return
end

if typ == "text" then
    ngx.say("recv: ", data)
end

bytes, err = wb:send_close()
if not bytes then
    ngx.log(ngx.ERR, "failed to close: ", err)
    return
end
