.open dreamhome_v2.db
.mode box

DROP TABLE IF EXISTS Branch;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS Client;
DROP TABLE IF EXISTS PrivateOwner;
DROP TABLE IF EXISTS PropertyForRent;
DROP TABLE IF EXISTS Viewing;
DROP TABLE IF EXISTS Registration;

PRAGMA foreign_keys = ON;

CREATE TABLE Branch(
    branchNo CHAR(4) NOT NULL CHECK(LENGTH(branchNo) = 4) PRIMARY KEY,
    street VARCHAR(20) NOT NULL CHECK(LENGTH(street) > 0),
    city VARCHAR(15) NOT NULL CHECK(LENGTH(city) > 0),
    postcode VARCHAR(10) NOT NULL
);

-- –Branch Table Inserts:
INSERT INTO Branch VALUES
('B005', '22 Deer Rd', 'London', 'SW1 4EH'),
('B003', '163 Main St', 'Glasgow', 'G11 9QX'),
('B004', '32 Manse Rd', 'Bristol', 'BS99 1NZ'),
('B002', '56 Clover Dr', 'London', 'NW10 6EU');


CREATE TABLE Staff(
    staffNo VARCHAR(4) NOT NULL CHECK(LENGTH(staffNo) >= 3) PRIMARY KEY,
    fname VARCHAR(20) NOT NULL CHECK(LENGTH(fname) > 0),
    lname VARCHAR(20) NOT NULL CHECK(LENGTH(lname) > 0),
    position VARCHAR(15) NOT NULL CHECK(position IN ('Manager','Assistant','Supervisor')),
    sex CHAR(1) NOT NULL CHECK(sex IN ('M','F')),
    DOB TEXT NOT NULL,
    salary INTEGER NOT NULL CHECK(salary > 0),
    branchNo CHAR(4) NOT NULL,
    FOREIGN KEY (branchNo) REFERENCES Branch(branchNo)
);

-- –Staff Table Inserts:
INSERT INTO Staff VALUES
('SL21', 'John', 'White', 'Manager', 'M', '1965-10-01', 30000, 'B005'),
('SG37', 'Ann', 'Beech', 'Assistant', 'F', '1980-11-10', 12000, 'B003'),
('SG14', 'David', 'Ford', 'Supervisor', 'M', '1978-03-24', 18000, 'B003'),
('SA9', 'Mary', 'Howe', 'Assistant', 'F', '1990-02-19', 9000, 'B002'),
('SG5', 'Susan', 'Brand', 'Manager', 'F', '1960-06-03', 24000, 'B003'),
('SL41', 'Julie', 'Lee', 'Assistant', 'F', '1963-06-05', 9000, 'B005');

CREATE TABLE Client(
    clientNo CHAR(4) NOT NULL CHECK(LENGTH(clientNo) = 4) PRIMARY KEY,
    fname VARCHAR(20) NOT NULL CHECK(LENGTH(fname) > 0),
    lname VARCHAR(20) NOT NULL CHECK(LENGTH(lname) > 0),
    telNo VARCHAR(15) NOT NULL,
    prefType VARCHAR(10) NOT NULL CHECK(prefType IN ('Flat','House')),
    maxRent INTEGER NOT NULL CHECK (maxRent > 0),
    email VARCHAR(30) NOT NULL CHECK(LENGTH(email) > 0)
);
-- –Client Table Inserts:
INSERT INTO Client VALUES
('CR76', 'John', 'Kay', '0207-774-5632', 'Flat', 425, 'j.kay@gmail.com'),
('CR56', 'Aline', 'Stewart', '0141-848-1825', 'Flat', 350, 'a.stewart@yahoo.co.uk'),
('CR74', 'Mike', 'Ritchie', '01475-983179', 'House', 750, 'mritchie01@hotmail.com'),
('CR62', 'Mary', 'Tregear', '01224-196720', 'Flat', 600, 'm.tregear@hotmail.co.uk');

CREATE TABLE PrivateOwner(
    ownerNo CHAR(4) NOT NULL CHECK(LENGTH(ownerNo) = 4) PRIMARY KEY,
    fname VARCHAR(20) NOT NULL CHECK(LENGTH(fname) > 0),
    lname VARCHAR(20) NOT NULL CHECK(LENGTH(lname) > 0),
    address VARCHAR(30) NOT NULL CHECK(LENGTH(address) > 0),
    telNo VARCHAR(30) NOT NULL,
    email VARCHAR(30) NOT NULL,
    password VARCHAR(30) NOT NULL CHECK(LENGTH(password) >= 8)  -- password should be at least 8 characters to maintain account security
);
-- –PrivateOwner Table Inserts:
INSERT INTO PrivateOwner VALUES
('CO46', 'Joe', 'Keogh', '2 Fergus Dr, Aberdeen AB2 7SX', '01224-861212', 'j.keogh@gmail.com', '********'),
('CO87', 'Carol', 'Farrell', '6 Achray St, Glasgow G32 9DX', '0141-357-7419', 'c.farrell@hotmail.com', '********'),
('CO40', 'Tina', 'Murphy', '63 Well St, Glasgow G42 9FX', '0141-943-1728', 't.murphy@hotmail.com', '********'),
('CO93', 'Tony', 'Shaw', '12 Park Pl, Glasgow G4 6FF', '0141-225-7025', 't.shaw@hotmail.com', '********');

CREATE TABLE PropertyForRent(
    propertyNo CHAR(4) NOT NULL CHECK(LENGTH(propertyNo) >= 3) PRIMARY KEY,
    street VARCHAR(20) NOT NULL CHECK(LENGTH(street) > 0),
    city VARCHAR(15) NOT NULL CHECK(LENGTH(city) > 0),
    postcode VARCHAR(10) NOT NULL,
    type VARCHAR(20) NOT NULL CHECK(type IN ('Flat','House')),
    rooms INTEGER NOT NULL CHECK(rooms > 0),
    rent INTEGER NOT NULL CHECK(rent > 0),
    ownerNo CHAR(4) NOT NULL CHECK(LENGTH(ownerNo) = 4),
    staffNo VARCHAR(4) NOT NULL CHECK(LENGTH(staffNo) >= 3),
    branchNo CHAR(4) NOT NULL CHECK(LENGTH(branchNo) = 4),
    FOREIGN KEY (ownerNo) REFERENCES PrivateOwner(ownerNo),
    FOREIGN KEY (staffNo) REFERENCES Staff(staffNo),
    FOREIGN KEY (branchNo) REFERENCES Branch(branchNo)
);
-- –PropertyForRent Table Inserts:
INSERT INTO PropertyForRent VALUES
('PA14', '16 Holhead', 'Aberdeen', 'AB7 5SQ', 'House', 6, 650, 'CO46', 'SA9', 'B005'),
('PL94', '6 Argyll St', 'London', 'NW2', 'Flat', 4, 400, 'CO87', 'SL41', 'B005'),
('PG4', '6 Lawrence St', 'Glasgow', 'G11 9QX', 'Flat', 3, 350, 'CO40', 'SG14', 'B003'),
('PG36', '2 Manor Rd', 'Glasgow', 'G32 4QX', 'Flat', 3, 375, 'CO93', 'SG37', 'B003'),
('PG21', '18 Dale Rd', 'Glasgow', 'G12', 'House', 5, 600, 'CO87', 'SG37', 'B003'),
('PG16', '5 Novar Dr', 'Glasgow', 'G12 9AX', 'Flat', 4, 450, 'CO93', 'SG14', 'B003');

CREATE TABLE Viewing(
    viewingNo CHAR(4) NOT NULL CHECK(LENGTH(viewingNo) = 4) PRIMARY KEY,
    clientNo CHAR(4) NOT NULL CHECK(LENGTH(clientNo) = 4),
    propertyNo CHAR(4) NOT NULL CHECK(LENGTH(propertyNo) >= 3),
    viewDate TEXT,
    comment TEXT,
    FOREIGN KEY (propertyNo) REFERENCES PropertyForRent(propertyNo),
    FOREIGN KEY (clientNo) REFERENCES Client(clientNo)
);
-- –Viewing Table Inserts:
INSERT INTO Viewing VALUES
('0001', 'CR76', 'PA14', '2025-05-24', 'too small'),
('0002', 'CR56', 'PG4', '2025-08-20', 'too remote'),
('0003', 'CR74', 'PG36', '2025-04-14', NULL),
('0004', 'CR62', 'PG16', '2025-05-26', 'no eating room'),
('0005', 'CR56', 'PA14', '2025-05-14', NULL);


CREATE TABLE Registration(
    clientNo CHAR(4) NOT NULL CHECK(LENGTH(clientNo) = 4) PRIMARY KEY,
    branchNo CHAR(4) NOT NULL CHECK(LENGTH(clientNo) = 4),
    staffNo VARCHAR(4) NOT NULL CHECK(LENGTH(clientNo) >= 3),
    dateJoined TEXT
);
-- –Registration Table Inserts:
INSERT INTO Registration VALUES
('CR76', 'B005', 'SL41', '2025-11-12'),
('CR56', 'B003', 'SG37', '2025-04-20'),
('CR74', 'B003', 'SG14', '2025-10-16'),
('CR62', 'B005', 'SA9', '2025-03-07');