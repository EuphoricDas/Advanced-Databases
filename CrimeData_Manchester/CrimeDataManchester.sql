----craeate database
go
create database Task3DB


--create a table combining all the crime files of 2017 and 2018
go
select * into allCrimes from [dbo].[2017-01-greater-manchester]
union all
select * from [dbo].[2017-02-greater-manchester-street]
union all
select * from [dbo].[2017-03-greater-manchester-street]
union all
select * from [dbo].[2017-04-greater-manchester-street]
union all
select * from [dbo].[2017-05-greater-manchester-street]
union all
select * from [dbo].[2017-06-greater-manchester-street]
union all
select * from [dbo].[2017-07-greater-manchester-street]
union all
select * from [dbo].[2017-08-greater-manchester-street]
union all
select * from [dbo].[2017-09-greater-manchester-street]
union all
select * from [dbo].[2017-10-greater-manchester-street]
union all
select * from [dbo].[2017-11-greater-manchester-street]
union all
select * from [dbo].[2017-12-greater-manchester-street]
union all
select * from [dbo].[2018-01-greater-manchester-street]
union all
select * from [dbo].[2018-02-greater-manchester-street]
union all
select * from [dbo].[2018-03-greater-manchester-street]
union all
select * from [dbo].[2018-04-greater-manchester-street]
union all
select * from [dbo].[2018-05-greater-manchester-street]
union all
select * from [dbo].[2018-06-greater-manchester-street]
union all
select * from [dbo].[2018-07-greater-manchester-street]
union all
select * from [dbo].[2018-08-greater-manchester-street]
union all
select * from [dbo].[2018-09-greater-manchester-street]
union all
select * from [dbo].[2018-10-greater-manchester-street]
union all
select * from [dbo].[2018-11-greater-manchester-street]
union all
select * from [dbo].[2018-12-greater-manchester-street]

select * from allCrimes


-------Add identity to allCrimes------
alter table allCrimes
   add id int identity

--Add Geo Location to allCrimes
alter table allCrimes
add GeoLocation Geography

update allCrimes
set GeoLocation = geography::Point(Latitude,Longitude, 4326)
where Latitude is not null and Longitude is not null

-------create a view LSOA for the Manchester Area-----
create view LSOA_GM as
select * from LSOA
where LSOA like 'Bolton%' or LSOA like 'Bury%' or LSOA like 'Oldham%' or
LSOA like 'Rochdale%' or LSOA like 'Stockport%' or LSOA like 'Tameside%' or 
LSOA like 'Trafford%' or LSOA like 'Wigan%' or LSOA like 'Salford%' or
LSOA like 'Manchester%'

------create view by joining LSOA for Greater Manchester with Crime data
go
create view LSOA_Crime_GM as
select [l].[LSOA],[l].[All Ages],[l].[Area Codes],[a].[Crime ID],[a].[Month],
cast([a].[Month]+'-01' as date) as Date, [a].[Reported By], [a].[Falls within], [a].[Longitude],
[a].[Latitude], [a].[Location], [a].[Crime Type], [a].[Last outcome category],
[a].id,[a].[GeoLocation]
from allCrimes a
inner join LSOA_GM l on
[a].[LSOA code] = [l].[Area Codes]





----------------View CrimeType Report for 2018------
go
create view Report_By_Crime as
select count(*) as Total_Crimes,[Crime Type],Month
from LSOA_Crime_GM
where Month like'2018%'
group by [Crime Type],Month


----Yearly report of all Crimes
go 
create view report_yearly_allCrimes as
select count(*) as total,YEAR(DATE) as year
from LSOA_Crime_GM
group by YEAR(Date)



------crime report near piccadily
go
create view crimes_piccadily as
select [Crime Type],count(*) as total_crimes
from LSOA_Crime_GM
where Latitude like '53.4%' and Longitude like '-2.2%'
group by [Crime Type]


---------Anti Social behaviour in Salford----------
go
create view antiSocial_salford as
select * from LSOA_Crime_GM
where [Crime Type] = 'Anti-social behaviour' and LSOA like 'Salford%'
and GeoLocation is not null

------------vehicle crimes Manchester--------
go 
create view vehicleCrime_GM as
select * 
from LSOA_Crime_GM
where [Crime Type]='Vehicle crime' and GeoLocation is not null

----antiSocial_GM
go 
create view antiSocial_GM as
select * 
from LSOA_Crime_GM
where [Crime Type]='Anti-social behaviour' and GeoLocation is not null

--vehicleCrime_Salford
go
create view vehicleCrime_Salford as
select * from LSOA_Crime_GM
where [Crime Type] = 'Vehicle crime' and LSOA like 'Salford%'
and GeoLocation is not null

