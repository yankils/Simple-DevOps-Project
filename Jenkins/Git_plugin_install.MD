# Configure Git pulgin on Jenkins
Git is one of the most popular tool for version contorl system. you can pull code from git repositories using jenkins if you use github plugin. 

#### Follow this artical in **[YouTube](https://www.youtube.com/watch?v=wgfsVmHnAiM)**

#### Prerequisites
1. Jenkins server **[Get Help Here](https://www.youtube.com/watch?v=M32O4Yv0ANc)

#### Install Git on Jenkins server
Install git packages on jenkins server
```sh
  yum install git -y
 ```

#### Setup Git on jenkins console
- Install git plugin without restart  
  - `Manage Jenkins` > `Jenkins Plugins` > `available` > `github`

- Configure git path
  - `Manage Jenkins` > `Global Tool Configuration` > `git`

#### Next Steps

- [x] [Configure Users & Groups in Jenkins](https://youtu.be/jZOqcB32dYM)
- [x] [Secure your Jenkins Server](https://youtu.be/19FmJumnkDc)
- [x] [Jenkins Plugin Installation](https://youtu.be/p_PqPBbjaZ4)
- [x] [Jenkins Master-Slave Configuration](https://youtu.be/hwrYURP4O2k)
