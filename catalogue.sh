
echo -e "e[36m -e ">>>>>>>Create  catalogue service file<<<<<<<<<<"
cp catalogue.service /etc/systemd/system/catalogue.service
echo -e "e[36m -e ">>>>>>>Create  Mongodb Repo<<<<<<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "e[36m -e ">>>>>>>Create  Node Js Repos<<<<<<<<<<"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e "e[36m -e ">>>>>>>Install Node js<<<<<<<<<<"
yum install nodejs -y
echo -e "e[36m -e  ">>>>>>> ADD Roboshop User<<<<<<<<<<"
useradd roboshop
echo -e "e[36m -e ">>>>>>>Create  Application Directory<<<<<<<<<<"
mkdir /app
echo -e "e[36m -e ">>>>>>>Download Application content<<<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
echo -e "e[36m -e ">>>>>>>Extract Application content<<<<<<<<<<"

cd /app
unzip /tmp/catalogue.zip
cd /app
echo -e "e[36m -e  ">>>>>>>Download NodeJs Dependencies<<<<<<<<<<"

npm install
echo -e" "e[36m -e ">>>>>>>Install Mongodb Client<<<<<<<<<<"

yum install mongodb-org-shell -y
echo -e "e[36m -e ">>>>>>>Load  catalogue schema<<<<<<<<<<"
mongo --host mongodb.devops999.store </app/schema/catalogue.js
echo -e  "e[36m -e ">>>>>>>Start  catalogue service <<<<<<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue