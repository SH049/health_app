const { environment } = require('@rails/webpacker')

module.exports = environment

const webpack = require('webpack')

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)
const sassLoader = environment.loaders.get('sass')
sassLoader.use.push('sass-loader')

environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'postcss-loader'
})

module.exports = environment
