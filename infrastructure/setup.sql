-- CREATE DATABASE test_db

-- USE test_db
-- GO
-- CREATE SCHEMA [source]
-- GO
-- CREATE SCHEMA [dest]

-- USE test_db
-- DROP TABLE [source].testdata
-- DROP TABLE [dest].testdata

-- USE test_db
-- CREATE TABLE [source].testdata (
--    id int,
--    rand_string varchar(255),
--    rand_decimal decimal(5,2),
--    rand_bit bit
-- )

-- CREATE TABLE [dest].testdata
-- (
--     id int,
--     rand_string varchar(255),
--     rand_decimal decimal(5,2),
--     rand_bit bit
-- )

INSERT INTO [source].testdata (id, rand_string, rand_decimal, rand_bit)
VALUES (1, 'abc', 1.0, 0), (2, 'def', 2.0, 1), (3, 'ghi', -3.0, 1)
-- SELECT
--     *
-- FROM
--     INFORMATION_SCHEMA.TABLES
-- WHERE
--     TABLE_SCHEMA = 'source'

-- SELECT COLUMN_NAME, * 
-- FROM INFORMATION_SCHEMA.COLUMNS
-- WHERE TABLE_NAME = 'testdata' AND TABLE_SCHEMA='source'

TRUNCATE TABLE dest.testdata