
c 'into index'



root_el = document.getElementById 'root'
Provider = rc require('react-redux').Provider
store = require('../store/create.coffee')
nexus = rc require('./nexus.coffee').default


root_component = rr
    render: ->
        c 'here'
        Provider
            store: store
            nexus()




set_and_render = ->
    { width, height } = root_el.getBoundingClientRect() # remove the props in favor of the global
    window.ww = width
    window.wh = height
    React_DOM.render spacer_component(), root_el
    setTimeout ->
        React_DOM.render root_component(), root_el
    , 10


window.onload = ->
    c '039034'
    set_and_render()
    window.onresize = debounce(set_and_render, 100, false)
