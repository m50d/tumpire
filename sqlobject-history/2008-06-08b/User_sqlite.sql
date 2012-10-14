-- Exported definition from 2008-06-08T23:12:54
-- Class tumpire.model.User
-- Database: sqlite
CREATE TABLE tg_user (
    id INTEGER PRIMARY KEY,
    user_name VARCHAR (255) NOT NULL UNIQUE,
    email_address VARCHAR (255) NOT NULL UNIQUE,
    password VARCHAR (40),
    address VARCHAR (255),
    college VARCHAR (255),
    notes VARCHAR (255),
    water VARCHAR (255)
)
