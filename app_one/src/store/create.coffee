

c '03'
{
    applyMiddleware, compose, createStore
} = require 'redux'
{ combineReducers } = require 'redux-immutable'
thunk = require('redux-thunk').default


c '3009'



initial_state = Imm.Map
    placeholder: 43


effects_q = [
    {
        type: 'init_primus'
    }
]


lookup = require('./reducers/lookup.coffee').default { effects_q }

reducers = { lookup }


store = createStore(combineReducers(reducers), initial_state, compose(applyMiddleware(thunk)))



effects = require('./effects/index.coffee').default { store }


effect_trigger = ->
    effects()



store.subscribe effect_trigger
effects()


exports.default = store
