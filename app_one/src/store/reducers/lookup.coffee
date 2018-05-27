




bb = {}


bb.res_std_search = ({ payload }) ->
    state = state.set 'results', Imm.Map(action.payload.data.payload)
    state


keys_bb = _.keys bb



server_msg_api = ({ type, payload }) ->
    if _.includes(keys_bb, type)
        bb[type] { payload }
    else
        c color.yellow("No-op in api-res-api")












aa = {}


aa['primus:data'] = ({ state, action, effects_q }) ->
    { type, payload } = action.payload.data
    server_msg_api { type, payload }


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
