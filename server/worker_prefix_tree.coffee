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


exports.reduce_tree = reduce_tree = (acc, tree) ->
    if acc.indexOf(tree.match_word) is -1
        acc = [].concat(acc, tree.match_word)
    _.reduce tree.chd_nodes, (acc2, node, prefix) ->
        reduce_tree acc2, node
    , acc


exports.search_prefix_tree = search_prefix_tree = (payload) ->
    { prefix } = payload
    if prefix.length is 0
        return []
    else
        cursor = tree
        canceled = false
        if cursor isnt undefined
            prefix_rayy = prefix.split ''
            for char in prefix_rayy
                if cursor.chd_nodes[char] isnt undefined
                    cursor = cursor.chd_nodes[char]
                else
                    canceled = true
                    return []
            if canceled is false
                reduce_tree([], cursor)


aa = {}


aa.search_tree = ({ payload }) ->
    { search_str, search_type, spark_ref } = payload
    # search above





# export for testing:
# because I needed to decouple the constructive properties of the function from the
# thread-associated messaging, I've factored the latter out into an injected `signal_func`.
exports.build_tree = buid_tree = ({ the_dictionary, signal_func }) ->
    tree =
        key: []
        chd_nodes: {}
        match_words: []

    len_dict = the_dictionary.length
    perc_count = len_dict / 100
    counter = 0
    for word, idx in the_dictionary
        cursor = tree
        prefix = ''
        if (word.length < 1) or (word is undefined)
            # NOTE TODO send a message on build failure
        else
            perc = counter++ / perc_count
            if Math.floor(counter % perc_count) is 0
                signal_func
                    field: field
                    perc_count: Math.floor perc
                    spark_ref: spark_ref


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
        acc33[field] = build_tree { the_dictionary }
        # NOTE TODO send a progress message update here.
        acc33

















keys_aa = _.keys aa




process.on 'message', ({ type, payload }) ->
    if _.includes(keys_aa, type)
        aa[type] { payload }
    else
        c (color.red "no-op in worker with type: #{type}", on)
