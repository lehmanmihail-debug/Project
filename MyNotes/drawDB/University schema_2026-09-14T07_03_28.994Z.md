``` mermaid
erDiagram
    enrollment }o--|| students : "references"
    enrollment }o--|| courses : "references"
    instructors ||--|| departments : "references"
    courses ||--|| departments : "references"
    students }o--|| major : "references"

    students {
        INT id
        VARCHAR first_name
        VARCHAR last_name
        VARCHAR email
        VARCHAR phone
        VARCHAR address
        DATE dob
        INT major_id
    }

    courses {
        INT id
        VARCHAR name
        INT dep_id
        INT credits
    }

    enrollment {
        INT id
        INT course_id
        INT student_id
        VARCHAR term
    }

    instructors {
        INT id
        VARCHAR first_name
        VARCHAR last_name
        VARCHAR email
        INT dep_id
    }

    departments {
        INT id
        VARCHAR name
        INT chairperson
    }

    major {
        INT id
        VARCHAR name
    }