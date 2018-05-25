

aa = {}



aa.api_sc = ({ effect, store }) ->
    primus.write effect.payload


aa.init_primus = ({ effect, store }) ->
    primus.on 'data', (data) ->
        store.dispatch
            type: 'primus:data'
            payload: { data }


    primus.write
        type: 'checkin'



keys_aa = _.keys aa
effects_precursor = ({ store }) ->
    ({ effects_q })->
        if effects_q.length > 0
            _.map effects_q, (effect, idx) ->
                etype = effect.type
                effects_q.splice idx, 1
                if (_.includes keys_aa, etype)
                    aa[etype] { effect, store }
                else
                    c 'No-op in effects with type:', etype
                    # Don't log this in production.



exports.default = effects_precursor
