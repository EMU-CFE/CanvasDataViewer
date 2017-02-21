###Welcome to CanvasDataViewer!

Our project is used to automatically download Canvas Data files into a SQL Server database where you can query and analyze the information.  Canvas is a proprietary learning management system widely used in higher education and K12, and Canvas Data is the big data service that allows you to download all user activity data for your own use.  

Canvas Data files are very large--currently a full download includes at least one file for each of 63 tables, and some tables require more than one file.  For a large campus each daily download can include more than 8GB of files that contain millions of database records.  Manually downloading Canvas Data files from the Canvas web interface and loading them into a database can take hours.  Our CanvasDataViewer automates this process.  When set up with a SQL job agent to run the process at night, you can come to work every morning with fresh Canvas Data waiting for you to analyze.

###Who will find this useful?  

We think the most likely use case will be campuses that want to evaluate the Canvas Data product as a source of information for teachers and program managers.  When schools implement a long-term Canvas Data program they will most likely want to purchase a license for a hosted data repository like Amazon Redshift that can automatically accept Canvas Data.  
CanvasDataViewer may be suitable for long-term use--we have built the system to download the latest data schema from Canvas and built the database table to suit.  But we have seen the Canvas Data service change over time, so we can't be sure that our application won't break at some point and need updates.

###What do I need?

CanvasDataViewer need to be installed on Microsoft SQL Server, preferably SQL Server 2012 or later.  You cannot use the free SQL Server Express product because it has a 10GB limit.  All other components, like the node.js libraries, can be downloaded for free.

###Who needs to set it up and how long will it take?

The initial setup needs to be performed by a SQL Server administrator--someone who knows their way around SQL Server Management Studio and Windows Server.  The basic setup can be done in a few hours, although some users may run into problems that can make it a multi-day project.

