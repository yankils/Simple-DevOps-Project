
## SonarQube Integration with Jenkins

Integration SonarQube server with Jenkins is necessary to store your reports. Follow below steps to enable that.


### Prerequisites
1. SonarQube Server 
1. Jenkins Server

### Implementation

Login to Jenkins server and install sonarqube scanner. 

- SonarQube scanner URL : https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner
- Package : https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.2.0.1227-linux.zip
- 
```sh 
# wget https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.2.0.1227-linux.zip
# unzip sonar-scanner-cli-3.2.0.1227-linux.zip
# mv sonar-scanner-3.2.0.1227-linux /opt/sonar_scanner 
```

Set SonarQube server details in sonar-scanner property file 

 - Sonar properties file: /opt/sonar_scanner/conf/sonar-scanner.properties
   - sonar.host.url=http://`<SONAR_SERVER_IP>`:9000

Login to Jenkins GUI console and install " SonarQube scanner" plugin

 - `Manage Jenkins` > `Manage Plugins` > `Avalable` > `SonarQube scanner` 

Configure SonarQube scanner home path

- `Manage Jenkins` > `Global Tool Configuration` > `SonarQube Scanner` 
   - Name  : `sonar_scanner`
   - SONAR_RUNNER_HOME : `/opt/sonar_scanner`

Configure SonarQube server name and authentication token 
- `Manage Jenkins` > `Configure Systems` > `SonarQube Servers`
    - Name : `SonarQube`
	- ServerURL : `http://<Sonarqube_server>:9000/sonar`
	- Server `authentication token`
To Get Authentication code follow below steps.
	Login to SonarQube server as a admin  `My Account` > `Security` > `Generate Token`

Create a job to test SonarQube. Provide below sonar properties details in the job under build 
- Build:
  - `Execute SonarQube Scanner` > `Analysis properties`  (it is mandatary).  
     - sonar.projectKey=`DevOpsProject`
     - sonar.projectName=`DevOpsProject`
     - sonar.projectVersion=`1.0`
     - sonar.sources=`/var/lib/jenkins/workspace/$JOB_NAME/<PROJECT_NAME>/src`

Execute job to get analysis report. 


