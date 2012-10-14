-- Exported definition from 2008-06-08T23:10:02
-- Class tumpire.model.Permission
-- Database: sqlite
CREATE TABLE permission (
    id INTEGER PRIMARY KEY,
    permission_name VARCHAR (16) NOT NULL UNIQUE,
    description VARCHAR (255)
)
