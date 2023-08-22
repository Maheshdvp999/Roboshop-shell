log=/tmp/roboshop.log

func_apppreq() {
    echo -e "\e[36m>>>>>>>Create ${component} service <<<<<<<<<<\e[0m"
    cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
    echo -e "\e[36m>>>>>>> ADD Roboshop ${component}<<<<<<<<<<\e[0m"
    useradd roboshop &>>${log}
    echo -e "\e[36m>>>>>>>Clean up Applicationcontent<<<<<<<<<<\e[0m"
    rm -rf /app &>>${log}
    echo -e "\e[36m>>>>>>>Create  Application Directory<<<<<<<<<<\e[0m"
    mkdir /app &>>${log}
    echo -e "\e[36m>>>>>>>Download Application content<<<<<<<<<<\e[0m"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
    echo -e "\e[36m>>>>>>>Extract Application content<<<<<<<<<<\e[0m"

    cd /app
    unzip /tmp/${component}.zip &>>${log}
    cd /app

  }
func_systemd () {
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}
}
func_nodejs () {
  log=/tmp/roboshop.log
  echo -e "\e[36m>>>>>>>Create  ${component} service file<<<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  echo -e "\e[36m>>>>>>>Create  Mongodb Repo<<<<<<<<<<\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  echo -e "\e[36m>>>>>>>Create  Node Js Repos<<<<<<<<<<\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
  echo -e "\e[36m>>>>>>>Install Node js<<<<<<<<<<\e[0m"
  yum install nodejs -y &>>${log}
  func_apppreq
  echo -e "\e[36m>>>>>>>Download NodeJs Dependencies<<<<<<<<<<\e[0m"

  npm install &>>${log}
  echo -e "\e[36m>>>>>>>Install Mongodb Client<<<<<<<<<<\e[0m"

  func_schema_setup
  func_systemd
}

func_java () {

  echo -e "\e[36m>>>>>>>Install Maven <<<<<<<<<<\e[0m"
  yum install maven -y &>>${log}
  func_apppreq
  echo -e "\e[36m>>>>>>>Build ${component} service <<<<<<<<<<\e[0m"
  mvn clean package &>>${log}
  mv target/${component}-1.0.jar ${component}.jar &>>${log}
  func_schema_setup
  func_systemd
}

func_python () {
  echo -e "\e[36m>>>>>>>Build ${component} service <<<<<<<<<<\e[0m"

  yum install python36 gcc python3-devel -y &>>${log}
  func_apppreq
  echo -e "\e[36m>>>>>>>Build ${component} service <<<<<<<<<<\e[0m"

  pip3.6 install -r requirements.txt &>>${log}
  func_systemd
}
func_schema_setup () {
 if ["${schema_type}" == "mongodb" ]; then
   echo -e "\e[36m>>>>>>>Install Mongo Client <<<<<<<<<<\e[0m"
   yum install mongodb-org-shell -y &>>${log}
   echo -e "\e[36m>>>>>>>Load user schema<<<<<<<<<<\e[0m"
   mongo --host mongodb.devops999.store </app/schema/${component}.js &>>${log}
 fi
 if ["${schema_type}" == "mongodb" ]; then
   echo -e "\e[36m>>>>>>>Install MySQL Client <<<<<<<<<<\e[0m"
   yum install mysql -y &>>${log}
   echo -e "\e[36m>>>>>>>Install Load Schema <<<<<<<<<<\e[0m"
   mysql -h mysql.devops999.store -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>${log}

  fi
}