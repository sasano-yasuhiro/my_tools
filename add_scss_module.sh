#!/usr/bin/bash
insert_scss(){
echo "      {
        test: /\.(sa|sc|c)ss$/,
        exclude: /node_modules/,
        use: [
          'style-loader',
          {
            loader: 'css-loader',
            options: { url: false }
          },
          'sass-loader'
        ]
      },"
}

npm install style-loader css-loader sass-loader node-sass --save-dev
cd ${1}
# 区切り文字を改行のみにする
IFS_BACKUP=$IFS
IFS=$'\n'
# ファイルの読み込み
while read -r LINE
do
  echo $LINE
  if [[ $LINE =~ rules ]]; then
    insert_scss
  elif [[ $LINE =~ sass-loader ]]; then
    exit 1
  fi
done < webpack.config.js > webpack.config.js.new
# 区切り文字を元に戻す
IFS=$IFS_BACKUP
# ファイルの置き換え
mv webpack.config.js webpack.config.js.old
mv webpack.config.js.new webpack.config.js
rm webpack.config.js.old
cd ..
