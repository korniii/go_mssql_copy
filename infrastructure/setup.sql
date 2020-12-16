-- CREATE DATABASE test_db

-- USE test_db
-- GO
-- CREATE SCHEMA [source]
-- GO
-- CREATE SCHEMA [dest]

-- USE test_db
-- CREATE TABLE [source].testdata (
--    id int,
--    rand_string varchar(255) 
-- )

-- CREATE TABLE [dest].testdata
-- (
--     id int,
--     rand_string varchar(255)
-- )

-- INSERT INTO [source].testdata (id, rand_string)
-- VALUES (1, 'abc'), (2, 'def'), (3, 'ghi')

-- SELECT
--     *
-- FROM
--     INFORMATION_SCHEMA.TABLES
-- WHERE
--     TABLE_SCHEMA = 'source'

SELECT COLUMN_NAME, * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'testdata' AND TABLE_SCHEMA='source'