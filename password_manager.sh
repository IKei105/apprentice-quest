#!/bin/bash

readonly SERVICE_NAME=0
readonly USER_NAME=1
readonly PASSWORD=2

echo "パスワードマネージャーへようこそ！"
echo "公開鍵として登録したメールアドレスを入力してください。"
read mail_address
while [ -z "$mail_address" ]; do
  echo -n "メールアドレスを入力してください："
  read mail_address
done

while true
do
  echo "次の選択肢から入力してください(Add Password/Get Password/Exit)："
  read input

  if [ "${input}" = "Add Password" ]; then
    echo -n "サービス名を入力してください："
      read service_name
    while [ -z "$service_name" ]; do
      echo -n "サービス名を正しく入力してください："
      read service_name
    done
    echo -n "ユーザー名を入力してください："
    read user_name
    while [ -z "$user_name" ]; do
      echo -n "ユーザー名を正しく入力してください："
      read user_name
    done
    echo -n "パスワードを入力してください："
    read password
    while [ -z "$password" ]; do
      echo -n "パスワードを正しく入力してください："
      read password
    done
    password_info="${service_name}:${user_name}:${password}"

    if [ -e password_info.txt.gpg ]; then
      gpg -d password_info.txt.gpg > password_info.txt
    else
      touch password_info.txt
    fi

    echo $password_info >> password_info.txt

    gpg -r $mail_address -e password_info.txt
 
    if [ $? -eq 0 ]; then
      rm password_info.txt
    else
      echo "エラーが発生しました。終了します。"	
    fi

    echo "パスワードの追加は成功しました。"
  elif [ "${input}" = "Get Password" ]; then
    if [ -e password_info.txt.gpg ]; then
      echo -n "サービス名を入力してください："
      read input

      gpg -d password_info.txt.gpg > password_info.txt
      result=$(grep  $input password_info.txt)

      rm password_info.txt

      if [ -n "${result}" ] ; then
        results=(${result//:/ })
        echo "サービス名: ${results[SERVICE_NAME]}"
        echo "ユーザー名: ${results[USER_NAME]}"
        echo "パスワード: ${results[PASSWORD]}"
      else
        echo "そのサービスは登録されていません。"
      fi
    else
      echo "サービスの登録が行われていません。"
    fi
  elif [ "${input}" = "Exit" ]; then
    echo -n "Thank you"
    printf '\033[31m%s\033[m\n' '!'
    exit
  else
    echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
  fi
done
