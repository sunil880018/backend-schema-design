-- Cities Table: Stores information about cities
CREATE TABLE cities (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(255) NOT NULL,
    state VARCHAR(255),
    country VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Schools Table: Stores information about schools in different cities
CREATE TABLE schools (
    school_id SERIAL PRIMARY KEY,
    city_id INT REFERENCES cities(city_id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    phone_number VARCHAR(20),
    email VARCHAR(255),
    website VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Users Table: Stores information about users (teachers, students, staff)
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    school_id INT REFERENCES schools(school_id) ON DELETE CASCADE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) CHECK (role IN ('teacher', 'student', 'admin', 'staff')) NOT NULL, -- Role can be teacher, student, admin, staff
    phone_number VARCHAR(20),
    profile_picture VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Classes Table: Stores information about classes within a school
CREATE TABLE classes (
    class_id SERIAL PRIMARY KEY,
    school_id INT REFERENCES schools(school_id) ON DELETE CASCADE,
    class_name VARCHAR(100) NOT NULL, -- e.g., 'Class 1', 'Grade 2'
    grade VARCHAR(50), -- e.g., 'Grade 1', 'Grade 2', 'Grade 10'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Students Table: Tracks which students are in which classes
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    class_id INT REFERENCES classes(class_id) ON DELETE CASCADE,
    admission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'Active', -- Student status can be 'Active', 'Graduated', 'Dropped', etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Teachers Table: Tracks which teachers are assigned to which classes
CREATE TABLE teachers (
    teacher_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    subject_id INT REFERENCES subjects(subject_id) ON DELETE SET NULL, -- Subjects taught by the teacher
    class_id INT REFERENCES classes(class_id) ON DELETE CASCADE, -- Class taught by the teacher
    hire_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Subjects Table: Stores information about subjects offered in the school
CREATE TABLE subjects (
    subject_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Class Subjects Table: Tracks which subjects are taught in which classes
CREATE TABLE class_subjects (
    class_id INT REFERENCES classes(class_id) ON DELETE CASCADE,
    subject_id INT REFERENCES subjects(subject_id) ON DELETE CASCADE,
    PRIMARY KEY (class_id, subject_id)
);

-- Grades Table: Stores the grades for students in various subjects
CREATE TABLE grades (
    grade_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id) ON DELETE CASCADE,
    subject_id INT REFERENCES subjects(subject_id) ON DELETE CASCADE,
    grade DECIMAL(5, 2), -- Grade for the student in this subject
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Exams Table: Stores information about exams
CREATE TABLE exams (
    exam_id SERIAL PRIMARY KEY,
    subject_id INT REFERENCES subjects(subject_id) ON DELETE CASCADE,
    exam_name VARCHAR(255) NOT NULL,
    exam_date TIMESTAMP NOT NULL,
    duration INT, -- Duration of the exam in minutes
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Exam Results Table: Stores results of students for various exams
CREATE TABLE exam_results (
    result_id SERIAL PRIMARY KEY,
    exam_id INT REFERENCES exams(exam_id) ON DELETE CASCADE,
    student_id INT REFERENCES students(student_id) ON DELETE CASCADE,
    marks_obtained DECIMAL(5, 2), -- Marks obtained by the student
    status VARCHAR(50) CHECK (status IN ('Passed', 'Failed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Timetable Table: Stores the schedule for classes and teachers
CREATE TABLE timetable (
    timetable_id SERIAL PRIMARY KEY,
    class_id INT REFERENCES classes(class_id) ON DELETE CASCADE,
    subject_id INT REFERENCES subjects(subject_id) ON DELETE CASCADE,
    teacher_id INT REFERENCES teachers(teacher_id) ON DELETE CASCADE,
    day_of_week VARCHAR(20), -- e.g., 'Monday', 'Tuesday'
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- School Events Table: Stores school events like meetings, sports day, etc.
CREATE TABLE school_events (
    event_id SERIAL PRIMARY KEY,
    school_id INT REFERENCES schools(school_id) ON DELETE CASCADE,
    event_name VARCHAR(255) NOT NULL,
    event_date TIMESTAMP NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Attendance Table: Tracks student attendance for each class
CREATE TABLE attendance (
    attendance_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id) ON DELETE CASCADE,
    class_id INT REFERENCES classes(class_id) ON DELETE CASCADE,
    date TIMESTAMP NOT NULL,
    status VARCHAR(50) CHECK (status IN ('Present', 'Absent', 'Late', 'Excused')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Messages Table: Stores messages between teachers, students, and staff
CREATE TABLE messages (
    message_id SERIAL PRIMARY KEY,
    sender_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    receiver_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    message_text TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Notifications Table: Stores notifications for students, teachers, and staff
CREATE TABLE notifications (
    notification_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Fees Table: Tracks the fee payments for students
CREATE TABLE fees (
    fee_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    due_date TIMESTAMP NOT NULL,
    payment_status VARCHAR(50) CHECK (payment_status IN ('Paid', 'Pending', 'Overdue')) DEFAULT 'Pending',
    payment_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- School Admin Table: Stores information about school admins
CREATE TABLE school_admins (
    admin_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    school_id INT REFERENCES schools(school_id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

