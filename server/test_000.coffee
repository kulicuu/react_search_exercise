



_ = require 'lodash'
fp = require 'lodash/fp'
c = console.log.bind console
color = require 'bash-color'
fs = require 'fs'
assert = require 'assert'




















{ build_tree, reduce_tree, search_prefix_tree } = require('./worker_prefix_tree.coffee')









d1_raw = fs.readFileSync './test_dictionaries/d1.txt', 'utf8'
d1 = d1_raw.split '\n'




signal_func = ({ field, perc_count, spark_ref }) ->
    c (color.green "SIGNAL FUNCTION HAS: ", on)


# build_dictionary d1

tree = build_tree
    the_dictionary: d1
    signal_func: signal_func
    field: 'test'
    spark_ref: 'test'



x1 = search_prefix_tree
    prefix: 'ob'
    tree: tree


c 'x1', x1, 'x1'
