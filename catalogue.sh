
echo -e "\e[36m>>>>>>>Create  catalogue service file<<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>Create  Mongodb Repo<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>Create  Node Js Repos<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>Install Node js<<<<<<<<<<\e[0m"
yum install nodejs -y &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>> ADD Roboshop User<<<<<<<<<<\e[0m"
useradd roboshop &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>Create  Application Directory<<<<<<<<<<\e[0m"
mkdir /app &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>Download Application content<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &&>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>Extract Application content<<<<<<<<<<\e[0m"

cd /app &>>/tmp/roboshop.log
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>Download NodeJs Dependencies<<<<<<<<<<\e[0m"

npm install &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>Install Mongodb Client<<<<<<<<<<\e[0m"

yum install mongodb-org-shell -y &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>Load  catalogue schema<<<<<<<<<<\e[0m"
mongo --host mongodb.devops999.store </app/schema/catalogue.js
echo -e "\e[36m>>>>>>>Start  catalogue service <<<<<<<<<<\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable catalogue &>>/tmp/roboshop.log
systemctl restart catalogue &>>/tmp/roboshop.log