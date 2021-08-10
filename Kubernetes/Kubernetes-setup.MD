# Setup Kubernetes (K8s) Cluster on AWS


1. Create Ubuntu EC2 instance
2. install AWSCLI
   ```
   snap install aws-cli  # version 1.15.58, or
   apt  install awscli   # version 1.18.69-1ubuntu0.20.04.1

   See 'snap info aws-cli' for additional versions.
   ```

3. Install kubectl on ubuntu instance
   ```sh
   
   curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
   chmod +x ./kubectl
   sudo mv ./kubectl /usr/local/bin/kubectl
   ```

4. Install kops on ubuntu instance
   ```sh
    curl -LO  https://github.com/kubernetes/kops/releases/download/1.15.0/kops-linux-amd64
    chmod +x kops-linux-amd64
    sudo mv kops-linux-amd64 /usr/local/bin/kops
    kops version (it should be 1.15.0)
    Note: use below command if you wish to use latest version. For now we could see latest version of kops. So ignore it until further update. 
    # curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64

    ```
5. Create an IAM user/role  with Route53, EC2, IAM and S3 full access

6. Attach IAM role to ubuntu instance
   ```sh
   # Note: If you create IAM user with programmatic access then provide Access keys. Otherwise region information is enough
   aws configure
    ```

7. Create a Route53 private hosted zone (you can create Public hosted zone if you have a domain)
   ```sh
   Routeh53 --> hosted zones --> created hosted zone  
   Domain Name: valaxy.net
   Type: Private hosted zone for Amazon VPC. Make sure you are chosing right VPC if you have multiple
   ```

8. create an S3 bucket
   ```sh
    aws s3 mb s3://demo.k8s.valaxy.net
   ```
9. Expose environment variable:
   ```sh
    export KOPS_STATE_STORE=s3://demo.k8s.valaxy.net
   ```

10. Create sshkeys before creating cluster
   ```sh
    ssh-keygen
   ```

11. Create kubernetes cluster definitions on S3 bucket
   ```sh
   kops create cluster --cloud=aws --zones=ap-south-1b --name=demo.k8s.valaxy.net --dns-zone=valaxy.net --dns private 
    ```

12. Create kubernetes cluser
    ```sh
    kops update cluster demo.k8s.valaxy.net --yes
    ```
13. To cahnge the kubernetes master and worker instance sizes 
   ```sh 
   kops edit ig --name=<cluster_name> nodes
   #kops edit ig --name=demo.k8s.valaxy.net nodes 
   kops edit ig --name=<cluster_name> master-<zone_name>
   #kops edit ig --name=demo.k8s.valaxy.net master-ap-south-1b
   ```
14. to Delete cluster (try once your lab is done)
   ```sh 
   kops delete cluster <cluster_name> --yes
   ```
15. Validate your cluster
     ```sh
      kops validate cluster
    ```

16. To list nodes
   ```sh
   kubectl get nodes
   ```


   
#### Deploying Nginx pods on Kubernetes
1. Deploying Nginx Container
    ```sh
    kubectl run --generator=run-pod/v1 sample-nginx --image=nginx --replicas=2 --port=80
    #kubectl run sample-nginx --image=nginx --replicas=2 --port=80
    # kubectl run simple-devops-project --image=yankils/simple-devops-image --replicas=2 --port=8080
    kubectl get pods
    kubectl get deployments
   ```

2. Expose the deployment as service. This will create an ELB in front of those 2 containers and allow us to publicly access them.
   ```sh
   kubectl expose deployment sample-nginx --port=80 --type=LoadBalancer
   # kubectl expose deployment simple-devops-project --port=8080 --type=LoadBalancer
   kubectl get services -o wide
   ```
