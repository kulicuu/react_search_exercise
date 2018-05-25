


c = console.log.bind console
fs = require 'fs'
color = require 'bash-color'
express = require 'express'
path = require 'path'
http = require 'http'
port = 3003
Primus = require 'primus'

public_dir = path.resolve('..', 'app_one', 'public')
index_path = '/dev_index.html'

a1 = express()

a1.all '/', (req, res, next) ->
    res.sendFile path.join(public_dir, index_path)


a1.use express.static(public_dir)


a1_server = http.createServer a1



a1_primus = new Primus(a1_server, {transformer: 'websockets'})
a1_primus.save path.join(public_dir, '/js', '/primus.js')








a1_server.listen port, ->
    c color.blue("Server listening on: #{port}")
