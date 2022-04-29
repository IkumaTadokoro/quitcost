const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')
const { DefinePlugin } = require('webpack')
const webpack = require('webpack')
const dotenv = require('dotenv')

function hotfixPostcssLoaderConfig(subloader) {
  const subloaderName = subloader.loader
  if (subloaderName === 'postcss-loader') {
    if (subloader.options.postcssOptions) {
      console.log(
        '\x1b[31m%s\x1b[0m',
        'Remove postcssOptions workaround in config/webpack/environment.js'
      )
    } else {
      subloader.options.postcssOptions = subloader.options.config
      delete subloader.options.config
    }
  }
}

environment.loaders.keys().forEach((loaderName) => {
  const loader = environment.loaders.get(loaderName)
  loader.use.forEach(hotfixPostcssLoaderConfig)
})

environment.config.merge({
  module: {
    rules: [
      {
        test: /\.mjs$/,
        include: /node_modules/,
        type: 'javascript/auto'
      }
    ]
  }
})

const dotenvFiles = ['.env']
dotenvFiles.forEach((dotenvFile) => {
  dotenv.config({ path: dotenvFile, silent: true})
})

environment.plugins.prepend('Environment',
  new webpack.EnvironmentPlugin(
    JSON.parse(JSON.stringify(process.env))
  )
)

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.plugins.prepend(
  'Define',
  new DefinePlugin({
    __VUE_OPTIONS_API__: false,
    __VUE_PROD_DEVTOOLS__: false
  })
)
environment.loaders.prepend('vue', vue)
module.exports = environment
