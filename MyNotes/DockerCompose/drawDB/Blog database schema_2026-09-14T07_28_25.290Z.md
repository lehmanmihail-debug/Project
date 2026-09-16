```mermaid 
erDiagram
	blog_posts }o--|| users : references
	comments }o--|| blog_posts : references
	comments }o--|| users : references
	blog_tag }o--|| tags : references
	blog_tag }o--|| blog_posts : references

	users {
		INT id
		VARCHAR(255) username
		VARCHAR(255) password
		VARCHAR(255) email
		TIMESTAMP last_login
	}

	blog_posts {
		INT id
		INT user_id
		VARCHAR(255) title
		VARCHAR(255) content
		VARCHAR(255) cover
	}

	comments {
		INT id
		INT blog_id
		INT user_id
		VARCHAR(255) content
	}

	tags {
		INT id
		VARCHAR(255) name
	}

	blog_tag {
		INT blog_id
		INT tag_id
	}
```