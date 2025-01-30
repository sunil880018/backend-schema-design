
# Social Media Database Schema

## Users
This table holds information about users on the platform, including their name, profile picture, and email.

### Table: `users`
| Column          | Type         | Description                                      |
|-----------------|--------------|--------------------------------------------------|
| id              | SERIAL       | Primary key, unique identifier for each user     |
| first_name     | VARCHAR(255) | User's first name                               |
| last_name      | VARCHAR(255) | User's last name                                |
| profile_picture| VARCHAR(255) | URL to user's profile picture                   |
| short_intro    | TEXT         | Short introduction or bio of the user            |
| email          | VARCHAR(255) | User's unique email address                      |
| password_hash  | VARCHAR(255) | Hashed password for authentication              |
| created_at     | TIMESTAMP    | Timestamp when the user was created             |
| updated_at     | TIMESTAMP    | Timestamp when the user was last updated         |

## Posts
This table stores information about posts created by users. Posts can include text, images, and videos.

### Table: `posts`
| Column        | Type         | Description                                      |
|---------------|--------------|--------------------------------------------------|
| id            | SERIAL       | Primary key, unique identifier for each post     |
| user_id       | INT          | Foreign key referencing `users(id)`              |
| content       | TEXT         | Text content of the post                         |
| image_url     | VARCHAR(255) | URL to an image attached to the post             |
| video_url     | VARCHAR(255) | URL to a video attached to the post              |
| created_at    | TIMESTAMP    | Timestamp when the post was created              |
| updated_at    | TIMESTAMP    | Timestamp when the post was last updated         |
| is_deleted    | BOOLEAN      | Flag indicating whether the post has been deleted|

## Comments
This table stores comments related to posts. Comments can also have replies (nested comments), indicated by the `parent_comment_id`.

### Table: `comments`
| Column           | Type         | Description                                      |
|------------------|--------------|--------------------------------------------------|
| id               | SERIAL       | Primary key, unique identifier for each comment  |
| post_id          | INT          | Foreign key referencing `posts(id)`              |
| user_id          | INT          | Foreign key referencing `users(id)`              |
| parent_comment_id| INT          | Foreign key referencing `comments(id)` for replies|
| comment          | TEXT         | The content of the comment                       |
| created_at       | TIMESTAMP    | Timestamp when the comment was created           |
| updated_at       | TIMESTAMP    | Timestamp when the comment was last updated      |
| is_deleted       | BOOLEAN      | Flag indicating whether the comment has been deleted|
| is_child         | BOOLEAN      | Flag indicating whether the comment is a reply   |
| total_edits      | INT          | Count of the number of edits made to the comment |

## Reactions
This table records reactions to posts and comments (like, love, etc.). A user can only react once per post or comment.

### Table: `reactions`
| Column       | Type         | Description                                      |
|--------------|--------------|--------------------------------------------------|
| id           | SERIAL       | Primary key, unique identifier for each reaction |
| user_id      | INT          | Foreign key referencing `users(id)`              |
| post_id      | INT          | Foreign key referencing `posts(id)` (nullable)   |
| comment_id   | INT          | Foreign key referencing `comments(id)` (nullable)|
| reaction_type| VARCHAR(50)  | Type of reaction (e.g., 'like', 'love')          |
| created_at   | TIMESTAMP    | Timestamp when the reaction was created          |

## Notifications
Stores notifications for users (e.g., when someone comments or likes their post).

### Table: `notifications`
| Column           | Type         | Description                                      |
|------------------|--------------|--------------------------------------------------|
| id               | SERIAL       | Primary key, unique identifier for each notification|
| user_id          | INT          | Foreign key referencing `users(id)`              |
| notification_type| VARCHAR(255) | Type of notification (e.g., 'comment', 'like')   |
| source_id        | INT          | ID of the post or comment related to the notification|
| message          | TEXT         | The notification message                         |
| is_read          | BOOLEAN      | Flag indicating whether the notification has been read|
| created_at       | TIMESTAMP    | Timestamp when the notification was created      |

## Media Files
Tracks files uploaded by users, either attached to posts or comments.

### Table: `media_files`
| Column        | Type         | Description                                      |
|---------------|--------------|--------------------------------------------------|
| id            | SERIAL       | Primary key, unique identifier for each media file|
| user_id       | INT          | Foreign key referencing `users(id)`              |
| file_url      | VARCHAR(255) | URL to the media file                            |
| file_type     | VARCHAR(50)  | Type of file (e.g., 'image', 'video')            |
| file_size     | BIGINT       | Size of the file in bytes                        |
| uploaded_at   | TIMESTAMP    | Timestamp when the file was uploaded             |
| post_id       | INT          | Foreign key referencing `posts(id)` (nullable)   |
| comment_id    | INT          | Foreign key referencing `comments(id)` (nullable)|

## Hashtags
Stores hashtags used in posts to allow for easy categorization and searching.

### Table: `hashtags`
| Column        | Type         | Description                                      |
|---------------|--------------|--------------------------------------------------|
| id            | SERIAL       | Primary key, unique identifier for each hashtag  |
| name          | VARCHAR(255) | Name of the hashtag                             |
| created_at    | TIMESTAMP    | Timestamp when the hashtag was created          |

## Post-Hashtags
Many-to-many relationship between posts and hashtags.

### Table: `post_hashtags`
| Column       | Type         | Description                                      |
|--------------|--------------|--------------------------------------------------|
| post_id      | INT          | Foreign key referencing `posts(id)`              |
| hashtag_id   | INT          | Foreign key referencing `hashtags(id)`           |
| PRIMARY KEY  | (post_id, hashtag_id) | Composite primary key for this many-to-many relationship|

## Followers
This table tracks users who follow other users.

### Table: `followers`
| Column         | Type         | Description                                      |
|----------------|--------------|--------------------------------------------------|
| id             | SERIAL       | Primary key, unique identifier for each follow   |
| follower_id    | INT          | Foreign key referencing `users(id)`              |
| following_id   | INT          | Foreign key referencing `users(id)`              |
| created_at     | TIMESTAMP    | Timestamp when the follow relationship was created|
| UNIQUE(follower_id, following_id) | Prevents duplicate follow relationships|

## Post Shares
Tracks the sharing activity of posts.

### Table: `post_shares`
| Column      | Type         | Description                                      |
|-------------|--------------|--------------------------------------------------|
| id          | SERIAL       | Primary key, unique identifier for each share    |
| user_id     | INT          | Foreign key referencing `users(id)`              |
| post_id     | INT          | Foreign key referencing `posts(id)`              |
| shared_at   | TIMESTAMP    | Timestamp when the post was shared               |

## Post Tags
Allows tagging of posts with categories or topics.

### Table: `post_tags`
| Column      | Type         | Description                                      |
|-------------|--------------|--------------------------------------------------|
| id          | SERIAL       | Primary key, unique identifier for each tag      |
| post_id     | INT          | Foreign key referencing `posts(id)`              |
| tag_name    | VARCHAR(255) | The tag name (e.g., 'technology', 'travel')      |
| created_at  | TIMESTAMP    | Timestamp when the tag was created              |

## User Preferences
Stores user-specific preferences, like notification settings.

### Table: `user_preferences`
| Column          | Type         | Description                                      |
|-----------------|--------------|--------------------------------------------------|
| id              | SERIAL       | Primary key, unique identifier for each preference|
| user_id         | INT          | Foreign key referencing `users(id)`              |
| preference_key  | VARCHAR(255) | Key for the user preference (e.g., 'email_notifications')|
| preference_value| VARCHAR(255) | Value for the user preference (e.g., 'true')     |
| created_at      | TIMESTAMP    | Timestamp when the preference was created        |
| updated_at      | TIMESTAMP    | Timestamp when the preference was last updated   |

## User Activities
Records various activities a user performs, such as creating posts, commenting, or liking a post.

### Table: `user_activities`
| Column          | Type         | Description                                      |
|-----------------|--------------|--------------------------------------------------|
| id              | SERIAL       | Primary key, unique identifier for each activity |
| user_id         | INT          | Foreign key referencing `users(id)`              |
| activity_type   | VARCHAR(255) | Type of activity (e.g., 'create_post', 'comment')|
| related_entity_id| INT         | ID of related entity (Post ID, Comment ID, etc.) |
| description     | TEXT         | Description of the activity                      |
| created_at      | TIMESTAMP    | Timestamp when the activity occurred             |
