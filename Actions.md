Edit caltech-capstone/gs-accessing-data-mysql/complete/src/main/resources/application.properties setting spring.datasource.url=jdbc:mysql://payment-db:3306/payment
Compile code to create a .jar file
Build the container with Docker
Apply deployment manifest file caltech-capstone/manifests/payment-deployment.yaml to deploy Spring application and MySql database
Apply CPU and Memory HPA manifests: caltech-capstone/manifests/payment-hpa-cpu.yaml, caltech-capstone/manifests/payment-hpa-cpu.yaml to setup horizontal load balancing
Apply network policy manifest file to allow access only from the Spring application to MySql
Apply RBAC manifest files to create a role, a CSR and bind it all together to a user k8s-admin
