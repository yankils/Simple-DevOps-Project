# SonarQube Installation

SonarQube provides the capability to not only show health of an application but also to highlight issues newly introduced. With a Quality Gate in place, you can fix the leak and therefore improve code quality systematically.
### Follow this Article in **[YouTube](https://www.youtube.com/watch?v=zRQrcAi9UdU)**

### Prerequisites
1. EC2 instance with Java installed
1. MySQL Database Server or MyQL RDS instance. **[Get help here](https://www.youtube.com/watch?v=vLaW6b441x0)**

### Installation

Install MySQL client version 

 ```sh
  # yum install mysql
 ```
Download stable SonarQube version from below website. 
- Website: https://www.sonarqube.org/downloads/
- Note: This Article written for SonarQube6.0  

Download & unzip SonarQube 6.0
```sh
# cd /opt
# wget https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-6.0.zip
# unzip sonarqube-6.0.zip
# mv /opt/sonarqube-6.0 /opt/sonar
```
Allow RDS instance security group to access SonarQube server 

Connect to RDS instance with database credentials
```sh 
mysql -h <RDS_Instance_endpoint>:3306 -u <DB_USER_NAME> -p <DB_PASSWORD> 
```
Create a new sonar database
```sh
CREATE DATABASE sonar CHARACTER SET utf8 COLLATE utf8_general_ci;
```

Create a local and a remote user
```sh
CREATE USER sonar@localhost IDENTIFIED BY 'sonar';
CREATE USER sonar@'%' IDENTIFIED BY 'sonar';
```

Grant database access permissions to users 
```sh
GRANT ALL ON sonar.* TO sonar@localhost;
GRANT ALL ON sonar.* TO sonar@'%';
```

check users and databases 
```sh
use mysql
show databases;
SELECT User FROM mysql.user;
FLUSH PRIVILEGES;
QUIT
```
So for you have configured required database information on RDS. Let’s Jump back to your EC2 instance and enable SonarQube properties file to connect his Database.

### ON EC2 Instance
Edit sonar properties file to uncomment and provide required information for below properties. 

- File Name: /opt/sonar/conf/sonar.properties
  - sonar.jdbc.username=`sonar`
  - sonar.jdbc.password=`sonar`
  - sonar.jdbc.url=jdbc:mysql://`<RDS_DATABAE_ENDPOINT>:3306`/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance&useSSL=false
  - sonar.web.host=`0.0.0.0`
  - sonar.web.context=`/sonar`

Start SonarQube service 
```sh
# cd /opt/sonar/bin/linux-x86-64/
# ./sonar.sh start
```

##### Run SonarQube as a default service 

Implement SonarQube server as a service
```sh
Copy sonar.sh to etc/init.d/sonar and modify it according to your platform.
# sudo cp /opt/sonar/bin/linux-x86-64/sonar.sh /etc/init.d/sonar
# sudo vi /etc/init.d/sonar
```

Add below values to your /etc/init.d/sonar file
```sh
Insert/modify below values
SONAR_HOME=/opt/sonar
PLATFORM=linux-x86-64

WRAPPER_CMD="${SONAR_HOME}/bin/${PLATFORM}/wrapper"
WRAPPER_CONF="${SONAR_HOME}/conf/wrapper.conf"
PIDDIR="/var/run"
```

Start SonarQube server
```sh
# service sonar start
```
SonarQube application uses port 9000. access SonarQube from browser
```sh
  http://<EC2_PUBLIC_IP>:9000/sonar
```
###  Troubleshooting 

1. Check whether you enabled port 9000 in EC2 instance security group
2. Check whether you enabled EC2 instance IP range in RDS security group

### Next Step
- [x] [Integrate SonarQube with Jenkins](https://www.youtube.com/watch?v=k-3krTRuAFA)
