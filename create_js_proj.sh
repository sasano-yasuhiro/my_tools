#!/usr/bin/bash
entry_file="app.js"
output_dir="public"
function create_webpack_config(){
if test $1 = dev; then
  mode="development"
elif test $1 = release; then
  mode="production"
else
  exit
fi
echo "module.exports = {
  // ビルド情報の設定
  mode: '$mode', // ビルドモード(production,development)
  devtool: 'inline-source-map', // ソースマップ
  entry: './src/$entry_file', // エントリーファイル 
  output: {
    path: __dirname + '/$output_dir', // 出力ディレクトリ
    filename: 'sample.js' // 出力ファイル
  },
  // 自動更新の設定
  watchOptions: {
    ignored: /node_modules/
  },
};" > webpack.config.$1.js 
}
create_entry_file(){
echo "console.log('Hello World!!!!');
" > $entry_file
}
# メイン処理
mkdir ${1}
cd ${1}
npm init -y
npm install webpack webpack-cli --save-dev
# 初期ファイルの配置
create_webpack_config dev
create_webpack_config release
mkdir src
mkdir $output_dir # 出力先
cd src
create_entry_file 
#touch $entry_file 
cd ..
# 後処理
# package.jsonに以下を追加
#    "start": "webpack -w --config webpack.config.dev.js",
#    "build": "webpack --config webpack.config.release.js",
ls -l
cd ..

