# Integrating Kubernetes cluster with Ansible

1. Log into ansible server and copy public key onto Kubernetes cluster master account

1. create hosts file with a new group called [kubernetes] and add Kubernetes master server.

1. Add ansible key to kubernest master server root account under authorized hosts

1. write playbooks to create a pods and services

   #### create-deployment.yml
   ```sh
   ----
   - name: Create pods using deployment
     hosts: kubernetes
         become: true
         user: root

         tasks:
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
   ```


1. Check for pods, deployments and services on kubernetes master
   ```sh
   kubectl get pods
   kubectl get deploy
   kubectl get service
   ```

1. Access application suing Loadbalancer URL
   ```sh
   wget <service_ip>:8080
   http://<LoadBalancerURL>
   ```
