# Integrating Kubernetes cluster with Ansible

1. Login to ansible server and copy public key onto kubernetes cluseter master account 

1. Update hosts file with new group called kubernetes and add kubernetes master in that. 

1. Create ansible playbooks to create deployment and services 
		
1.  Check for pods, deployments and services on kubernetes master
    ```sh 
    kubectl get pods 
    kubectl get deploy 
    kubectl get service
    ```
	
1. Access application suing service IP
   ```sh
   wget <kubernetes-Master-IP>:31200
   ```
