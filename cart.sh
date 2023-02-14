# Shell script to configure Frontend component in Roboshop
# set -e >> which means whenever any step in the script is filing, the script will stop there and then it self
set -e

# declaring a variable for my Component as "cart"
component=cart

# declaring a variable for loading schema
schema_load=false

source common.sh

NODEJS
USER_CREATION
SERVICE

