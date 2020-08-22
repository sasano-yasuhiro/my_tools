#!/usr/bin/bash
entry_file=${2}

insert_react_module(){
  # 区切り文字を改行のみにする
  IFS_BACKUP=$IFS
  IFS=$'\n'
  # ファイルの読み込み
  while read -r LINE
  do
    if [ "`echo $LINE | grep 'presets'`" ]; then
      echo "presets: ['@babel/preset-env', '@babel/preset-react'],
      plugins: ['@babel/plugin-syntax-jsx'],"
    else
      echo $LINE
    fi
  done < webpack.config.js > webpack.config.js.new
  # 区切り文字を元に戻す
  IFS=$IFS_BACKUP
  # ファイルの置き換え
  mv webpack.config.js webpack.config.js.old
  mv webpack.config.js.new webpack.config.js
  rm webpack.config.js.old
}

create_entry_file(){
echo "import React from 'react';
import ReactDOM from 'react-dom';

console.log('Hello World!!!!');

let element = undefined;
ReactDOM.render(
  document.getElementById(element,'app')
);" > $entry_file
}

# メイン処理
if [ $# -ne 2 ]; then
  echo "$0 project-name entry_file" 1>&2
  exit 1
fi
proj=${1}
cd ${proj}
npm install @babel/preset-react --save-dev
npm install react react-dom
insert_react_module
create_entry_file

