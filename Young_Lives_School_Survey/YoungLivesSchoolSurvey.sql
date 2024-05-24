---create database
go
create database Task2DB;

--create a general table with identifiers and some general info

select UNIQUEID,SCHOOLID,CLASSID,STUDENTID,YLCHILDID,PROVINCE,
DISTRICTCODE,LOCALITY,GENDER,AGE,ETHNICITY,MOM_EDUC,MOM_READ,DAD_EDUC,
DAD_READ,STDYLCHD as YL_child
into generalInfo
from vietnam_wave_1

---adding a primary key
alter table generalInfo alter column UNIQUEID varchar(50) NOT NULL
alter table generalInfo add primary key(UNIQUEID)


--Create table studentQuestionnaire_w1 which consists of set of questions asked to the students
--SJR-School Joining Reason
select UNIQUEID,MOM_READ,MOM_EDUC,DAD_READ,DAD_EDUC,STDLIV as STAY,STDHLTH0 as HEALTH_PROBLEMS,STPLSTDY as OWN_ST_PLACE,
STHVCOMP as OWN_COMPUTER,STHVINTR as INTERNET,STRPTCL1 as REP_GRADE1to5,
STRPTCL6 as REP_GRADE6to9,STRPTCL10 as REP_GRADE10,STAGEENG as STAGE_ENG,
STITMOW1 as COMP_MATH_TB,STITMOW3 as NON_COMP_MATH_TB,STITMOW2 as COMP_ENG_TB,
STITMOW4 as NON_COMP_ENG_TB,STITMOW5 as SCHOOL_BAG,STPLHL01 as PAR_DISCS_SCHL,
STPLHL03 as PAR_HELP_MATH,STPLHL06 as PAR_HELP_ENG,STSPEN01 as MOM_ENG,
STSPEN02 as DAD_ENG,STGR1001 as SJR_DISTANCE,STGR1002 as SJR_SUB,
STGR1004 as SJR_EXPENSE,STGR1005 as SJR_FIN_AID,STGR1006 as SJR_SCH_PERF
into studentQuestionnaire_w1
from vietnam_wave_1

--adding the foreign key constraint
alter table studentQuestionnaire_w1
   add constraint FK_CH_UNIQUEID
   foreign key(UNIQUEID)
   references generalInfo(UNIQUEID)


--create table studentCogTest which list the students score on the cognitive tests

select UNIQUEID,ENG_TEST as ENG_TEST_ATTEMPT,ENG_RAWSCORE,MATH_TEST as MATH_TEST_ATTEMPT,
MATH_RAWSCORE
into studentCogTest
from vietnam_wave_1

--adding the foreign key constraint
alter table studentCogTest
   add constraint FK_SQ_UNIQUEID
   foreign key(UNIQUEID)
   references generalInfo(UNIQUEID)


--create table classRoster consists the information collected from the Roster

select UNIQUEID,GRLENRL as GIRLS_ENRLD,BOYENRL as BOYS_ENRL,TTLENRL as TOTAL_ENRL,
TGRLENRL as ATTNDCE_GIRLS,TBOYENRL as ATTNDCE_BOY,TTTLENRL as TOTAL_ATTNDCE,
SCALLCT as STU_ALLOCATION,SCMNMTIN as MATH_PERIODS_PW,SCMNENIN as ENG_PERIODS_PW,
SCTXTMTH as MATH_TEXT_USED,SCTXTENG as ENG_TEXT_USED
into classRoster
from vietnam_wave_1

--adding the foreign key constraint
alter table classRoster
   add constraint FK_CR_UNIQUEID
   foreign key(UNIQUEID)
   references generalInfo(UNIQUEID)


--create table HM_Questionnaire consists of questions asked to the Pricipal

select UNIQUEID,HTNTCMP as HTQ_COMPLN_STATUS,HTAGE,HTSEX,HTETHGRP,HTCURRLE as 
HT_CURR_ROLE,HTYRSHT as YEARS_IN_CURR_ROLE,HTLVLEDC as HT_ED_LEVEL,HTLVLTCH as
HT_TEACH_TRAINING,HTNMSTEN as HT_STU_ENRLD,HTNMETST as HT_STU_ETNIC,HTPRDIST,
HTNOCMCH as EXTRA_CLASS,HTEXM011 as FEE_EXEMP_POVERTY,HTEXM041 as FEE_EXEMP_EXCELandPOVERTY,
HTEXM021 as FEE_EXEMP_ETHNIC_MIN
into HM_Questionnaire
from vietnam_wave_1

--adding the foreign key constraint
alter table HM_Questionnaire
   add constraint FK_HM_UNIQUEID
   foreign key(UNIQUEID)
   references generalInfo(UNIQUEID)


---Wave2
--create table studentQuestionnaire_w2
--NC_MATH_CLASS/ENG: Non-Compulsary Additional Math/English Class
--PC_MATH/ENG: Private Class for MATH/ENGLISH
select UNIQUEID, STNTCMP as COMPLN_STATUS,STMTHWRK as MATH_HW_FREQ,STMWRKCM as MATH_HW_FB,
STETHWRK as ENG_HW_FREQ,STEWRKCM as ENG_HW_FB,STADDMT as NC_MATH_CLASS,STADDEN
as NC_ENG_CLASS,STPRVMT as PC_MATH,STPRVEN as PC_ENG
into studentQuestionnaire_w2
from vietnam_wave_2

--adding the foreign key constraint
alter table studentQuestionnaire_w2
   add constraint FK_SQ2_UNIQUEID
   foreign key(UNIQUEID)
   references generalInfo(UNIQUEID)

--create table studentCogTest_w2

select UNIQUEID,ENG_TEST,ENG_RAWSCORE,MATH_TEST,MATH_RAWSCORE
into studentCogTest_w2
from vietnam_wave_2

--adding the foreign key constraint
alter table studentCogTest_w2
   add constraint FK_SCT2_UNIQUEID
   foreign key(UNIQUEID)
   references generalInfo(UNIQUEID)


--create table HM_Questionnaire_w2

select UNIQUEID,HTEDOVS as INSPECTION_FREQ,HTSTDDRP as STU_DROPOUT,HTCHDLBR as
CHILD_LABOUR,HTSTPFGL as PERF_ED_GOALS,HTTOKEXM as
NoOfStu_ATTEND_FINALS,HTLSPSEXM as NoOfStu_PASS_FINALS
into HM_Questionnaire_w2
from vietnam_wave_2

--adding the foreign key constraint
alter table HM_Questionnaire_w2
   add constraint FK_HMQ2_UNIQUEID
   foreign key(UNIQUEID)
   references generalInfo(UNIQUEID)


--create table tecaherBackground_w2 which consists of information about the teacher

select UNIQUEID,ENG_TCHID,ENG_TCLVLEDC as ENG_TEACHER_EDLEVEL,ENG_TCTCHQLF as ENG_TRAINING,
MATH_TCHID,MATH_TCLVLEDC as MATH_TEACHER_EDLEVEL,MATH_TCTCHQLF as MATH_TRAINING
into tecaherBackground_w2
from vietnam_wave_2

--adding the foreign key constraint
alter table tecaherBackground_w2
   add constraint FK_TB2_UNIQUEID
   foreign key(UNIQUEID)
   references generalInfo(UNIQUEID)


--create view for excl reports
--1
-- Students per Province
go
create view stu_Province
as
select Case when PROVINCE = '1'  then 'Ben Tre' when PROVINCE = '2'  then 'Da Nang' 
when PROVINCE = '3'  then 'Hung Yen' when PROVINCE = '4'  then 'Lao Cai' 
when PROVINCE = '5'  then 'Phu Yen' else 
'Unknown' end as PROVINCE,count(UNIQUEID) as Total_Students
from generalInfo
group by PROVINCE

--select * from stu_Province

--create view stu_ParEdu_Locality_1
--2
go
create view stu_ParEdu_Locality_1 as
select 
Case when g.LOCALITY = '1'  then 'Rural' when g.LOCALITY = '2'  then 'Urban'
else 'Unkown' end as Locality,count(g.UNIQUEID) as TotalFemaleStudents
from generalInfo g
inner join studentQuestionnaire_w1 sq on
g.UNIQUEID = sq.UNIQUEID
where sq.MOM_READ = '0'and sq.DAD_READ= '0' 
group by g.LOCALITY

--create same view where both parents are literate
--3
go
create view stu_ParEdu_Locality_2 as
select 
Case when g.LOCALITY = '1'  then 'Rural' when g.LOCALITY = '2'  then 'Urban'
else 'Unkown' end as Locality,count(g.UNIQUEID) as TotalFemaleStudents
from generalInfo g
inner join studentQuestionnaire_w1 sq on
g.UNIQUEID = sq.UNIQUEID
where sq.MOM_READ = '1'and sq.DAD_READ= '1' 
group by g.LOCALITY

--create view stu_Gender_Locality
--4
go
create view stu_Gender_Locality as
select 
Case when LOCALITY = '1'  then 'Rural' when LOCALITY = '2'  then 'Urban'
else 'Unkown' end as Locality,
count(case when gender='1' then 1 end) as male_count,
count(case when gender='2' then 1 end) as female_count
from generalInfo
group by LOCALITY



--create view stu_Passed
go
create view stu_Passed as
select g.SCHOOLID,count(hm.NoOfStu_PASS_FINALS) as No_of_Students_Passed,
count(hm.NoOfStu_ATTEND_FINALS) as No_of_Students_Atteded
from HM_Questionnaire_w2 hm inner join generalInfo g on
hm.UNIQUEID = g.UNIQUEID
group by hm.NoOfStu_PASS_FINALS,g.SCHOOLID


--query for Math_Eng Test evaluation

select s1.UNIQUEID,s1.ENG_RAWSCORE as eng_score_w1,s2.ENG_RAWSCORE as eng_score_w2,
((cast(s1.ENG_RAWSCORE as int)) - 
(cast(s2.ENG_RAWSCORE as int))) as 
'Eng_Diff',
s1.MATH_RAWSCORE as math_score_w1,s2.MATH_RAWSCORE as math_score_w2,
((cast(s1.MATH_RAWSCORE as int)) - 
(cast(s2.MATH_RAWSCORE as int))) as 
'Math_Diff'
from 
studentCogTest s1 inner join studentCogTest_w2 s2 on
s1.UNIQUEID = s2.UNIQUEID
where s1.ENG_TEST_ATTEMPT='yes' and s2.ENG_TEST = 'yes'
and s1.MATH_TEST_ATTEMPT = 'yes' and s2.MATH_TEST = 'yes'

--query to analyse the reason to join school due to distance and financial aid

select Case when g.LOCALITY = '1'  then 'Rural' when g.LOCALITY = '2'  then 'Urban'
else 'Unkown' end as Locality, count(g.UNIQUEID) as Total_Students
from generalInfo g
inner join studentQuestionnaire_w1 s on
g.UNIQUEID = s.UNIQUEID
where s.SJR_DISTANCE = '4' or s.SJR_DISTANCE = '3' and SJR_FIN_AID = '4' or
SJR_FIN_AID = '3'
group by g.LOCALITY

--query to analyse the reason to join school due to School's Performance and
-- the subject quality being taught

select Case when g.LOCALITY = '1'  then 'Rural' when g.LOCALITY = '2'  then 'Urban'
else 'Unkown' end as Locality, count(g.UNIQUEID) as Total_Students
from generalInfo g
inner join studentQuestionnaire_w1 s on
g.UNIQUEID = s.UNIQUEID
where s.SJR_SCH_PERF = '4' or s.SJR_SCH_PERF = '3' and s.SJR_SUB = '4' or
SJR_SUB = '3'
group by g.LOCALITY

