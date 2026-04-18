#!/bin/bash
log_folder="/var/log/expense/backend"
script_name=$(echo $0 -d "." -f1)
time_stamp=$(date +%Y-%m-%d-%H-%m-%S)
log_file="$log_folder/$script_name-$time_stamp.log"
mkdir -p $log_folder
userid=0   #$(id -u)
R="\e[31m"
G="\e[32"
N="\e[0m"
Y="\e[33m"
check_root()
{
    if [ $userid -ne 0 ]
    then
        echo "user dont have root access"
        exit 1
    else
        echo "user have root access"
    fi
}
validate()
{
    if [ $1 -ne 0 ]
    then
        echo "$2 is failed"
        exit 1
    else
        echo "$2 is succ"
    fi

}
echo "script start excute at:$(date)"
check_root

dnf module disable nodejs -y
validate $? "disable difault node js"

dnf module enable nodejs:20 -y
validate $? "enable node js:20"

dnf install nodejs -y
validate $? "install nodejs"

useradd expense
validate $? "creating user expense"

mkdir -p /app #if we run 2nd time we get error
validate $? "creating app dir"

#if we run this 2nd time we get error so we need to delete old code
curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
validate $? "Downloading backend application code"

cd /app
unzip /tmp/backend.zip
validate $? "extracting backend application code"
npm install

cp /c/devops/daws-81s/repos/expense-shell/backend.service /etc/systemd/system/backend.service

#load the date before running backend

dnf install mysql -y
validate $? "installing mysql client"

#mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pExpenseApp@1 < /app/schema/backend.sql
mysql -h <mysql.daws81s.online> -uroot -pExpenseApp@1 < /app/schema/backend.sql
validate $? "schema loading"

systemctl daemon-reload
validate $? "daemon reload"

systemctl enable backend
validate $? "enable backend"

systemctl restart backend
validate $? "restart backend"



