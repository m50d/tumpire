-- Exported definition from 2008-06-08T23:09:37
-- Class tumpire.model.Pseudonym
-- Database: sqlite
CREATE TABLE pseudonym (
    id INTEGER PRIMARY KEY,
    name VARCHAR (255) NOT NULL UNIQUE,
    player_id INT CONSTRAINT player_id_exists REFERENCES tg_user(id) 
)
