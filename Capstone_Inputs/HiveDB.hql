DROP DATABASE IF EXISTS doan2506_cap CASCADE;
CREATE DATABASE doan2506_cap;
USE doan2506_cap;

SET mapreduce.input.fileinputformat.split.maxsize = 67108864;
SET mapreduce.map.memory.mb = 2048;
SET mapreduce.reduce.memory.mb = 2048;
SET mapreduce.map.output.compress = true;
SET mapreduce.map.output.compress.codec = org.apache.hadoop.io.compress.SnappyCodec;

CREATE EXTERNAL TABLE departments STORED AS AVRO LOCATION '/user/doan2506/hive/warehouse/Capstone/departments' TBLPROPERTIES ('avro.schema.url'='/user/doan2506/hive/avsc/departments.avsc');
CREATE EXTERNAL TABLE titles STORED AS AVRO LOCATION '/user/doan2506/hive/warehouse/Capstone/titles' TBLPROPERTIES ('avro.schema.url'='/user/doan2506/hive/avsc/titles.avsc');
CREATE EXTERNAL TABLE employees STORED AS AVRO LOCATION '/user/doan2506/hive/warehouse/Capstone/employees' TBLPROPERTIES ('avro.schema.url'='/user/doan2506/hive/avsc/employees.avsc');
CREATE EXTERNAL TABLE dept_manager STORED AS AVRO LOCATION '/user/doan2506/hive/warehouse/Capstone/dept_manager' TBLPROPERTIES ('avro.schema.url'='/user/doan2506/hive/avsc/dept_manager.avsc');
CREATE EXTERNAL TABLE dept_emp STORED AS AVRO LOCATION '/user/doan2506/hive/warehouse/Capstone/dept_emp' TBLPROPERTIES ('avro.schema.url'='/user/doan2506/hive/avsc/dept_emp.avsc');
CREATE EXTERNAL TABLE salaries STORED AS AVRO LOCATION '/user/doan2506/hive/warehouse/Capstone/salaries' TBLPROPERTIES ('avro.schema.url'='/user/doan2506/hive/avsc/salaries.avsc');