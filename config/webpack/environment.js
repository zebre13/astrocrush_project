const { environment } = require('@rails/webpacker')

// Preventing Babel from transpiling NodeModules packages
environment.loaders.delete('nodeModules');

//jquery
const webpack = require('webpack')

environment.plugins.prepend('Provide',
new webpack.ProvidePlugin({
  $: 'jquery/src/jquery',
  jQuery: 'jquery/src/jquery'
})
)

module.exports = environment
