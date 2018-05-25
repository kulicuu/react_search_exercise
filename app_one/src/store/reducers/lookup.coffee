

aa = {}




aa['primus:data'] = ({ state, action, effects_q }) ->
    # c action.payload.data.payload
    state = state.set 'results', Imm.Map(action.payload.data.payload)
    state


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
