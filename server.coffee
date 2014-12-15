
# author: Christopher Kelley, 2014

extend = require 'node.extend'
http_proxy = require 'http-proxy'
http = require 'http'

module.exports = __module__ = ( options ) ->

    settings = extend
        debug: false
        port: 80
        host: 'http://localhost'
        map:
            www:
                port: 8080
    , options

    settings.debug and console.log 'map:\n', settings.map

    proxy = http_proxy.createProxyServer { }

    proxy.on 'error', ( err, req, res ) ->
        message = "404 Not Found [#{err}]"
        res.writeHead 404,
            'Content-Type': 'text/plain'

        res.end message

    server = http.createServer ( req, res ) ->
        namespace = req.headers.host?.split('.')[0] or 'www'
        host = settings.map[namespace]?.host or settings.host
        port = settings.map[namespace]?.port or 8080
        resolved = "#{host}:#{port}"
        if settings.debug
            console.log '---'
            console.log 'uri  : ' + req.headers.host + req.url
            console.log 'proxy: ' + resolved
        proxy.web req, res,
            target: resolved

    server.listen settings.port, ( ) ->
        settings.debug and console.log 'listening::' + settings.port


if require.main is module
    __module__ require './config.json'

