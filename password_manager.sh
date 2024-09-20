#!/bin/bash

readonly SERVICE_NAME=0
readonly USER_NAME=1
readonly PASSWORD=2

echo "パスワードマネージャーへようこそ！"
while true
do
  echo "次の選択肢から入力してください(Add Password/Get Password/Exit)："
  read input
  if [ "${input}" = "Add Password" ]; then
    echo -n "サービス名を入力してください："
    read service_name
    echo -n "ユーザー名を入力してください："
    read user_name
    echo -n "パスワードを入力してください："
    read password

    password_info="${service_name}:${user_name}:${password}"
    echo $password_info >> password_info.txt
    echo "パスワードの追加は成功しました。"

  elif [ "${input}" = "Get Password" ]; then
    echo -n "サービス名を入力してください："
    read input
    
    result=$(grep  $input password_info.txt)

    if [ -n "${result}" ] ; then
      results=(${result//:/ })
      echo "サービス名: ${results[SERVICE_NAME]}"
      echo "ユーザー名: ${results[USER_NAME]}"
      echo "パスワード: ${results[PASSWORD]}"
    else
      echo "そのサービスは登録されていません。"
    fi
  elif [ "${input}" = "Exit" ]; then
    echo -n "Thank you"
    printf '\033[31m%s\033[m\n' '!'
    exit
  else
    echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
  fi
done