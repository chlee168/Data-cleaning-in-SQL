select * from dbo.usedcar

--Change the name of the table
EXEC sp_rename ['Used Car Dataset$'], 'usedcar';

--Change column 1 "F1" to "car_id"
EXEC sp_rename 'dbo.usedcar.F1', 'car_id', 'COLUMN';

--Separate 'car_name' to 'car_year','car_brand' and 'car_model'

alter table dbo.usedcar
add car_year int ,car_brand nvarchar(100), car_model nvarchar(100)

update dbo.usedcar
Set car_year = left(car_name,CHARINDEX(' ',car_name)),
    car_brand = SUBSTRING(car_name,5,CHARINDEX(' ',car_name,6)-CHARINDEX(' ',car_name)),
	car_model = SUBSTRING(car_name,charindex(' ',car_name,6),LEN(car_name)-charindex(' ',car_name,6))

--Adjust the format in registration year and add a new column "registration_date"
alter table dbo.usedcar
add registration_date date

update dbo.usedcar
set registration_date = convert(date,registration_year)

--Rearrange car_id to start from "1" instead of "0"
update dbo.usedcar
set car_id =  car_id +1

--format the price column
EXEC sp_rename 'dbo.usedcar.price(in lakhs)', 'price', 'COLUMN';

ALTER TABLE dbo.usedcar
ALTER COLUMN price DECIMAL(18, 2);


UPDATE dbo.usedcar
SET price = price* 100000

select replace(format(price *100000,'c'),',000.00','k') from dbo.usedcar

--Format the "ownsership" column and uncertain value 
EXEC sp_rename 'dbo.usedcar.ownsership', 'ownership', 'COLUMN';

update dbo.usedcar
set ownership = 
       case when ownership = 'First Owner' then '1st'
         when ownership = 'Second Owner' then '2nd'
		 when ownership = 'Third Owner' then '3rd'
		 else 'not sure' end

select *
from dbo.usedcar



--Check if there are duplicates
select distinct car_brand,car_model 
from dbo.usedcar
order by car_brand







