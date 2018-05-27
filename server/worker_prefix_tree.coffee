












tree_lib = _.reduce [ 'title', 'gtin', 'gender', 'sale_price', 'price', 'image_link', 'additional_image_link' ], (acc33, field, idx33) ->
    the_dictionary = _.reduce arq, (acc, entry, id) ->
        acc.push entry[field]
        acc
    , []

    tree =
        key: []
        chd_nodes: {}
        match_words: []

    the_dictionary.map (word, idx) ->
        c field, word
        unless word is undefined
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
