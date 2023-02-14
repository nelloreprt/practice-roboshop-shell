# Shell script to configure Frontend component in Roboshop
# set -e >> which means whenever any step in the script is filing, the script will stop there and then it self
set -e

source common.sh

PRINT_HEAD "Install Nginx"
yum install nginx -y &>> ${LOG}
STATUS_CHECK

PRINT_HEAD "Enable Nginx service"
systemctl enable nginx &>> ${LOG}
STATUS_CHECK

PRINT_HEAD "Start Nginx service"
systemctl start nginx &>> ${LOG}
STATUS_CHECK

PRINT_HEAD "Remove the default content that web server is serving."
rm -rf /usr/share/nginx/html/* &>> ${LOG}
STATUS_CHECK

PRINT_HEAD "Download the frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>> ${LOG}
STATUS_CHECK

PRINT_HEAD "Extract the frontend content."
cd /usr/share/nginx/html &>> ${LOG}
STATUS_CHECK

PRINT_HEAD "empty the content in >> /usr/share/nginx/html"
rm -rf * &>> ${LOG}
STATUS_CHECK

PRINT_HEAD "unzipping"
unzip /tmp/frontend.zip &>> ${LOG}
STATUS_CHECK

PRINT_HEAD "Create Nginx Reverse Proxy Configuration."
cp ${path}/files/robosho.conf /etc/nginx/default.d/roboshop.conf &>> ${LOG}
STATUS_CHECK

PRINT_HEAD "Restart Nginx Service to load the changes of the configuration."
systemctl restart nginx &>> ${LOG}
STATUS_CHECK