
DockerFile 

1. A Dockerfile is a text document that contains all the commands a user could call on the command line to assemble an image.   
2. The docker build command builds an image from a Dockerfile and a context.  
 ```sh 
  docker build .
  docker build -f /path/to/a/Dockerfile .
  docker build -t shykes/myapp .
 ```

3. The Docker daemon runs the instructions in the Dockerfile one-by-one, committing the result of each instruction to a new image if necessary, before finally outputting the ID of your new image.  
4. Whenever possible, Docker uses a build-cache to accelerate the docker build process significantly.  
5. When you’re done with your build, you’re ready to look into scanning your image with docker scan  
 ```sh
 docker scan hello-world
 
 ```

## Dockerfile Creation  

 Docker file format
  ```sh
   # Comment
   INSTRUCTION arguments
  ```

1. A Dockerfile must begin with a FROM instruction.  

2. Docker distributes official versions of the images that can be used for building Dockerfiles under docker/dockerfile repository on Docker Hub.

- `FROM` - A valid Dockerfile must start with a FROM instruction.

- `RUN` - The RUN instruction will execute any commands in a new layer on top of the current image and commit the results. The resulting committed image will be used for the next step in the Dockerfile.

- `CMD` - The main purpose of a CMD is to provide defaults for an executing container. 

   `Note:` There can only be one CMD instruction in a Dockerfile. If you list more than one CMD then only the last CMD will take effect.

   `Note` - Do not confuse RUN with CMD. RUN actually runs a command and commits the result; CMD does not execute anything at build time, but specifies the intended command for the image.

- `LABEL` -The LABEL instruction adds metadata to an image. A LABEL is a key-value pair. T

- `EXPOSE`
  1. The EXPOSE instruction informs Docker that the container listens on the specified network ports at runtime. 
  2. To set up port redirection on the host system, see using the -P flag.
  3. The docker network command supports creating networks for communication among containers without the need to expose or publish specific ports, because the containers connected to the network can communicate with each other over any port. 

- `ENV` - The ENV instruction sets the environment variable <key> to the value <value>.

- `ADD` - The ADD instruction copies new files, directories or remote file URLs from <src> and adds them to the filesystem of the image at the path <dest>.

    If <src> is a local tar archive in a recognized compression format (identity, gzip, bzip2 or xz) then it is unpacked as a directory. 

- `COPY` - The COPY instruction copies new files or directories from <src> and adds them to the filesystem of the container at the path <dest>.

- `ENTRYPOINT` - An ENTRYPOINT allows you to configure a container that will run as an executable.

  1. ENTRYPOINT will override all elements specified using CMD
  2. Both CMD and ENTRYPOINT instructions define what command gets executed when running a container. There are few rules that describe their co-operation.

  3. Dockerfile should specify at least one of CMD or ENTRYPOINT commands.

  4. ENTRYPOINT should be defined when using the container as an executable.

  5. CMD should be used as a way of defining default arguments for an ENTRYPOINT command or for executing an ad-hoc command in a container.

  6. CMD will be overridden when running the container with alternative arguments.

- `VOLUME` - The VOLUME instruction creates a mount point with the specified name and marks it as holding externally mounted volumes from native host or other containers. 

- `USER` - The USER instruction sets the user name to use when running the image
- `WORKDIR` - The WORKDIR instruction sets the working directory for any RUN, CMD, ENTRYPOINT, COPY and ADD instructions

- `ARG` - The ARG instruction defines a variable that users can pass at build-time to the builder with the docker build command using the --build-arg <varname>=<value> flag. 

- `SHELL` - The SHELL instruction allows the default shell used for the shell form of commands to be overridden. 


