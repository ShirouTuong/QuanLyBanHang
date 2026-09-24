CREATE DATABASE IF NOT EXISTS QuanLyBanHang;

USE QuanLyBanHang;

CREATE TABLE Customer (
    cID INT PRIMARY KEY,
    cName VARCHAR(100) NOT NULL,
    cAge INT,
    CONSTRAINT chk_customer_age CHECK (cAge > 0)
);

CREATE TABLE Product (
    pID INT PRIMARY KEY,
    pName VARCHAR(100) NOT NULL,
    pPrice DECIMAL(12,2) NOT NULL,
    CONSTRAINT chk_product_price CHECK (pPrice > 0)
);

CREATE TABLE `Order` (
    oID INT PRIMARY KEY,
    cID INT NOT NULL,
    oDate DATE NOT NULL,
    oTotalPrice DECIMAL(12,2) NOT NULL DEFAULT 0,

    CONSTRAINT fk_order_customer
        FOREIGN KEY (cID)
        REFERENCES Customer(cID),

    CONSTRAINT chk_order_total
        CHECK (oTotalPrice >= 0)
);

CREATE TABLE OrderDetail (
    oID INT NOT NULL,
    pID INT NOT NULL,
    odQTY INT NOT NULL,

    PRIMARY KEY (oID, pID),

    CONSTRAINT fk_orderdetail_order
        FOREIGN KEY (oID)
        REFERENCES `Order`(oID),

    CONSTRAINT fk_orderdetail_product
        FOREIGN KEY (pID)
        REFERENCES Product(pID),

    CONSTRAINT chk_orderdetail_qty
        CHECK (odQTY > 0)
);

USE QuanLyBanHang;

INSERT INTO Customer (cID, cName, cAge) VALUES
(1, 'Minh Quan', 10),
(2, 'Ngoc Oanh', 20),
(3, 'Hong Ha', 50);

INSERT INTO Product (pID, pName, pPrice) VALUES
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2);

INSERT INTO `Order` (oID, cID, oDate, oTotalPrice) VALUES
(1, 1, '2006-03-21',0),
(2, 2, '2006-03-23',0),
(3, 1, '2006-03-16',0);

INSERT INTO OrderDetail (oID, pID, odQTY) VALUES
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 4),
(2, 3, 3);

SELECT oID, oDate, oTotalPrice 
FROM `Order`;

SELECT DISTINCT c.cName, p.pName
FROM Customer c
JOIN `Order` o ON c.cID = o.cID
JOIN OrderDetail od ON o.oID = od.oID
JOIN Product p ON od.pID = p.pID;

SELECT cName 
FROM Customer 
WHERE cID NOT IN (SELECT DISTINCT cID FROM `Order`);

SELECT 
    o.oID, 
    o.oDate, 
    SUM(od.odQTY * p.pPrice) AS TotalPrice
FROM `Order` o
JOIN OrderDetail od ON o.oID = od.oID
JOIN Product p ON od.pID = p.pID
GROUP BY o.oID, o.oDate;