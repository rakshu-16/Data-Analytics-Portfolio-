CREATE TABLE "M2"
(
    "Buyer" character varying,
    "Cust Code" character varying(10) COLLATE pg_catalog."default",
    "Cust Name" character varying,
    "Delivery Period" character varying(20) COLLATE pg_catalog."default",
    "Department Name"  character varying,
    "Designer" character varying(10) COLLATE pg_catalog."default",
    "Doc Date" timestamp without time zone,
    "Doc Num" character varying,
    "EMP Code" character varying(10) COLLATE pg_catalog."default",
    "Emp Name"  character varying,
    "EMP Code (MEMP)" character varying(15) COLLATE pg_catalog."default",
    "End Time" timestamp without time zone,
    "Fiscal Date" date,
    "Fiscal Date Time" timestamp without time zone,
    "Form Type" character varying,
    "In Active" character varying(10) COLLATE pg_catalog."default",
    "Is Final Process" character varying(10) COLLATE pg_catalog."default",
    "Item Code" character varying COLLATE pg_catalog."default",
    "Item Name" character varying,
    "Machine / Employee" character varying(20) COLLATE pg_catalog."default",
    "Machine Code	" character varying(20) COLLATE pg_catalog."default",
    "Machine Code (EMP)" character varying(20) COLLATE pg_catalog."default",
    "Machine Name" character varying(20) COLLATE pg_catalog."default",
    "Machine Name (EMP)" character varying(20) COLLATE pg_catalog."default",
    "Operation Code	" character varying(20) COLLATE pg_catalog."default",
    "Operation Name	"  character varying,
    "Rpm" integer,
    "SAP So Num" integer,
    "Sapgrno" integer,
    "Shift Code" character varying(5) COLLATE pg_catalog."default",
    "Shortages" character varying(10) COLLATE pg_catalog."default",
    "SNO" integer,
    "SO Del Date" timestamp without time zone,
    "SO Delivery Date" timestamp without time zone,
    "SO Docdate" timestamp without time zone,
    "SO DocDate F" timestamp without time zone,
    "SO Expected Delivery F" timestamp without time zone,
    "SO Num" integer,
    "So Posting Date" timestamp without time zone,
    "Start Time" timestamp without time zone,
    "U_GRCDate" timestamp without time zone,
    "U_GRRate" numeric,
    "U_unitdeldt" timestamp without time zone,
    "User Id" integer,
    "User Id1" integer,
    "User Name"  character varying,
    "Variant Name" character varying,
    "WO Date" date,
    "WO Number" integer,
    "WO Status" character varying COLLATE pg_catalog."default",
    "Work Centre Code" character varying(10) COLLATE pg_catalog."default",
    "Work Centre Name" character varying,
    "Balance Qty" integer,
    "Docnum" integer,
    "Final Processed Qty" integer,
    "Fiscal Year" integer,
    "Man/Rejc" integer,
    "Manufactured Qty" integer,
    "Per day Machine Cost made" numeric,
    "Press Qty" integer,
    "Processed Qty" integer,
    "Produced Qty" integer,
    "Rejected Qty" integer,
    "Repeat" integer,
    "today Manufactured qty " integer,
    "TotalQty" integer,
    "TotalValue" numeric,
    "WO Qty" integer
)

select *  from "M2"

-- 1.Manufactured_Quantity
select sum("Manufactured Qty") as Manufactured_Quantity from "M2"

-- 2.Rjected Quantity
select sum("Rejected Qty") as Rejected_Quantity from "M2"

-- 3.processed Quantity
select sum("Processed Qty") as Processed_Quantity from "M2"

-- 4.Wastage Quanity     two integer division gives zero in postgressql,so we cast one to decimal
select concat(round((cast(sum("Rejected Qty") as decimal)/ sum("Processed Qty"))*100,3),'%' ) from "M2"

-- 5.employee wise rejected quanity
select "Emp Name",sum("Rejected Qty") from "M2"
where "Rejected Qty" != 0
group by "M2"."Emp Name"
order by 2 desc


-- 6.Machine wise rejected quanity
select "Machine Name",sum("Rejected Qty") from "M2"
where "Rejected Qty" != 0
group by 1
order by 2 desc

-- 7.Opeartion wise manufactured/rejected quanity
select "Operation Name	",sum("Rejected Qty") as rejected_quanity,sum("Manufactured Qty") as manufactured_quantity from "M2"
group by 1
order by 1

-- 8.Rejected vs manufactured
select sum("Rejected Qty") as Rejected_Quanity, sum("Manufactured Qty") as manufactured_quanity from "M2"

--9.Department wise Rejected and manufactured  quanity
select "Department Name",sum("Rejected Qty") as rejected_quanity,sum("Manufactured Qty") as manufactured_quantity from "M2"
group by 1
order by 1

-- 10.Delivery status wise manufactured quanity
select "Delivery Period",sum("Manufactured Qty") from "M2"
group by 1

-- 11.Brandwise manufactured and rejected quanity
select "Buyer" as Brand_name,sum("Rejected Qty"),sum("Manufactured Qty") from "M2"
group by 1
order by 1

