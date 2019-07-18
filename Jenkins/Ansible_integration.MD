# Ansible integration with Jenkins

Follow this on **[YouTube](https://www.youtube.com/watch?v=nE4b9mW2ym0)**

### Prerequisites:
1. Ansible server **[Get Help Here](https://www.youtube.com/watch?v=79xFyOc_eEY)**
2. Jenkins Server **[Get Help Here](https://www.youtube.com/watch?v=M32O4Yv0ANc)**

### Part-01 Integration Setps

Install "publish Over SSH"
 - `Manage Jenkins` > `Manage Plugins` > `Available` > `Publish over SSH` 

Enable connection between Ansible and Jenkins
- `Manage Jenkins` > `Configure System` > `Publish Over SSH` > `SSH Servers` 

	- SSH Servers:
		- Hostname:`<ServerIP>`
		- username: `ansadm`
		- password: `*******`

Test the connection "Test Connection"
