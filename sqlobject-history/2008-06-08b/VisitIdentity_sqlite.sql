-- Exported definition from 2008-06-08T23:12:54
-- Class tumpire.model.VisitIdentity
-- Database: sqlite
CREATE TABLE visit_identity (
    id INTEGER PRIMARY KEY,
    visit_key VARCHAR (40) NOT NULL UNIQUE,
    user_id INT
)
