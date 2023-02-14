# Shell script to configure Frontend component in Roboshop
# set -e >> which means whenever any step in the script is filing, the script will stop there and then it self
set -e

# if the password is not exported as a variable during run time, then i dont want to start the script without password
if [ -z ${mysql_password} ]
then
  echo “variable root_mysql_password is missing”
  exit
fi

# declaring a variable for my Component as "catalogue"
component=shipping

# declaring a variable for loading schema
schema_load=true

source common.sh

NODEJS

PRINT_HEAD "Hence we are going to install maven, This indeed takes care of java installation."
yum install maven -y &>> ${LOG}
STATUS_CHECK

USER_CREATION

PRINT_HEAD "Lets download the dependencies"
  cd /app
  mvn clean package &>> ${LOG}
  mv target/shipping-1.0.jar shipping.jar &>> ${LOG}
  STATUS_CHECK

SERVICE

LOAD_SCHEMA

