-----Child smoking and drinking habits------------
go
create view childSmokeAndAlchl as 
select  c.childid,c.round,c.chsmoke,c.chalcohol,s.yc,s.country
from childSmokeAndDrink c
inner join survey_report s on
c.childid=s.childid and c.round=s.round

--1. Smoking and Drinking Habits of Children in India and Ethiopia
 
--Younger Cohort-Smoke and alcohol

---T-SQL statement------
go
select count(*) as total,country from childSmokeAndAlchl
where chsmoke = 1 or chalcohol=1 and yc=1
group by country

---Create view to make a report--------------
go
create view v1 as
select count(*) as total,country from childSmokeAndAlchl
where chsmoke = 1 or chalcohol=1 and yc=1
group by country


--Older Cohort-Smoke and alcohol
---T-SQL statement------
go
select count(*) as total,country from childSmokeAndAlchl
where chsmoke = 1 or chalcohol=1 and yc=1
group by country

---Create view to make a report--------------
go
create view v1_1 as
select count(*) as total,country from childSmokeAndAlchl
where chsmoke = 1 or chalcohol=1 and yc=0
group by country

--2.Child Carer's education impact on child

--Creating a view
go
create view childCarerEd as 
select ce.childid,ce.round,ce.levlread,ce.levlwrit,cl.carecantread,s.country,
s.typesite,s.region
from childEdlevel ce
inner join carerEdLevel cl on
ce.childid=cl.childid and ce.round=cl.round
inner join survey_report s on
cl.childid = s.childid and cl.round = s.round


---Stored Procedure
go
create procedure ChangeColumnValues
as
select childid,round,Case when levlread = '1' then 'cant read' 
when levlread = '2' then 'reads letters' when levlread= '3' then 'reads words'
when levlread='4' then 'reads sentences' else 'Unknown' end as levlread,
Case when levlwrit = '1' then 'no' when levlwrit = '2' then 'yes but with difficulty'
when levlwrit = '3' then 'able to write'  else 'Unknown' end as levlwrit,
Case when carecantread = '0' then 'no' when carecantread = '1' then 'yes'
else 'Unknown' end as carecantread,
country,
Case when typesite = '1' then 'Urban' when typesite = '2' then 'Rural' else 'Unknown'
end as typesite,
Case when region = '23' then 'Telangana' when region = '22' then 'Rayalaseema'
 when region='21' then 'Coastal Andhra' else 'Unknown' end as region
from childCarerEd 
go;


--creating a temp table to hold the result of the stored procedure
create table #tmp
(childid varchar(30), 
 round int, 
 levlread varchar(50),
 levlwrit varchar(50),
 carecantread varchar(50),
 country varchar(50),
 typesite varchar(50),
 region varchar(50)
)

insert into #tmp(childid, 
 round, 
 levlread,
 levlwrit,
 carecantread,
 country,
 typesite,
 region
)
exec ChangeColumnValues


-- Carer can't read but child can


---T-SQL statement------
select count(*) as count,region
from
#tmp
where levlread = 'reads sentences' and levlwrit = 'able to write' and carecantread = 'no' and country = 'India'
group by region
------creating view for report
----Since we cannot use tmp table in a view creating a table task3 and creating a view from that
select count(*) as count,region
into task3
from
#tmp
where levlread = 'reads sentences' and levlwrit = 'able to write' and carecantread = 'no' and country = 'India'
group by region

go
create view v2 as 
select * from task3

--Carer can read and child can read
---T-SQL statement------
go
select count(*) as count,region
from
#tmp
where levlread = 'reads sentences' and levlwrit = 'able to write' and carecantread = 'yes' and country = 'India'
group by region
------creating view for report
----Since we cannot use tmp table in a view creating a table task3_1 and creating a view from that
go
select count(*) as count,region
into task3_1
from
#tmp
where levlread = 'reads sentences' and levlwrit = 'able to write' and carecantread = 'yes' and country = 'India'
group by region 

go
create view v2_1 as
select * from task3_1



--3 Realtion between Children who are Underweight and their access to food and water

--create a view
go
create view childHealth as 
select ch.childid,ch.round,ch.underweight,b.drwaterq as waterReq,b.cookingq 
as cookingReq,s.country
from childHealthStatus ch
inner join basicReq b on
ch.childid=b.childid and ch.round=b.round
inner join survey_report s on
b.childid=s.childid and b.round=s.round

------T-SQL statement for children underweight
go
select count(*) as total,country
from childHealth
where underweight = '2' 
group by country
------Creating a view for report

go
create view v3 as
select count(*) as total,country
from childHealth
where underweight = '2' 
group by country


----------------T-SQL statement for children underweight with no basic amenities
go
select count(*) as total,country
from childHealth
where underweight = '2' and waterReq = '0' and cookingReq = '0'
group by country
------Creating a view for report
go
create view v3_1 as
select count(*) as total,country
from childHealth
where underweight = '2' and waterReq = '0' and cookingReq = '0'
group by country


--4. Relation between Illness and Typesite

--create a view
go
create view childIll as
select  ci.childid,ci.round,ci.chmightdie,ci.chdisability,
s.country,s.typesite
from childIllness ci
inner join survey_report s on
ci.childid = s.childid and ci.round = s.round

-----------T-SQL statement
go
select count(*) as total,country,
Case when typesite = '1' then 'Urban' when typesite = '2' then 'Rural' else 'Unknown'
end as typesite
from childIll
where chmightdie='1'
group by typesite,country
---------creating a view for report
go
create view v4 as
select count(*) as total,country,
Case when typesite = '1' then 'Urban' when typesite = '2' then 'Rural' else 'Unknown'
end as typesite
from childIll
where chmightdie='1'
group by typesite,country
 

--5 Relationship between ChildMarriage and Sex Education

--create a view
go
create view chMarrSexEd as 
select  cg.marrcohab,cs.chrephealth1,cs.chrephealth2,cs.chrephealth3,
s.typesite,s.country
from childGeneralInfo cg
inner join childSexEd cs on
cg.childid = cs.childid and cg.round = cs.round
inner join survey_report s on
cs.childid = s.childid and cs.round = s.round

----No sex education

----TSQL Statement
go
select count(*) as total,
Case when typesite = '1' then 'Urban' when typesite = '2' then 'Rural' else 'Unknown'
end as typesite,country
from chMarrSexEd
where marrcohab = '1' and chrephealth2 = '0'
group by typesite,country
----creating a view for report
go 
create view v5 as
select count(*) as total,
Case when typesite = '1' then 'Urban' when typesite = '2' then 'Rural' else 'Unknown'
end as typesite,country
from chMarrSexEd
where marrcohab = '1' and chrephealth2 = '0'
group by typesite,country

--with sex education
---TSQL Statement
go
select count(*) as total,
Case when typesite = '1' then 'Urban' when typesite = '2' then 'Rural' else 'Unknown'
end as typesite,country
from chMarrSexEd
where marrcohab = '1' and chrephealth2 = '1'
group by typesite,country

-----creating a view for report
go 
create view v5_1 as
select count(*) as total,
Case when typesite = '1' then 'Urban' when typesite = '2' then 'Rural' else 'Unknown'
end as typesite,country
from chMarrSexEd
where marrcohab = '1' and chrephealth2 = '1'
group by typesite,country







 