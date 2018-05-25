

aa = {}


keys_aa = _.includes aa


lookup_precursor = ({ effects_q }) ->
    (action, type) ->
        if _.includes(keys_aa, action.type)
            aa[action.type] { state, action, effects_q }
        else
            c "No-op in updates/reducers with type", action.type
            # NOTE : Better not to log this in production.
            state



exports.default = lookup_precursor
