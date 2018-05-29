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


map_prefix_to_match = ({ dictionary, prefix }) ->
    candidates = []
    for word in dictionary
        if word.indexOf(prefix) is 0
            candidates.push word
        if candidates.length > 1
            # break_ties { candidates }
            candidates.pop()
        else
            candidates.pop()


map_substring_to_match = ({ dictionary, partial_str }) ->
    dictionary.reduce (candidates, word, idx) ->
        unless word is undefined
            if (word.indexOf partial_str) > -1
                candidates.push word
        candidates
    , []


reduce_tree = (acc, tree) ->
    if acc.indexOf(tree.match_word) is -1
        acc = [].concat(acc, tree.match_word)
    _.reduce tree.chd_nodes, (acc2, node, prefx) ->
        reduce_tree acc2, node
    , acc


aa = {}


aa.search_tree = ({ payload }) ->
    { search_str, search_type, spark_ref } = payload
    if search_str.length is 0
        send_match
            spark_ref: spark_ref
            match_set: []
    else
        cursor = tree_lib[search_type]
        cancelled = false
        unless cursor is undefined
            search_str_rayy = search_str.split ''
            for char in search_str_rayy
                if cursor.chd_nodes[char] isnt undefined
                    cursor = cursor.chd_nodes[char]
                else
                    cancelled = true
                    send_match
                        spark_ref: spark_ref
                        match_set: []
            if cancelled is false
                send_match
                    spark_ref: spark_ref
                    match_set: reduce_tree( [], cursor )


# # exporting for test
# # This builds a dictionary to a tree structure.
# exports.build_dictionary = build_dictionary = ({ dictionary }) ->
#     tree =
#         key: []
#         chd_nodes: {}
#         match_words: []




build_tree = ({ the_dictionary }) ->
    tree =
        key: []
        chd_nodes: {}
        match_words: []
    for word, idx in the_dictionary
        cursor = tree
        prefix = ''
        if (word.length < 1) or (word is undefined)
            # NOTE TODO send a message on build failure
        else
            for char, jdx in word
                prefix+= char
                if not _.includes(_.keys(cursor.chd_nodes), char)
                    cursor.chd_nodes[char] =
                        prefix: prefix
                        chd_nodes: {}
                        match_word: map_prefix_to_match
                            prefix: prefix
                            dictionary: the_dictionary
                cursor = cursor.chd_nodes[char]
    tree




aa.build_table = ({ payload }) ->
    { arq, spark_ref } = payload
    tree_lib = _.reduce [ 'title', 'gtin', 'gender', 'sale_price', 'price', 'image_link', 'additional_image_link' ], (acc33, field, idx33) ->
        the_dictionary = _.reduce arq, (acc, entry, id) ->
            acc.push entry[field]
            acc
        , []
        the_tree = build_tree { the_dictionary }
        # NOTE TODO send a progress message update here.
        acc33[field] = the_tree
        acc33



aa.build_tree_deprecated = ({ payload }) ->
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
                                match_words: map_prefix_to_match
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
