-- Library Management System

-- Create Tables

-- Branches
DROP TABLE IF EXISTS branch;
CREATE TABLE branch (
	branch_id VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(10),
    branch_address VARCHAR(30),
    contact_no VARCHAR(15)
);

-- Employees
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
	emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(30),
    position VARCHAR(30),
    salary DECIMAL(10,2),
    branch_id VARCHAR(10) REFERENCES branch(branch_id)
);

-- Books
DROP TABLE IF EXISTS books;
CREATE TABLE books (
	isbn VARCHAR(50) PRIMARY KEY,
    book_title VARCHAR(80),
    category VARCHAR(30),
    rental_price DECIMAL(10,2),
    status VARCHAR(10),
    author VARCHAR(30),
    publisher VARCHAR(30)
);

-- Members
DROP TABLE IF EXISTS members;
CREATE TABLE members (
	member_id VARCHAR(10) PRIMARY KEY,
    member_name VARCHAR(30),
    member_address VARCHAR(30),
    reg_date DATE
);

-- Issued Status
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status (
	issued_id VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR(30) REFERENCES members(member_id),
    issued_date DATE,
    issued_book_isbn VARCHAR(50) REFERENCES books(isbn),
    issued_emp_id VARCHAR(10) REFERENCES employees(emp_id)
);

-- Return Status
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status (
	return_id VARCHAR(10) PRIMARY KEY,
    issued_id VARCHAR(10) REFERENCES issued_status(issued_id),
    return_date DATE
);

