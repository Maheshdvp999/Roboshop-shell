
echo ">>>>>>>Create  catalogue service file<<<<<<<<<<"
cp catalogue.service /etc/systemd/system/catalogue.service
echo ">>>>>>>Create  Mongodb Repo<<<<<<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo ">>>>>>>Create  Node Js Repos<<<<<<<<<<"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo ">>>>>>>Install Node js<<<<<<<<<<"
yum install nodejs -y
echo ">>>>>>> ADD Roboshop User<<<<<<<<<<"
useradd roboshop
echo ">>>>>>>Create  Application Directory<<<<<<<<<<"
mkdir /app
echo ">>>>>>>Download Application content<<<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
echo ">>>>>>>Extract Application content<<<<<<<<<<"

cd /app
unzip /tmp/catalogue.zip
cd /app
echo ">>>>>>>Download NodeJs Dependencies<<<<<<<<<<"

npm install
echo ">>>>>>>Install Mongodb Client<<<<<<<<<<"

yum install mongodb-org-shell -y
echo ">>>>>>>Load  catalogue schema<<<<<<<<<<"
mongo --host mongodb.devops999.store </app/schema/catalogue.js
echo ">>>>>>>Start  catalogue service <<<<<<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue