#!/bin/sh

# MYSQL SETUP 
#
# ###########



#
# Creating supervisor file
###########################
create_supervisor_conf() {
  rm -rf /etc/supervisord.conf
  cat > /etc/supervisord.conf <<EOF
[unix_http_server]
file=/var/run/supervisor.sock   ; 
chmod=0700                       ; 

[supervisord]
logfile=/var/log/supervisord.log ; 
pidfile=/var/run/supervisord.pid ; 
childlogdir=/var/log/           ; 

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///var/run/supervisor.sock ; 

[program:nginx]
command=/usr/sbin/nginx
autorestart=true
autostart=true


EOF
}

# WWW & LOGS 
#
# ################

create_www_dir() {
  # Create LOG directoties for NGINX & PHP-FPM
  echo "Creating www directories"
  mkdir -p /DATA/www
  mkdir -p /DATA/logs

}

apply_www_permissions(){
  echo "Applying www permissions"
  chown -R nginx:nginx /DATA/www /DATA/logs

}


# DJANGO INSTALL  
#
# ################




# Running all our scripts
create_www_dir
apply_www_permissions
create_supervisor_conf




# Start Supervisor 
echo "Starting Supervisor"
/usr/bin/supervisord -n -c /etc/supervisord.conf
