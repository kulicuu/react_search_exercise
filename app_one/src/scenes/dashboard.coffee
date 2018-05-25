







comp = rr

    getInitialState: ->
        search_type: 'title'
        search_str: ''

    render: ->
        div
            style:
                width: '100%'
                height: '100%'
                display: 'flex'
                flexDirection: 'column'
                backgroundColor: 'beige'
                justifyContent: 'center'
                alignItems: 'center'
            div
                style:
                    width: '80%'
                    height: '20%'
                    display: 'flex'
                    flexDirection: 'row'
                select
                    onChange: (e) =>
                        @setState
                            search_type: e.currentTarget.value

                    style:
                        width: 100
                        height: 40
                        # backgroundColor: 'red'
                    name: 'search_by'
                    option
                        value: 'title'
                        'title'
                    option
                        value: 'gtin'
                        'gtin'
                    option
                        value: 'gender'
                        'gender'
                    option
                        value: 'sale_price'
                        'sale_price'
                    option
                        value: 'price'
                        'price'
                    option
                        value: 'image_link'
                        'image_link'
                    option
                        value: 'additional_image_link'
                        'additional_image_link'
                input
                    onChange: (e) =>
                        @setState
                            search_str: e.currentTarget.value
                        @props.send_search
                            search_str: e.currentTarget.value
                            search_type: @state.search_type
                    style:
                        width: '70%'
                        height: '30%'
                    type: 'text'
                    placeholder: 'search_string'





map_state_to_props = (state) ->
    lookup: state.get('lookup')

map_dispatch_to_props = (dispatch) ->
    send_search: ({ search_str, search_type }) ->
        dispatch
            type: 'api_sc'
            payload:
                type: 'std_search'
                payload: { search_str, search_type }


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
