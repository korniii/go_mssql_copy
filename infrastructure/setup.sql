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


-- add 100 dummies into source tables

-- 100 dummies for customer table
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
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(11, 'Fuller', '4.70', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(12, 'Bruno', '4.45', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(13, 'Kyla', '3.35', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(14, 'Sara', '1.15', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(15, 'Nyssa', '5.66', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(16, 'Dante', '3.18', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(17, 'Honorato', '9.87', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(18, 'Fleur', '4.52', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(19, 'Noble', '4.93', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(20, 'Karyn', '6.71', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(21, 'Audra', '2.07', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(22, 'Sharon', '5.16', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(23, 'Dale', '7.00', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(24, 'Guinevere', '3.62', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(25, 'Dana', '7.35', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(26, 'Vivian', '5.75', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(27, 'Illiana', '4.93', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(28, 'Hayley', '1.86', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(29, 'Xerxes', '1.87', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(30, 'Bryar', '1.91', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(31, 'Sybil', '1.63', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(32, 'Daquan', '8.56', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(33, 'Basia', '8.39', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(34, 'Melvin', '5.85', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(35, 'Nayda', '7.02', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(36, 'Montana', '6.42', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(37, 'Glenna', '5.00', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(38, 'Shelby', '4.98', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(39, 'Rosalyn', '0.60', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(40, 'Sybill', '0.48', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(41, 'Halee', '5.69', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(42, 'Nero', '0.88', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(43, 'Linus', '8.99', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(44, 'Ulla', '1.03', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(45, 'Ima', '6.03', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(46, 'Xantha', '2.48', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(47, 'Adria', '0.85', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(48, 'Illana', '3.06', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(49, 'Jermaine', '5.36', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(50, 'Stella', '0.03', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(51, 'Hammett', '6.17', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(52, 'Ryder', '8.13', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(53, 'Tallulah', '8.95', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(54, 'Jerry', '0.58', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(55, 'Allegra', '6.36', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(56, 'Gareth', '3.27', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(57, 'Molly', '6.28', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(58, 'Summer', '6.47', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(59, 'Stella', '7.88', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(60, 'Hanae', '6.91', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(61, 'Omar', '0.04', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(62, 'Clarke', '1.77', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(63, 'Allegra', '9.28', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(64, 'Sarah', '0.62', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(65, 'Macaulay', '5.12', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(66, 'Geraldine', '6.15', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(67, 'Maia', '8.92', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(68, 'Britanney', '9.25', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(69, 'Amena', '5.18', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(70, 'Tatum', '4.63', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(71, 'Merritt', '7.67', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(72, 'Mannix', '0.71', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(73, 'Alea', '7.24', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(74, 'Simon', '9.94', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(75, 'Yuli', '0.30', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(76, 'Jamal', '0.45', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(77, 'Allen', '3.31', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(78, 'Velma', '3.70', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(79, 'James', '7.56', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(80, 'Ferris', '1.77', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(81, 'Raja', '0.39', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(82, 'Regina', '9.49', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(83, 'Melvin', '8.60', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(84, 'Cleo', '2.79', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(85, 'Josephine', '6.81', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(86, 'Lilah', '9.60', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(87, 'Burke', '4.83', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(88, 'Chester', '4.15', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(89, 'Fleur', '1.27', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(90, 'Bert', '9.86', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(91, 'Henry', '1.90', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(92, 'Kermit', '6.09', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(93, 'Carter', '0.26', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(94, 'Lane', '7.93', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(95, 'Hiram', '4.37', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(96, 'Emerald', '3.54', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(97, 'Tara', '4.21', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(98, 'William', '6.75', '1');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(99, 'Lacota', '2.44', '0');
INSERT INTO [source].customer
    ([id],[rand_string],[rand_decimal],[rand_bit])
VALUES(100, 'Martina', '7.92', '0');



-- 100 dummies for item table
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(1, 'Ignatius', '8.21', '0', 80);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(2, 'Ray', '3.81', '0', 93);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(3, 'Wallace', '1.00', '1', 44);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(4, 'Baxter', '4.71', '0', 42);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(5, 'Zenia', '5.55', '0', 96);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(6, 'Cody', '8.48', '1', 39);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(7, 'Macy', '9.64', '1', 96);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(8, 'Faith', '8.55', '1', 77);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(9, 'Connor', '6.61', '1', 58);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(10, 'Mohammad', '6.82', '1', 48);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(11, 'Deanna', '8.91', '0', 28);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(12, 'Roanna', '6.24', '0', 76);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(13, 'Claudia', '4.32', '1', 30);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(14, 'Fletcher', '6.73', '0', 91);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(15, 'Neil', '1.06', '1', 12);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(16, 'Amery', '1.60', '1', 14);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(17, 'Ciaran', '9.27', '0', 30);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(18, 'Tanek', '2.15', '1', 20);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(19, 'Yvette', '0.16', '1', 83);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(20, 'Lucas', '6.20', '0', 95);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(21, 'Gil', '0.86', '1', 73);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(22, 'Xena', '8.62', '0', 91);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(23, 'Carolyn', '7.42', '0', 58);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(24, 'Avram', '7.01', '1', 85);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(25, 'Elton', '6.07', '1', 37);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(26, 'Barclay', '7.13', '0', 28);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(27, 'Natalie', '0.34', '0', 31);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(28, 'Hadassah', '9.95', '0', 98);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(29, 'Charles', '3.02', '0', 80);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(30, 'Pamela', '1.67', '1', 67);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(31, 'Noah', '0.38', '1', 83);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(32, 'Gavin', '3.34', '1', 70);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(33, 'Cassandra', '9.28', '0', 27);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(34, 'Jasper', '5.52', '1', 12);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(35, 'May', '6.52', '1', 29);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(36, 'Dahlia', '4.52', '0', 74);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(37, 'Aaron', '3.17', '1', 69);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(38, 'Sacha', '1.39', '1', 41);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(39, 'Arsenio', '9.59', '1', 94);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(40, 'Upton', '9.78', '1', 98);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(41, 'Sybill', '3.68', '0', 4);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(42, 'Brianna', '3.50', '0', 38);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(43, 'Iola', '1.36', '0', 24);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(44, 'Kyra', '9.15', '1', 4);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(45, 'Cullen', '6.66', '0', 97);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(46, 'Octavia', '7.30', '0', 42);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(47, 'Zephr', '6.45', '0', 16);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(48, 'Sharon', '1.16', '0', 4);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(49, 'Piper', '2.88', '0', 48);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(50, 'Sheila', '0.63', '1', 11);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(51, 'Salvador', '6.77', '0', 37);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(52, 'Olga', '1.43', '0', 34);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(53, 'Aspen', '4.93', '1', 56);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(54, 'Maisie', '7.32', '1', 87);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(55, 'Joseph', '0.41', '0', 43);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(56, 'Melanie', '8.76', '1', 57);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(57, 'Jolene', '6.21', '1', 81);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(58, 'Mechelle', '4.20', '1', 44);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(59, 'Isabella', '9.47', '1', 71);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(60, 'Mollie', '6.69', '1', 1);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(61, 'Garrison', '0.78', '1', 8);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(62, 'Lionel', '8.72', '0', 11);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(63, 'Fatima', '0.72', '1', 31);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(64, 'Ezra', '8.40', '0', 23);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(65, 'Joshua', '9.17', '0', 23);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(66, 'Ivor', '5.59', '0', 97);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(67, 'Declan', '3.83', '1', 29);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(68, 'Zenia', '6.14', '1', 7);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(69, 'Amber', '1.99', '1', 60);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(70, 'Blair', '4.98', '0', 8);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(71, 'Chelsea', '1.48', '1', 80);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(72, 'Amanda', '8.53', '0', 68);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(73, 'Chester', '7.92', '1', 55);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(74, 'Barbara', '8.01', '0', 33);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(75, 'Mannix', '8.61', '0', 27);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(76, 'Rae', '9.29', '1', 57);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(77, 'Wing', '5.80', '1', 87);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(78, 'Faith', '7.17', '0', 81);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(79, 'Joshua', '9.60', '1', 3);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(80, 'Marvin', '1.47', '1', 12);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(81, 'Warren', '3.74', '0', 1);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(82, 'Oliver', '0.37', '0', 56);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(83, 'Josiah', '0.16', '1', 60);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(84, 'Amanda', '1.34', '1', 50);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(85, 'Shaeleigh', '1.59', '1', 32);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(86, 'Zenaida', '3.74', '0', 1);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(87, 'Ulric', '9.18', '0', 67);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(88, 'Alyssa', '5.04', '1', 94);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(89, 'Arsenio', '7.26', '1', 71);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(90, 'Reagan', '1.59', '0', 25);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(91, 'Buckminster', '0.58', '1', 24);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(92, 'Jarrod', '5.70', '1', 52);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(93, 'Harding', '2.88', '1', 72);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(94, 'Stephanie', '4.93', '1', 54);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(95, 'Sylvester', '4.69', '0', 40);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(96, 'Dante', '1.17', '1', 99);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(97, 'Lev', '7.36', '0', 72);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(98, 'Felix', '0.20', '0', 13);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(99, 'William', '8.68', '0', 93);
INSERT INTO [source].item
    ([id],[rand_string],[rand_decimal],[rand_bit],[customer_id])
VALUES(100, 'Hayley', '2.31', '1', 19);