erDiagram
    students ||--o{ enrollment : "has"
    courses ||--o{ enrollment : "has"
    departments ||--o{ instructors : "employs"
    departments ||--o{ courses : "offers"
    major ||--o{ students : "specializes"

    students {
        INT id
        VARCHAR(255) first_name
        VARCHAR(255) last_name
        VARCHAR(255) email
        VARCHAR(255) phone
        VARCHAR(255) address
        DATE dob
        INT major_id
    }

    enrollment {
        INT id
        INT course_id
        INT student_id
        VARCHAR(255) term
    }

    courses {
        INT id
        VARCHAR(255) name
        INT dep_id
        INT credits
    }

    instructors {
        INT id
        VARCHAR(255) first_name
        VARCHAR(255) last_name
        VARCHAR(255) email
        INT dep_id
    }

    departments {
        INT id
        VARCHAR(255) name
        INT chairperson
    }

    major {
        INT id
        VARCHAR(255) name
    }