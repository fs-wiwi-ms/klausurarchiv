const path = require("path");
const glob = require("glob");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const TerserPlugin = require("terser-webpack-plugin");
const OptimizeCSSAssetsPlugin = require("optimize-css-assets-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const CompressionPlugin = require("compression-webpack-plugin");

module.exports = (env, options) => ({
  optimization: {
    minimizer: [
      new TerserPlugin({
        parallel: true
      }),
      new OptimizeCSSAssetsPlugin({}),
    ],
  },
  context: path.resolve(__dirname, "src"),
  entry: {
    app: "./app/index.ts"
  },
  output: {
    filename: "./js/[name].js",
    path: path.resolve(__dirname, "../priv/static/"),
  },
  resolve: {
    extensions: [".ts", ".js"],
  },
  devtool: "inline-source-map",
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader",
        },
      },
      {
        test: /\.tsx?$/,
        use: "ts-loader",
        exclude: /node_modules/,
      },
      {
        test: /\.ts$/,
        enforce: "pre",
        use: [
          {
            loader: "tslint-loader",
            options: {
              /* Loader options go here */
            },
          },
        ],
      },
      {
        test: /\.(sa|c)ss$/,
        use: [MiniCssExtractPlugin.loader,
          "css-loader",
          "sass-loader",
        ],
      },
      {
        test: /\.(eot|woff|woff2|svg|ttf)([\?]?.*)$/,
        use: [
          {
            loader: "file-loader",
            options: {
              outputPath: "../static/fonts/",
              publicPath: "/fonts/",
            },
          },
        ],
      },
      {
        test: /\.png$/,
        use: [
          {
            loader: "file-loader",
            options: {
              outputPath: "../static/images/",
              publicPath: "/images/",
            },
          },
        ],
      },
    ],
  },
  plugins: [
    new CleanWebpackPlugin(),
    new MiniCssExtractPlugin({
      filename: "./css/[name].css",
    }),
    new CopyWebpackPlugin({
      patterns: [
        {from: "../static/", to: "./"}
      ],
    }),
    new CompressionPlugin()
  ],
});
