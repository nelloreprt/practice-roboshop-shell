# Shell script to configure Frontend component in Roboshop
# set -e >> which means whenever any step in the script is filing, the script will stop there and then it self
set -e

source common.sh

PRINT_HEAD "Redis is offering the repo file as a rpm"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> ${LOG}
STATUS_CHECK

PRINT_HEAD "Enable Redis 6.2 from package streams"
dnf module enable redis:remi-6.2 -y &>> ${LOG}
STATUS_CHECK

PRINT_HEAD "Install Redis"
dnf yum install redis -y &>> ${LOG}
STATUS_CHECK

PRINT_HEAD "Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/redis.conf & /etc/redis/redis.conf"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>> ${LOG}
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf &>> ${LOG}
STATUS_CHECK

PRINT_HEAD "Enable Redis Service"
systemctl enable redis &>> ${LOG}
STATUS_CHECK

PRINT_HEAD "Start Redis Service"
systemctl start redis &>> ${LOG}
STATUS_CHECK



