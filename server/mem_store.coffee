# { title, gtin, gender, sale_price, price, image_link, additional_image_link }


c = console.log.bind console
color = require 'bash-color'
_ = require 'lodash'
fp = require 'lodash/fp'
fs = require 'fs'
fork = require('child_process').fork
flow = require 'async'
path = require 'path'
shortid = require 'shortid'


raw_data = fs.readFileSync './products.csv', 'utf8'
rayy = raw_data.split('\n')
rayy.shift()

tree_worker = null # scoped here




spark_check = {}




arq = rayy.reduce (acc, line, idx) ->
    [ title, gtin, gender, sale_price, price, image_link, additional_image_link ] = line.split(',')
    acc[gtin] = { title, gtin, gender, sale_price, price, image_link, additional_image_link }
    acc
, {}


c (_.size arq), 'size arq'


dd = {}


dd.progress_update = ({ payload }) ->
    { perc_count, spark_ref } = payload
    c 'progress_update', perc_count
    spark = spark_check[spark_ref]
    if spark
        spark.write
            type: 'progress_update_prefix_tree_build'
            payload: perc_count


dd.match_report = ({ payload }) ->
    { match_set } = payload


keys_worker_res_api = _.keys dd
















cc = {}


cc.build_tree = ({ payload, spark }) ->
    spark_ref = shortid()
    tree_worker.send
        type: 'build_tree'
        payload:
            arq: arq
            spark_ref: spark_ref
    if spark
        spark_check[spark_ref] = spark
        spark.write
            type: 'res_build_tree'



keys_cc = _.keys cc


tree_api = ({ type, payload }) ->
    if _.includes(keys_cc, type)
        cc[type] { payload }








start_tree_build = ->
    tree_worker = fork(path.resolve(__dirname, 'worker_prefix_tree.coffee'))
    tree_worker.on 'message', ({ type, payload }) ->
        if _.includes(keys_worker_res_api, type)
            dd[type] { payload }
        else
            c color.yellow


setTimeout ->
    start_tree_build()
, 100


setTimeout ->
    tree_api
        type: 'build_tree'
, 2000





exports.tree_api = tree_api
