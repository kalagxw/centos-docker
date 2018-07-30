#基础镜像
FROM centos:latest

#作者
MAINTAINER kalagxw

#用户
#USER root

#更新yum
RUN yum update -y

#安装vim wget openssh-server openssh-clients
RUN yum install -y vim-minimal \
wget \
curl \
openssh-server \
openssh-clients \
openssh \
epel-release

#修改ssh配置
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN sed -i '/^#Host_Key/'d /etc/ssh/sshd_config
RUN sed -i '/^Host_Key/'d /etc/ssh/sshd_config
RUN echo 'HostKey /etc/ssh/ssh_host_rsa_key'>/etc/ssh/sshd_config

#生成ssh-key与配置ssh-key
RUN ssh-keygen -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key
RUN mkdir -p /root/.ssh
RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAttCOKBNadAC5s4yE5JRIZ24UvZaB6K4mlU+txxAfmfyepuPlJw0Da6YX6iMUqj5iIsaYrCMUjszAsbNomnxfYKwVbFpnVZtMJVLeu1VLhCklYM4Btu0Q+5NalUQzmvmUx3Cc3Cr/BXmTzXVWDeyBGhdFkrMCdspS/xd9SU9wcpcOGxb8bRk3EWQS95ejdEL2S0F3t9E2PWEXrtk3JfWjR3IsY1hSJAAsHAd2/sQasAYktmJhZp2l+/E2NoSvrNrgTMZm5senQYhvAH4jn43ScxWqWbT2SLeGhQ/q0YEouscKoJLLEdijPx+yphh4TU8TDMZe+9oj9XMjAz8EHZqjWQ=='>/root/.ssh/authorized_keys

#修改root用户登录密码
RUN echo 'root:root'|chpasswd

#开放22端口
EXPOSE 22

#镜像运行时，启动sshd
CMD ["/usr/sbin/sshd", "-D"]
