

--Charlie's Chocolate Factory company produces chocolates. The following product information is stored: product name, product ID, and quantity on hand. These chocolates are made up of many components. Each component can be supplied by one or more suppliers. The following component information is kept: component ID, name, description, quantity on hand, suppliers who supply them, when and how much they supplied, and products in which they are used. On the other hand following supplier information is stored: supplier ID, name, and activation status.

/*Assumptions

    A supplier can exist without providing components.
    A component does not have to be associated with a supplier. It may already have been in the inventory.
    A component does not have to be associated with a product. Not all components are used in products.
    A product cannot exist without components. */

/*Do the following exercises, using the data model.

     a) Create a database named "Manufacturer"

     b) Create the tables in the database.

     c) Define table constraints.*/

CREATE DATABASE Manufacturer 

CREATE TABLE [Product](
[prod_id] INT PRIMARY KEY NOT NULL, 
[Prod_name] VARCHAR(50) NOT NULL, 
[quantity] INT NULL ) ;

CREATE TABLE [Prod_Comp](
[comp_id] INT NOT NULL REFERENCES [Component], 
[prod_id] INT NOT NULL REFERENCES [Product], 
[quantity_comp] INT NULL, 
PRIMARY KEY ([comp_id],[prod_id])) ;  

CREATE TABLE [Component](
[comp_id] INT PRIMARY KEY NOT NULL, 
[comp_name] VARCHAR(50) NOT NULL, 
[description] VARCHAR(50) NULL, 
[quantity_comp] INT NULL) ;


CREATE TABLE [Supplier](
[supp_id] INT PRIMARY KEY NOT NULL,
[supp_name] VARCHAR(50) NOT NULL,
[supp_location] VARCHAR(50) NULL,
[supp_country] VARCHAR NULL, 
[is_active] BIT NULL) ;


CREATE TABLE [Comp_Supp](
[sup_id] INT NOT NULL REFERENCES [supplier] ,
[comp_id] INT NOT NULL REFERENCES [Component] , 
[order_date] DATE NULL , 
[quantity] INT NULL,
PRIMARY KEY ([sup_id],[comp_id])) ; 



