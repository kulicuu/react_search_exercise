

c = console.log.bind console
color = require 'bash-color'
_ = require 'lodash'
fp = require 'lodash/fp'
fs = require 'fs'


arq = require('./mem_store.coffee').default

{ tree_lib } = require('./mem_store.coffee')


aa = {}



reduce_tree = (acc, tree) ->
    if acc.indexOf(tree.match_word) is -1
        acc = [].concat(acc, tree.match_word)
    _.reduce tree.chd_nodes, (acc2, node, prefix) ->
        reduce_tree acc2, node
    , acc



# more performant
aa.tree_search = ({ payload, spark }) ->
    c 'hey'
    { search_str, search_type } = payload
    if search_str.length is 0
        spark.write
            type: 'res_tree_search'
            payload: {}
    else
        c 'hay2'
        cursor = tree_lib[search_type]
        unless cursor is undefined
            c 'hay3'
            rayy = search_str.split ''
            for char in rayy
                if cursor.chd_nodes[char] isnt undefined
                    cursor = cursor.chd_nodes[char]
                else
                    spark.write
                        type: 'res_tree_search'
                        payload: {}
            c 'hey4', cursor
            c 'hey5', reduce_tree( [], cursor )
            spark.write
                type: 'res_tree_search'
                payload: reduce_tree( [], cursor )




# supernaive
aa.std_search = ({ payload, spark }) ->
    { search_str, search_type } = payload
    c search_str, search_type
    counter = 0
    results = _.reduce arq, (acc, entry, gtin) ->
        # c entry, 'entry'
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
        c (color.yellow("No-op in server api with type", on)), color.purple(type, on)


exports.default = api
