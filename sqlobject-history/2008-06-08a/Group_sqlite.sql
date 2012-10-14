-- Exported definition from 2008-06-08T23:10:02
-- Class tumpire.model.Group
-- Database: sqlite
CREATE TABLE tg_group (
    id INTEGER PRIMARY KEY,
    group_name VARCHAR (16) NOT NULL UNIQUE,
    display_name VARCHAR (255),
    created TIMESTAMP
);
CREATE TABLE user_group (
group_id INT NOT NULL,
user_id INT NOT NULL
);
CREATE TABLE group_permission (
group_id INT NOT NULL,
permission_id INT NOT NULL
)
