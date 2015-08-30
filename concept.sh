#!/bin/bash
###############################
# Dustin's Nginx Tool Concept #
###############################

# Distribution Detection

if [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
   DISTRO=$DISTRIB_ID

elif [ -f /etc/redhat-release ]; then
   DISTRO="RedHat/CentOS"

else
   DISTRO=$(uname -s)

fi
echo "You are running $DISTRO Linux"

# Nginx Installation Check 

