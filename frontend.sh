
echo -e "\e[36m>>>>>>>>>install nginx <<<<<<<<<\e[0m"
yum install nginx -y
func_exit_status
echo -e "\e[36m>>>>>>>>>install nginx <<<<<<<<<\e[0m"

cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
func_exit_status

echo -e "\e[36m>>>>>>>>>Remove nginx Content<<<<<<<<<\e[0m"

rm -rf /usr/share/nginx/html/*
func_exit_status
echo -e "\e[36m>>>>>>>>>Add  nginx Content<<<<<<<<<\e[0m"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
func_exit_status
echo -e "\e[36m>>>>>>>>>Start nginx <<<<<<<<<\e[0m"

systemctl enable nginx
systemctl restart nginx
func_exit_status