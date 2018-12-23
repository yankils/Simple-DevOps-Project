# Simple DevOps Project - 4



In this project, we will be see how to *use Git, Jenkins, Ansible, DockerHub, Docker to DEPLOY on a docker container.,*

*Follow this project in *[Youtube](https://youtu.be/MJ74RcL6jv8)**

![](https://github.com/ValaxyTech/DevOpsDemos/blob/master/SimpeDevOpsProjects/images/Project-4.png)

#### PreRequisites
1. Jenkins - Get help [here](https://www.youtube.com/watch?v=M32O4Yv0ANc)
1. Ansible - Get help [here](https://www.youtube.com/watch?v=79xFyOc_eEY)
1. Setup ansible client and install docker. [here](https://www.youtube.com/watch?v=nMLQgXf8tZ0)
1. Docker Hub account 

#### Previous DevOps projects:

1. Simple DevOps project-1 [here](https://www.youtube.com/watch?v=Z9G5stlXoyg)
1. Simple DevOps project-2 [here](https://www.youtube.com/watch?v=nE4b9mW2ym0)
1. Simple DevOps project-3 [here](https://www.youtube.com/watch?v=nMLQgXf8tZ0)

In *part-01* we create Docker image on ansible server through Jenkins job and pushed it onto DockerHub. 

### Part-01 : Create an docker image 
    
1. Login to Jenkins console
1. Create *Jenkins job*, Fill the following details,
   - *Source Code Management:*
      - Repository : `https://github.com/ValaxyTech/hello-world.git`
      - Branches to build : `*/master`  
   - *Build:*
     - Root POM:`pom.xml`
     - Goals and options : `clean install package`
   - *Post Steps*
     - *Send files or execute commands over SSH*
       - Name: `ansible_server`
       - Source files	: `webapp/target/*.war`
       - Remove prefix	: `webapp/target`
       - Remote directory	: `//opt//docker`

     - *Send files or execute commands over SSH*
       - Name: `ansible_server`
       - Source files	: `Dockerfile`
       - Remote directory	: `//opt//docker`
       - Exec Command: 
	      - `cd /opt/docker`
          - `docker build -t valaxy_demo .`
	      - `docker tag valaxy_demo valaxy/valaxy_demo`
          - `docker push valaxy/valaxy_demo`
          - `docker rmi valaxy_demo valaxy/valaxy_demo`
              
1. Login to Docker host and check images and containers. (no images and containers)

1. login to docker hub and check. shouldn't find images with for valaxy_demo 

1. Execute Jenkins job

1. check images in Docker hub. Now you could able to see new images pushed to Valaxy Docker_Hub

#### Troubleshooting:
1. Docker should be installed on ansible server 
1. Should login to "docker hub" on ansible server
1. Docker admin user should be part of `docker` group

In *Part-02* we create *create_docker_container.yml* playbook. this get intiated by jenkins job, run by ansible and exected on dokcer_host

### Part-02 : Deploy Containers

1. Write a yml file to create a container (file name : create_docker_container.yml)
   ```yaml
     ---
     - hosts: web-servers
       become: true
       tasks:
        - name: stop previous version docker
          shell: docker stop valaxy_demo
        - name: remove stopped container
          shell: docker rm -f valaxy_demo	  
        - name: remove docker images
          shell: docker image rm -f valaxy/valaxy_demo
          
        - name: create docker image
          shell: docker run -d --name valaxy_demo -p 8090:8080 valaxy/valaxy_demo

1. Add this script to Jenkins job.
   - Chose *"configure"* to modify your jenkins job. 
     - *Under post build actions*
        - Send files or execute commands over SSH
          - Exec Command: 
          ```sh
             cd /opt/playbooks
             ansible-playbook create_docker_container.yml
            ```
          
1. Execute Jenkins job. 

1. You could see a new container on your docker host. can able access it from browser on port 8090

Troubleshooting: 
Makesure you have opened required ports on AWS Security group for this server. 

In *Part-03* we try to improvise to store docker images previous versions

### Part-03 : Deploy with Version Control Containers 

So for we used latest docker image to build a container, but what happens if latest version is not working?  
One easiest solution is, maintaining version for each build. This can be achieved by using environment variables. 

here we use 2 variables 
- `BUILD_ID` -  The current build id
- `JOB_NAME` - Name of the project of this build. This is the name you gave your job when you first set it up.

for more info Please refer [this URL](https://wiki.jenkins.io/display/JENKINS/Building+a+software+project)

Lets modify jenkins job which was created in *Part-01* as below.

1. Create Jenkins job 
   - *Source Code Management:*
      - Repository : `https://github.com/ValaxyTech/hello-world.git`
      - Branches to build : `*/master`  
   - *Build:*
     - Root POM:`pom.xml`
     - Goals and options : `clean install package`
 
   - *Send files or execute commands over SSH*
     - Name: `ansible_server`
     - Source files	: `webapp/target/*.war`
     - Remove prefix	: `webapp/target`
     - Remote directory	: `//opt//docker`

   - *Send files or execute commands over SSH*
     - Name: `ansible_server`
     - Source files	: `Dockerfile`
     - Remote directory	: `//opt//docker`
      	- `cd /opt/docker`
        - `docker build -t $JOB_NAME:v1.$BUILD_ID .`
        - `docker tag $JOB_NAME:v1.$BUILD_ID valaxy/$JOB_NAME:v1.$BUILD_ID`
        - `docker tag $JOB_NAME:v1.$BUILD_ID valaxy/$JOB_NAME:latest`
        - `docker push valaxy/$JOB_NAME:v1.$BUILD_ID`
        - `docker push valaxy/$JOB_NAME:latest`
        - `docker rmi $JOB_NAME:v1.$BUILD_ID valaxy/$JOB_NAME:v1.$BUILD_ID` 
        - `valaxy/$JOB_NAME:latest`
##### References
[1] - [Jenkins Docs - Building Software Projects](https://wiki.jenkins.io/display/JENKINS/Building+a+software+project)
