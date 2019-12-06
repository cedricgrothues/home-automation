CREATE TABLE IF NOT EXISTS rooms (
    id varchar(20) PRIMARY KEY,
    name text NOT NULL
                                 );

CREATE TABLE IF NOT EXISTS devices (
    id varchar(20) PRIMARY KEY,
    name text NOT NULL,
    type text NOT NULL,
    controller text NOT NULL,
    address text NOT NULL,
    room_id text NOT NULL,
    FOREIGN KEY (room_id) REFERENCES rooms (id) ON UPDATE CASCADE ON DELETE SET NULL
                                   );