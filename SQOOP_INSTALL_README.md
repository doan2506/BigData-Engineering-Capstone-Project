# How to Run the Project with Docker-Compose

Since GitHub Codespaces does not have Hadoop installed, we will use Docker to spin up a custom Big Data cluster, manually install Sqoop, and run the pipeline!

## Step 1: Start the Cluster
1. Open your Codespace terminal.
2. Run `docker-compose up -d`.
3. Wait about 30 seconds for all the containers (HDFS, Hive, MySQL, Spark) to start up.

## Step 2: Install Sqoop inside the Namenode
Because Apache Sqoop is retired, there is no official Docker image for it. You must install it manually inside your running `namenode` container.

Run these commands in your Codespace terminal to enter the namenode and download Sqoop:
```bash
# Enter the Namenode container as root
docker exec -it namenode /bin/bash

# Install wget first!
apt-get update && apt-get install -y wget

# Download and extract Sqoop
wget https://archive.apache.org/dist/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz
tar -xvf sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz
mv sqoop-1.4.7.bin__hadoop-2.6.0 /usr/local/sqoop

# Add the MySQL JDBC driver to Sqoop so it can talk to your MySQL container
cd /usr/local/sqoop/lib
wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar

# Setup Environment Variables
export SQOOP_HOME=/usr/local/sqoop
export PATH=$PATH:$SQOOP_HOME/bin
export HADOOP_CONF_DIR=/etc/hadoop
```

## Step 3: Run the Pipeline!
Now that your cluster is running and Sqoop is installed inside your Namenode, you can run the final script!

Because you mounted your Codespace into the `namenode` container, you can navigate to the project folder and run the script right from inside the container:
```bash
# Navigate to the mounted project folder
cd /workspaces/BigData-Engineering-Capstone-Project

# Run the Bash Script!
bash Capstone_Inputs/Capstone_P1.sh
```

*(Note: The script might throw a few minor warnings depending on how the containers initialized, but it will execute the Hive, Sqoop, and Spark tasks end-to-end!)*
