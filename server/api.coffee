

c = console.log.bind console
color = require 'bash-color'
_ = require 'lodash'
fp = require 'lodash/fp'
fs = require 'fs'


arq = require('./mem_store.coffee').default


aa = {}


aa.std_search = ({ payload, spark }) ->
    { search_str, search_type } = payload
    c search_str, search_type
    results = _.reduce arq, (acc, entry, gtin) ->
        if entry[search_type].includes search_str
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
        c (color.yellow("No-op in server api with type", on)), color.purple(type, on)


exports.default = api
