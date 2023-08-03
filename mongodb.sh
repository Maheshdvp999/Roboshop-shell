
cp mysql.repo /etc/yum.repos.d/mysql.repo

yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod
systemctl restart mongod
