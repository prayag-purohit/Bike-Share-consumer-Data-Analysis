###Combining Files
cd 'D:\Google Project\SourceFiles'
copy*.csv mergedfiles-CyclisticCaseStudy-2021.csv

###Uploading files to Mysql server
mysql -u root -p --local-infile
********

SET GLOBAL local_infile = true;
SHOW Global variables like 'local_infile';
USE GoogleDB

LOAD DATA LOCAL INFILE 'D:/Google Project/mergedfiles-CyclisticCaseStudy-2021.csv' INTO TABLE combined_data
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
