-- Exported definition from 2008-06-08T23:09:37
-- Class tumpire.model.Kill
-- Database: sqlite
CREATE TABLE kill (
    id INTEGER PRIMARY KEY,
    killer_id INT CONSTRAINT killer_id_exists REFERENCES tg_user(id) ,
    victim_id INT CONSTRAINT victim_id_exists REFERENCES tg_user(id) ,
    event_id INT CONSTRAINT event_id_exists REFERENCES event(id) 
)
