/****** Object: Creates Database Healthcare center with 18 Tables
Author: PARESH GUPTA
SUID: 819935376
Email: pgupta06@syr.edu
  ******/

USE master
GO

/****** Object:  Database Healthcare center  ******/
IF DB_ID('HealthcareCenter') IS NOT NULL
	DROP DATABASE HealthcareCenter
GO

CREATE DATABASE HealthcareCenter
GO 

USE HealthcareCenter
GO


/****** Object:  Table Addresses ******/
CREATE TABLE Addresses(
AddressID int NOT NULL PRIMARY KEY,
StreetNumber int NULL,
Apartment nvarchar(50) NULL,
City nvarchar(50) NULL,
State nvarchar(50) NULL,
ZIPCode nvarchar(20) NULL
)

/****** Object:  Table Departments ******/
CREATE TABLE Departments(
DepartmentID int NOT NULL PRIMARY KEY,
Name varchar(50) NULL,
Location int NULL
)

/****** Object:  Table Insurance ******/
CREATE TABLE Insurance(
InsuranceNumber varchar(50) NOT NULL PRIMARY KEY,
Company varchar(100) NOT NULL,
Coverage decimal(5,2) NOT NULL
)

/****** Object:  Table Medicines ******/
CREATE TABLE Medicines(
MedicineID int NOT NULL PRIMARY KEY,
Name varchar(50) NULL,
Description varchar(100) NULL,
QuantityInStock int NOT NULL,
PricePerUnit money NOT NULL CHECK (PricePerUnit > 0)
)

/****** Object:  Table Doctors ******/
CREATE TABLE Doctors(
   DoctorID int NOT NULL PRIMARY KEY IDENTITY(1,1),
   FirstName varchar(50) NOT NULL,
   LastName varchar(50) NULL,
   ContactNumber nchar(14) NOT NULL UNIQUE,
   Email nvarchar(100) UNIQUE,
   SSN nchar(11) NOT NULL UNIQUE,
   AddressID int NOT NULL, 
   DepartmentID int NOT NULL

   FOREIGN KEY(AddressID) REFERENCES Addresses(AddressID),
   FOREIGN KEY(DepartmentID) REFERENCES Departments(DepartmentID)
   )

/****** Object:  Table Patients ******/
CREATE TABLE Patients(
  PatientID int NOT NULL PRIMARY KEY IDENTITY(1,1),
  FirstName varchar(50) NOT NULL,
  LastName varchar(50) NULL,
  Age int NULL,
  ContactNumber nchar(14) NOT NULL UNIQUE,
  Email varchar(100) NULL UNIQUE,
  SSN nchar(11) NOT NULL UNIQUE,
  InsuranceNumber varchar(50) UNIQUE NULL,
  AddressID int NOT NULL
  
  FOREIGN KEY(InsuranceNumber) REFERENCES Insurance(InsuranceNumber),
  FOREIGN KEY(AddressID) REFERENCES Addresses(AddressID)
  )


/****** Object:  Table Prescription ******/
CREATE TABLE Prescription(
  PrescriptionID int NOT NULL PRIMARY KEY,
  PatientID int NOT NULL,
  DoctorID int NOT NULL,
  
  FOREIGN KEY(PatientID) REFERENCES Patients(PatientID),
  FOREIGN KEY(DoctorID) REFERENCES Doctors(DoctorID)
  )

/****** Object:  Table PrescriptionItem ******/
  CREATE TABLE PrescriptionItem(
  PrescriptionID int NOT NULL,
  MedicineID int NOT NULL,
  Instruction varchar(100) NULL,

  PRIMARY KEY(PrescriptionID, MedicineID),
  FOREIGN KEY(PrescriptionID) REFERENCES Prescription(PrescriptionID),
  FOREIGN KEY(MedicineID) REFERENCES Medicines(MedicineID)
  )

/****** Object:  Table Patients Medical History ******/
CREATE TABLE PatientMedicalHistory(
 MedicalHistoryID int NOT NULL PRIMARY KEY,
 PatientID int NOT NULL,
 Diagnosis varchar(100) NULL,
 DoctorID int NOT NULL,
 
 FOREIGN KEY(PatientID) REFERENCES Patients(PatientID),
 FOREIGN KEY(DoctorID) REFERENCES Doctors(DoctorID)
 )

/****** Object:  Table Visitors ******/
CREATE TABLE Visitors(
 VisitorID int NOT NULL PRIMARY KEY,
 FirstName varchar(50) NOT NULL,
 LastName varchar(50) NULL,
 Relation varchar(50) NULL,
 PatientID int NOT NULL,
 ContactNumber nchar(14) NOT NULL UNIQUE,

 FOREIGN KEY(PatientID) REFERENCES Patients(PatientID)
 )


/****** Object:  Table DoctorJobDetails ******/
CREATE TABLE DoctorJobDetails(
DoctorID int NOT NULL PRIMARY KEY,
Specialization varchar(100) NULL,
Salary money NOT NULL CHECK (Salary > 0)

FOREIGN KEY(DoctorID) REFERENCES Doctors(DoctorID)
)

/****** Object:  Table GeneralEmployees ******/
CREATE TABLE GeneralEmployees(
EmployeeID int NOT NULL PRIMARY KEY IDENTITY(1,1),
FirstName varchar(50) NOT NULL,
LastName varchar(50) NULL,
ContactNumber nchar(14) NOT NULL UNIQUE,
Email varchar(100) NULL UNIQUE,
SSN nchar(11) NOT NULL UNIQUE,
AddressID int NOT NULL,
DepartmentID int NOT NULL,

FOREIGN KEY(AddressID) REFERENCES Addresses(AddressID),
FOREIGN KEY(DepartmentID) REFERENCES Departments(DepartmentID)
)

/****** Object:  Table EmployeeJobDetails ******/
CREATE TABLE EmployeeJobDetails(
EmployeeID int NOT NULL PRIMARY KEY,
Description varchar(100) NULL,
Status varchar(15) NULL,
Salary money NOT NULL CHECK (Salary > 0)

FOREIGN KEY(EmployeeID) REFERENCES GeneralEmployees(EmployeeID)
)

/****** Object:  Table RoomRate ******/
CREATE TABLE RoomRate(
RoomID int NOT NULL PRIMARY KEY,
RoomType varchar(50) NOT NULL,
Charge money NOT NULL CHECK (Charge > 0)
)

/****** Object:  Table TestRates ******/
CREATE TABLE TestRate(
TestID int NOT NULL PRIMARY KEY,
Description varchar(50) NOT NULL,
Charge money NOT NULL CHECK (Charge > 0)
)

/****** Object:  Table Billing ******/
CREATE TABLE Billing(
BillID int NOT NULL PRIMARY KEY,
RoomID int NULL,
InsuranceNumber varchar(50) NULL,

FOREIGN KEY(RoomID) REFERENCES RoomRate(RoomID),
FOREIGN KEY(InsuranceNumber) REFERENCES Insurance(InsuranceNumber),
)

GO

/****** Object:  Table MedicinesPurchased ******/
CREATE TABLE MedicinesPurchased(
MedicineID int NOT NULL,
BillID int NOT NULL,

PRIMARY KEY(MedicineID,BillID),
FOREIGN KEY(MedicineID) REFERENCES Medicines(MedicineID),
FOREIGN KEY(BillID) REFERENCES Billing(BillID)
)
GO 
/****** Object:  Table TestsTaken ******/
CREATE TABLE TestsTaken(
TestID int NOT NULL,
BillID int NOT NULL,

PRIMARY KEY(TestID, BillID),
FOREIGN KEY(TestID) REFERENCES TestRate(TestID),
FOREIGN KEY(BillID) REFERENCES Billing(BillID)
)
GO

INSERT Addresses(AddressID, StreetNumber, Apartment, City, State, ZIPCode) VALUES
(1,312,'Mission Blvd.','Union City','CA','51627'),
(2,308,'Greenwood Place','Syracuse','NY','13210'),
(3,124,'Lancaster Avenue','Charlotte','NC','62514'),
(4,546,'Dell St.','Miami','FL','72621'),
(5,765,'E. Fayette','Buffalo','NY','82626'),
(6,245,'Clarendon St.','Rochester','NY','72625'),
(7,745,'Paseo Padre','Binghamton','NY','72536'),
(8,890,'Barbara St.','Ithaca','NY','72525'),
(9,368,'Ostrom Avenue','Syracuse','NY','72522'),
(10,142,'Comstock Avenue','Syracuse','NY','90847'),
(11,345, 'Winchell Pl', 'Anderson','IN','86383'),
(12,87, 'Polk St. Suite 5', 'San Francisco','CA','13254'),
(13,2299, 'E Baylor Dr', 'Syracuse','NY','92028'),
(14,722, 'DaVinci Blvd.','Ithaca','NY','91716'),
(15,12, 'Orchestra Terrace','New York City','NY','81615'),
(16,2299,'E Baylor Dr', 'Dallas','TX','75224'),
(17,305,'14th Ave. S. Suite 3B', 'Seattle','WA','98128'),
(18,89,'Chiaroscuro Rd.', 'Portland','OR','97219'),
(19,2743, 'Bering St.', 'Anchorage','AK','99508'),
(20,2817 ,'Milton Dr.', 'Albuquerque','NM','87110'),
(21,55, 'Grizzly Peak Rd.', 'Butte','MT','59801'),
(22,89, 'Jefferson Way Suite 2', 'Providence','RI','02909'),
(23,187, 'Suffolk Ln.', 'Boise', 'ID','83720'),
(24,281, 'Milton Pl.', 'Albuquerque', 'NY','62580'),
(25,23, 'Beeling Rd.', 'Portland', 'OR','97508'),
(26,8429, 'Chiaroscuro Pl.', 'Albuquerque', 'NM','87110'),
(27,91, 'Polk St. Suite 5', 'Austin', 'TX','75251'),
(28,1245, 'Orchestra Avenue', 'Syracuse', 'NY','13210'),
(29,2732, 'Baker Blvd.', 'Eugene', 'OR','97403'),
(30,717, 'E Michigan Ave', 'Chicago', 'IL','60611'),
(31,1877, 'Ete Ct', 'Frogtown', 'LA','70563'),
(32,1234, 'Main St', 'Normal', 'IL','61761')
GO

INSERT Departments(DepartmentID,Name,Location) VALUES
(1,'Public Health',312),
(2,'Emergency',121),
(3,'Pharmacy',151),
(4,'E.N.T. Clinic',221),
(5,'Intensive Care Unit',234),
(6,'Orthopedic',356),
(7,'Cardiology',282),
(8,'Dentistry',333),
(9,'Dermatology',514),
(10,'Oncology',415),
(11,'Pathology',512),
(12,'Respiratory',366)

GO

INSERT Insurance(InsuranceNumber,Company,Coverage) VALUES
('QQ123456C','Aetna',90),
('AB234567A','Anthem Blue Cross',95),
('BG098764D','Humana',80),
('GH889072S','IHC Group',85),
('FG562873M','Cigna',95),
('BH141672W','Aetna',90),
('II615167F','IHC Group',95),
('KH927168V','Humana',95),
('LJ716816C','Humana',80),
('DR239798W','UnitedHealthCare',90),
('DR281918K','UnitedHealthCare',90)
GO

INSERT Medicines(MedicineID,Name,Description,QuantityInStock,PricePerUnit) VALUES
(23,'Allegra','Allergy',100,20),
(13,'Ibuprofen','Pain Killer',200,15),
(45,'Paracetamol','Pain Killer',200,13),
(10,'Amoxcillin','AntiBiotic',300,16),
(50,'Cetrizine','Cold and Fever',250,20),
(15,'Azelaic Acid','Acne',150,25),
(14,'Cromolyn','Allergy',100,23),
(25,'Folic Acid','Anemia',314,21.3),
(11,'Tetracyclines','Asthma',200,45.2),
(91,'Anesthetics','Burns',651,32.1)
GO

INSERT Doctors(FirstName,LastName,ContactNumber,Email,SSN,AddressID,DepartmentID) VALUES
('Alex','Hales','(358) 123-7679','ahales@yahoo.com','444-56-2341',3,1),
('Brian','Charles','(234) 567-9191','brian@gmail.com','345-67-1234',2,4),
('Pattrick','Brown','(651) 567-7919','patrick23@hotmail.com','234-56-7890',4,2),
('Henry','Blanc','(456) 786-8180','blanc34@hotmail.com','908-67-2768',5,6),
('James','Watson','(358) 678-7170','jwatson@yahoo.com','356-66-8976',1,4),
('Moreno', 'Antonio','(312) 555-9441','mant@gmail.com','127-38-2778',17,7),
('Hardy', 'Thomas','(360) 555-2680','h.thomos@gmail.com','244-86-0987',19,8),
('Citeaux', 'Fred', '(503) 555-7555','fred@gmail.com','291-78-6959',18,12),
('Lincoln', 'Elizabeth','(503) 555-9573','eli34@hotmail.com','817-83-2972',20,11),
('Yorres', 'Jaime','(208) 555-8097','jaime33@yahoo.com','919-00-8281',16,9),
('Phillips', 'Rene','(351) 555-1219','rene43@hotmail.com','837-90-0101',21,2)
GO

INSERT Patients(FirstName,LastName,Age,ContactNumber,Email,SSN,InsuranceNumber,AddressID) VALUES
('Sabrina','Watson',25,'(234) 345-9780','sw34@hotmail.com','234-67-8790','BG098764D',6),
('John', 'Wheeler',31,'(345) 234-7189','john45@gmail.com','453-87-8765','AB234567A',8),
('Mandy','Greene',27,'(518) 768-7898','mgreene34@gmail.com','765-88-9978','FG562873M',7),
('Monica','Wheeler',65,'(615) 786-9851','mwheeler@hotmail.com','888-99-7615','QQ123456C',10),
('Sabrina','Wayne', 73,'(514) 456-8134','sabrina21@yahoo.com','564-00-8515','GH889072S',9),
('Pavarotti','Jose',35,'(469) 555-8828','jose@hotmail.com','171-81-8173','BH141672W',22),
('Braunschweiger','Art',35,'(206) 555-4112','art3@hotmail.com','872-63-7282','II615167F',24),
('Wong','Liu',62,'(351) 555-1219','liu83@gmail.com','563-28-6238','LJ716816C',23),
('Nagy','Helvetius',67,'(469) 565-8228','ngy62@gmail.com','559-71-9719','DR239798W',27),
('Jablonski','Karl',34,'(907) 555-7584','karl91@gmail.com','543-98-7191','DR281918K',25),
('Chelan','Donna',73,'(907) 555-7614','donna81@hotmail.com','815-43-9383','KH927168V',26)
GO

INSERT Prescription(PrescriptionID, PatientID, DoctorID) VALUES 
(1,2,3),
(2,3,4),
(3,4,5),
(4,5,1),
(5,1,2),
(6,6,10),
(7,11,11),
(8,7,1),
(9,10,2),
(10,8,6),
(11,9,9)
GO

INSERT PrescriptionItem(PrescriptionID,MedicineID,Instruction) VALUES
(1,45,'2 Days Rest'),
(2,50,'Drink Fluids'),
(3,10,'5 Days Rest'),
(4,13,'Take Rest'),
(5,23,'Avoid outside exposure'),
(6,91,NULL),
(7,11,NULL),
(8,45,'3 days Rest'),
(9,23,NULL),
(10,15,'Wash face regularly'),
(11,23,'Avoid outside exposure')
GO

INSERT PatientMedicalHistory(MedicalHistoryID,PatientID,Diagnosis,DoctorID) VALUES
(1,3,'High Fever',1),
(2,4,'Ankle sprain',4),
(3,5,'Flu',1),
(4,1,'High Fever',1),
(5,3,'Back pain',4),
(6,6,'Acne',10),
(7,2,'Neck Problems',4),
(8,8,'Chest Pain',6),
(9,7,'Swollen gums',7),
(10,4,'Asthma',8),
(11,9,'Airthritis',4)
GO

INSERT Visitors(VisitorID,FirstName,LastName,Relation,PatientID,ContactNumber) VALUES
(24,'Mayank','Garg','Brother',1,'(345) 908-1535'),
(67,'Fanny','Sam','Sister',2,'(800) 555-1205'),
(25,'Barack','Trump','Uncle',3,'(301) 555-8950'),
(45,'Bill','Sawyer','Father',4,'(800) 555-8725'),
(76,'Jimmy','Larry','Aunt',5,'(559) 555-9586'),
(23,'Kelly','Watson','Friend',11,'(469) 555-8828'),
(11,'Jason','Ponting','Friend',9,'(206) 555-4112'),
(20,'Mary','Martin','Friend',10,'(216) 555-4112')
GO

INSERT DoctorJobDetails(DoctorID,Specialization,Salary) VALUES
(1,'Public Health',150000),
(2,'E.N.T.',175000),
(3,'General Medicine',180000),
(4,'Pain Management',154000),
(5,'Orthopedic',200000),
(6,'Cardiology',175000),
(7,'Dentist',153000),
(8,'Respiratory',105000),
(9,'Pathology',195000),
(10,'Dermatology',193000),
(11,'General Medicine',175000)
GO

INSERT GeneralEmployees(FirstName,LastName,ContactNumber,Email,SSN,AddressID,DepartmentID) VALUES
('Maria','Anders','(765) 550-7888','manders06@yahoo.com','345-00-9819',13,1),
('Hanna','Moos','(243) 655-8312','hanna23@gmail.com','234-87-9171',14,2),
('John','Steel','(310) 595-2139','jsteel@hotmail.com','274-84-8271',12,3),
('Fran','Wilson','(503) 555-7555','coolfran@yahoo.com','827-82-8181',11,4),
('Paula','Wilson','(415) 555-5938','wilsonpaula@gmail.com','818-92-8171',15,5),
('Smith','Cindy','(319) 555-1139','cindy12@gmail.com','932-92-9222',28,6),
('Jones','Elmer','(478) 555-1139 ','elmer9@hotmail.com','981-27-3921',32,7),
('Hernandez','Olivia','(253) 555-8332','olivia91@hotmail.com','232-38-2291',29,8),
('Aaronsen','Robert','(510) 555-7733','robert61@hotmail.com','189-71-9719',31,9),
('OLeary','Rhea','(765) 555-7878','rhea01@hotmail.com','189-71-9339',30,10)
GO

INSERT EmployeeJobDetails(EmployeeID,Description,Status,Salary) VALUES
(1,'Receptionist','Temporary',40000),
(2,'Nurse','Permanent',60000),
(3,'Runner','Temporary',30000),
(4,'Nurse','Permanent',65000),
(5,'Nurse','Permanent',70000),
(6,'Nurse','Temporary',63000),
(7,'Nurse','Permanent',72000),
(8,'IT Consultant','Permanent',65000),
(9,'Receptionist','Permanent',72000),
(10,'Runner','Temporary',60000)
GO

INSERT RoomRate(RoomID,RoomType,Charge) VALUES
(234,'Luxury',9000),
(456,'Basic',3000),
(245,'Semi-Private',5000),
(345,'Private',7000)
GO

INSERT TestRate(TestID,Description,Charge) VALUES
(9878,'X-ray',3000),
(6736,'MRI',5000),
(7337,'Blood Test',2000),
(7272,'Lipid Profile',900)
GO

INSERT Billing(BillID,RoomID,InsuranceNumber) VALUES
(2432,345,'FG562873M'),
(8287,234,'AB234567A'),
(9282,234,'FG562873M'),
(8772,456,'GH889072S'),
(8272,245,'BG098764D')
GO

INSERT MedicinesPurchased(MedicineID,BillID) VALUES
(10,8272),
(23,8772),
(14,8772),
(50,9282),
(13,9282),
(45,9282),
(13,8287),
(11,8287),
(45,2432),
(23,2432),
(13,2432),
(91,2432),
(25,2432)
GO

INSERT TestsTaken(BillID,TestID) VALUES
(2432,9878),
(2432,6736),
(8287,7337),
(9282,7337),
(9282,7272),
(8772,6736),
(8272,9878)
GO

/****** Object:  Index IX_DoctorID ******/
CREATE NONCLUSTERED INDEX IX_DoctorID
ON DoctorJobDetails(DoctorID ASC)
GO

/****** Object:  Index IX_DocAddressID ******/
CREATE NONCLUSTERED INDEX IX_DocAddressID
ON Doctors(AddressID ASC)
GO

/****** Object:  Index IX_GEAddressID******/
CREATE NONCLUSTERED INDEX IX_GEAddressID
ON GeneralEmployees(AddressID ASC)
GO

/****** Object:  Index IX_PatientID ******/
CREATE NONCLUSTERED INDEX IX_PatientID
ON Visitors(PatientID ASC)
GO

/****** Object:  Index IX_RoomID ******/
CREATE NONCLUSTERED INDEX IX_RoomID
ON Billing(RoomID ASC)
GO

/****** Object:  Index IX_InsuranceNumber ******/
CREATE NONCLUSTERED INDEX IX_InsuranceNumber
ON Billing(InsuranceNumber ASC)
GO

/****** Object:  Index IX_Doctors_DepartmentID ******/
CREATE NONCLUSTERED INDEX IX_Doctors_DepartmentID
ON Doctors(DepartmentID ASC)
GO

/****** Object:  Index IX_Employees_DepartmentID ******/
CREATE NONCLUSTERED INDEX IX_Employees_DepartmentID
ON GeneralEmployees(DepartmentID ASC)
GO

/****** Object:  Creating a view to restrict access to salary information of doctors ******/
CREATE VIEW DocJobDetails
AS
SELECT DoctorID,Specialization 
FROM DoctorJobDetails
GO

/****** Object:  Creating a view to restrict access to salary information of GeneralEmployees ******/
CREATE VIEW GeneralEmployeeJobDetails
AS 
SELECT EmployeeID,Description,Status
FROM EmployeeJobDetails
GO

/****** Object:  Creating a view to show patient details along with their medical history ******/
CREATE VIEW PatientHistory
AS
SELECT p.FirstName, p.LastName, Age, Diagnosis,  d.Firstname + '' + d.LastName AS AttendedByDoctor
FROM Patients p JOIN PatientMedicalHistory mh
ON p.PatientID =  mh.PatientID
JOIN Doctors d
ON mh.DoctorID = d.DoctorID
GO

/****** Object:  Creating a view to show billing information ******/
CREATE VIEW Bill(BillID, PatientID, PatientName, RoomCharge, TestsTaken, Medicines, AmountCoveredByInsurance, Total)

AS
SELECT b.BillID, MAX(p.PatientID),MAX(p.FirstName) + ' ' + MAX(p.LastName),
SUM(r.Charge), SUM(tr.Charge), SUM(m.PricePerUnit),  MAX(CAST(i.Coverage AS varchar) + '%'), 
SUM(r.Charge + tr.Charge + m.PricePerUnit - ((i.Coverage/100)*(r.Charge + tr.Charge + m.PricePerUnit))) 
FROM Billing b JOIN RoomRate r
ON b.RoomID = r.RoomID 
JOIN TestsTaken tt
ON b.BillID = tt.BillID 
JOIN TestRate tr
ON tr.TestID = tt.TestID
JOIN MedicinesPurchased mp 
ON mp.BillID = b.BillID
JOIN Medicines m 
ON mp.MedicineID = m.MedicineID  
JOIN Insurance i
ON b.InsuranceNumber = i.InsuranceNumber
JOIN Patients p
ON i.InsuranceNumber = p.InsuranceNumber
GROUP BY b.BillID 
GO


/****** Object:  Creating a stored procedure to show doctor's information ******/

CREATE PROCEDURE DoctorInformation
@FirstName varchar(40) = '%'
AS
SELECT FirstName + ' ' + LastName AS Name, ContactNumber, Email, SSN
FROM Doctors
WHERE FirstName LIKE @FirstName;
GO

/****** Object:  Creating a stored procedure to show general employee's information ******/

CREATE PROCEDURE GeneralEmployeeInformation
@FName varchar(40) = '%'
AS
SELECT FirstName + ' ' + LastName AS Name, ContactNumber, Email, SSN
FROM GeneralEmployees
WHERE FirstName LIKE @FName;
GO

/****** Object:  Creating a stored procedure to show Patient's information ******/

CREATE PROCEDURE PatientInformation
@Name varchar(40) = '%'
AS
SELECT FirstName, LastName,Age, ContactNumber, Email, SSN
FROM Patients
WHERE FirstName LIKE @Name;
GO

/****** Object:  Creating a trigger to account for medicines sold ******/

CREATE TRIGGER MedicineSold
ON MedicinesPurchased
AFTER INSERT, UPDATE
AS
UPDATE Medicines
SET QuantityInStock = QuantityInStock - 1
WHERE MedicineID IN (SELECT MedicineID FROM inserted);
GO

/****** Object:  Creating a function to show Patient's prescription issued by doctor ******/

CREATE FUNCTION fnPrescription
(@DoctorName varchar(40) = '%', @PatientName varchar(40) = '%')
RETURNS TABLE
RETURN

SELECT d.FirstName AS DoctorFName, d.LastName AS DoctorLNAME, p.FirstName AS PatientFName, 
p.LastName AS PatientLName, m.Name AS Medicine

FROM Doctors d JOIN Prescription
ON d.DoctorID = Prescription.DoctorID
JOIN PrescriptionItem
ON Prescription.PrescriptionID = PrescriptionItem.PrescriptionID
JOIN Patients p
ON Prescription.PatientID = p.PatientID
JOIN Medicines m
ON PrescriptionItem.MedicineID = m.MedicineID
WHERE d.FirstName LIKE @DoctorName AND p.FirstName LIKE @PatientName 
GO

/****** Object:  Creating a function to find Doctor Information based on his/her specialization ******/
CREATE FUNCTION fnDoctorDetails
(@Specialization varchar(40) = '%')
RETURNS TABLE
RETURN

SELECT FirstName, LastName, ContactNumber, Email, Specialization
FROM Doctors JOIN
DoctorJobDetails
ON Doctors.DoctorID = DoctorJobDetails.DoctorID
WHERE Specialization LIKE @Specialization
GO



 



