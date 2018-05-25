







comp = rr


    render: ->
        div null, "dashboard"




map_state_to_props = (state) ->
    lookup: state.get('lookup')

map_dispatch_to_props = (dispatch) ->
    {}


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
