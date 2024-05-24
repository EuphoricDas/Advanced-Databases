----------create database
create database Task1DB



----------------------------------------Combine the datasets India and Ethiopia into Survey_reports-------------------------------------------------------------------------------------
select childid,clustid,commid,typesite,region,dint,round,yc,childloc,deceased,
chsex,chethnic,agemon,marrcohab,marrcohab_age,birth,birth_age,
underweight,stunting,thinness,
tetanus,delivery,bcg,measles,polio,dpt,hib
chmightdie,chillness,chinjury,chdisability,chdisscale
chsmoke,chalcohol,
chrephealth1,chrephealth2,chrephealth3,chrephealth4
hsleep,hcare,hchore,hschool,hstudy,hplay,
levlread,levlwrit,literate,
careage,carecantread,
dadid,dadage,dadyrdied,dadcantread,momid,momage,momyrdied,momcantread,
ownlandhse,ownhouse,
wi,hq,sv,elecq,toiletq,drwaterq,cookingq

into survey_report
from india_constructed

union
select childid,clustid,commid,typesite,region,dint,round,yc,childloc,deceased,
chsex,chethnic,agemon,marrcohab,marrcohab_age,birth,birth_age,
underweight,stunting,thinness,
tetanus,delivery,bcg,measles,polio,dpt,hib
chmightdie,chillness,chinjury,chdisability,chdisscale
chsmoke,chalcohol,
chrephealth1,chrephealth2,chrephealth3,chrephealth4
hsleep,hcare,hchore,hschool,hstudy,hplay,
levlread,levlwrit,literate,
careage,carecantread,
dadid,dadage,dadyrdied,dadcantread,momid,momage,momyrdied,momcantread,
ownlandhse,ownhouse,
wi_new as wi,hq_new as hq,sv_new as sv,elecq_new as elecq,toiletq_new as tolietq,drwaterq_new as drwaterq,cookingq_new as cookingq 
from ethiopia_constructed

select * from survey_report

--------Adding the country column and creating a composite primary key----------------
alter table survey_report
add country varchar(50)

select left(childid,2) from survey_report

update survey_report
set country= case when left(childid,2)='ET' then 'Ethiopia' else 'India' end

alter table survey_report alter column childid varchar(30) NOT NULL
alter table survey_report alter column round int NOT NULL
alter table survey_report add primary key(childid,round)

---------Table childSmokeAndDrink-------------
select childid,round, chsmoke,chalcohol
into childSmokeAndDrink
from 
survey_report

alter table childSmokeAndDrink
   add constraint FK_ChildId_Round
   foreign key(childid, round)
   references survey_report(childid, round)

select * from childSmokeAndDrink

---------Table childGeneralInfo-------------
select childid,round,chsex,chethnic,agemon,marrcohab,marrcohab_age,birth,
birth_age
into childGeneralInfo
from 
survey_report

alter table childGeneralInfo
   add constraint FK_ChildId_Round_GI
   foreign key(childid, round)
   references survey_report(childid, round)

-------Table childHealthStatus---------
select childid,round,underweight,stunting,thinness
into childHealthStatus
from 
survey_report

alter table childHealthStatus
   add constraint FK_ChildId_Round_HS
   foreign key(childid, round)
   references survey_report(childid, round)

-----------Table childVaccStatus-----------
select childid,round,tetanus,delivery,bcg,measles,polio,dpt
into childVaccStatus
from 
survey_report

alter table childVaccStatus
   add constraint FK_ChildId_Round_VS
   foreign key(childid, round)
   references survey_report(childid, round)

--------------Table childIllness----------
select childid,round,chmightdie,chillness,chinjury,chdisability
into childIllness
from 
survey_report

alter table childIllness
   add constraint FK_ChildId_Round_CI
   foreign key(childid, round)
   references survey_report(childid, round)

---------Table childSexEd---------
select childid,round,chrephealth1,chrephealth2,chrephealth3
into childSexEd
from 
survey_report

alter table childSexEd
   add constraint FK_ChildId_Round_CSE
   foreign key(childid, round)
   references survey_report(childid, round)

-------Table childHours----------
select childid,round,hsleep,hcare,hchore,hschool,hstudy,hplay
into childHours
from 
survey_report

alter table childHours
   add constraint FK_ChildId_Round_CH
   foreign key(childid, round)
   references survey_report(childid, round)

-----------Table childEdLevel----------
select childid,round,levlread,levlwrit,literate
into childEdLevel
from 
survey_report

alter table childEdLevel
   add constraint FK_ChildId_Round_CEL
   foreign key(childid, round)
   references survey_report(childid, round)

-----------Table carerEdLevel-----------
select childid,round,careage,carecantread
into carerEdLevel
from 
survey_report

alter table carerEdLevel
   add constraint FK_ChildId_Round_CCel
   foreign key(childid, round)
   references survey_report(childid, round)

----------Table parentsInfo-------------
select childid,round,dadid,dadage,dadyrdied,dadcantread,momid,momage,momyrdied,momcantread
into parentsInfo
from 
survey_report

alter table parentsInfo
   add constraint FK_ChildId_Round_CPI
   foreign key(childid, round)
   references survey_report(childid, round)

------------Table ownProp----------------
select childid,round,ownlandhse,ownhouse
into ownProp
from 
survey_report

alter table ownProp
   add constraint FK_ChildId_Round_OP
   foreign key(childid, round)
   references survey_report(childid, round)

-----------------Table basicReq-----------------
select childid,round,wi,hq,sv,elecq,toiletq,drwaterq,cookingq
into basicReq
from 
survey_report

alter table basicReq
   add constraint FK_ChildId_Round_BR
   foreign key(childid, round)
   references survey_report(childid, round)





