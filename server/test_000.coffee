



_ = require 'lodash'
fp = require 'lodash/fp'
c = console.log.bind console
color = require 'bash-color'
fs = require 'fs'










map_prefix_to_match = ({ dictionary, prefix }) ->
    candides = []
    for word in dictionary
        c word, 'word'
        if word.indexOf(prefix) is 0
            c 'zero'
            candides.push word

    c candides, 'now candides'
    if candides.length > 1
        # return break_ties { candides }
        candides.pop()
    else
        candides.pop()







tree = null








build_dictionary3 = (the_dictionary) ->
    tree =
        key: []
        chd_nodes: {}
        match_words: []


    for word, idx in the_dictionary
        cursor = tree
        prefix = ''
        unless word.length < 1
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

    # tree








reduce_tree = (acc, tree) ->
    if acc.indexOf(tree.match_word) is -1
        acc = [].concat(acc, tree.match_word)
    _.reduce tree.chd_nodes, (acc2, node, prefix) ->
        reduce_tree acc2, node
    , acc








search_prefix_tree = (payload) ->
    { prefix } = payload
    if prefix.length is 0
        return []
    else
        cursor = tree
        canceled = false
        if cursor isnt undefined
            prefix_rayy = prefix.split ''
            for char in prefix_rayy
                c char, 'char'
                c cursor.chd_nodes[char], 'xxxx'
                if cursor.chd_nodes[char] isnt undefined
                    cursor = cursor.chd_nodes[char]
                else
                    canceled = true
                    c '23300'
                    return []

            if canceled is false
                c '2333'
                reduce_tree([], cursor)




d1_raw = fs.readFileSync './test_dictionaries/d1.txt', 'utf8'
d1 = d1_raw.split '\n'
build_dictionary3 d1



# c '\n'
# c tree.chd_nodes


s1 = search_prefix_tree
    prefix: "occ"

c s1, 's1'
