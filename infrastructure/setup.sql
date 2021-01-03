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

CREATE TABLE [source].load
(
    id int,
    rand_string varchar(255),
    rand_decimal decimal(5,2),
    rand_bit bit,
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


CREATE TABLE [dest].load
(
    id int,
    rand_string varchar(255),
    rand_decimal decimal(5,2),
    rand_bit bit,
) 


-- add 10 dummies into source tables

-- 10 dummies for customer table
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(1, 'Harding', '9.51', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(2, 'Deacon', '7.65', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(3, 'Gage', '4.77', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(4, 'Sacha', '6.05', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(5, 'Vivian', '2.90', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(6, 'Ursa', '8.43', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(7, 'Lyle', '3.20', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(8, 'Juliet', '1.44', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(9, 'Latifah', '1.97', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(10, 'Karina', '8.57', '0');


-- 10 dummies for item table
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(1, 'Ignatius', '8.21', '0', 1);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(2, 'Ray', '3.81', '0', 2);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(3, 'Wallace', '1.00', '1', 3);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(4, 'Baxter', '4.71', '0', 4);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(5, 'Zenia', '5.55', '0', 5);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(6, 'Cody', '8.48', '1', 6);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(7, 'Macy', '9.64', '1', 7);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(8, 'Faith', '8.55', '1', 8);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(9, 'Connor', '6.61', '1', 9);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(10, 'Mohammad', '6.82', '1', 10);

DECLARE @i int = 0
WHILE @i < 1000000
BEGIN
    SET @i = @i + 1
    INSERT INTO [source].load
        ([id],[rand_string],[rand_decimal],[rand_bit])
    VALUES(100, 'Hayley', '2.31', '1'); 
END