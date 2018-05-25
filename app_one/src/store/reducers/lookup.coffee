

aa = {}


keys_aa = _.includes aa


lookup_precursor = ({ effects_q }) ->
# lookup = (state, action) ->
    (state, action) ->
        # c 'into reducer with state', state
        # c 'and action', action
        if _.includes(keys_aa, action.type)
            aa[action.type] { state, action, effects_q }
            # aa[action.type] { state, action }
        else
            c "No-op in updates/reducers with type", action.type
            # NOTE : Better not to log this in production.
            state



exports.default = lookup_precursor
# exports.default = lookup
