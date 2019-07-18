# Ansible Installation

Ansible is an open-source automation platform. It is very, very simple to set up and yet powerful. Ansible can help you with configuration management, application deployment, task automation.

### Prerequisites

1. An AWS EC2 instance (on Master)

### Installation steps:
#### on Amazon EC2 instance

1. Install python 
   ```sh
   yum install python
   ```
2. Install python-pip
   ```sh
    yum install python-pip
    ```
3. install ansible using pip
    ```sh
    pip install ansible
    ```

#### On RHEL 8.x server


1. Install Python latest version  (on Master & Slave)
   ```sh 
   yum install python3 -y
   ```

1. By default, python3 is the command to run python commands. to use just python, use "alternatives" command. (on Master & Slave)
   ```sh 
   alternatives --set python /usr/bin/python3
   ```

1. Check for Python version  
   ```sh 
   python --version
   ```
1. Install python-pip package manager (on Master)
   ```sh 
   yum -y install python3-pip
   ```

1. Create a new user for ansible administration & grant admin access to the user (on Master and Slave)
   ```sh 
   useradd ansadmin
   passwd ansadmin
   ```
1. below command adds ansadmin to sudoers file. But we strongly recommended using "visudo" command if you are aware vi or nano editor. (on Master & Slave)
   ```sh
   echo "ansadmin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
   ```
1. Using key-based authentication is advised. If you are still at the learning stage use password-based authentication (On Master & Slave)
   ```sh 
   # sed command replaces "PasswordAuthentication no to yes" without editing file 
    sed -ie 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sudo service sshd reload
   ``` 

    #### Install Ansible as a ansadmin user (On Master)
   ```sh 
   su - ansadmin
   pip3 install ansible --user
   ``` 
      Note: Ansible must be installed as a user (here ansadmin)
1. check for ansible version 
   ```sh
   ansible --version
   ```

1. Log in as a ansadmin user on master and generate ssh key (On Master)
   ```sh 
   ssh-keygen
   ```
1. Copy keys onto all ansible managed hosts (On Master)
   ```sh 
   ssh-copy-id ansadmin@<target-server>
   ```
### Validation test

1. Create a directory /etc/ansible and create an inventory file called "hosts" add control node IP address in it. 
   
1. Run ansible command as ansadmin user it should be successful (Master)
   ```sh 
   ansible all -m ping
   ```
