

c = console.log.bind console
color = require 'bash-color'
_ = require 'lodash'
fp = require 'lodash/fp'
fs = require 'fs'
fork = require('child_process').fork
flow = require 'async'
path = require 'path'



raw_data = fs.readFileSync './products.csv', 'utf8'


rayy = raw_data.split('\n')
# c rayy[0]
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


# now we want to compute autocomplete tree for every column.   It's not going to be a more powerful feature (actually less) than the string includes running through the thing linearly, but it's
# massively more performant.  In the real world we'd use something like Elasticsearch, or if
# we need to demonstrate CS fundamentals we'd implement something similar from scratch.
# start with title:







# This is if we will just have one entry returned, but we could also
# use this method to return a bunch of answers in a way that would
# work much faster over large data sets.
map_prefix_to_match = ({ dictionary, prefix }) ->
    candidates = []
    for word in dictionary
        if word.indexOf(prefix) is 0
            candidates.push word
        if candidates.length > 1
            # break_ties { candidates }
            candides.pop()
        else
            candides.pop()


map_substring_to_match = ({ dictionary, partial_str }) ->
    dictionary.reduce (candidates, word, idx) ->
        unless word is undefined
            if (word.indexOf partial_str) > -1
                candidates.push word
        candidates
    , []



# tree_lib = _.reduce [ 'title', 'gtin', 'gender', 'sale_price', 'price', 'image_link', 'additional_image_link' ], (acc33, field, idx33) ->
#     the_dictionary = _.reduce arq, (acc, entry, id) ->
#         acc.push entry[field]
#         acc
#     , []
#
#     tree =
#         key: []
#         chd_nodes: {}
#         match_words: []
#
#     the_dictionary.map (word, idx) ->
#         c field, word
#         unless word is undefined
#             rayy = word.split ''
#             cursor_key = []
#             rayy.map (char, idx2) ->
#                 cursor_key.push char
#                 _.reduce cursor_key, (acc, char2, idx2) ->
#                     if not acc.chd_nodes[char2]
#                         acc.chd_nodes[char2] =
#                             key: cursor_key
#                             chd_nodes: {}
#                             match_words: map_substring_to_match
#                                 dictionary: the_dictionary
#                                 partial_str: cursor_key.join ''
#                     acc = acc.chd_nodes[char2]
#                     acc
#                 , tree
#     acc33[field] = tree
#     acc33
# , {}















worker_res_api = {}




keys_worker_res_api = _.keys worker_res_api






start_tree_build = ->
    tree_worker = fork(path.resolve(__dirname, 'worker_prefix_tree.coffee'))
    tree_worker.on 'message', ({ type, payload }) ->
        if _.includes(keys_worker_res_api, type)
            worker_res_api[type] { payload }
        else
            c color.yellow





exports.default = arq


exports.tree_lib = tree_lib
