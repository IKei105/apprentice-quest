#!/bin/bash

echo "パスワードマネージャーへようこそ！"
echo -n "サービス名を入力してください："
read service_name
echo -n "ユーザー名を入力してください："
read user_name
echo -n "パスワードを入力してください："
read password

password_info="${service_name}:${user_name}:${password}"
echo $password_info >> password_info.txt

echo -n "Thank you"
printf '\033[31m%s\033[m\n' '!'