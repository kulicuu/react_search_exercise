




span_0_style =
    fontSize: 10
    maxWidth: '20%'
    width: '20%'
    marginRight: 30


span_1_style = fp.assign span_0_style,
    color: 'white'
    fontSize: 12

results_comp = ->
    # c @props.results
    res = @props.results.toArray()
    div
        style:
            backgroundColor: 'lightblue'
            width: '100%'
            # height: '100%'
            display: 'flex'
            flexDirection: 'column'
        # @props.results.map (entry, id) =>
        #     c entry, 'entry'
        div
            style:
                display: 'flex'
                flexDirection: 'row'
                justifyContent: 'space-between'
                width: '100%'
                height: '10%'
            span
                style: span_1_style
                "Title"
            span
                style: span_1_style
                "Gtin"
            span
                style: span_1_style
                "Gender"
            span
                style: span_1_style
                "Sale Price"
            span
                style: span_1_style
                "Price"

        res.map (entry, id) ->
            c entry
            div
                key: "entry:#{id}"
            # div
            #     key: "entry:#{id}"
                style:
                    display: 'flex'
                    flexDirection: 'row'
                    justifyContent: 'space-between'
                    width: '100%'
                    height: '10%'
                span
                    style: span_0_style
                    entry.title
                span
                    style: span_0_style
                    entry.gtin
                span
                    style: span_0_style
                    entry.gender
                span
                    style: span_0_style
                    entry.sale_price
                span
                    style: span_0_style
                    entry.price




comp = rr

    getInitialState: ->
        search_type: 'title'
        search_str: ''

    render: ->
        div
            style:
                width: '100%'
                # height: '100%'
                display: 'flex'
                flexDirection: 'column'
                backgroundColor: 'ivory'
                justifyContent: 'center'
                alignItems: 'center'
            div

                style:
                    marginTop: 40
                    width: '80%'
                    # height: '20%'
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
                        height: 40
                        marginBottom: 40
                    type: 'text'
                    placeholder: 'search_string'
            results_comp.bind(@)()




map_state_to_props = (state) ->
    # lookup: state.get('lookup')
    c (state.getIn ['lookup', 'results']), 'results'
    results: state.getIn ['lookup', 'results']

map_dispatch_to_props = (dispatch) ->
    send_search: ({ search_str, search_type }) ->
        dispatch
            type: 'api_sc'
            payload:
                # type: 'std_search'
                type: 'tree_search'
                payload: { search_str, search_type }


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
