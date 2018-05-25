


{
    applyMiddleware, compose, createStore
} = require 'redux'
{ combineReducers } = require 'redux-immutable'
thunk = require('redux-thunk').default


lookup = require('./reducers/lookup.coffee').default

reducers = { lookup }

initial_state = Imm.Map
    placeholder: 43

store = createStore(combineReducers(reducers), initial_state, compose(applyMiddleware(thunk)))








effect_trigger = ->
    effects { effects_q }


state_store.subscribe effect_trigger
effects { effects_q }


export default store
