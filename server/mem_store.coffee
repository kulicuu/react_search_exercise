

c = console.log.bind console
color = require 'bash-color'
_ = require 'lodash'
fp = require 'lodash/fp'
fs = require 'fs'



raw_data = fs.readFileSync './products.csv', 'utf8'


rayy = raw_data.split('\n')
c rayy[0]
rayy.shift()

# c rayy[0]



arq = {}

# create_record = ({ title, gtin, gender, sale_price, price, image_link, additional_image_link }) ->

# { title, gtin, gender, sale_price, price, image_link, additional_image_link }



arq = rayy.reduce (acc, line, idx) ->
    [ title, gtin, gender, sale_price, price, image_link, additional_image_link ] = line.split(',')
    acc[gtin] = { title, gtin, gender, sale_price, price, image_link, additional_image_link }
    acc
, {}


c (_.size arq), 'size arq'


exports.default = arq
