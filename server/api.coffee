

c = console.log.bind console
color = require 'bash-color'
_ = require 'lodash'
fp = require 'lodash/fp'
fs = require 'fs'


mem_store = require('./mem_store.coffee').default



aa = {}


aa.checkin = ({ payload, spark }) ->
    spark.write
        type: "OK"
        payload: null # might prefetch some data here









keys_aa = _.keys
api = ({ type, payload, spark }) ->
    if _.includes(keys_aa, type)
        aa[type] { payload, spark }
    else
        c (color.yellow("No-op in server api with type", on)), color.purple(type, on)







exports.default = api
