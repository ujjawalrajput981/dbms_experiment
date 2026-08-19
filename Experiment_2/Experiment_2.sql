CREATE DATABASE Indian_Ecommerce;

USE Indian_Ecommerce;

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNo VARCHAR(15) NOT NULL,
    DOB DATE NOT NULL
);

CREATE TABLE Address (
    AddressID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    Pincode VARCHAR(10) NOT NULL,
    State VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,

    FOREIGN KEY (CustomerID)
    REFERENCES Customer(CustomerID)
    ON DELETE CASCADE
);


CREATE TABLE Category (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL UNIQUE,
    Description VARCHAR(255)
);


CREATE TABLE Seller (
    SellerID INT PRIMARY KEY AUTO_INCREMENT,
    SellerName VARCHAR(100) NOT NULL,
    PhoneNo VARCHAR(15) NOT NULL UNIQUE
);


CREATE TABLE Product (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryID INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Image VARCHAR(255),

    FOREIGN KEY (CategoryID)
    REFERENCES Category(CategoryID)
    ON DELETE CASCADE
);


-- Product Specialization: Electronic
CREATE TABLE Electronic (
    ProductID INT PRIMARY KEY,

    FOREIGN KEY (ProductID)
    REFERENCES Product(ProductID)
    ON DELETE CASCADE
);


CREATE TABLE Fashion (
    ProductID INT PRIMARY KEY,

    FOREIGN KEY (ProductID)
    REFERENCES Product(ProductID)
    ON DELETE CASCADE
);


CREATE TABLE Books (
    ProductID INT PRIMARY KEY,
    SellerID INT,

    FOREIGN KEY (ProductID)
    REFERENCES Product(ProductID)
    ON DELETE CASCADE,

    FOREIGN KEY (SellerID)
    REFERENCES Seller(SellerID)
    ON DELETE SET NULL
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    OrderStatus VARCHAR(30) NOT NULL,

    FOREIGN KEY (CustomerID)
    REFERENCES Customer(CustomerID)
    ON DELETE CASCADE
);

CREATE TABLE OrderItem (
    OrderID INT NOT NULL,
    item_seq_no INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Unit_Price DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (OrderID, item_seq_no),

    FOREIGN KEY (OrderID)
    REFERENCES Orders(OrderID)
    ON DELETE CASCADE,

    FOREIGN KEY (ProductID)
    REFERENCES Product(ProductID)
    ON DELETE CASCADE
);

CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL UNIQUE,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(30) NOT NULL,
    Status VARCHAR(30) NOT NULL,

    FOREIGN KEY (OrderID)
    REFERENCES Orders(OrderID)
    ON DELETE CASCADE
);

CREATE TABLE Delivery (
    DeliveryID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL UNIQUE,
    CourierName VARCHAR(100) NOT NULL,
    Status VARCHAR(30) NOT NULL,
    DeliveryDate DATE,

    FOREIGN KEY (OrderID)
    REFERENCES Orders(OrderID)
    ON DELETE CASCADE
);

-- Customers
INSERT INTO Customer
(Name, Email, PhoneNo, DOB)
VALUES
('Ujjawal Chauhan', 'ujjawal@gmail.com', '9876543210', '2005-05-15'),
('Rahul Sharma', 'rahul@gmail.com', '9876543211', '2004-08-20'),
('Aman Verma', 'aman@gmail.com', '9876543212', '2005-01-10');


-- Categories
INSERT INTO Category
(CategoryName, Description)
VALUES
('Electronics', 'Electronic products'),
('Fashion', 'Clothing products'),
('Books', 'Books and study material');


-- Sellers
INSERT INTO Seller
(SellerName, PhoneNo)
VALUES
('Tech Store', '9000000001'),
('Fashion Store', '9000000002'),
('Book Store', '9000000003');


-- Products
INSERT INTO Product
(CategoryID, Price, Image)
VALUES
(1, 49999.00, 'laptop.jpg'),
(1, 2999.00, 'headphones.jpg'),
(2, 999.00, 'shirt.jpg'),
(3, 599.00, 'book.jpg');


-- Product Specialization
INSERT INTO Electronic VALUES (1);
INSERT INTO Electronic VALUES (2);

INSERT INTO Fashion VALUES (3);

INSERT INTO Books VALUES (4, 3);


-- Addresses
INSERT INTO Address
(CustomerID, Pincode, State, City)
VALUES
(1, '226001', 'Uttar Pradesh', 'Lucknow'),
(2, '110001', 'Delhi', 'New Delhi'),
(3, '201301', 'Uttar Pradesh', 'Noida');


-- Orders
INSERT INTO Orders
(CustomerID, OrderDate, OrderStatus)
VALUES
(1, '2026-08-01', 'Placed'),
(2, '2026-08-03', 'Shipped'),
(3, '2026-08-05', 'Delivered');


-- Order Items
INSERT INTO OrderItem
(OrderID, item_seq_no, ProductID, Quantity, Unit_Price)
VALUES
(1, 1, 1, 1, 49999.00),
(1, 2, 2, 1, 2999.00),
(2, 1, 3, 2, 999.00);


-- Payments
INSERT INTO Payment
(OrderID, PaymentDate, Amount, PaymentMethod, Status)
VALUES
(1, '2026-08-01', 52998.00, 'UPI', 'Success'),
(2, '2026-08-03', 1998.00, 'Card', 'Success');


-- Deliveries
INSERT INTO Delivery
(OrderID, CourierName, Status, DeliveryDate)
VALUES
(1, 'Delhivery', 'Delivered', '2026-08-04'),
(2, 'Blue Dart', 'Shipped', NULL);

-- Demonstration of Referential Integrity Violation
INSERT INTO Orders
(CustomerID, OrderDate, OrderStatus)
VALUES
(999, '2026-08-20', 'Placed');

-- Demonstration of ON DELETE CASCADE
DELETE FROM Customer
WHERE CustomerID = 3;

SELECT * FROM Orders
WHERE CustomerID = 3;

-- Demonstration of ON DELETE SET NULL
DELETE FROM Seller
WHERE SellerID = 3;

SELECT * FROM Books;