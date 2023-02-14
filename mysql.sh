# Shell script to configure Frontend component in Roboshop
# set -e >> which means whenever any step in the script is filing, the script will stop there and then it self
set -e

# if the password is not exported as a variable during run time, then i dont want to start the script without password
if [ -z ${mysql_password} ]
then
  echo “variable root_mysql_password is missing”
  exit
fi


source common.sh
db=mysql

# calling script from a function
DATA_BASE

# password to the database will be injected using export command as it is
#always a good practice not to disclose password in the script

PRINT_HEAD " change the default root password with EXPORT COMMAND"
mysql_secure_installation --set-root-pass {mysql_password}  &>> ${LOG}
STATUS_CHECK











