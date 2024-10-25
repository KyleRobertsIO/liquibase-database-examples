--liquibase formatted sql

--changeset database.admin:1 labels:1.0.0 context:dev,uat,prod
--comment: Initialize the base schemas.
CREATE SCHEMA dataset;

CREATE TABLE dataset.users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--changeset database.admin:2 labels:1.0.0 context:dev
--comment: Insert fake data for development.
INSERT INTO dataset.users (username, email) VALUES
('john_doe', 'john_doe@example.com'),
('jane_smith', 'jane_smith@example.com'),
('michael_jordan', 'michael_jordan@example.com'),
('alice_wonder', 'alice_wonder@example.com'),
('charlie_brown', 'charlie_brown@example.com');