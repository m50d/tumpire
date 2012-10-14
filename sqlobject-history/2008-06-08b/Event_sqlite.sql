-- Exported definition from 2008-06-08T23:12:54
-- Class tumpire.model.Event
-- Database: sqlite
CREATE TABLE event (
    id INTEGER PRIMARY KEY,
    headline VARCHAR (255),
    datetime TIMESTAMP
);
CREATE TABLE event_pseudonym (
event INT NOT NULL,
events INT NOT NULL
)
