# Shell script to configure RabbitMQ component in Roboshop
# set -e >> which means whenever any step in the script is filing, the script will stop there and then it self
set -e

# if the password is not exported as a variable during run time, then i dont want to start the script without password
if [ -z ${roboshop_rabbitmq_password} ]
then
  echo “variable roboshop_rabbitmq_password is missing”
  exit
fi


source common.sh



PRINT_HEAD " We will download erlang Configure YUM Repos from the script provided by vendor"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>> ${LOG}
STATUS_CHECK

PRINT_HEAD " Install ErLang"
yum install erlang -y &>> ${LOG}
STATUS_CHECK

PRINT_HEAD " Configure YUM Repos for RabbitMQ"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> ${LOG}
STATUS_CHECK

PRINT_HEAD " Install RabbitMQ"
yum install rabbitmq-server -y &>> ${LOG}
STATUS_CHECK

PRINT_HEAD " Enable RabbitMQ Service"
systemctl enable rabbitmq-server &>> ${LOG}
STATUS_CHECK

PRINT_HEAD " Start RabbitMQ Service"
systemctl start rabbitmq-server &>> ${LOG}
STATUS_CHECK

PRINT_HEAD " Check for RabbitMQ port is 5672"
netstat -lntp &>> ${LOG}
STATUS_CHECK

PRINT_HEAD " create one user for the application"
sudo rabbitmqctl list users | roboshop &>> ${LOG}
if [ $? -ne 0 ]; then
rabbitmqctl add_user roboshop ${roboshop_rabbitmq_password} &>> ${LOG}
fi
STATUS_CHECK

PRINT_HEAD " Tagging the user as administrator"
rabbitmqctl set_user_tags roboshop administrator &>> ${LOG}
STATUS_CHECK

PRINT_HEAD " Setting permissions to the user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> ${LOG}
STATUS_CHECK
