#!/bin/bash
log_folder="/var/log/expense-shell/frontend/"
script_name=$(echo $0 | cut -d "." -f1)
time_stamp=$(date +%Y-%m-%d-%H-%m-%S)
log_file="$log_folder/$script_name-$time_stamp.log"
mkdir -p $log_folder
userid=$(id -u)
R="\e[31m"
G="\e[32"
N="\e[0m"
Y="\e[33m"
check_root()
{
    if [ $userid -ne 0 ]
    then
        echo -e "$Y user dont have root access... $N"
        exit 1
    else
        echo -e "$Y user have root access....$N"
    fi

}
validate()
{
    if [ $1 -ne 0 ]
    then
        echo -e "$R $2 is.....failed $N"
    else
        echo -e "$G $2 is.....succ $N"
    fi
}
echo "script start excute at:$(date)"
check_root

dnf install nginx -y 
validate $? "installing nginx"

systemctl enable nginx
validate $? "enabling nginx"

systemctl start nginx
validate $? "start nginx"

rm -rf /usr/share/nginx/html/*
validate $? "removing default websit"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
validate $? "Downloading front end code"

cd /usr/share/nginx/html
unzip /tmp/frontend.zip
validate $? "extract frontend code"

cp /c/devops/daws-81s/repos/expense-shell/backend.service /etc/nginx/default.d/expense.conf
validate "copy expense conf"

systemctl restart nginx
validate $? "restart nginx"
