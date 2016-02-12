var path    = require('path');
var webpack = require('webpack');

module.exports = {
  entry: './lib/react/denshobato.js',
  output: { path: __dirname + '/app/assets/javascripts/', filename: 'denshobato.js' },
  resolve: { extensions: ['', '.js', '.jsx'] },
  module: {
    loaders: [
      {
        test: /.jsx?$/,
        loader: 'babel-loader',
        exclude: /node_modules/,
        query: {
          plugins: ['transform-decorators-legacy'],
          presets: ['es2015', 'react', 'stage-0', 'stage-1', 'stage-2', 'stage-3'],
        },
      },
      {
        test: /\.sass$/,
        loaders: ['style', 'css', 'sass'],
      },
    ],
  },
};
