




span_0_style =
    fontSize: 10
    maxWidth: '20%'
    width: '20%'
    marginRight: 30


span_1_style = fp.assign span_0_style,
    color: 'white'
    fontSize: 12

results_comp = ->
    res = @props.results.toArray()
    div
        style:
            backgroundColor: 'lightblue'
            width: '100%'
            display: 'flex'
            flexDirection: 'column'
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
            div
                key: "entry:#{id}"
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




search_bar = ->
    div
        style:
            marginTop: 12
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
                if @state.search_data_structure_type is 'naive'
                    @props.send_search_naive
                        search_str: e.currentTarget.value
                        search_type: @state.search_type
                else
                    @props.send_search_tree
                        search_str: e.currentTarget.value
                        search_type: @state.search_type
            style:
                width: '70%'
                height: 40
                marginBottom: 40
            type: 'text'
            placeholder: 'search_string'


tree_build_panel = ->
    div
        style:
            display: 'flex'
            justifyContent: 'center'
            alignItems: 'center'
            width: 140
            marginLeft: 20
            height: 48
            backgroundColor: 'lightgreen'
        span
            style:
                fontSize: 8
                color: 'grey'
            "building... #{@props.field} :  #{@props.tree_build_progress} %"
        button
            disabled: @state.building
            style:
                fontSize: 8
            onClick: (e) =>
                @props.command_build_tree()
                @setState
                    building: true
            "start build tree"


tree_search_bar = ->
        if @props.title_done
            div
                style:
                    marginTop: 12
                    width: '80%'
                    display: 'flex'
                    flexDirection: 'row'
                search_bar.bind(@)()
                tree_build_panel.bind(@)()
        else
            div
                style:
                    marginTop: 12
                    width: '80%'
                    display: 'flex'
                    flexDirection: 'row'
                tree_build_panel.bind(@)()





search_data_structure_type_panel = ->
    div
        style:
            display: 'flex'
            flexDirection: 'row'
        div
            onClick: =>
                @setState
                    search_data_structure_type: 'tree-search'
            style:
                border: if @state.search_data_structure_type is 'naive' then "" else "2px solid lightgreen"
                backgroundColor: 'white'
                width: 40
                height: 40
                display: 'flex'
                flexDirection: 'center'
                alignItems: 'center'
                cursor: 'pointer'
            span
                style:
                    fontSize: 10
                    textAlign: 'center'
                    color: if @state.search_data_structure_type is 'naive' then 'grey' else 'black'
                "tree-search"
        div
            onClick: =>
                @setState
                    search_data_structure_type: 'naive'
            style:
                border: if @state.search_data_structure_type is 'tree-search' then "" else "2px solid lightgreen"
                backgroundColor: 'white'
                width: 40
                height: 40
                display: 'flex'
                flexDirection: 'center'
                alignItems: 'center'
                cursor: 'pointer'
            span
                style:
                    fontSize: 10
                    textAlign: 'center'
                    color: if @state.search_data_structure_type is 'naive' then 'black' else 'grey'
                "naive-search"

comp = rr

    getInitialState: ->
        search_type: 'title'
        search_str: ''
        building: false
        search_data_structure_type: 'naive'


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

            search_data_structure_type_panel.bind(@)()
            if @state.search_data_structure_type is 'naive'
                search_bar.bind(@)()
            else
                tree_search_bar.bind(@)()

            results_comp.bind(@)()


map_state_to_props = (state) ->
    results: state.getIn ['lookup', 'results']
    tree_build_progress: state.getIn ['lookup', 'tree_build_progress']
    title_done: state.getIn ['lookup', 'title_done']
    field: state.getIn ['lookup', 'field']


map_dispatch_to_props = (dispatch) ->
    command_build_tree: ->
        dispatch
            type: 'api_sc'
            payload:
                type: 'command_build_tree'


    send_search_tree: ({ search_str, search_type }) ->
        dispatch
            type: 'api_sc'
            payload:
                type: 'tree_search'
                payload: { search_str, search_type }

    send_search_naive: ({ search_str, search_type }) ->
        dispatch
            type: 'api_sc'
            payload:
                type: 'std_search'
                payload: { search_str, search_type }


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
