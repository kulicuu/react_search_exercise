



_ = require 'lodash'
fp = require 'lodash/fp'
c = console.log.bind console
color = require 'bash-color'
fs = require 'fs'

assert = require 'assert'










map_prefix_to_match = ({ dictionary, prefix }) ->
    candides = []
    for word in dictionary
        if word.indexOf(prefix) is 0
            candides.push word
    if candides.length > 1
        # return break_ties { candides }
        candides.pop()
    else
        candides.pop()


tree = null










{ build_tree, reduce_tree, search_prefix_tree } = require('./worker_prefix_tree.coffee')







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
                if cursor.chd_nodes[char] isnt undefined
                    cursor = cursor.chd_nodes[char]
                else
                    canceled = true
                    return []
            if canceled is false
                reduce_tree([], cursor)


d1_raw = fs.readFileSync './test_dictionaries/d1.txt', 'utf8'
d1 = d1_raw.split '\n'
build_dictionary d1






s1 = search_prefix_tree
    prefix: "occ"

c s1, 's1'

assert s1.indexOf('occurring') > -1
