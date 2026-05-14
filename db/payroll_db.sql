-- MySQL schema for Employee Payroll System
CREATE DATABASE IF NOT EXISTS payroll_db;
USE payroll_db;

CREATE TABLE IF NOT EXISTS admin (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(100) NOT NULL
);

INSERT INTO admin(username, password) VALUES ('Admin1','87654321')
  ON DUPLICATE KEY UPDATE password=VALUES(password);

CREATE TABLE IF NOT EXISTS employee (
  id INT AUTO_INCREMENT PRIMARY KEY,
  firstname VARCHAR(50),
  lastname VARCHAR(50),
  dob DATE,
  gender VARCHAR(10),
  email VARCHAR(100),
  contact VARCHAR(20),
  address1 VARCHAR(100),
  address2 VARCHAR(100),
  house_no VARCHAR(50),
  postal_code VARCHAR(20),
  department VARCHAR(50),
  designation VARCHAR(50),
  status VARCHAR(20),
  hire_date DATE,
  basic_salary DOUBLE,
  job_title VARCHAR(50),
  picture LONGBLOB
);

CREATE TABLE IF NOT EXISTS allowance (
  emp_id INT PRIMARY KEY,
  overtime DOUBLE DEFAULT 0,
  medical DOUBLE DEFAULT 0,
  bonus DOUBLE DEFAULT 0,
  other DOUBLE DEFAULT 0,
  total_overtime_rate DOUBLE DEFAULT 0,
  rph_rate DOUBLE DEFAULT 0,
  FOREIGN KEY (emp_id) REFERENCES employee(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS deduction (
  emp_id INT PRIMARY KEY,
  percentage DOUBLE DEFAULT 0,
  amount DOUBLE DEFAULT 0,
  reason VARCHAR(100),
  FOREIGN KEY (emp_id) REFERENCES employee(id) ON DELETE CASCADE
);
