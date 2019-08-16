# Writing Deployment and Service files 

1. create deployment and service files.

   #### valaxy-deploy.yml Deployment file
   ```sh
   apiVersion: apps/v1 # for versions before 1.9.0 use apps/v1beta2
   kind: Deployment
   metadata:
     name: valaxy-deployment
   spec:
     selector:
       matchLabels:
         app: valaxy-devops-project
     replicas: 2 # tells deployment to run 2 pods matching the template
     template:
       metadata:
         labels:
           app: valaxy-devops-project
       spec:
         containers:
         - name: valaxy-devops-project
           #To create new pods every time when there is a new image, replace image tag with version number
           image: yankils/simple-devops-image:altest 
        
           imagePullPolicy: Always
           ports:
           - containerPort: 8080

   ```
   #### valaxy-service.yml service file
   ```sh
   apiVersion: v1
   kind: Service
   metadata:
     name: valaxy-service
     labels:
       app: valaxy-devops-project
   spec:
     selector:
       app: valaxy-devops-project
     type: LoadBalancer
     ports:
       - protocol: TCP
         nodePort: 31200
         port: 8080
         targetPort: 8080
   ```

1. Launch a deploy and service using yaml files.
   ```sh
   kubectl apply -f valaxy-deploy.yml
   kubectl apply -f valaxy-service.yml
   ```
