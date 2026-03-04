-- CRUD operations

-- Task 1. Create a New Book Record - "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'
INSERT INTO books
VALUES('978-1-60129-456-2','To Kill a Mockingbird', 'Classic', '6.00', 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;

-- Task 2. Update an Existing Member's Address
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103'
RETURNING *;

-- Task 3. Delete the record with issued_id = 'IS121' from the issued_status table.
DELETE FROM issued_status
WHERE issued_id = 'IS121'
RETURNING *;

-- Task 4. Retrieve All Books Issued by the employee with emp_id = 'E101'.
SELECT issued_emp_id, emp_name, isbn, book_title, issued_date, issued_member_id
FROM issued_status
INNER JOIN books
ON issued_status.issued_book_isbn = books.isbn
INNER JOIN employees
ON issued_status.issued_emp_id = employees.emp_id
WHERE issued_emp_id = 'E101';

-- Task 5. Find members who have issued more than one book.
SELECT issued_member_id, member_name, COUNT(issued_id) AS no_of_books_issued
FROM issued_status
INNER JOIN members
ON issued_status.issued_member_id = members.member_id
GROUP BY issued_member_id, member_name
HAVING COUNT(issued_id) > 1;

-- CTAS (Create Table As Select)

-- Task 6. Use CTAS to generate a new table for number of issues for each book
CREATE TABLE books_issued_count AS
SELECT isbn, book_title, COUNT(issued_id) AS number_of_issues
FROM issued_status
INNER JOIN books
ON issued_status.issued_book_isbn = books.isbn
GROUP BY isbn, book_title;

SELECT * FROM books_issued_count;

-- Business Problems and Answers (Data Analysis)

-- Task 7. Retrieve All Books in a 'Classic' Category
SELECT * FROM books
WHERE category = 'Classic';

-- Task 8. Find Total Rental Income by Category
SELECT category, SUM(rental_price) AS total_rental_income
FROM books
INNER JOIN issued_status ON
issued_status.issued_book_isbn = books.isbn
GROUP BY category;

-- Task 9. List Members Who Registered in the Last 180 Days of available data
SELECT * FROM members
WHERE reg_date >= (
	SELECT MAX(reg_date)
	FROM members
) - INTERVAL '180 days';

-- Task 10. List Employees with Their Branch Manager's Name and their branch details
SELECT e1.emp_id, e1.emp_name,
e2.emp_id AS branch_manager_id, e2.emp_name AS branch_manager_name, 
b.branch_id, b.branch_address, b.contact_no
FROM branch AS b
INNER JOIN employees AS e1
ON b.branch_id = e1.branch_id
INNER JOIN employees AS e2
ON b.manager_id = e2.emp_id;

-- Task 11. Create a Table of Books with Rental Price Above 7.00
CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;

SELECT * FROM expensive_books;

-- Task 12. Retrieve the List of Books Not Yet Returned
SELECT isbn, book_title FROM issued_status
LEFT OUTER JOIN return_status
ON issued_status.issued_id = return_status.issued_id
INNER JOIN books
ON issued_status.issued_book_isbn = books.isbn
WHERE return_status.return_id IS NULL;

-- Task 13. Identify members whose books were not returned within 30 days of the issue date
SELECT member_id, member_name, book_title, issued_date,
(return_date - issued_date) - 30 AS days_overdue
FROM issued_status
INNER JOIN return_status
ON issued_status.issued_id = return_status.issued_id
INNER JOIN books
ON issued_status.issued_book_isbn = books.isbn
INNER JOIN members
ON issued_status.issued_member_id = members.member_id
WHERE (return_date - issued_date) > 30; 

-- Task 14. Update the status of books in the books table to "Yes" when they are returned
UPDATE books
SET status = 'yes'
FROM issued_status
INNER JOIN return_status
ON issued_status.issued_id = return_status.issued_id
WHERE books.isbn = issued_status.issued_book_isbn;

-- Task 15. Generate a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
CREATE TABLE branch_performance_report AS
SELECT b.branch_id,
COUNT(i.issued_id) AS no_of_books_issued, 
COUNT(r.return_id) AS no_of_books_returned,
SUM(rental_price) AS total_revenue_generated
FROM branch AS b
INNER JOIN employees AS e
ON b.branch_id = e.branch_id
INNER JOIN issued_status AS i
ON e.emp_id = i.issued_emp_id
LEFT OUTER JOIN return_status AS r
ON i.issued_id = r.issued_id
INNER JOIN books b1
ON b1.isbn = i.issued_book_isbn
GROUP BY b.branch_id
ORDER BY b.branch_id;

SELECT * FROM branch_performance_report;

