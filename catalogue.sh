
echo -e "\e[36m>>>>>>>Create  catalogue service file<<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service
echo -e "\e[36m>>>>>>>Create  Mongodb Repo<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[36m>>>>>>>Create  Node Js Repos<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e "\e[36m>>>>>>>Install Node js<<<<<<<<<<\e[0m"
yum install nodejs -y
echo -e "\e[36m>>>>>>> ADD Roboshop User<<<<<<<<<<\e[0m"
useradd roboshop
echo -e "\e[36m>>>>>>>Create  Application Directory<<<<<<<<<<\e[0m"
mkdir /app
echo -e "\e[36m>>>>>>>Download Application content<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
echo -e "\e[36m>>>>>>>Extract Application content<<<<<<<<<<\e[0m"

cd /app
unzip /tmp/catalogue.zip
cd /app
echo -e "\e[36m>>>>>>>Download NodeJs Dependencies<<<<<<<<<<\e[0m"

npm install
echo -e "\e[36m>>>>>>>Install Mongodb Client<<<<<<<<<<\e[0m"

yum install mongodb-org-shell -y
echo -e "\e[36m>>>>>>>Load  catalogue schema<<<<<<<<<<\e[0m"
mongo --host mongodb.devops999.store </app/schema/catalogue.js
echo -e "\e[36m>>>>>>>Start  catalogue service <<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue