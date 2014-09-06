
# author: Christopher Kelley, 2014

extend = require 'node.extend'

module.exports = __module__ = ( ( options ) ->

    settings = extend
        port: 80
        map:
            www: 8080
    , options

    express = require 'express'
    app     = express()
    http    = require 'http'
    server  = http.createServer app

    server.listen settings.port, () ->
        console.log 'Starting registry mapping on port ' + settings.port

    app.use ( req, res ) ->
        host = req.get('host').split('.')
        if host.length > 2
            ns = host[0]
            plain = host[1] + '.' + host[2].split(':')[0]
        else
            ns = settings.map.www
            plain = host[0] + '.' + host[1].split(':')[0]
        ns = settings.map[ns] or settings.map.www
        direction = req.protocol + '://' + plain + ':' + ns + req.originalUrl
        res.redirect direction

)

if require.main is module
    __module__ require './config.json'
