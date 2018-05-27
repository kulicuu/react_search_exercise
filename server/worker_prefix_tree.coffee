# { title, gtin, gender, sale_price, price, image_link, additional_image_link }


_ = require 'lodash'
fp = require 'lodash/fp'
c = console.log.bind console
color = require 'bash-color'





tree_lib = null






send_progress = ({ field, perc_count, spark_ref }) ->
    process.send
        type: 'progress_update'
        payload: { field, perc_count, spark_ref }



send_match = ({ match_set, spark_ref }) ->
    process.send
        type: 'match_report'
        payload: { match_set, spark_ref }



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




aa = {}


aa.build_tree = ({ payload }) ->
    { arq, spark_ref } = payload
    tree_lib = _.reduce [ 'title', 'gtin', 'gender', 'sale_price', 'price', 'image_link', 'additional_image_link' ], (acc33, field, idx33) ->
        the_dictionary = _.reduce arq, (acc, entry, id) ->
            acc.push entry[field]
            acc
        , []

        tree =
            key: []
            chd_nodes: {}
            match_words: []

        len_dict = the_dictionary.length
        perc_count = len_dict / 100
        counter = 0
        the_dictionary.map (word, idx) ->



            # c field, word
            unless word is undefined
                counter++
                perc = counter / perc_count
                if Math.floor(counter % perc_count) is 0
                    send_progress
                        field: field
                        perc_count: Math.floor perc
                        spark_ref: spark_ref
                rayy = word.split ''
                cursor_key = []
                rayy.map (char, idx2) ->
                    cursor_key.push char
                    _.reduce cursor_key, (acc, char2, idx2) ->
                        if not acc.chd_nodes[char2]
                            acc.chd_nodes[char2] =
                                key: cursor_key
                                chd_nodes: {}
                                match_words: map_substring_to_match
                                    dictionary: the_dictionary
                                    partial_str: cursor_key.join ''
                        acc = acc.chd_nodes[char2]
                        acc
                    , tree
        acc33[field] = tree
        acc33
    , {}



    send_progress
        field: 'ALL'
        perc_count: 100
        spark_ref: spark_ref














keys_aa = _.keys aa




process.on 'message', ({ type, payload }) ->
    if _.includes(keys_aa, type)
        aa[type] { payload }
    else
        c (color.red "no-op in worker with type: #{type}", on)
