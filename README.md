# Tool_Tool_ScriptDiagram #
***This is a fork of [Script SQL Server 2008 diagrams to a file](http://web.archive.org/web/20130427102921/http://www.conceptdevelopment.net/Database/Tool_ScriptDiagram2008/).***

## Introduction ##
1. SQL Server allows you to draw diagrams of your schema
1. The diagrams are stored in a binary format in `dbo.sysdiagrams`
1. That data is backed-up/restored with the actual database, but there is NO SUPPORTED METHOD to save to a file. This is where `Tool_ScriptDiagram` is used: to extract the data into text format.
1. Re-create diagram from the Tool_ScriptDiagram generated script
1. Tool_ScriptDiagram allows you to 'extract' the binary data from dbo.sysdiagrams into a text format that can be saved to disk and added to source control. It saves the data in the form of INSERT statements that re-create the diagram's binary data directly into dbo.[sysdiagrams]

## Usage ##
1. Create a new diagram using Sql Server Management Studio
1. Add tables to diagram
1. Arrange tables and add text to diagram
1. SQL Server 'hides' the diagram data in binary format in `dbo.sysdiagrams`
1. `EXEC Tool_ScriptDiagram 'YourDiagramName`' produces output in the Messages window, which is in fact an SQL script itself (ie. code generation!)
1. The messages window is the text-version of the diagram. You can save this file to disk, add it to source control, etc. You can also run the script back on the source database to test it worked - simply copy the script up into the query window and Execute it.
1. If the script failed to run successfully it will print an error message.
6. Refresh the Diagrams folder
Refresh the Diagrams folder
7. The scripted diagram has been re-created!

**Protip:** Include sysdiagrams.sql in your project to suppress SSDT warnings if your diagram is set to Build Action=Compile

# Tool_GrantRole #
Unrelated utitility for setting up user accounts in SQL databases with all the steps that are easy to miss. 
Was formerly a gist but keeping here for better source control.