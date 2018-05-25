


######  A simple search exercise with React, NodeJS, Primus:


Quick and dirty CSV parse, ReactJS client connected by Websockets to a NodeJS server.  

Can search linearly (not performant for serious applications, use Elasticsearch or something like that).

The interface is nothing special.  Very rudimentary.  I mostly focused on getting the full-stack elements wired up.  

I limited myself to a few hours for this task.  There were some bugs associated with breaking changes since I'd last used React (some months ago, recently I've been working with ReactNative).

There are no tests, as I think (unit) tests on React are mostly a waste of time, at least until getting to the point where one needs to worry about regressions, in serious computations.  

Integration tests are another matter, but those mostly matter when wiring up the backend.


Anyways I'm kind of out of time for this one right now, I might return to it later.




### Instructions:
- Assuming you have NodeJS, Npm, etc you will install Webpack `npm i -g webpack webpack-cli` and Nodemon `npm i -g nodemon`
- clone and `npm i`
- From directory `app_one` run the command `webpack -w`
- From directory `server` run `nodemon simple.coffee`
- Open a browser to port http://localhost:3003
- You can select the field to search with the dropdown.  Then type a search string in the input.  I didn't have time to clear the search results when for example deleting the text in the input bar.  (a few hours work.)
