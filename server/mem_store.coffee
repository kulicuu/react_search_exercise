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
arq = require('./naive_search.coffee').arq
spark_check = {}


dd = {}


dd.progress_update = ({ payload }) ->
    { perc_count, spark_ref, field } = payload
    if perc_count % 10 is 0
        c 'progress_update', perc_count
    spark = spark_check[spark_ref]
    if spark
        spark.write
            type: 'progress_update_prefix_tree_build'
            payload: { perc_count, field }


dd.match_report = ({ payload }) ->
    { match_set } = payload


keys_worker_res_api = _.keys dd


cc = {}


cc.search_tree = ({ payload, spark }) ->
    spark_check[spark.id] = spark
    tree_worker.send
        type: 'search_tree'
        payload: (fp.assign payload, {spark_ref: spark.id})


cc.build_table = ({ payload, spark }) ->
    tree_worker.send
        type: 'build_table'
        payload:
            arq: arq
            spark_ref: spark.id
    spark_check[spark.id] = spark
    spark.write
        type: 'res_build_tree'


keys_cc = _.keys cc


tree_api = ({ type, payload, spark }) ->
    if _.includes(keys_cc, type)
        cc[type] { payload, spark }
    else
        c "no-op in tree-api with type", type


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


exports.arq = arq
exports.tree_api = tree_api
