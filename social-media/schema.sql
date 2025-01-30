-- Below is a PostgreSQL database schema for a social media platform, 
-- which includes tables for posts, comments, reactions, and related data.

-- Table to store user information
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    profile_picture VARCHAR(255),
    short_intro TEXT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table to store social media posts
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT,
    image_url VARCHAR(255),
    video_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- Table to store comments on posts
CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    post_id INT NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    parent_comment_id INT REFERENCES comments(id) ON DELETE CASCADE,  -- For nested comments
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    is_child BOOLEAN DEFAULT FALSE,  -- Indicates if this is a reply to another comment
    total_edits INT DEFAULT 0
);

-- Table to store reactions on posts and comments
CREATE TABLE reactions (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    post_id INT REFERENCES posts(id) ON DELETE CASCADE,
    comment_id INT REFERENCES comments(id) ON DELETE CASCADE,
    reaction_type VARCHAR(50) NOT NULL,  -- e.g., 'like', 'love', 'angry', etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, post_id, comment_id)  -- Ensures user can react only once per post/comment
);

-- Table to store notifications for users (e.g., likes, comments, replies, etc.)
CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    notification_type VARCHAR(255) NOT NULL,  -- e.g., 'comment', 'like', 'mention'
    source_id INT NOT NULL,  -- Can be post_id or comment_id, based on notification type
    message TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table to store media files (images, videos, etc.) uploaded with posts or comments
CREATE TABLE media_files (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    file_url VARCHAR(255) NOT NULL,
    file_type VARCHAR(50),  -- e.g., 'image', 'video', 'audio'
    file_size BIGINT,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    post_id INT REFERENCES posts(id) ON DELETE CASCADE,
    comment_id INT REFERENCES comments(id) ON DELETE CASCADE
);

-- Table to store hashtags used in posts
CREATE TABLE hashtags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table to store post_hashtag relationships (many-to-many)
CREATE TABLE post_hashtags (
    post_id INT NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    hashtag_id INT NOT NULL REFERENCES hashtags(id) ON DELETE CASCADE,
    PRIMARY KEY (post_id, hashtag_id)
);

-- Table to store users following other users
CREATE TABLE followers (
    id SERIAL PRIMARY KEY,
    follower_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    following_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (follower_id, following_id)
);

-- Table to track the posts shared by users
CREATE TABLE post_shares (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    post_id INT NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    shared_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table to track the tags associated with posts (e.g., topic, category, etc.)
CREATE TABLE post_tags (
    id SERIAL PRIMARY KEY,
    post_id INT NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    tag_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table to store user preferences (e.g., notification settings)
CREATE TABLE user_preferences (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    preference_key VARCHAR(255) NOT NULL,  -- e.g., 'email_notifications', 'privacy_settings'
    preference_value VARCHAR(255) NOT NULL,  -- e.g., 'true', 'false'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for tracking user's activities (like post creation, comment, etc.)
CREATE TABLE user_activities (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    activity_type VARCHAR(255) NOT NULL,  -- e.g., 'create_post', 'comment', 'like_post'
    related_entity_id INT,  -- Post ID, Comment ID, etc.
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
