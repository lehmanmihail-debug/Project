Table students [headercolor: #ff4f81] {
	id int [ pk, increment, not null, unique ]
	first_name varchar(255)
	last_name varchar(255)
	email varchar(255)
	phone varchar(255)
	address varchar(255)
	dob date
	major_id int
}

Table courses [headercolor: #bc49c4] {
	id int [ pk, increment, not null, unique ]
	name varchar(255)
	dep_id int
	credits int
}

Table enrollment [headercolor: #7c4af0] {
	id int [ pk, increment, not null, unique ]
	course_id int
	student_id int
	term varchar(255)
}

Table instructors [headercolor: #7d9dff] {
	id int [ pk, increment, not null, unique ]
	first_name varchar(255)
	last_name varchar(255)
	email varchar(255)
	dep_id int
}

Table departments [headercolor: #32c9b0] {
	id int [ pk, increment, not null, unique ]
	name varchar(255)
	chairperson int
}

Table major [headercolor: #ffe159] {
	id int [ pk, increment, not null, unique ]
	name varchar(255)
}

Ref enrollment_student_id_fk {
	enrollment.student_id > students.id [ delete: no action, update: no action ]
}

Ref enrollment_course_id_fk {
	enrollment.course_id > courses.id [ delete: no action, update: no action ]
}

Ref instructors_dep_id_fk {
	instructors.dep_id - departments.id [ delete: no action, update: no action ]
}

Ref courses_dep_id_fk {
	courses.dep_id - departments.id [ delete: no action, update: no action ]
}

Ref students_major_id_fk {
	students.major_id > major.id [ delete: no action, update: no action ]
}