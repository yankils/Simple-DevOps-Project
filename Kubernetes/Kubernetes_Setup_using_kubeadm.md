# Kubernetes Cluster installation using kubeadm
Follow this documentation to set up a Kubernetes cluster on __CentOS__ 7 machines.

This documentation guides you in setting up a cluster with one master node and two worker nodes.

## Prerequisites: 
1. System Requirements 
    >Master: t2.medium (2 CPUs and 2GB Memory)   
    >Worker Nodes: t2.micro 

1. Open Below ports in the Security Group. 
   #### Master node: 
    `6443  
    32750  
    10250  
    4443  
    443  
    8080 `

   ##### On Master node and Worker node:
    `179`  

   ### `On Master and Worker:`
1. Perform all the commands as root user unless otherwise specified
 
   Install, Enable and start docker service.
   Use the Docker repository to install docker.
   > If you use docker from CentOS OS repository, the docker version might be old to work with Kubernetes v1.13.0 and above

   ```sh
   yum install -y -q yum-utils device-mapper-persistent-data lvm2 > /dev/null 2>&1
   yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo > /dev/null 2>&1
   yum install -y -q docker-ce >/dev/null 2>&1
   ```
1. Start Docker services 
   ```sh
   systemctl enable docker
   systemctl start docker
   ```
1. Disable SELinux
   ```sh
   setenforce 0
   sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
   ```
1. Disable Firewall
   ```sh
   systemctl disable firewalld
   systemctl stop firewalld
   ```
1. Disable swap
     ```sh
     sed -i '/swap/d' /etc/fstab
     swapoff -a
    ```
1. Update sysctl settings for Kubernetes networking
   ```sh
   cat >> /etc/sysctl.d/kubernetes.conf <<EOF
   net.bridge.bridge-nf-call-ip6tables = 1
   net.bridge.bridge-nf-call-iptables = 1
   EOF
   sysctl --system
   ```
## Kubernetes Setup
1. Add yum repository for kubernetes packages 
    ```sh
    cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
    [kubernetes]
    name=Kubernetes
    baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
    enabled=1
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
            https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
    EOF
    ```
1. Install Kubernetes
    ```sh
    yum install -y kubeadm-1.15.6-0.x86_64 kubelet-1.15.6-0.x86_64 kubectl-1.15.6-0.x86_64
    ```
1. Enable and Start kubelet service
    ```sh
    systemctl enable kubelet
    systemctl start kubelet
    ```
## `On Master Node:`
1. Initialize Kubernetes Cluster
    ```sh
    kubeadm init --apiserver-advertise-address=<MasterServerIP> --pod-network-cidr=192.168.0.0/16
    ```
1. Create a user for kubernetes administration  and copy kube config file.   
    ``To be able to use kubectl command to connect and interact with the cluster, the user needs kube config file.``  
    In this case, we are creating a user called `kubeadmin`
    ```sh
    useradd kubeadmin 
    mkdir /home/kubeadmin/.kube
    cp /etc/kubernetes/admin.conf /home/kubeadmin/.kube/config
    chown -R kubeadmin:kubeadmin /home/kubeadmin/.kube
    ```
1. Deploy Calico network as a __kubeadmin__ user. 
	> This should be executed as a user (heare as a __kubeadmin__ )
    
    ```sh
    sudo su - kubeadmin 
    kubectl create -f https://docs.projectcalico.org/v3.9/manifests/calico.yaml
    ```

1. Cluster join command
    ```sh
    kubeadm token create --print-join-command
    ```
## `On Worker Node:`
1. Add worker nodes to cluster 
    > Use the output from __kubeadm token create__ command in previous step from the master server and run here.

1. Verifying the cluster
    To Get Nodes status
    ```sh
    kubectl get nodes
    ```
    To Get component status
    ```sh
    kubectl get cs
    ```

