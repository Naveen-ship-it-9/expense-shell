#!/bin/bash

# log_folder="/var/log/expense-shell/"
# script_name=$(echo $0 | cut -d "." -f1)
# time_stamp=$(date +%Y-%m-%d-%H-%m-%S)
# log_file="$log_folder/$script_name-$script_name.log"
# mkdir -p $log_folder
# userid=0    #$(id -u)
# R="\e[31m"
# G="\e[32m"
# N="\e[0m"
# Y="\e[33m"

# check_root()
# {
#     if [ $userid -ne 0 ]
#     then
#         echo -e "$R user dont have root access plz check...try with sudo.. $N" | tee -a $log_file
#         exit 1
#     else
#         echo -e "$G user have root access... $N" | tee -a $log_file #&>>$log_file
#     fi
# }
# validate()
# {
#     if [ $1 -ne 0 ]
#     then
#         echo -e "$R $2 is.... failed $N" | tee -a $log_file
#     else
#         echo -e "$G $2 is..... succ $N" | tee -a $log_file
#     fi
# }
# echo "script start executing at: $(date)"
# check_root

# dnf install mysql server -y
# validate $? "insatlling mysql server"

# systemctl enable mysql
# validate $? "enable mysql server"

# systemctl start mysql
# validate $? "started mysql server"

# mysql_secure_installation --set-root-pass Naveen@09
# validate $? "setting up root password"


#e script run chesenpudu ala manaku password set up place lo error vasthudi bcz password already set up 
#if u run the script first time password well set up but if u run it again password place way error its already set up
#before set up password only we check if password set up no need to set if not it need to set up


log_folder="/var/log/expense-shell/"
script_name=$(echo $0 | cut -d "." -f1)
time_stamp=$(date +%Y-%m-%d-%H-%m-%S)
log_file="$log_folder/$script_name-$script_name.log"
mkdir -p $log_folder
userid=$(id -u)
G="\e[32m"
R="\e[31m"
N="\e[0m"
Y="\e[33m"
check_root()
{
    if [ $userid -ne 0 ]
    then
        echo -e "$R user dont have root access...plz check $N"
        exit 1
    else
        echo -e "$G user have root access $N"
    fi
}
validate()
{
    if [ $1 -ne 0 ]
    then
        echo -e "$R $2 is....Failed $N"
    else
        echo -e "$G $2 is....succ $N"
    fi
}
echo "script run date is:$(date)"
check_root

dnf insatll mysql server -y
validate $? "insatlling mysql"

systemctl enable mysql
validate $? "enabling mysql"

systemctl start mysql
validate $? "start mysql"

#mysql -h ipaddress -u root -pExpenseApp@1 -e 'show databases;'
#instred of ip we use DNS

mysql -h mysql.daws81s.online -u root -pExpenseApp@1 -e 'show databases;'
if [ $? -ne 0 ]
then
    echo "mysql root password is not setup setting now"
    mysql_secure_installation --set-root-pass Naveen@09
    validate $? "setting up root password"
else
    echo "mysql root pass already setup..."
fi
