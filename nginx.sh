#!/bin/bash
################################################ 
# Nginx vhost generation script test           #
# Dustin Larmeir  		               #
################################################

## Domain name input
echo "Please enter the desired domain name without the www. prefix"
read domain

## Additional Information
echo "Would you like clean url support for Wordpress?"
read answer
if [ "$answer" = "yes" ]; then
## Define webroot location
webroot=/home/dlarmeir/www

## Define username and group
username=www-data
group=www-data

## Define config file location
configfile=/etc/nginx/sites-available
configsymlink=/etc/nginx/sites-enabled

## Make directories based on definitions
mkdir -p $webroot/$domain;
mkdir -p $webroot/$domain/htdocs;
mkdir -p $webroot/$domain/logs;

## Change ownership of directories to be webserver writeable
chown -R $username:$group $webroot/$domain

## Vhost creation based on definitions
echo "server {" >>$configfile/$domain
echo "  listen      80;" >>$configfile/$domain
echo "  server_name $domain www.$domain;" >>$configfile/$domain
echo "  access_log $webroot/$domain/logs/access.log;" >>$configfile/$domain
echo "  error_log $webroot/$domain/logs/error.log;" >>$configfile/$domain
echo "  rewrite_log on;" >>$configfile/$domain
echo "  root    $webroot/$domain/htdocs;" >>$configfile/$domain
echo "  index   index.php index.html index.htm;" >>$configfile/$domain

## Wordpress rewrites (optional)
echo "" >>$configfile/$domain
echo "  # Wordpress Rewrites" >>$configfile/$domain
echo -n "       if (!-e $" >>$configfile/$domain; echo "request_filename) {" >>$configfile/$domain
echo -n "       rewrite ^/(.+)$ /index.php?url=$" >>$configfile/$domain; echo "1 last;" >>$configfile/$domain
echo "  break;" >>$configfile/$domain
echo "  }" >>$configfile/$domain

## FastCGI Configs
echo "" >>$configfile/$domain
echo "  # Enable FastCGI on unix:/tmp/php-fpm.sock" >>$configfile/$domain
echo "  location ~ \.php$ {" >>$configfile/$domain
echo "  fastcgi_pass   unix:/var/run/php5-fpm.sock;" >>$configfile/$domain
echo "  fastcgi_index  index.php;" >>$configfile/$domain
echo "  fastcgi_intercept_errors on;" >>$configfile/$domain
echo -n "       fastcgi_param  SCRIPT_FILENAME " >>$configfile/$domain; echo -n "$" >>$configfile/$domain; echo -n "document_root$">>$configfile/$domain; echo "fastcgi_script_name;" >>$configfile/$domain
echo "  include        fastcgi_params;" >>$configfile/$domain
echo "  }" >>$configfile/$domain

## Block hidden file types
echo "" >>$configfile/$domain
echo "  # Deny hidden file types" >>$configfile/$domain
echo "  location ~ /(\.ht|\.git|\.svn) {" >>$configfile/$domain
echo "  deny  all;" >>$configfile/$domain
echo "  }" >>$configfile/$domain
echo "}" >>$configfile/$domain

## Build symlink for production
ln -s $configfile/$domain $configsymlink/$domain

## Server restart
/etc/init.d/nginx restart
## End of script
echo "Complete"
sh dustins-nginx-administration-tool.sh
fi
if [ "$answer" = "no" ]; then
## Define webroot location
webroot=/home/dlarmeir/www

## Define username and group
username=www-data
group=www-data

## Define config file location
configfile=/etc/nginx/sites-available
configsymlink=/etc/nginx/sites-enabled

## Make directories based on definitions
mkdir -p $webroot/$domain;
mkdir -p $webroot/$domain/htdocs;
mkdir -p $webroot/$domain/logs;

## Change ownership of directories to be webserver writeable
chown -R $username:$group $webroot/$domain

## Vhost creation based on definitions
echo "server {" >>$configfile/$domain
echo "  listen      80;" >>$configfile/$domain
echo "  server_name $domain www.$domain;" >>$configfile/$domain
echo "  access_log $webroot/$domain/logs/access.log;" >>$configfile/$domain
echo "  error_log $webroot/$domain/logs/error.log;" >>$configfile/$domain
echo "  rewrite_log on;" >>$configfile/$domain
echo "  root    $webroot/$domain/htdocs;" >>$configfile/$domain
echo "  index   index.php index.html index.htm;" >>$configfile/$domain

## FastCGI Configs
echo "" >>$configfile/$domain
echo "  # Enable FastCGI on unix:/tmp/php-fpm.sock" >>$configfile/$domain
echo "  location ~ \.php$ {" >>$configfile/$domain
echo "  fastcgi_pass   unix:/var/run/php5-fpm.sock;" >>$configfile/$domain
echo "  fastcgi_index  index.php;" >>$configfile/$domain
echo "  fastcgi_intercept_errors on;" >>$configfile/$domain
echo -n "       fastcgi_param  SCRIPT_FILENAME " >>$configfile/$domain; echo -n "$" >>$configfile/$domain; echo -n "document_root$">>$configfile/$domain; echo "fastcgi_script_name;" >>$configfile/$domain
echo "  include        fastcgi_params;" >>$configfile/$domain
echo "  }" >>$configfile/$domain

## Block hidden file types
echo "" >>$configfile/$domain
echo "  # Deny hidden file types" >>$configfile/$domain
echo "  location ~ /(\.ht|\.git|\.svn) {" >>$configfile/$domain
echo "  deny  all;" >>$configfile/$domain
echo "  }" >>$configfile/$domain
echo "}" >>$configfile/$domain

## Build symlink for production
ln -s $configfile/$domain $configsymlink/$domain

## Server restart
/etc/init.d/nginx restart
## End of script
echo "Complete"
sh dustins-nginx-administration-tool.sh
fi


