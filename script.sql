DROP DATABASE IF EXISTS escrito;
CREATE DATABASE escrito;
USE escrito;

CREATE TABLE Producto (
id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
nombre VARCHAR(30) NOT NULL,
descripcion VARCHAR(255) NOT NULL,
stock INT UNSIGNED NOT NULL,
precio FLOAT UNSIGNED NOT NULL,
fechaAlta DATETIME NOT NULL DEFAULT NOW(),
isDeleted bool default false
);

CREATE TABLE Compra(
id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
fechaAlta DATETIME NOT NULL DEFAULT NOW(),
id_P INT UNSIGNED NOT NULL,
cantidad INT UNSIGNED NOT NULL,
FOREIGN KEY (id_P) REFERENCES Producto(id));

delimiter $$
CREATE TRIGGER checkCompra BEFORE INSERT ON Compra
FOR EACH ROW BEGIN 
	SET @stock = (SELECT stock FROM Producto WHERE id=NEW.id_P);
	IF NEW.cantidad = 0 THEN 
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="cantidad no puede ser 0";
	END IF;
    IF NEW.cantidad > @stock THEN 
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="cantidad a comprar excede el stock";
	ELSE 
		UPDATE Producto SET stock = (stock - NEW.cantidad) WHERE id = NEW.id_P;
	END IF;
END $$

CREATE TRIGGER checkDeleteProducto BEFORE DELETE ON Producto
FOR EACH ROW BEGIN
	SET @comprasCount = (SELECT COUNT(*) FROM Compra WHERE id_P = OLD.id);
    IF @comprasCount > 0 THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Product cant be deleted";
	END IF;
END $$
select *  from producto; 
CREATE TRIGGER trimmProducto BEFORE INSERT ON Producto 
FOR EACH ROW BEGIN
SET NEW.fechaAlta = TRIM(BOTH FROM NEW.fechaAlta);
SET NEW.nombre = TRIM(BOTH FROM NEW.nombre);
SET NEW.descripcion = TRIM(BOTH FROM NEW.descripcion);
END$$
delimiter ;

DROP USER IF EXISTS usuario@'%';
CREATE USER "usuario"@"%" IDENTIFIED BY "clave1";
GRANT ALL PRIVILEGES ON  escrito.* TO "usuario"@"%";

INSERT INTO Producto VALUES (	1	, 'Fuji Apples' , 'ports volutpat quam pede lobortis ligula sit amet eleifend pede libero', 	24	,  	69.33	 , '2021-07-14', 	true	);
INSERT INTO Producto VALUES (	2	, 'Wine - Fino Tio Pepe Gonzalez', 'turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam', 	15	,  	40.92	 , '2021-05-11', 	false	);
INSERT INTO Producto VALUES (	3	, 'Pepper - Chili Powder' , 'nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla', 	98	,  	78.33	 , '2021-07-19', 	true	);
INSERT INTO Producto VALUES (	4	, 'Dc Hikiage Hira Huba' , 'sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus', 	55	,  	95.32	 , '2021-02-12', 	false	);
INSERT INTO Producto VALUES (	5	, 'Hipnotiq Liquor' , 'eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae', 	83	,  	31.93	 , '2021-08-22', 	true	);
INSERT INTO Producto VALUES (	6	, 'Shrimp, Dried, Small' , 'convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien', 	76	,  	91.38	 , '2021-09-14', 	true	);
INSERT INTO Producto VALUES (	7	, 'Amarula Cream' , 'pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin', 	85	,  	59.77	 , '2020-12-16', 	false	);
INSERT INTO Producto VALUES (	8	, 'Shallots' , 'dui proin leo odio porttitor id consequat in consequat ut nulla', 	98	,  	41.9	 , '2021-05-16', 	true	);
INSERT INTO Producto VALUES (	9	, 'Yokaline' , 'maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque	', 	9	,  	94.78	 , '2021-07-22', 	false	);
INSERT INTO Producto VALUES (	10	, 'Oil - Pumpkinseed' , 'mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere', 	51	,  	70.65	 , '2021-06-25', 	false	);
INSERT INTO Compra (id_P, cantidad) VALUES (1,12);  
INSERT INTO Compra (id_P, cantidad) VALUES (10,12);  
