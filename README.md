# shell
some of my used shell scripts

### How to use
1.mult_ssh.sh <br>
establish a trust relationship of SSH (admin -> server...)
```shell 
ssh-keygen -t rsa -b 2048 -N '' -f ~/.ssh/ssh-id_rsa
ssh-copy-id -i ~/.ssh/ssh-id_rsa.pub 192.168.1.11
```
