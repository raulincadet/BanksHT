# Web Scraping  and Data Wrangling of Banks Quarterly Financial Statements

![GitHub top language](https://img.shields.io/github/languages/top/raulincadet/BanksHT?style=plastic)
![GitHub repo size](https://img.shields.io/github/repo-size/raulincadet/BanksHT?color=green)
![GitHub language count](https://img.shields.io/github/languages/count/raulincadet/BanksHT?style=plastic)
![Lines of code](https://img.shields.io/tokei/lines/github/raulincadet/BanksHT?color=orange&style=plastic)

## About the repository
This repository is a first part of a personal project to collect and structured financial data related to Haitian banking system. Quarterly report are provided by the Haitian central bank on its website, as xls and xlsx files. At that time, they are almost 100 files. Since they are not adequatly formatted to be used as provided, these data are rarely used. However, since it is a major sector of the economy, it is crucial to be able to monitor the banking industry financial condition. The first part of the project intends to:
1) Automate the downloading of the quarterly reports(approximately 100), from the website of the central bank;
2) Clean and structured balance sheets income statements data, then gathereed each type of these financial statements as into panel data (by bank and by quarter);
3) Clean, structured and gathered data related to the number of employees to be structured as a panel data (by bank and by quarter).

Structured data, resulted from this first part of the project, is used to build a dashboard. The code of the second phase of the project is available in [another repository](https://github.com/raulincadet/BanksHT_dashboard). The dashboard can be found [HERE](https://cours.shinyapps.io/BanksHT_dashboard/).

## Method
While R is used to download the excel files, a greater part of the job is done with Python. Indeed, Python is used to cleaned and structured data. Financial data related to the banks, provided on the website of the central banks are not structured as time series data. Each excel file contains many sheets, with different kinds of financial data. My targets were the balance sheet and the income statement. I should have chronological data for
each variable of the reports, to be able to plot their trends. In this regards, several Python functions have been written to import data from
the excel files, cleaning and gathering them as panel data (by quarters and by banks). 

### Packages and modules
The packages and modules used for each one of these programming languages are shown below.

1. R
   * stringi
   * XML
3. Python
   * calendar
   * datetime
   * dateutil
   * numpy
   * math
   * pandas
   * unicode
    
### Challenges
I had to face some challenges to realize this phase of the projects. Indeed, although the excel files seems to be similar, it is not always the case. There are some other challenges. They are mentionned below:
  * There are some discrepancies, from a quarterly report to another, in the names of the months and years that constitute a part of the names of the excel files sheets where the balance sheet data are provided;
  * There is a few discrepancy related to the variable names in the balance sheet and the income statement of a quarterly report;
  * Considering a financial report, for example, the balance sheet, the number of rows and columns to be considered varies from a quarter to another, for several reasons: 
      * One report may have more or less banks than another, because some banks have failed or acquir1ed by another one;
      * One report may have more empty rows than another one  
  * For several rows of the balance sheet, the name of the variable is "other", meanningful for human being, since "other" is usually indented, meaning it is related to the variable name of the previous row (variable are presented by row in the excel files);

### Process
1) Since the balance sheet, the income statement, and the number of employees do not have the same structure, for each one of them a function have been written to import, clean and structure data
2) A function is written to verify if the previous functions work well for each one of the excel files. In this regard, if a function does not work for one or several of the excel files, a message (debuging it). 
3) Another function that account for the first one that should import and clean data, does a loop to do this task for all excel files containing the reports and gathering data in one data frame.
4) Duplicated data are removed from data gathered
5) The data frame of each financial statement (balance sheet, income statement)kj;ladrqjr and the number of employees, are save in csv file. This is the last kask using Python.
6) Back to R file, cvs files are imported, and some additional manipulations are done to structure data as a panel of all variables found in the 3 datasets fo balance sheet, income statement, and number of employees.
7) The new dataset is saved as a rda file, to be used in the second phase of the project, to build the [dashboard](https://cours.shinyapps.io/BanksHT_dashboard/).

## Result
1) The result of this phase of the project is three datasets in cvs files, one containing panel data of the balance sheets, another one the income statements, and the number of employees. Each dataset is structured as a panel data, by bank and by quarter.
2) A dataset of all the variables retrieved from the previous dataset, saved in a rda file.

