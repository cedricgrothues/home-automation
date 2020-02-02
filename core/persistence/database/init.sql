CREATE TABLE IF NOT EXISTS rooms (
    id varchar(20) PRIMARY KEY,
    name text NOT NULL
);

CREATE TABLE IF NOT EXISTS devices (
    deid varchar(20) PRIMARY KEY,
    name text NOT NULL,
    type text NOT NULL,
    controller text NOT NULL,
    address text NOT NULL,
    token text,
    room_id text NOT NULL,
    FOREIGN KEY (room_id) REFERENCES rooms (id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS scenes (
   id varchar(20) PRIMARY KEY,
   name text NOT NULL,
   owner text NOT NULL
);

CREATE TABLE IF NOT EXISTS actions (
   id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
   controller text NOT NULL,
   device text NOT NULL,
   property text NOT NULL,
   value text NOT NULL,
   type text NOT NULL,
   scene_id text NOT NULL,
   FOREIGN KEY (scene_id) REFERENCES scenes (id) ON UPDATE CASCADE ON DELETE SET NULL
);
