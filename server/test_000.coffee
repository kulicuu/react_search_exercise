



_ = require 'lodash'
fp = require 'lodash/fp'
c = console.log.bind console
color = require 'bash-color'
fs = require 'fs'








reduce_tree = (acc, tree) ->
    if acc.indexOf(tree.match_word) is -1
        acc = [].concat(acc, tree.match_word)
    _.reduce tree.chd_nodes, (acc2, node, prefx) ->
        reduce_tree acc2, node
    , acc




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




send_progress = ->
    c 'sending progress'

send_match = ->
    c 'sending match'





test_build_dictionary = (the_dictionary) ->

    tree =
        key: []
        chd_nodes: {}
        match_words: []

    the_dictionary.map (word, idx) ->
        # c field, word
        unless word is undefined
            # counter++
            # perc = counter / perc_count
            # if Math.floor(counter % perc_count) is 0
            #     send_progress
            #         field: field
            #         perc_count: Math.floor perc
            #         spark_ref: spark_ref
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


    c 'now tree', tree




search_tree = ({ payload }) ->
    { search_str } = payload
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
                    c 'cancelled'
            if cancelled is false
                reduce_tree( [], cursor )





d1_raw = fs.readFileSync './test_dictionaries/d1.txt', 'utf8'
d1 = d1_raw.split '/n'
test_build_dictionary d1
