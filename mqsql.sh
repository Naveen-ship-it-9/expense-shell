#!/bin/bash

log_folder="/var/log/expense-shell/"
script_name=$(echo $0 | cut -d "." -f1)
time_stamp=$(date +%Y-%m-%d-%H-%m-%S)
log_file="$log_folder/$script_name-$script_name.log"
mkdir -p $log_folder
userid=0    #$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

check_root()
{
    if [ $userid -ne 0 ]
    then
        echo -e "$R user dont have root access plz check...try with sudo.. $N" | tee -a $log_file
        exit 1
    else
        echo -e "$G user have root access... $N" | tee -a $log_file #&>>$log_file
    fi
}
validate()
{
    if [ $1 -ne 0 ]
    then
        echo -e "$R $2 is.... failed $N" | tee -a $log_file
    else
        echo -e "$G $2 is..... succ $N" | tee -a $log_file
    fi
}
echo "script start executing at: $(date)"
check_root

dnf install mysql server -y
validate $? "insatlling mysql server"

systemctl enable mysql
validate $? "enable mysql server"

systemctl start mysql
validate $? "started mysql server"

mysql_secure_installation --set-root-pass Naveen@09
validate $? "setting up root password"



