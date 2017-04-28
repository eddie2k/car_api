CREATE SCHEMA ally_cars AUTHORIZATION postgres;

CREATE EXTENSION postgis SCHEMA public VERSION "2.3.2";

CREATE TABLE ally_cars.cars
(
  coordinates geometry NOT NULL,
  description text NOT NULL,
  CONSTRAINT pk_coordinates PRIMARY KEY (coordinates)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ally_cars.cars
  OWNER TO postgres;

CREATE UNIQUE INDEX coordinates_idx
  ON ally_cars.cars
  USING btree
  (coordinates);
