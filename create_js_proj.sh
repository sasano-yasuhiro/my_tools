#!/usr/bin/bash
entry_file="app.js"
output_dir="public"
output_file="bundle.js"

# webpack.config.*.jsの作成
create_webpack_config(){
if test $1 = dev; then
  mode="development"
elif test $1 = release; then
  mode="production"
else
  exit 1
fi
echo "module.exports = {
  // ビルド情報の設定
  mode: '$mode', // ビルドモード(production,development)
  devtool: 'inline-source-map', // ソースマップ
  entry: './src/$entry_file', // エントリーファイル 
  output: {
    path: __dirname + '/$output_dir', // 出力ディレクトリ
    filename: '$output_file' // 出力ファイル
  },
  // 自動更新の設定
  watchOptions: {
    ignored: /node_modules/
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env']
          }
        }
      }
    ]
  },
};" > webpack.config.$1.js 
}

# エントリーファイルの作成
create_entry_file(){
echo "console.log('Hello World!!!!');
document.write('Hello World!!!!');
" > $entry_file
}

insert_babel_env(){
  echo '  "babel": {'
  echo '  "presets": [["@babel/preset-env", {"targets": ["defaults"]}]]'
  echo '  },'
}

# package.jsonに以下を追加
insert_package_json(){
#    "start": "webpack -w --config webpack.config.dev.js",
#    "build": "webpack --config webpack.config.release.js",
# 区切り文字を改行のみにする
IFS_BACKUP=$IFS
IFS=$'\n'
# ファイルの読み込み
while read -r LINE
do
  echo $LINE
  if [ "`echo $LINE | grep 'scripts'`" ]; then
    echo '    "start": "webpack -w --config webpack.config.dev.js",'
    echo '    "build": "webpack --config webpack.config.release.js",'
  elif [ "`echo $LINE | grep 'license'`" ]; then
    insert_babel_env
  fi
done < package.json > package.json.new
# ファイルの置き換え
mv package.json package.json.old
mv package.json.new package.json
rm package.json.old
# 区切り文字を元に戻す
IFS=$IFS_BACKUP
}

create_index(){
echo "<html>
<head>
<meta charset='UTF-8'>
<link rel='stylesheet' href='index.css'>
</head>
<body>
<script src='$output_file'></script>
</body>
</html>
" > $output_dir/index.html
echo "@charset 'utf-8';
body {
background-color:#cccccc;
}" > $output_dir/index.css
}

# メイン処理
if [ $# -ne 1 ]; then
  echo "$0 project-name" 1>&2
  exit 1
fi
mkdir ${1}
cd ${1}
npm init -y
npm install webpack webpack-cli --save-dev
npm install @babel/core @babel/cli @babel/preset-env --save-dev
npm install babel-loader --save-dev
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
insert_package_json
create_index
ls -l
ls -l public
cd ..

