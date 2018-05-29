

c = console.log.bind console
color = require 'bash-color'
_ = require 'lodash'
fp = require 'lodash/fp'
fs = require 'fs'


{ tree_api, arq } = require('./mem_store.coffee')


aa = {}


# TODO Rename this to e.g. 'command_build_table'
aa.command_build_tree = ({ payload, spark }) ->
    tree_api
        type: 'build_table'
        payload: null
        spark: spark


aa.tree_search = ({ payload, spark }) ->
    { search_str, search_type } = payload
    tree_api
        type: 'search_tree'
        payload: { search_str, search_type }
        spark: spark

# supernaive
aa.std_search = ({ payload, spark }) ->
    { search_str, search_type } = payload
    c search_str, search_type
    counter = 0
    results = _.reduce arq, (acc, entry, gtin) ->
        if (entry[search_type]) and (entry[search_type].includes search_str) and (counter++ < 100)
            acc[gtin] = entry
        acc
    , {}
    spark.write
        type: 'res_std_search'
        payload: results


aa.checkin = ({ payload, spark }) ->
    spark.write
        type: "OK"
        payload: null # might prefetch some data here


keys_aa = _.keys aa
api = ({ type, payload, spark }) ->
    if _.includes(keys_aa, type)
        aa[type] { payload, spark }
    else
        c "no-op", type


exports.default = api
