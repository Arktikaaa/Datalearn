DROP TABLE IF EXISTS people2;
CREATE TABLE people2(
   Person VARCHAR(17) NOT NULL PRIMARY KEY
  ,Region VARCHAR(7) NOT NULL
);
INSERT INTO people2(Person,Region) VALUES ('Anna Andreadi','West');
INSERT INTO people2(Person,Region) VALUES ('Chuck Magee','East');
INSERT INTO people2(Person,Region) VALUES ('Kelly Williams','Central');
INSERT INTO people2(Person,Region) VALUES ('Cassandra Brandow','South');