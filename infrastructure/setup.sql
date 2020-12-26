USE master
GO

IF EXISTS (SELECT *
FROM master.dbo.sysdatabases
WHERE NAME='test_db') DROP DATABASE test_db

CREATE DATABASE test_db

USE test_db
GO
CREATE SCHEMA [source]
GO
CREATE SCHEMA [dest]
GO

USE test_db
CREATE TABLE [source].customer
(
    id int PRIMARY KEY,
    rand_string varchar(255),
    rand_decimal decimal(5,2),
    rand_bit bit
)

CREATE TABLE [source].item
(
    id int,
    rand_string varchar(255),
    rand_decimal decimal(5,2),
    rand_bit bit,
    customer_id int,
    CONSTRAINT fk_customer_id FOREIGN KEY (customer_id) REFERENCES [source].customer (id)
)

CREATE TABLE [dest].customer
(
    id int PRIMARY KEY,
    rand_string varchar(255),
    rand_decimal decimal(5,2),
    rand_bit bit
)

CREATE TABLE [dest].item
(
    id int,
    rand_string varchar(255),
    rand_decimal decimal(5,2),
    rand_bit bit,
    customer_id int,
    CONSTRAINT fk_customer_id FOREIGN KEY (customer_id) REFERENCES [dest].customer (id)
) 



-- INSERT INTO [source].testdata
--     (id, rand_string, rand_decimal, rand_bit)
-- VALUES
--     (1, 'abc', 1.0, 0),
--     (2, 'def', 2.0, 1),
--     (3, 'ghi', -3.0, 1)
-- SELECT
--     *
-- FROM
--     INFORMATION_SCHEMA.TABLES
-- WHERE
--     TABLE_SCHEMA = 'source'

-- SELECT COLUMN_NAME, * 
-- FROM INFORMATION_SCHEMA.COLUMNS
-- WHERE TABLE_NAME = 'testdata' AND TABLE_SCHEMA='source'

-- TRUNCATE TABLE dest.testdata