-- Create database
CREATE DATABASE IF NOT EXISTS day_4;
USE day_4;

-- Table: Students
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    registration_date DATE
);

INSERT INTO Students (student_id, first_name, last_name, registration_date) VALUES
(1, 'Ali', 'Khan', '2022-01-15'),
(2, 'Sara', 'Ahmed', '2021-11-23'),
(3, 'John', 'Doe', '2023-03-01'),
(4, 'Maria', 'Smith', '2022-07-18'),
(5, 'David', 'Lee', '2021-12-05');

-- Table: Courses
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name TEXT NOT NULL,
    category TEXT,
    start_date DATE,
    end_date DATE
);

INSERT INTO Courses (course_id, course_name, category, start_date, end_date) VALUES
(101, 'Python for Beginners', 'Programming', '2022-02-01', '2022-05-01'),
(102, 'Data Science Bootcamp', 'Data Science', '2022-03-01', NULL),
(103, 'Web Development', 'Programming', '2023-01-10', '2023-04-10'),
(104, 'AI Fundamentals', 'AI', '2023-02-15', NULL),
(105, 'Database Systems', 'Data Management', '2022-06-01', '2022-09-01');

-- Table: Enrollments
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date) VALUES
(1001, 1, 101, '2022-01-20'),
(1002, 2, 101, '2022-02-01'),
(1003, 3, 102, '2023-03-05'),
(1004, 4, 103, '2023-02-01'),
(1005, 5, 104, '2023-02-20'),
(1006, 1, 104, '2023-03-01'),
(1007, 2, 105, '2022-06-15');

-- Table: Instructors
CREATE TABLE Instructors (
    instructor_id INT PRIMARY KEY,
    instructor_name TEXT NOT NULL,
    course_id INT,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

INSERT INTO Instructors (instructor_id, instructor_name, course_id) VALUES
(201, 'Mr. Usman', 101),
(202, 'Ms. Fatima', 102),
(203, 'Mr. Brown', 103),
(204, 'Ms. Ayesha', 104),
(205, 'Mr. Chang', 105);


-- Problem 1: Students with Multiple Enrollments (Normal)
	-- Problem: Your AI model needs to identify highly engaged students for personalized course recommendations. 
    -- Write a SQL query to find students with more than one enrollment, using a subquery. 
    -- Display the first_name, last_name, and student_id from the Students table. 
    -- Sort by first_name ascending.
select * from Students;
select * from Enrollments;

select 
	s.first_name, s.last_name, s.student_id 
from Students s 
where s.student_id in 
	(select student_id from Enrollments group by student_id having count(course_id) > 1)
order by s.first_name asc;

-- Problem 2: Courses with No Enrollments (Normal)
	-- Problem: Your AI model needs to identify underperforming courses for marketing campaigns. 
    -- Write a SQL query to find courses with no enrollments, using a subquery. 
    -- Display the course_name and category from the Courses table. 
    -- Sort by course_name ascending.
select * from Courses;
select * from Enrollments;

select 
	c.course_name, c.course_id 
from Courses c 
where c.course_id in 
		(select course_id from Enrollments group by course_id having count(enrollment_id) = 0)
order by c.course_name asc;

-- Problem 3: Recent Enrollments (Normal)
	-- Problem: Your AI model needs recent student activity for engagement analysis. 
    -- Write a SQL query to find students enrolled in courses after January 1, 2023, using a subquery. 
    -- Join the Students and Enrollments tables, and display the first_name, last_name, and enrollment_date. 
    -- Sort by enrollment_date descending.
select * from Students;
select * from Enrollments;

select 
	s.first_name, s.last_name, e.enrollment_date from Students s 
join Enrollments e on 
	s.student_id = e.student_id
where e.course_id in 
	(select course_id from Enrollments where enrollment_date > '2023-01-01')
order by e.enrollment_date desc;

-- Problem 4: Top Enrolled Course (Normal)
	-- Problem: Your AI model needs to highlight popular courses for resource allocation. 
    -- Write a SQL query to find the course with the highest number of enrollments, using a subquery. 
    -- Join the Courses and Enrollments tables, and display the course_name, category, and enrollment count. 
    -- If there’s a tie, show all top courses.
select * from Courses;
select * from Enrollments;

select 
	c.course_name, c.category, count(e.enrollment_id) as tot_enrol 
from Courses c 
	join Enrollments e on 
		c.course_id = e.course_id 
	group by c.course_id
    having count(e.enrollment_id) = 
		(select max(tot_enrollments) from (select course_id, count(enrollment_id) as tot_enrollments from Enrollments group by course_id) sub)
	order by c.course_name asc;

-- Problem 5: Student Enrollment Ranking (Normal)
	-- Problem: Your AI model needs to rank students by their number of enrollments for engagement analysis. 
    -- Write a SQL query to rank students using RANK(), a window function. 
    -- Join the Students and Enrollments tables, and display the first_name, last_name, enrollment_count, and rank. 
    -- Sort by rank ascending, then first_name ascending.
select * from Students;
select * from Enrollments;

select 
	s.first_name, s.last_name, count(e.enrollment_id) as course_num_enrolls,
    rank() over (order by count(e.enrollment_id) desc) as enroll_ranks
from Students s 
left join Enrollments e on 
	s.student_id = e.student_id 
group by s.student_id, s.first_name, s.last_name
order by enroll_ranks asc, s.first_name asc;

-- Problem 6: Course Enrollment Distribution (Normal)
	-- Problem: Your AI model needs to segment courses by enrollment volume for resource planning. 
    -- Write a SQL query to assign courses to quartiles based on their enrollment count, using NTILE(). 
    -- Join the Courses and Enrollments tables, and display the course_name, category, enrollment_count, and quartile (1–4). 
    -- Sort by quartile ascending, then course_name ascending.
select 
	c.course_name, c.category, count(e.enrollment_id) as tot_enrol,
    ntile(4) over (order by count(e.enrollment_id) desc) as quartile
from Courses c 
	join Enrollments e on 
		c.course_id = e.course_id 
group by c.course_id, c.course_name, c.category
order by quartile asc, c.course_name asc;

-- Problem 7: Instructor Course Rankings (Normal)
	-- Problem: Your AI model needs to evaluate instructor performance based on course enrollments. 
    -- Write a SQL query to rank instructors by the total number of enrollments in their courses, using DENSE_RANK(). 
    -- Join the Instructors, Courses, and Enrollments tables, and display the instructor_name, course_name, enrollment_count, and dense rank. 
    -- Sort by dense_rank ascending, then instructor_name ascending.

select i.instructor_name, c.course_name,
		count(e.enrollment_id) as enrollment_count,
        dense_rank() over (order by count(e.enrollment_id) desc) as densee_rank
from Instructors i 
	join Courses c on 
		i.course_id = c.course_id
	left join Enrollments e on 
		c.course_id = e.course_id
group by i.instructor_id, i.instructor_name, c.course_name;

-- Problem 8: Running Total of Enrollments by Category (Normal)
	-- Problem: Your AI model needs to track enrollment trends by course category for strategic planning. 
    -- Write a SQL query to calculate the running total of enrollments per category, ordered by enrollment date, using SUM() OVER. 
    -- Join the Courses, Enrollments, and Students tables, and display the category, first_name, last_name, enrollment_date, and running total. 
    -- Sort by category ascending, then enrollment_date ascending.
select * from Courses;
select * from Enrollments;
select * from Students;

select 
	c.category, s.first_name, s.last_name, e.enrollment_date,
    sum(1) over (partition by c.category order by e.enrollment_date) as running_total
from Courses c 
	join Enrollments e on c.course_id = e.course_id
    join Students s on e.student_id = s.student_id
order by c.category asc, e.enrollment_date asc;

-- Problem 9: Unique Enrollment Number per Course (Normal)
	-- Problem: Your AI model needs to assign unique identifiers to enrollments within each course for tracking. 
    -- Write a SQL query to assign a unique number to each enrollment per course using ROW_NUMBER(). 
    -- Join the Courses, Enrollments, and Students tables, and display the course_name, first_name, last_name, enrollment_date, and row number. 
    -- Sort by course_name ascending, then enrollment_date ascending.
select * from Courses;
select * from Enrollments;
select * from Students;

select c.course_name, s.first_name, s.last_name, e.enrollment_date,
		row_number() over (partition by(c.course_id) order by e.enrollment_date) as row_num
from Courses c
	join Enrollments e on c.course_id = e.course_id
    join Students s on e.student_id = s.student_id
order by c.course_name asc, e.enrollment_date asc;

-- Problem 10: Enrollment Count per Student Over Time (Normal)
	-- Problem: Your AI model needs to track student enrollment trends for engagement analysis. 
    -- Write a SQL query to calculate the cumulative number of enrollments per student, ordered by enrollment date, using COUNT() OVER. 
    -- Join the Students, Enrollments, and Courses tables, and display the first_name, last_name, course_name, enrollment_date, and cumulative count. 
    -- Sort by first_name ascending, then enrollment_date ascending.
select * from Students;
select * from Enrollments;
select * from Courses;

select s.first_name, s.last_name, c.course_name, e.enrollment_date,
		count(e.enrollment_id) over (partition by s.student_id order by e.enrollment_date) as cummulative_count
from Students s 
	join Enrollments e on s.student_id = e.student_id
    join Courses c on e.course_id = c.course_id
order by s.first_name asc, e.enrollment_date asc;

-- Problem 11: Students Enrolled in Programming Courses (Normal)
	-- Problem: Your AI model needs to target students interested in programming for specialized campaigns. 
    -- Write a SQL query to find students enrolled in courses with the category ‘Programming’, using a subquery. 
    -- Join the Students, Enrollments, and Courses tables, and display the first_name, last_name, and course_name. 
    -- Sort by first_name ascending.
    
select s.first_name, s.last_name, c.course_name 
from Students s 
	join Enrollments e on s.student_id = e.student_id 
    join Courses c on e.course_id = c.course_id
    where c.course_id in (select course_id from Courses where category = "Programming")
order by s.first_name asc;

-- Problem 12: Courses Taught by Specific Instructors (Normal)
	-- Problem: Your AI model needs to identify courses taught by instructors with names starting with ‘Ms.’ for administrative analysis. 
    -- Write a SQL query to find these courses, using a subquery. 
    -- Join the Courses and Instructors tables, and display the course_name, category, and instructor_name. 
    -- Sort by course_name ascending.

select c.course_name, c.category, i.instructor_name 
from Courses c 
	join Instructors i on c.course_id = i.course_id
where i.instructor_id in (select instructor_id from Instructors where instructor_name like "Ms.%")
order by c.course_name;

-- Problem 13: Course Enrollment Order by Date (Normal)
	-- Problem: Your AI model needs to analyze the sequence of course enrollments for trend analysis. 
    -- Write a SQL query to assign a rank to each course based on its earliest enrollment date, using RANK(). 
    -- Join the Courses and Enrollments tables, and display the course_name, category, earliest_enrollment_date, and rank. 
    -- Sort by rank ascending, then course_name ascending.
select * from Courses;
select * from Enrollments;

select c.course_name, c.category,
		min(e.enrollment_date) as earliest_enrollment_name,
        rank() over (order by min(e.enrollment_date)) as enrollment_rank
from Courses c 
	join Enrollments e on c.course_id = e.course_id
group by c.course_name, c.category;

-- Problem 14: Student Enrollment Sequence (Normal)
	-- Problem: Your AI model needs to track the order of enrollments for each student for engagement analysis. 
    -- Write a SQL query to assign a unique sequence number to each of a student’s enrollments, using ROW_NUMBER(). 
    -- Join the Students, Enrollments, and Courses tables, and display the first_name, last_name, course_name, enrollment_date, and sequence number. 
    -- Sort by first_name ascending, then enrollment_date ascending
select * from Courses;

select s.first_name, s.last_name, c.course_name, e.enrollment_date,
		row_number() over (partition by s.student_id order by e.enrollment_date) as seq_num
from Students s 
	join Enrollments e on s.student_id = e.student_id
    join Courses c on e.course_id = c.course_id
order by s.first_name asc, e.enrollment_date asc;

-- Problem 15: Previous Enrollment Date per Student (Normal)
	-- Problem: Your AI model needs to analyze the time between a student’s enrollments for retention studies. 
    -- Write a SQL query to show each enrollment’s previous enrollment date for each student, using LAG(). 
    -- Join the Students, Enrollments, and Courses tables, and display the first_name, last_name, course_name, enrollment_date, and previous enrollment date. 
    -- Sort by first_name ascending, then enrollment_date ascending.
select s.first_name, s.last_name, c.course_name, e.enrollment_date,
		lag(e.enrollment_date) over (partition by s.student_id order by e.enrollment_date) as previous_enrollment_date
from Students s 
	join Enrollments e on s.student_id = e.student_id
    join Courses c on e.course_id = c.course_id
order by s.first_name asc, e.enrollment_date asc;

-- Problem 16: Category Enrollment Rankings (Normal)
	-- Problem: Your AI model needs to rank course categories by total enrollments for strategic analysis. 
    -- Write a SQL query to rank categories using DENSE_RANK(). 
    -- Join the Courses and Enrollments tables, and display the category, enrollment_count, and dense rank. 
    -- Sort by dense_rank ascending, then category ascending.
select c.category, count(e.enrollment_id) as enroll_count,
		dense_rank() over (order by count(e.enrollment_id) desc) as densed_rank
from Courses c 
	join Enrollments e on c.course_id = e.course_id
group by c.category
order by densed_rank asc, c.category asc;

-- Problem 17: Students with Recent High-Enrollment Courses (Normal-to-Medium)
	-- Problem: Your AI model needs to identify students enrolled in popular courses 
		-- (those with 2 or more enrollments) after January 1, 2023, for targeted engagement campaigns. 
	-- Write a SQL query using a nested subquery to find these students. 
    -- Join the Students, Enrollments, and Courses tables, and display the first_name, last_name, course_name, and enrollment_date. 
    -- Sort by enrollment_date descending, then first_name ascending.

select s.first_name, s.last_name, c.course_name, e.enrollment_date 
from Students s 
	join Enrollments e on s.student_id = e.student_id
    join Courses c on e.course_id = c.course_id
where e.course_id in 
	(select course_id from Enrollments where enrollment_date > '2023-01-01' and course_id in 
		(select course_id from Enrollments group by course_id having count(course_id) >= 2))
order by e.enrollment_date desc, s.first_name asc;

-- Problem 18: Instructors of Top Enrollment Categories (Normal-to-Medium)
	-- Problem: Your AI model needs to identify instructors teaching courses in the 
			-- top enrollment category (highest total enrollments) for performance analysis. 
	-- Write a SQL query using a subquery to find these instructors. 
    -- Join the Instructors, Courses, and Enrollments tables, and display the instructor_name, course_name, category, and enrollment_count. 
    -- Sort by instructor_name ascending, then course_name ascending.
select * from Enrollments;
select c.category from Courses c left join Enrollments e on c.course_id = e.course_id group by c.category order by count(e.enrollment_id) desc limit 1;
select i.instructor_name, c.course_name, c.category, count(e.enrollment_id) as enrollment_count
from Instructors i 
	join Courses c on i.course_id = c.course_id
	left join Enrollments e on c.course_id = e.course_id
where c.category = 
				(select c.category from Courses c2 
						left join Enrollments e2 on 
									c2.course_id = e2.course_id 
						group by c2.category 
                        order by count(e2.enrollment_id) desc limit 1)
group by i.instructor_id, i.instructor_name, c.course_name, c.category
order by i.instructor_name asc, c.course_name asc;

-- Problem 19: First Enrollment per Category (Normal-to-Medium)
	-- Problem: Your AI model needs to track the first enrollment in each course category for historical analysis. 
    -- Write a SQL query to identify the first enrollment per category, using RANK() and a window function. 
    -- Join the Courses, Enrollments, and Students tables, and display the category, course_name, first_name, last_name, enrollment_date, and rank. 
    -- Filter for rank 1 and sort by category ascending.
select t.category, t.course_name, t.first_name, t.last_name, t.enrollment_date, t.course_rank from
		(select c.category, c.course_name, s.first_name, s.last_name, e.enrollment_date,
				rank() over (partition by c.category order by e.enrollment_date) as course_rank
		from Courses c 
			join Enrollments e on c.course_id = e.course_id
			join Students s on e.student_id = s.student_id) t
where t.course_rank = 1
order by t.category asc;

-- Problem 20: Days Between Enrollments per Student (Normal-to-Medium)
	-- Problem: Your AI model needs to analyze the time gaps between a student’s enrollments for retention analysis. 
    -- Write a SQL query to calculate the number of days between each enrollment and the previous one for each student, using LAG() and date functions. 
    -- Join the Students, Enrollments, and Courses tables, and display the first_name, last_name, course_name, enrollment_date, 
    -- and days since the previous enrollment (NULL for the first). 
    -- Sort by first_name ascending, then enrollment_date ascending.
select s.first_name, s.last_name, c.course_name, e.enrollment_date,
		datediff(e.enrollment_date, lag(e.enrollment_date) over (partition by s.student_id order by e.enrollment_date)) as days_since_prev
from Students s
	join Enrollments e on s.student_id = e.student_id
    join Courses c on e.course_id = c.course_id
order by s.first_name asc, e.enrollment_date asc;