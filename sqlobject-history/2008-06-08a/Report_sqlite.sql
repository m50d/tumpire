-- Exported definition from 2008-06-08T23:10:02
-- Class tumpire.model.Report
-- Database: sqlite
CREATE TABLE report (
    id INTEGER PRIMARY KEY,
    speaker_id INT CONSTRAINT speaker_id_exists REFERENCES pseudonym(id) ,
    content VARCHAR (1000),
    event_id INT CONSTRAINT event_id_exists REFERENCES event(id) 
)
