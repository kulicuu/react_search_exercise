




bb = {}


bb.progress_update_prefix_tree_build = ({ state, payload }) ->
    { perc_count, field } = payload
    state = state.set 'field', field
    state = state.set 'tree_build_progress', perc_count
    if field is 'gtin'
        state = state.set 'title_done', true
    if field is 'gender'
        state = state.set 'gtin_done', true
    if field is 'sale_price'
        state = state.set 'gender_done', true
    state


bb.res_std_search = ({ state, payload }) ->
    state = state.set 'results', Imm.Map(action.payload.data.payload)
    state


keys_bb = _.keys bb




server_msg_api = ({ type, payload, state, effects_q }) ->
    if _.includes(keys_bb, type)
        bb[type] { state, payload }
    else
        c "No-op in server_msg_api-api", type
        state












aa = {}


aa['primus:data'] = ({ state, action, effects_q }) ->
    { type, payload } = action.payload.data
    server_msg_api { type, payload, state, effects_q }


aa.api_sc = ({ state, action, effects_q }) ->
    effects_q.push
        type: 'api_sc'
        payload: action.payload
    state

keys_aa = _.keys aa


lookup_precursor = ({ effects_q }) ->
    (state, action) ->
        if _.includes(keys_aa, action.type)
            aa[action.type] { state, action, effects_q }
        else
            c "No-op in updates/reducers with type", action.type
            # NOTE : Better not to log this in production.
            state


exports.default = lookup_precursor
# exports.default = lookup
