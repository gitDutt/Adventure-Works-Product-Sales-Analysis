FILENAME REFFILE '/home/u61473458/BAN_130/datasets_1/AdventureWorks.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.Product;
	GETNAMES=YES;
	SHEET="Product";
RUN;

title "Summary of Datasheet Product";
proc print data=work.product (obs=10);
run;

/****/

FILENAME REFFILE '/home/u61473458/BAN_130/datasets_1/AdventureWorks.xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.SalesOrderDetail;
	GETNAMES=YES;
	SHEET="SalesOrderDetail";
RUN;


title "Summary of Datasheet SalesOrderDetail";
proc print data=work.SalesOrderDetail (obs = 10);
run;

/*************** Creating dataset Product_Clean ***************/
Data Product_Clean;
set Work.Product(keep=ProductID Name ProductNumber Color ListPrice);
if color='' then color="NA";  /*replacing missing valur of color with "NA"*/
List_num=input(ListPrice,8.2);
format list_num dollar8.2;
drop ListPrice;
rename List_num=ListPrice;
run;
title "Summary of Product_Clean after cleaning";
proc print data=Product_clean (obs=10);
run;

/* Creating dataset SalesOrderDetail_Clean */

Data SalesOrderDetail_Clean;
set Work.SalesOrderDetail(keep = SalesOrderID SalesOrderDetailID OrderQty ProductID UnitPrice LineTotal ModifiedDate
rename = 
(ModifiedDate = C_ModifiedDate
OrderQty = C_OrderQty
UnitPrice = C_UnitPrice
LineTotal = C_LineTotal
));
ModifiedDate = datepart(input(C_ModifiedDate,anydtdtm.));
format ModifiedDate mmddyy10.;
UnitPrice = input(C_UnitPrice,dollar8.2);
FORMAT UnitPrice DOLLAR8.2;
LineTotal= input(C_LineTotal,dollar8.2);
FORMAT LineTotal DOLLAR8.2;
OrderQty = input(C_OrderQty,comma9.);

drop C_ModifiedDate C_UnitPrice C_LineTotal C_OrderQty;
IF YEAR(ModifiedDate)=2013 OR YEAR(ModifiedDate)=2014 THEN 
OUTPUT;
proc sort data=salesorderdetail_clean;
by productID;
run;

title "Summary of Salesorderdetail after cleaning";
proc print data=salesorderdetail_clean (obs=10);
run;

