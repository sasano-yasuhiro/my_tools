#!/bin/bash
# graphvizのインストール
sudo yum install -y graphviz
# EC2へのMavenインストール
sudo wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
# Javaのインストール
sudo amazon-linux-extras enable corretto8
sudo yum install java-1.8.0-amazon-corretto-devel
sudo /usr/sbin/alternatives --config java
sudo /usr/sbin/alternatives --config javac
# PlantUML serverのインストール
#git clone https://github.com/plantuml/plantuml-server.git
#cd plantuml-server/
#mvn jetty:run
