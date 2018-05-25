

{
    applyMiddleware, compose, createStore
} = require 'redux'
{ combineReducers } = require 'redux-immutable'
thunk = require('redux-thunk').default


initial_state = Imm.Map
    placeholder: 43

c 'initial_state', initial_state



effects_q = [
    {
        type: 'init_primus'
    }
]


lookup = require('./reducers/lookup.coffee').default { effects_q }
# lookup = require('./reducers/lookup.coffee').default


reducers = { lookup }


store = createStore(lookup, initial_state, applyMiddleware(thunk))
c 'store', store

effects = require('./effects/index.coffee').default { store }




effect_trigger = ->
    effects { effects_q }



store.subscribe effect_trigger
effects { effects_q }


exports.default = store
