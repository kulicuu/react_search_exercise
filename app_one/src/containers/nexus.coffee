




dashboard = rc require('../scenes/dashboard.coffee').default

render = ->
    c 'into'
    dashboard()

comp = rr
    render: render

map_state_to_props = (state) ->
    {}

map_dispatch_to_props = (dispatch) ->
    {}

exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
