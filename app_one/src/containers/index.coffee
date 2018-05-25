

root_el = document.getElementById 'root'
Provider = rc require('react-redux').Provider
store = require('../store/create.coffee').default
nexus = rc require('./nexus.coffee').default


root_component = rr
    render: ->
        Provider
            store: store
            nexus()


set_and_render = ->
    { width, height } = root_el.getBoundingClientRect() # remove the props in favor of the global
    window.ww = width
    window.wh = height
    React_DOM.render root_component(), root_el


window.onload = ->
    c 'window'
    set_and_render()
    window.onresize = debounce(set_and_render, 100, false)
