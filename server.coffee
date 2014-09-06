
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
        host = req.get('host')
        console.log host
        host = host.split('.')
        ns = host[0]
        plain = host[1] + '.' + host[2]
        console.log ns
        console.log req.originalUrl
        direction = req.protocol + '://' + plain + ':' + settings.map[ns] + req.originalUrl
        console.log direction
        res.redirect direction

)

if require.main is module
    __module__ require './config.json'
