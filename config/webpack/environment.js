const { environment } = require('@rails/webpacker')

module.exports = environment

const webpack = require('webpack')

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)

environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'postcss-loader'
})

module.exports = environment
