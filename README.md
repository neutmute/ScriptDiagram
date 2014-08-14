# Tool_ScriptDiagram #
***This is a fork of [Script SQL Server 2008 diagrams to a file](http://web.archive.org/web/20130427102921/http://www.conceptdevelopment.net/Database/Tool_ScriptDiagram2008/).***

## Introduction ##
1. SQL Server allows you to draw diagrams of your schema
1. The diagrams are stored in a binary format in `dbo.sysdiagrams`
1. That data is backed-up/restored with the actual database, but there is no supported method to save the representation of the diagram. 
1. `Tool_ScriptDiagram` allows you to extract the binary data from dbo.sysdiagrams into a text format that can be saved to disk, added to source control and your database build. It saves the data in the form of INSERT statements that re-create the diagram's binary data directly into dbo.sysdiagrams.

## Usage ##
1. Create a new diagram using Sql Server Management Studio
1. Add tables to the diagram
1. Arrange tables and add text to diagram
1. SQL Server hides the diagram data in binary format in `dbo.sysdiagrams`. The hiding is done via an extended property.
1. `EXEC Tool_ScriptDiagram 'YourDiagramName`' produces output in the Messages window, which is itself a SQL script
1. The messages window is the text-version of the diagram. You can save this file to disk, add it to source control, your SSDT database build. You can also run the script back on the source database to test it worked - simply copy the script up into the query window and execute it.
1. If the script failed to run it will print an error message.
6. Refresh the Diagrams folder
7. The scripted diagram has been re-created!

**Protip:** if your diagram script is set to Build Action=Compile, include sysdiagrams.sql in your project to suppress SSDT warnings.

# Tool_GrantRole #
Unrelated utility for setting up user accounts in SQL databases with all the steps that are easy to miss. 
Was formerly a gist but keeping here for better source control.