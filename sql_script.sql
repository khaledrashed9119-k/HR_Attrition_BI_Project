

/* 

i shouldnt not put everything in just one script as i might face some issues later by calling the script twice specially for the bulk insert 
but i am doint this all in one script just to present it so through out my work i was very cautious to not to run the whole script at once 
at any single point or any query running

*/

-- ddl for database and schemas and raw table

create database HR_Attrition;
go
use HR_Attrition;
go
create schema Attrition_Raw;
go
create schema Attrition_DWH;
go
create table Attrition_Raw.EmployeeAttritionRaw
(   Age int,
    Attrition varchar(50),
    BusinessTravel varchar(50),
    DailyRate int,
    Department varchar(50),
    DistanceFromHome int,
    Education int,
    EducationField varchar(50),
    EmployeeCount int,
    EmployeeNumber int,
    EnvironmentSatisfaction int,
    Gender varchar(50), 
    HourlyRate int,
    JobInvolvement int,
    JobLevel int,
    JobRole varchar(50),
    JobSatisfaction int,
    MaritalStatus varchar(20),
    MonthlyIncome int,
    MonthlyRate int,
    NumCompaniesWorked int,
    Over18 varchar(20),
    OverTime varchar(20),
    PercentSalaryHike int,
    PerformanceRating int,
    RelationshipSatisfaction int,
    StandardHours int,
    StockOptionLevel int,
    TotalWorkingYears int,
    TrainingTimesLastYear int,
    WorkLifeBalance int,
    YearsAtCompany int,
    YearsInCurrentRole int,
    YearsSinceLastPromotion int,
    YearsWithCurrManager int
)
go -- loading data from csv file
bulk insert Attrition_Raw.EmployeeAttritionRaw
from 'D:\teleperformance\data_and_requirments\DATA_OF_HR_Attrition_csv.csv'
with (
    format = 'CSV',
    firstrow = 2,
    codepage = '65001',
    rowterminator = '0x0a'
);
go -- make sure that the whole data was added
select * from Attrition_Raw.EmployeeAttritionRaw 

--validation checks and data exploration


select distinct * from Attrition_Raw.EmployeeAttritionRaw 





select top(5) * from Attrition_Raw.EmployeeAttritionRaw where Attrition = 'yes' order by age desc





select count (*) as the_total, count(distinct EmployeeNumber)as unique_employees from Attrition_Raw.EmployeeAttritionRaw 




select
    sum(case when EmployeeNumber is null then 1 else 0 end) as NullEmployeeNumber,
    sum(case when Age is null then 1 else 0 end) as NullAge,
    sum(case when Attrition is null then 1 else 0 end) as NullAttrition,
    sum(case when MonthlyIncome is null then 1 else 0 end) as NullIncome,
    sum(case when Department is null then 1 else 0 end) as NullDepartment
from Attrition_Raw.EmployeeAttritionRaw;



select *
from Attrition_Raw.EmployeeAttritionRaw
where Age <= 0
   or MonthlyIncome < 0
   or YearsAtCompany < 0
   or Attrition not in ('Yes', 'No');



select
    Attrition,
    count(*) as EmployeeCount,
    cast(count(*) * 100.0 /( select count(*) from Attrition_Raw.EmployeeAttritionRaw) as decimal (5,2)) as Percentage
from Attrition_Raw.EmployeeAttritionRaw
group by Attrition;






select
    Department,
    count(*) as TotalEmployees,
    sum(case when Attrition = 'Yes' then 1 else 0 end) as EmployeesLeft,
    cast(100.0 * sum(case when Attrition = 'Yes' then 1 else 0 end)/ nullif(count(*), 0)as decimal(5,2)) as AttritionRate
from Attrition_Raw.EmployeeAttritionRaw
group by Department
order by AttritionRate desc;






select
    Department,
    JobRole,
    JobLevel,
    count(*) as EmployeeCount
from Attrition_Raw.EmployeeAttritionRaw
group by Department, JobRole, JobLevel
order by Department, JobRole, JobLevel;





select
    EmployeeNumber,
    count(*) as DuplicateCount
from Attrition_Raw.EmployeeAttritionRaw
group by EmployeeNumber
having count(*) > 1
order by DuplicateCount desc;






select
    min(age) as MinimumAge,
    max(age) as MasximumAge ,
    min(YearsAtCompany) as MinimumYearsAtCompany,
    max(YearsAtCompany) as MaximumYearAtCompany
from Attrition_Raw.EmployeeAttritionRaw






select
    YearsAtCompany,
    count(*) as EmployeeCount
from Attrition_Raw.EmployeeAttritionRaw
group by YearsAtCompany
order by YearsAtCompany asc;







select top 5
    YearsAtCompany,
    count(*) as EmployeeCount
from Attrition_Raw.EmployeeAttritionRaw
group by YearsAtCompany
order by EmployeeCount desc;




-- DWH ddl

create table Attrition_DWH.Dim_employee
(
    EmployeeKey int identity(1,1) primary key,
    EmployeeNumber int not null unique,
    Age int,
    AgeGroup varchar(20),
    Gender varchar(10),
    MaritalStatus varchar(20),
    Education int,
    EducationField varchar(50),
    StockOptionLevel int,
    NumCompaniesWorked int,
    DistanceFromHome int
)
go
create table Attrition_DWH.Dim_job
(
    JobKey int identity(1,1) primary key,
    Department varchar(50) not null,
    JobRole varchar(50) not null,
    JobLevel int not null,

    constraint CO_DimJob
        unique (Department, JobRole, JobLevel)
)
go
create table Attrition_DWH.Dim_work_conditions
(
    WorkConditionsKey int identity(1,1) primary key,
    BusinessTravel varchar(30) not null,
    OverTime varchar(5) not null,

    constraint CO_DimWorkConditions
        unique (BusinessTravel, OverTime)
)
go
create table Attrition_DWH.Dim_employee_experience
(
    ExperienceKey int identity(1,1) primary key,
    JobSatisfaction int not null,
    EnvironmentSatisfaction int not null,
    RelationshipSatisfaction int not null,
    WorkLifeBalance int not null,
    JobInvolvement int not null,

    constraint CO_DimEmployeeExperience
        unique (
            JobSatisfaction,
            EnvironmentSatisfaction,
            RelationshipSatisfaction,
            WorkLifeBalance,
            JobInvolvement
        )
)
go
create table Attrition_DWH.Fact_employee_attrition
(
    EmployeeKey int not null primary key,
    JobKey int not null,
    WorkConditionsKey int not null,
    ExperienceKey int not null,
    Attrition varchar(10),
    MonthlyIncome int,
    MonthlyRate int,
    DailyRate int,
    HourlyRate int,
    PercentSalaryHike int,
    TotalWorkingYears int,
    YearsAtCompany int,
    YearsAtCompany_Bins  varchar(20),
    YearsInCurrentRole int,
    YearsSinceLastPromotion int,
    YearsWithCurrManager int,
    TrainingTimesLastYear int,
    PerformanceRating int,

    constraint FK_Fact_Employee foreign key (EmployeeKey) references Attrition_DWH.Dim_employee(EmployeeKey),

    constraint FK_Fact_Job foreign key (JobKey) references Attrition_DWH.Dim_job(JobKey),

    constraint FK_Fact_WorkConditions foreign key (WorkConditionsKey) references Attrition_DWH.Dim_work_conditions(WorkConditionsKey),

    constraint FK_Fact_Experience foreign key (ExperienceKey) references Attrition_DWH.Dim_employee_experience(ExperienceKey),

    constraint CK_Fact_Attrition check (Attrition in ('Yes', 'No'))
)



-----------------------------------------------------       ETL



-- load Dim_employee
-- load new employees into Dim_employee

insert into Attrition_DWH.Dim_employee
(
    EmployeeNumber,
    Age,
    AgeGroup,
    Gender,
    MaritalStatus,
    Education,
    EducationField,
    StockOptionLevel,
    NumCompaniesWorked,
    DistanceFromHome
)
select
    r.EmployeeNumber,
    r.Age,
    case
        when r.Age < 25 then '<25'
        when r.Age between 25 and 34 then '25-34'
        when r.Age between 35 and 44 then '35-44'
        when r.Age between 45 and 54 then '45-54'
        when r.Age >= 55 then '55+'
        else 'Unknown'
    end as AgeGroup,
    r.Gender,
    r.MaritalStatus,
    r.Education,
    r.EducationField,
    r.StockOptionLevel,
    r.NumCompaniesWorked,
    r.DistanceFromHome
from Attrition_Raw.EmployeeAttritionRaw as r
where r.EmployeeNumber is not null
  and not exists -- this is for future loading
  (
      select 1
      from Attrition_DWH.Dim_employee as e
      where e.EmployeeNumber = r.EmployeeNumber
  );

-- make sure that the data was loaded into Attrition_DWH.Dim_employee

select * from Attrition_DWH.Dim_employee

--



-- load Dim_job

insert into Attrition_DWH.Dim_job
(
    Department,
    JobRole,
    JobLevel
)
select distinct
    r.Department,
    r.JobRole,
    r.JobLevel
from Attrition_Raw.EmployeeAttritionRaw as r
where r.Department is not null
  and r.JobRole is not null
  and r.JobLevel is not null
  and not exists
  (
      select 1 -- this is for future loading 
      from Attrition_DWH.Dim_job as j
      where j.Department = r.Department
        and j.JobRole = r.JobRole
        and j.JobLevel = r.JobLevel
  );


  -- make sure that the data was loaded into Attrition_DWH.Dim_job
  select * from Attrition_DWH.Dim_job
  --


-- load Dim_work_conditions

insert into Attrition_DWH.Dim_work_conditions
(
    BusinessTravel,
    OverTime
)
select distinct
    r.BusinessTravel,
    r.OverTime
from Attrition_Raw.EmployeeAttritionRaw as r
where r.BusinessTravel is not null
  and r.OverTime is not null
  and not exists -- this is for future loading
  (
      select 1
      from Attrition_DWH.Dim_work_conditions as w
      where w.BusinessTravel = r.BusinessTravel
        and w.OverTime = r.OverTime
  );



-- make sure that the data was loaded into Attrition_DWH.Dim_work_conditions
select * from Attrition_DWH.Dim_work_conditions order by WorkConditionsKey asc
--



-- load Dim_employee_experience

insert into Attrition_DWH.Dim_employee_experience
(
    JobSatisfaction,
    EnvironmentSatisfaction,
    RelationshipSatisfaction,
    WorkLifeBalance,
    JobInvolvement
)
select distinct
    r.JobSatisfaction,
    r.EnvironmentSatisfaction,
    r.RelationshipSatisfaction,
    r.WorkLifeBalance,
    r.JobInvolvement
from Attrition_Raw.EmployeeAttritionRaw as r
where r.JobSatisfaction is not null
  and r.EnvironmentSatisfaction is not null
  and r.RelationshipSatisfaction is not null
  and r.WorkLifeBalance is not null
  and r.JobInvolvement is not null
  and not exists -- this is for future loading
  (
      select 1
      from Attrition_DWH.Dim_employee_experience as e
      where e.JobSatisfaction = r.JobSatisfaction
        and e.EnvironmentSatisfaction = r.EnvironmentSatisfaction
        and e.RelationshipSatisfaction = r.RelationshipSatisfaction
        and e.WorkLifeBalance = r.WorkLifeBalance
        and e.JobInvolvement = r.JobInvolvement
  );


-- make sure that the data was loaded into Attrition_DWH.Dim_employee_experience

select *
from Attrition_DWH.Dim_employee_experience;
--

--load fact table

-- load employee attrition fact table

insert into Attrition_DWH.Fact_employee_attrition
(
    EmployeeKey,
    JobKey,
    WorkConditionsKey,
    ExperienceKey,
    Attrition,
    MonthlyIncome,
    MonthlyRate,
    DailyRate,
    HourlyRate,
    PercentSalaryHike,
    TotalWorkingYears,
    YearsAtCompany,
    YearsAtCompany_Bins,
    YearsInCurrentRole,
    YearsSinceLastPromotion,
    YearsWithCurrManager,
    TrainingTimesLastYear,
    PerformanceRating
)
select
    e.EmployeeKey,
    j.JobKey,
    w.WorkConditionsKey,
    x.ExperienceKey,
    r.Attrition,
    r.MonthlyIncome,
    r.MonthlyRate,
    r.DailyRate,
    r.HourlyRate,
    r.PercentSalaryHike,
    r.TotalWorkingYears,
    r.YearsAtCompany,

    case
        when r.YearsAtCompany between 0 and 4 then '0-4'
        when r.YearsAtCompany between 5 and 9 then '5-9'
        when r.YearsAtCompany between 10 and 19 then '10-19'
        when r.YearsAtCompany between 20 and 29 then '20-29'
        when r.YearsAtCompany between 30 and 40 then '30-40'
        else 'Unknown'
    end as YearsAtCompany_Bins,

    r.YearsInCurrentRole,
    r.YearsSinceLastPromotion,
    r.YearsWithCurrManager,
    r.TrainingTimesLastYear,
    r.PerformanceRating

from Attrition_Raw.EmployeeAttritionRaw as r

join Attrition_DWH.Dim_employee as e
    on r.EmployeeNumber = e.EmployeeNumber

join Attrition_DWH.Dim_job as j
    on r.Department = j.Department
    and r.JobRole = j.JobRole
    and r.JobLevel = j.JobLevel

join Attrition_DWH.Dim_work_conditions as w
    on r.BusinessTravel = w.BusinessTravel
    and r.OverTime = w.OverTime

join Attrition_DWH.Dim_employee_experience as x
    on r.JobSatisfaction = x.JobSatisfaction
    and r.EnvironmentSatisfaction = x.EnvironmentSatisfaction
    and r.RelationshipSatisfaction = x.RelationshipSatisfaction
    and r.WorkLifeBalance = x.WorkLifeBalance
    and r.JobInvolvement = x.JobInvolvement
where not exists -- this is for future loading
(
    select 1
    from Attrition_DWH.Fact_employee_attrition as f
    where f.EmployeeKey = e.EmployeeKey
);


-- make sure that the data was loaded into Attrition_DWH.Fact_employee_attrition

select * from HR_Attrition.Attrition_DWH.Fact_employee_attrition

--




-------------------------------------------------------------    validation

-- validate row counts
select
    (select count(*) from Attrition_Raw.EmployeeAttritionRaw) as RawRows,

    (select count(distinct EmployeeNumber) from Attrition_Raw.EmployeeAttritionRaw) as UniqueEmployees,

    (select count(*) from Attrition_DWH.Dim_employee) as DimEmployees,

    (select count(*) from Attrition_DWH.Fact_employee_attrition) as FactRows;


-- check for missing employees in fact table
select e.EmployeeNumber
from Attrition_DWH.Dim_employee as e
left join Attrition_DWH.Fact_employee_attrition as f
    on e.EmployeeKey = f.EmployeeKey
where f.EmployeeKey is null;


-- compare attrition results
select
    'Raw' as DataSource,
    Attrition,
    count(*) as EmployeeCount
from Attrition_Raw.EmployeeAttritionRaw
group by Attrition

union all

select
    'DWH' as DataSource,
    Attrition,
    count(*) as EmployeeCount
from Attrition_DWH.Fact_employee_attrition
group by Attrition;






-- dims and fact validation


select
    'Dim_job' as TableName,

    (select count(*)
     from (
         select distinct Department, JobRole, JobLevel
         from Attrition_Raw.EmployeeAttritionRaw
         where Department is not null
           and JobRole is not null
           and JobLevel is not null
     ) as j) as ExpectedRows,

    (select count(*)
     from Attrition_DWH.Dim_job) as ActualRows

union all

select
    'Dim_work_conditions' as TableName,

    (select count(*)
     from (
         select distinct BusinessTravel, OverTime
         from Attrition_Raw.EmployeeAttritionRaw
         where BusinessTravel is not null
           and OverTime is not null
     ) as w) as ExpectedRows,

    (select count(*)
     from Attrition_DWH.Dim_work_conditions) as ActualRows

union all

select
    'Dim_employee_experience' as TableName,

    (select count(*)
     from (
         select distinct
             JobSatisfaction,
             EnvironmentSatisfaction,
             RelationshipSatisfaction,
             WorkLifeBalance,
             JobInvolvement
         from Attrition_Raw.EmployeeAttritionRaw
         where JobSatisfaction is not null
           and EnvironmentSatisfaction is not null
           and RelationshipSatisfaction is not null
           and WorkLifeBalance is not null
           and JobInvolvement is not null
     ) as x) as ExpectedRows,

    (select count(*)
     from Attrition_DWH.Dim_employee_experience) as ActualRows

union all

SELECT
    'Dim_employee' as TableName,
    (SELECT COUNT(DISTINCT EmployeeNumber)
     FROM Attrition_Raw.EmployeeAttritionRaw
     WHERE EmployeeNumber IS NOT NULL) AS ExpectedRows,

    (SELECT COUNT(*)
     FROM Attrition_DWH.Dim_employee) AS ActualRows


union all


select
    'Fact_employee_attrition' as TableName,

    (select count(*)
     from Attrition_Raw.EmployeeAttritionRaw) as ExpectedRows,

    (select count(*)
     from Attrition_DWH.Fact_employee_attrition) as ActualRows;




-------------------------------  stored prosedure to call it whenever i want to add new data ( incremental load )





create procedure Attrition_DWH.sp_Incremental_Load
as
begin
    set nocount on;

    begin try
        begin transaction;

        -- load Dim_employee

        insert into Attrition_DWH.Dim_employee
        (
            EmployeeNumber,
            Age,
            AgeGroup,
            Gender,
            MaritalStatus,
            Education,
            EducationField,
            StockOptionLevel,
            NumCompaniesWorked,
            DistanceFromHome
        )
        select
            r.EmployeeNumber,
            r.Age,
            case
                when r.Age < 25 then '<25'
                when r.Age between 25 and 34 then '25-34'
                when r.Age between 35 and 44 then '35-44'
                when r.Age between 45 and 54 then '45-54'
                when r.Age >= 55 then '55+'
                else 'Unknown'
            end,
            r.Gender,
            r.MaritalStatus,
            r.Education,
            r.EducationField,
            r.StockOptionLevel,
            r.NumCompaniesWorked,
            r.DistanceFromHome
        from Attrition_Raw.EmployeeAttritionRaw as r
        where r.EmployeeNumber is not null
          and not exists (
              select 1
              from Attrition_DWH.Dim_employee as e
              where e.EmployeeNumber = r.EmployeeNumber
          );


        -- load Dim_job

        insert into Attrition_DWH.Dim_job
        (
            Department,
            JobRole,
            JobLevel
        )
        select distinct
            r.Department,
            r.JobRole,
            r.JobLevel
        from Attrition_Raw.EmployeeAttritionRaw as r
        where r.Department is not null
          and r.JobRole is not null
          and r.JobLevel is not null
          and not exists (
              select 1
              from Attrition_DWH.Dim_job as j
              where j.Department = r.Department
                and j.JobRole = r.JobRole
                and j.JobLevel = r.JobLevel
          );


        -- load Dim_work_conditions

        insert into Attrition_DWH.Dim_work_conditions
        (
            BusinessTravel,
            OverTime
        )
        select distinct
            r.BusinessTravel,
            r.OverTime
        from Attrition_Raw.EmployeeAttritionRaw as r
        where r.BusinessTravel is not null
          and r.OverTime is not null
          and not exists (
              select 1
              from Attrition_DWH.Dim_work_conditions as w
              where w.BusinessTravel = r.BusinessTravel
                and w.OverTime = r.OverTime
          );


        -- load Dim_employee_experience

        insert into Attrition_DWH.Dim_employee_experience
        (
            JobSatisfaction,
            EnvironmentSatisfaction,
            RelationshipSatisfaction,
            WorkLifeBalance,
            JobInvolvement
        )
        select distinct
            r.JobSatisfaction,
            r.EnvironmentSatisfaction,
            r.RelationshipSatisfaction,
            r.WorkLifeBalance,
            r.JobInvolvement
        from Attrition_Raw.EmployeeAttritionRaw as r
        where r.JobSatisfaction is not null
          and r.EnvironmentSatisfaction is not null
          and r.RelationshipSatisfaction is not null
          and r.WorkLifeBalance is not null
          and r.JobInvolvement is not null
          and not exists (
              select 1
              from Attrition_DWH.Dim_employee_experience as e
              where e.JobSatisfaction = r.JobSatisfaction
                and e.EnvironmentSatisfaction = r.EnvironmentSatisfaction
                and e.RelationshipSatisfaction = r.RelationshipSatisfaction
                and e.WorkLifeBalance = r.WorkLifeBalance
                and e.JobInvolvement = r.JobInvolvement
          );


        -- load Fact_employee_attrition

        insert into Attrition_DWH.Fact_employee_attrition
        (
            EmployeeKey,
            JobKey,
            WorkConditionsKey,
            ExperienceKey,
            Attrition,
            MonthlyIncome,
            MonthlyRate,
            DailyRate,
            HourlyRate,
            PercentSalaryHike,
            TotalWorkingYears,
            YearsAtCompany,
            YearsAtCompany_Bins,
            YearsInCurrentRole,
            YearsSinceLastPromotion,
            YearsWithCurrManager,
            TrainingTimesLastYear,
            PerformanceRating
        )
        select
            e.EmployeeKey,
            j.JobKey,
            w.WorkConditionsKey,
            x.ExperienceKey,
            r.Attrition,
            r.MonthlyIncome,
            r.MonthlyRate,
            r.DailyRate,
            r.HourlyRate,
            r.PercentSalaryHike,
            r.TotalWorkingYears,
            r.YearsAtCompany,
            case
                when r.YearsAtCompany between 0 and 4 then '0-4'
                when r.YearsAtCompany between 5 and 9 then '5-9'
                when r.YearsAtCompany between 10 and 19 then '10-19'
                when r.YearsAtCompany between 20 and 29 then '20-29'
                when r.YearsAtCompany between 30 and 40 then '30-40'
                else 'Unknown'
            end,
            r.YearsInCurrentRole,
            r.YearsSinceLastPromotion,
            r.YearsWithCurrManager,
            r.TrainingTimesLastYear,
            r.PerformanceRating

        from Attrition_Raw.EmployeeAttritionRaw as r

        join Attrition_DWH.Dim_employee as e
            on r.EmployeeNumber = e.EmployeeNumber

        join Attrition_DWH.Dim_job as j
            on r.Department = j.Department
           and r.JobRole = j.JobRole
           and r.JobLevel = j.JobLevel

        join Attrition_DWH.Dim_work_conditions as w
            on r.BusinessTravel = w.BusinessTravel
           and r.OverTime = w.OverTime

        join Attrition_DWH.Dim_employee_experience as x
            on r.JobSatisfaction = x.JobSatisfaction
           and r.EnvironmentSatisfaction = x.EnvironmentSatisfaction
           and r.RelationshipSatisfaction = x.RelationshipSatisfaction
           and r.WorkLifeBalance = x.WorkLifeBalance
           and r.JobInvolvement = x.JobInvolvement

        where 
        r.Attrition in ('Yes', 'No')
        and
        not exists (
              select 1
              from Attrition_DWH.Fact_employee_attrition as f
              where f.EmployeeKey = e.EmployeeKey
          );

        commit transaction;

        print 'Incremental ETL completed successfully';

    end try
    begin catch

        if @@trancount > 0
            rollback transaction;

        throw;

    end catch
end;



-- in order to call it 

exec Attrition_DWH.sp_Incremental_Load;


