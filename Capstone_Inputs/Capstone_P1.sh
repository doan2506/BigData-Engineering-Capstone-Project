#!/bin/bash
find . -name "*.avsc" -exec rm {} \;
find . -name "*.java" -exec rm {} \;
rm -rf /workspaces/BigData-Engineering-Capstone-Project/Capstone_Outputs
mkdir -p /workspaces/BigData-Engineering-Capstone-Project/Capstone_Outputs

# MySQL commands routed to mysql container
docker exec -w /workspaces/BigData-Engineering-Capstone-Project mysql mysql -u doan2506 -pBigdata123 -D doan2506 -e "source CreateMySQLTables.sql" > /workspaces/BigData-Engineering-Capstone-Project/Capstone_Outputs/Cap_MySQLTables.txt

# HDFS and Sqoop commands routed to namenode container
docker exec namenode hdfs dfs -rm -r /user/doan2506/hive/warehouse/Capstone
docker exec namenode hdfs dfs -mkdir -p /user/doan2506/hive/warehouse/Capstone
docker exec -w /workspaces/BigData-Engineering-Capstone-Project namenode sqoop import-all-tables --connect jdbc:mysql://mysql:3306/doan2506 --username doan2506 --password Bigdata123 --compression-codec=snappy --as-avrodatafile --warehouse-dir=/user/doan2506/hive/warehouse/Capstone --m 1 --driver com.mysql.jdbc.Driver

docker exec namenode hdfs dfs -rm -r /user/doan2506/hive/avsc
docker exec namenode hdfs dfs -mkdir -p /user/doan2506/hive/avsc
docker exec -w /workspaces/BigData-Engineering-Capstone-Project namenode hdfs dfs -put departments.avsc /user/doan2506/hive/avsc/departments.avsc
docker exec -w /workspaces/BigData-Engineering-Capstone-Project namenode hdfs dfs -put titles.avsc /user/doan2506/hive/avsc/titles.avsc
docker exec -w /workspaces/BigData-Engineering-Capstone-Project namenode hdfs dfs -put employees.avsc /user/doan2506/hive/avsc/employees.avsc
docker exec -w /workspaces/BigData-Engineering-Capstone-Project namenode hdfs dfs -put dept_manager.avsc /user/doan2506/hive/avsc/dept_manager.avsc
docker exec -w /workspaces/BigData-Engineering-Capstone-Project namenode hdfs dfs -put dept_emp.avsc /user/doan2506/hive/avsc/dept_emp.avsc
docker exec -w /workspaces/BigData-Engineering-Capstone-Project namenode hdfs dfs -put salaries.avsc /user/doan2506/hive/avsc/salaries.avsc
docker exec namenode hadoop fs -chmod +rwx /user/doan2506/hive/avsc/*
docker exec namenode hadoop fs -chmod +rwx /user/doan2506/hive/warehouse/Capstone/*

# Hive commands routed to hive-server container
docker exec -w /workspaces/BigData-Engineering-Capstone-Project hive-server hive -f HiveDB.hql > /workspaces/BigData-Engineering-Capstone-Project/Capstone_Outputs/Cap_HiveDB.txt
docker exec -w /workspaces/BigData-Engineering-Capstone-Project hive-server hive -f EDA.sql > /workspaces/BigData-Engineering-Capstone-Project/Capstone_Outputs/Cap_ImpalaAnalysis.txt
docker exec -w /workspaces/BigData-Engineering-Capstone-Project hive-server hive -f HiveTables.sql > /workspaces/BigData-Engineering-Capstone-Project/Capstone_Outputs/Cap_HiveTables.txt

# Spark commands routed to spark-master container
docker exec -w /workspaces/BigData-Engineering-Capstone-Project spark-master spark-submit capstone.py > /workspaces/BigData-Engineering-Capstone-Project/Capstone_Outputs/Cap_SparkSQL_EDA_ML.txt

# Final HDFS pulls
docker exec -w /workspaces/BigData-Engineering-Capstone-Project namenode hdfs dfs -copyToLocal /user/doan2506/random_forest.model /workspaces/BigData-Engineering-Capstone-Project/Capstone_Outputs/
zip -r /workspaces/BigData-Engineering-Capstone-Project/Capstone_Outputs/random_forest.model.zip /workspaces/BigData-Engineering-Capstone-Project/Capstone_Outputs/random_forest.model
rm -rf /workspaces/BigData-Engineering-Capstone-Project/Capstone_Outputs/random_forest.model

docker exec -w /workspaces/BigData-Engineering-Capstone-Project namenode hdfs dfs -copyToLocal /user/doan2506/logistic_regression.model /workspaces/BigData-Engineering-Capstone-Project/Capstone_Outputs/
zip -r /workspaces/BigData-Engineering-Capstone-Project/Capstone_Outputs/logistic_regression.model.zip /workspaces/BigData-Engineering-Capstone-Project/Capstone_Outputs/logistic_regression.model
rm -rf /workspaces/BigData-Engineering-Capstone-Project/Capstone_Outputs/logistic_regression.model