# Shell script to configure Frontend component in Roboshop
# set -e >> which means whenever any step in the script is filing, the script will stop there and then it self
set -e

source common.sh
db=mongo

# calling script from a function
DATA_BASE

PRINT_HEAD "Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> ${LOG}
STATUS_CHECK

PRINT_HEAD "Restart the service to make the changes effected."
systemctl restart mongod &>> ${LOG}
STATUS_CHECK