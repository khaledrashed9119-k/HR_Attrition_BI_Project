use HR_Attrition

select Department, count(*) as Attrition_Count
from HR_Attrition.Attrition_Raw.EmployeeAttritionRaw
where Attrition = 'Yes'
group by Department
order by Attrition_Count desc;