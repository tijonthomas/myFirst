-- selecting the second largest
select MAX (fob_id) from FOB where fob_id < (select MAX (fob_id) from FOB)
-- selecting the second lowest
select MIN(FOB_ID) from FOB where FOB_ID>(select MIN(FOB_ID) from FOB)

--The GROUP BY clause is a SQL command that is used to group rows that have the same values.
--SELECT statements… GROUP BY column_name1[,column_name2,…] [HAVING condition];
--It’s not always that we will want to perform groupings on all the data in a given table. There will be times when we will want to restrict our results to a certain given criteria.  In such cases , we can use the HAVING clause
select FOB_NAME from FOB group by FOB_NAME order by FOB_NAME

--“LIKE” is the comparison operator that is used in conjunction with wildcards
--‘xxx’ is any specified starting pattern such as a single character or more and “%” matches any number of characters starting from zero (0).
SELECT * FROM  members  WHERE postal_address  LIKE '% TX';

--The NOT logical operator can be used together with the wildcards to return rows that do not match the specified pattern.
SELECT * FROM movies WHERE year_released NOT LIKE '200_';

--The underscore wildcard is used to match exactly one character
SELECT * FROM movies WHERE year_released LIKE '200_';

--“REGEXP ‘pattern’” - REGEXP is the regular expression operator and ‘pattern’ represents the pattern to be matched by REGEXP.
--SELECT statements… WHERE fieldname REGEXP ‘pattern’;
SELECT * FROM `movies` WHERE `title` REGEXP 'code';
--searches for all the movie titles that have the word code in them. It does not matter whether the “code” is at the beginning, middle or end of the title. As long as it is contained in the title then it will be considered.

SELECT * FROM `movies` WHERE `title` REGEXP '^[abcd]';
--‘^[abcd]’ the caret (^) means that the pattern match should be applied at the beginning and the charlist [abcd] means that only movie titles that start with a, b, c or d are returned in our result set.

SELECT * FROM `movies` WHERE `title` REGEXP '^[^abcd]';
--‘^[^abcd]’ the caret (^) means that the pattern match should be applied at the beginning and the charlist [^abcd] means that the movie titles starting with any of the enclosed characters is excluded from the result set.

select * from information_schema.tables where table_name like '%%'
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME LIKE '%%'


Searched CASE expression with SELECT statement
 SELECT
   Name, Marks, 'Division' =
   CASE 
    WHEN Marks < 350 THEN 'Fail'
    WHEN Marks >= 350 AND Marks < 450 THEN ' THIRD'
    WHEN Marks >=450 AND Marks < 550 THEN 'SECOND'
    WHEN Marks >=550 AND Marks < 650 THEN 'FIRST'
    ELSE 'Excelent'
   END
 FROM
     Student; 
