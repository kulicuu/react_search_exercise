



#
# map_idx_to_color = (idx) ->
#     switch idx % 5
#         when 0 then 'springgreen'
#         when 1 then 'steelblue'
#         when 2 then 'mintcream'
#         when 3 then 'moccasin'
#         when 4 then 'lightgoldenrodyellow'







comp = rr
    # getInitialState: ->
    #     hovering: -1

    render: ->
        div null, "dashboard"
            # # className: "home"
            # for idx in [0 .. 100]
            #     div
            #         onMouseOver: do (idx) =>
            #             =>
            #                 @setState
            #                     hovering: idx
            #         onMouseOut: do (idx) =>
            #             =>
            #                 @setState
            #                     hovering: -1
            #         key: "ball:#{idx}"
            #         className: "ball"
            #         style:
            #             backgroundColor: map_idx_to_color(idx)
            #             width: do =>
            #                 if @state.hovering is idx
            #                     .23 * ww
            #                 else
            #                     .13 * ww
            #             height: do =>
            #                 if @state.hovering is idx
            #                     .23 * ww
            #                 else
            #                     .13 * ww





map_state_to_props = (state) ->
    state.get('lookup').toJS()

map_dispatch_to_props = (dispatch) ->
    {}




exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
