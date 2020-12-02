const path = require("path");
const glob = require("glob");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const TerserPlugin = require("terser-webpack-plugin");
const OptimizeCSSAssetsPlugin = require("optimize-css-assets-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const {CleanWebpackPlugin} = require("clean-webpack-plugin");

module.exports = (env, options) => ({
  entry: {
    app: "./app/index.ts"
  },
  context: path.resolve(__dirname, "src"),
  output: {
    filename: "./js/[name].js",
    path: path.resolve(__dirname, "../priv/static/"),
  },
  optimization: {
    minimizer: [
      new TerserPlugin({
        parallel: true,
        terserOptions: { compress: { unused: true, dead_code: true } },
      }),
      new OptimizeCSSAssetsPlugin({}),
    ],
  },
  resolve: {
    extensions: [".ts", ".js", ".json"],
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
        test: /\.(s[ac]|c)ss$/,
        use: [MiniCssExtractPlugin.loader, "css-loader", "sass-loader"],
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
  ],
});
