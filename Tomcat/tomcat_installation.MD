# Tomcat installation on EC2 instance

### Pre-requisites
1. EC2 instance with Java v1.8.x 

### Install Apache Tomcat
1. Download tomcat packages from  https://tomcat.apache.org/download-80.cgi onto /opt on EC2 instance
   ```sh 
   # Create tomcat directory
   cd /opt
   wget http://mirrors.fibergrid.in/apache/tomcat/tomcat-8/v8.5.35/bin/apache-tomcat-8.5.35.tar.gz
   tar -xvzf /opt/apache-tomcat-8.5.35.tar.gz
   ```
1. give executing permissions to startup.sh and shutdown.sh which are under bin. 
   ```sh
   chmod +x /opt/apache-tomcat-8.5.35/bin/startup.sh 
   shutdown.sh
   ```

1. create link files for tomcat startup.sh and shutdown.sh 
   ```sh
   ln -s /opt/apache-tomcat-8.5.35/bin/startup.sh /usr/local/bin/tomcatup
   ln -s /opt/apache-tomcat-8.5.35/bin/shutdown.sh /usr/local/bin/tomcatdown
   tomcatup
   ```
  #### Check point :
access tomcat application from browser on port 8080  
 - http://<Public_IP>:8080

  Using unique ports for each application is a best practice in an environment. But tomcat and Jenkins runs on ports number 8080. Hence lets change tomcat port number to 8090. Change port number in conf/server.xml file under tomcat home
   ```sh
 cd /opt/apache-tomcat-8.5.35/conf
# update port number in the "connecter port" field in server.xml
# restart tomcat after configuration update
tomcatdown
tomcatup
```
#### Check point :
Access tomcat application from browser on port 8090  
 - http://<Public_IP>:8090

1. now application is accessible on port 8090. but tomcat application doesnt allow to login from browser. changing a default parameter in context.xml does address this issue
   ```sh
   #search for context.xml
   find / -name context.xml
   ```
1. above command gives 3 context.xml files. comment (<!-- & -->) `Value ClassName` field on files which are under webapp directory. 
After that restart tomcat services to effect these changes
   ```sh 
   tomcatdown
   tomcatup
   ```
1. Update users information in the tomcat-users.xml file
goto tomcat home directory and Add below users to conf/tomcat-user.xml file
   ```sh
	<role rolename="manager-gui"/>
	<role rolename="manager-script"/>
	<role rolename="manager-jmx"/>
	<role rolename="manager-status"/>
	<user username="admin" password="admin" roles="manager-gui, manager-script, manager-jmx, manager-status"/>
	<user username="deployer" password="deployer" roles="manager-script"/>
	<user username="tomcat" password="s3cret" roles="manager-gui"/>
   ```
1. Restart serivce and try to login to tomcat application from the browser. This time it should be Successful

