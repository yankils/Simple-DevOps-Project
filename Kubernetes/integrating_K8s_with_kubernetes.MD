# Integrating Kubernetes cluster with Ansible  --- In progress

1. Log into ansible server and copy public key onto Kubernetes cluster master account 

1. update hosts file with a new group called Kubernetes and add Kubernetes master in that. 

1. write playbooks to create a pods and services 

   #### create-deployment.yml
   ```sh
   ----
   - name: Create pods using deployment 
     hosts: kubernetes 
	 become: true
	 user: root
	 
	 tasks:
     - name: pull latest docker image 
       command: docker pull yankils/simple-devops-image 
	  
	 - name: create a deployment
	   command: kubectl apply -f valaxy-deploy.yml
    ```

    #### create-service.yml
    ```sh 
    ---
    - name: create service for deployment 
      hosts: kubernetes
      become: true
      user: root
      
      tasks 	
      - name: create a service 
        command: kubectl apply -f valaxy-service.yml 
		
1.  Check for pods, deployments and services on kubernetes master
    ```sh 
	kubectl get pods 
	kubectl get deploy 
	kubectl get service
	```
	
1. Access application suing Loadbalancer URL
   ```
   wget <service_ip>:8080
   http://<LoadBalancerURL>

