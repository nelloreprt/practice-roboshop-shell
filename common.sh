#declaring a variable >> where value of the variable is dynamic, it changes as the path changes
path=$(pwd)

#declaring a variable >> where value of the variable is HARD CODED, where all the logs are stored
LOG=/tmp/roboshop.log

# this is a function with hardcoded values
STATUS_CHECK () {
  if [ $? -eq 0 ]; then
    echo -e "\e[31m Success \e[0m" ; else
      echo -e "\e[32m Fail \e[0m"
      echo -e "\e[33m check logs inside the path $LOG \e[0m"
  fi
}

# we are creating a function and we are sending a INPUT to the Function
# this is a dynamic function, where values of the function are injected inside the function
PRINT_HEAD () {
  echo $1
}

##################################


USER_CREATION () {
 PRINT_HEAD "Add application User"
   id roboshop
   if [ $? -ne 0]; then
     useradd roboshop &>> ${LOG}
   fi
   STATUS_CHECK

   PRINT_HEAD "Lets setup an app directory."
   mkdir /app  &>> ${LOG}
   STATUS_CHECK

   PRINT_HEAD "Download the application code to created app directory."
   curl -L -o /tmp/{component}.zip https://roboshop-artifacts.s3.amazonaws.com/{component}.zip &>> ${LOG}
   STATUS_CHECK

   PRINT_HEAD "Change directory to /app"
   cd /app &>> ${LOG}
   STATUS_CHECK

   PRINT_HEAD "Unzipping"
   rm -rf * /app &>> ${LOG}
   unzip /tmp/{component}.zip &>> ${LOG}
   STATUS_CHECK

}

NODEJS (){
  PRINT_HEAD "Setup NodeJS repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> ${LOG}
  STATUS_CHECK

  PRINT_HEAD "Install NodeJS"
  yum install nodejs -y &>> ${LOG}
  STATUS_CHECK

  PRINT_HEAD "Lets download the dependencies"
  cd /app
  npm install &>> ${LOG}
  STATUS_CHECK

}

SERVICE (){
PRINT_HEAD "Setup SystemD Catalogue Service"
  cp {path}/files/{component}.service /etc/systemd/system/{component}.service &>> ${LOG}
  STATUS_CHECK

  PRINT_HEAD "Load the service."
  systemctl daemon-reload &>> ${LOG}
  STATUS_CHECK

  PRINT_HEAD "Enable the service"
  systemctl enable {component} &>> ${LOG}
  STATUS_CHECK

  PRINT_HEAD "Start the service"
  systemctl start {component} &>> ${LOG}
  STATUS_CHECK

}

LOAD_SCHEMA(){
  if [ $schema_load == true ]; then
  if [ $db == mongo ]; then

    PRINT_HEAD "For the application to work fully functional we need to load schema to the Database"
    cp {path}/files/mongo.repo /etc/yum.repos.d/mongo.repo &>> ${LOG}
    STATUS_CHECK

    PRINT_HEAD "install mongodb-client"
    yum install mongodb-org-shell -y &>> ${LOG}
    STATUS_CHECK

    PRINT_HEAD "Load Schema"
    mongo --host MONGODB-SERVER-IPADDRESS </app/schema/{component}.js &>> ${LOG}
    STATUS_CHECK
    fi

   if [ $db == mysql ]; then
     PRINT_HEAD "install mysql client"
       labauto mysql-client &>> ${LOG}
       STATUS_CHECK

       PRINT_HEAD "Load Schema"
            mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -{mysql_password} < /app/schema/shipping.sql  &>> ${LOG}
            STATUS_CHECK
  fi
  fi
}


DATA_BASE (){

PRINT_HEAD " lets disable MySQL 8 version"
dnf module disable {db} -y  &>> ${LOG}
STATUS_CHECK

PRINT_HEAD " Setup the MySQL5.7 repo file"
cp {path}/files/{db}.repo /etc/yum.repos.d/{db}.repo &>> ${LOG}
STATUS_CHECK

PRINT_HEAD " Install MySQL Server"
yum install {db}-community-server -y  &>> ${LOG}
STATUS_CHECK

PRINT_HEAD " Enable MySQL Service"
systemctl enable {db}d  &>> ${LOG}
STATUS_CHECK

PRINT_HEAD " Start MySQL Service"
systemctl start {db}d  &>> ${LOG}
STATUS_CHECK

}