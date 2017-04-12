# Welcome to CanvasDataViewer!

## Project Description

Our project is used to automatically download Canvas Data files into a SQL Server database where you can query and analyze the information.  Canvas is a proprietary learning management system widely used in higher education and K12, and Canvas Data is the big data service that allows you to download all user activity data for your own use.  

Canvas Data files are very large--currently a full download includes at least one file for each of 82 tables, and some tables require more than one file.  For a large campus each daily download can include more than 8GB of files that contain millions of database records.  Manually downloading Canvas Data files from the Canvas web interface and loading them into a database can take hours.  Our CanvasDataViewer automates this process.  When set up with a SQL job agent to run the process at night, you can come to work every morning with fresh Canvas Data waiting for you to analyze.

### Who will find this useful?  

We think the most likely use case will be campuses that want to evaluate the Canvas Data product as a source of information for teachers and program managers.  When schools implement a long-term Canvas Data program they will most likely want to purchase a license for a hosted data repository like Amazon Redshift that can automatically accept Canvas Data.  
CanvasDataViewer may be suitable for long-term use--we have built the system to download the latest data schema from Canvas and built the database table to suit.  But we have seen the Canvas Data service change over time, so we can't be sure that our application won't break at some point and need updates.

### What do I need?

CanvasDataViewer need to be installed on Microsoft SQL Server, preferably SQL Server 2012 or later.  You cannot use the free SQL Server Express product because it has a 10GB limit.  All other components, like the node.js libraries, can be downloaded for free.

### Who needs to set it up and how long will it take?

The initial setup needs to be performed by a SQL Server administrator--someone who knows their way around SQL Server Management Studio and Windows Server.  The basic setup can be done in a few hours, although some users may run into problems that can make it a multi-day project.

## Installation

### Requirements

*	Windows OS 
   *	Windows 7 or newer 
   *	–  or  –   
   *	Windows 2012 Server or newer
   *	4GB+ RAM (2GB will run too slow)
*	Admin privileges on the user account
   *	Many instructions tell you to “Run as Admin”
   *	Usually you right-click on the file and “Run as Admin” is a menu choice
*	7-zip (http://www.7-zip.org)
   *	Required in the scripts that automatically decompress the Canvas Data files
  
### Step 1 – Install SQL Server

*	Require SQL Server 2012 or higher

### Step 2 – Enable xpcmdshell

*	Execute the following TSQL as a SQL Server admin (copy/paste into a New Query screen and run)
EXEC sp_configure 'show advanced options', 1
GO
RECONFIGURE
GO
EXEC sp_configure 'xp_cmdshell', 1
GO
RECONFIGURE
GO

### Step 3 – Install Node.js

1.	Download and install Node.js
    a.	Link: https://nodejs.org/en/
    b.	Select the “LTS” (long time support) version recommended for most users
    c.	Install with the standard “out of box” options

### Step 4 – Download and Unzip EMU CDV

1.	Download and install EMU’s Canvas Data Viewer (CDV)
    a.	Link: https://github.com/EMU-CFE/CanvasDataViewer
    b.	Download CDV.zip
    c.	Extract all files to your preferred location
  
### Step 5– Gather configuration information

1.	Use the SampleConfigurationInputs.txt file to collect your configuration information.  
2.	Items needed:
   a.	Your Node.js install path (example: C:\Program Files\nodejs)
   b.	Your Canvas Data credentials (from the Canvas Data Portal menu in your Canvas site)
      i. Canvas Data API Secret
      ii. Canvas Data API Key
   c.	Your SQL Server Information
      i. Server Instance Name
      ii. Server account user name (example: sa)
      iii. Server account user password
    
### Step 6 – Install the required Node.js modules
From the CanvasDataViewer folder that you unzipped 

1.	Copy mods.bat file to the Node.js directory (C:\Program Files\nodejs)
2.	Right-click mods.bat and Run as Administrator
3.	(This will download/install the Node.js modules (extensions) that CanvasDataViewer needs)

### Step 7 – Install the CanvasDataViewer JavaScript files
1.	Copy/paste to the Node.js directory (C:\Program Files\nodejs) 
    a.	AutoConfig.bat
    b.	AutoConfig.ps1
    c.	CanvasData_Schema_Latest.cdconfig
    d.	CanvasData_Tables_Latest.cdconfig
    e.	CanvasDataAuth_Schema.cdconfig
    f.	CanvasDataAuth_Tables.cdconfig 
2.	Right-click Run AutoConfig.bat and Run as Administrator
3.	Enter your configuration information as gathered from Step 5 (this step will modify the scripts and insert the information you provided)

### Step 8 – Create CanvasDataStore database in SQL Server

CanvasDataStore is a SQL Server database that houses Canvas Data and the stored procedures that download and install the data.

1.	Open SQL Server Management Studio
2.	In the ObjectExplorer click on Connect and select your database engine that you installed
3.	In the database engine, right-click on Databases and select New Database
4.	In Database Name enter “CanvasDataStore” and click OK (Leave all other settings as default. You must use this name because it is hard-coded into all the scripts.)
5.	Right-click on Databases and click Refresh to make sure CanvasDataStore has appeared
6.	In the top menu click on File > Open > File.  In the dialog box, find/highlight the CanvasDataStore_mmddyy_hhmm.sql ... file in the CDV scripts. The script should open in a New Query window.  Click Execute (F5).
7.	(N.B. The “Warning! The maximum key length is 900 bytes. …” error message is expected.  It doesn’t affect the installation and we’re working on eliminating it.)
8.	Open the CanvasDataStore database to confirm that tables have installed.

### Step 9 – Run the datafile download and database loading

1.	Open SQL Server Management Studio
2.	In the ObjectExplorer open the CanvasDataStore database and go to CanvasDataStore/Programmability/Stored Procedures
3.	Right-click on dbo.CanvasData_General_DownloadLatestSchemaAndTables and click “Execute Stored Procedure…”.  This process accesses Canvas API endpoints to download the current Canvas Data table schema.  It also downloads all the actual Canvas Data data, which is packaged in comma-delimited text files.  This can take up to an hour or more.
4.	Right-click on dbo.CanvasData_General_TableBuild and click “Execute Stored Procedure…”.  This process creates tables to hold the data according to the latest schema.  Then it loads all the datafiles into import tables.  Finally it transfers all the data to production tables and builds indexes on them to aid searching.  This process can take several hours depending on the amount of data in your instance.

### Step 10 - Set up SQL Server Agent Jobs

SQL Server Agent is a scheduler system that can run processes automatically.  

* Open SQL Server Agent
* Right-click on Jobs and select New Job
* Enter the following info:
  * General/Name
  * Steps - click on New:
    * Step Name
    * Database - change to CanvasDataStore
    * In Command window - "EXEC dbo.CanvasDataStore_General_DownloadLatestSchemaAndTables"
    * Click OK
  * Schedules - click on New:
    * Name
    * Frequency - "Daily"
    * Daily frequency - 1:00 AM
    * Click OK

Repeat this process to create a job for *dbo.CanvasData_General_TableBuild* at 2:00 AM

### Step 11 – Create CanvasDataLevel1 database in SQL Server

CanvasDataLevel1 is a SQL Server database that contains views to query Canvas Data.  These views all draw on data in the CanvasDataStore database. (CanvasDataLevel1 doesn't store any data of its own.)

You need to install CanvasDataLevel1 *after* you've successfully downloaded your Canvas Data into CanvasDataStore.  Otherwise the install will fail.

1.	Open SQL Server Management Studio
2.	In the ObjectExplorer click on Connect and select your database engine that you installed
3.	In the database engine, right-click on Databases and select New Database
4.	In Database Name enter “CanvasDataLevel1” and click OK (Leave all other settings as default. You must use this name because it is hard-coded into all the scripts.)
5.	Right-click on Databases and click Refresh to make sure CanvasDataLevel has appeared
6.	In the top menu click on File > Open > File.  In the dialog box, find/highlight the CanvasDataLevel1_mmddyy_hhmm.sql ... file in the CDV scripts. The script should open in a New Query window.  Click Execute (F5).
7.	Open the CanvasDataLevel1 database to confirm that the views have installed.

## Contributing

## Credits

* Bill Jones
* Andrew Anders

## Licensing
