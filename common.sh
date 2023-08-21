nodejs () {
  log=/tmp/roboshop.log
  echo -e "\e[36m>>>>>>>Create  ${component} service file<<<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  echo -e "\e[36m>>>>>>>Create  Mongodb Repo<<<<<<<<<<\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  echo -e "\e[36m>>>>>>>Create  Node Js Repos<<<<<<<<<<\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
  echo -e "\e[36m>>>>>>>Install Node js<<<<<<<<<<\e[0m"
  yum install nodejs -y &>>${log}
  echo -e "\e[36m>>>>>>> ADD Roboshop ${component}<<<<<<<<<<\e[0m"
  useradd roboshop &>>${log}
  echo -e "\e[36m>>>>>>>Create  Application Directory<<<<<<<<<<\e[0m"
  mkdir /app &>>${log}
  echo -e "\e[36m>>>>>>>Download Application content<<<<<<<<<<\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &&>>${log}
  echo -e "\e[36m>>>>>>>Extract Application content<<<<<<<<<<\e[0m"

  cd /app
  unzip /tmp/${component}.zip &>>${log}
  cd /app
  echo -e "\e[36m>>>>>>>Download NodeJs Dependencies<<<<<<<<<<\e[0m"

  npm install &>>${log}
  echo -e "\e[36m>>>>>>>Install Mongodb Client<<<<<<<<<<\e[0m"

  yum install mongodb-org-shell -y &>>${log}
  echo -e "\e[36m>>>>>>>Load user schema<<<<<<<<<<\e[0m"
  mongo --host mongodb.devops999.store </app/schema/${component}.js
  echo -e "\e[36m>>>>>>>Start user service <<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}
}