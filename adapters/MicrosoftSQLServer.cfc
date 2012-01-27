<cfcomponent extends="Abstract">

	<cfset variables.sqlTypes = {}>
	<cfset variables.sqlTypes['binary'] = {name='IMAGE'}>
	<cfset variables.sqlTypes['boolean'] = {name='BIT'}>
	<cfset variables.sqlTypes['date'] = {name='DATETIME'}>
	<cfset variables.sqlTypes['datetime'] = {name='DATETIME'}>
	<cfset variables.sqlTypes['decimal'] = {name='DECIMAL'}>
	<cfset variables.sqlTypes['float'] = {name='FLOAT'}>
	<cfset variables.sqlTypes['integer'] = {name='INT'}>
	<cfset variables.sqlTypes['string'] = {name='VARCHAR',limit=255}>
	<cfset variables.sqlTypes['text'] = {name='TEXT'}>
	<cfset variables.sqlTypes['time'] = {name='DATETIME'}>
	<cfset variables.sqlTypes['timestamp'] = {name='DATETIME'}>

	<cffunction name="adapterName" returntype="string" access="public" hint="name of database adapter">
		<cfreturn "MicrosoftSQLServer">
	</cffunction>

	<cffunction name="addPrimaryKeyOptions" returntype="string" access="public">
		<cfargument name="sql" type="string" required="true" hint="column definition sql">
		<cfargument name="options" type="struct" required="false" default="#StructNew()#" hint="column options">
		<cfscript>
		if (StructKeyExists(arguments.options, "null") && arguments.options.null)
			arguments.sql = arguments.sql & " NULL";
		else
			arguments.sql = arguments.sql & " NOT NULL";
		
		if (StructKeyExists(arguments.options, "autoIncrement") && arguments.options.autoIncrement)
			arguments.sql = arguments.sql & " IDENTITY(1,1)";
		
		arguments.sql = arguments.sql & " PRIMARY KEY";
		</cfscript>
		<cfreturn arguments.sql>
	</cffunction>
    
    <cffunction name="primaryKeyConstraint" returntype="string" access="public">
    	<cfargument name="name" type="string" required="true">
        <cfargument name="primaryKeys" type="array" required="true">
        <cfscript>
        var loc = {};
		
		loc.sql = "CONSTRAINT [PK_#arguments.name#] PRIMARY KEY CLUSTERED (";
		
		for (loc.i = 1; loc.i lte ArrayLen(arguments.primaryKeys); loc.i++)
		{
			if (loc.i != 1) 
				loc.sql = loc.sql & ", "; 
			loc.sql = loc.sql & arguments.primaryKeys[loc.i].toColumnNameSQL() & " ASC";
		}
		
		loc.sql = loc.sql & ")"; 
        </cfscript>
        <cfreturn loc.sql />
    </cffunction>

	<!---  SQL Server uses square brackets to escape table and column names --->
	<cffunction name="quoteTableName" returntype="string" access="public" hint="surrounds table or index names with quotes">
		<cfargument name="name" type="string" required="true" hint="column name">
		<cfreturn "[#Replace(arguments.name,".","`.`","ALL")#]">
	</cffunction>

	<cffunction name="quoteColumnName" returntype="string" access="public" hint="surrounds column names with quotes">
		<cfargument name="name" type="string" required="true" hint="column name">
		<cfreturn "[#arguments.name#]">
	</cffunction>

	<!--- createTable - use default --->
	
	<cffunction name="renameTable" returntype="string" access="public" hint="generates sql to rename a table">
		<cfargument name="oldName" type="string" required="true" hint="old table name">
		<cfargument name="newName" type="string" required="true" hint="new table name">
		<cfreturn "EXEC sp_rename '#arguments.oldName#', '#arguments.newName#'">
	</cffunction>

	<cffunction name="dropTable" returntype="string" access="public" hint="generates sql to drop a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfreturn "IF EXISTS(SELECT name FROM sysobjects WHERE name = N'#LCase(arguments.name)#' AND xtype='U') DROP TABLE #quoteTableName(LCase(arguments.name))#">
	</cffunction>
	
	<cffunction name="addColumnToTable" returntype="string" access="public" hint="generates sql to add a new column to a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="column" type="any" required="true" hint="column definition object">
		<cfreturn "ALTER TABLE #quoteTableName(LCase(arguments.name))# ADD #arguments.column.toSQL()#">
	</cffunction>
	
	<cffunction name="changeColumnInTable" returntype="string" access="public" hint="generates sql to change an existing column in a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="column" type="any" required="true" hint="column definition object">
		<cfreturn "ALTER TABLE #quoteTableName(LCase(arguments.name))# ALTER COLUMN #arguments.column.toSQL()#">
	</cffunction>
	
	<cffunction name="renameColumnInTable" returntype="string" access="public" hint="generates sql to rename an existing column in a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="columnName" type="string" required="true" hint="old column name">
		<cfargument name="newColumnName" type="string" required="true" hint="new column name">
		<cfreturn "EXEC sp_rename '#LCase(arguments.name)#.#arguments.columnName#', '#arguments.newColumnName#'">
	</cffunction>
	
	<!--- dropColumnFromTable - use default --->
	
	<!--- addForeignKeyToTable - use default --->
	
	<cffunction name="dropForeignKeyFromTable" returntype="string" access="public" hint="generates sql to add a foreign key constraint to a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="keyName" type="any" required="true" hint="foreign key name">
		<cfreturn "ALTER TABLE #quoteTableName(LCase(arguments.name))# DROP CONSTRAINT #arguments.keyname#">
	</cffunction>
	
	<!--- foreignKeySQL - use default --->
	
	<!--- addIndex - use default --->
	
	<cffunction name="removeIndex" returntype="string" access="public" hint="generates sql to remove a database index">
		<cfargument name="table" type="string" required="true" hint="table name">
		<cfargument name="indexName" type="string" required="false" default="" hint="index name">
		<cfreturn "DROP INDEX #arguments.table#.#quoteColumnName(arguments.indexName)#">
	</cffunction>

</cfcomponent>