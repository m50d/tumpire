-- Exported definition from 2008-06-08T23:12:54
-- Class tumpire.model.Visit
-- Database: sqlite
CREATE TABLE visit (
    id INTEGER PRIMARY KEY,
    visit_key VARCHAR (40) NOT NULL UNIQUE,
    created TIMESTAMP,
    expiry TIMESTAMP
)
