path = require 'path'


module.exports =
    entry: "./src/entry.coffee"
    output:
        path: path.resolve(__dirname, "public", "js")
        filename: "app_development.js"
        libraryTarget: "umd"
    module:
        rules: [
            {
                test: /\.coffee?/
                use: [ 'coffee-loader' ]
            }
            # ,
            # {
            #     test: /\.(png)$/
            #     use: [ 'url-loader' ]
            # }
        ]
