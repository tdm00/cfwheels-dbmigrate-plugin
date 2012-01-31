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
	
	<cffunction name="dropColumnFromTable" returntype="string" access="public" hint="generates sql to add a foreign key constraint to a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="columnName" type="any" required="true" hint="column name">
		<cfset $removeCheckConstraints(arguments.name, arguments.columnName)>
		<cfset $removeDefaultConstraint(arguments.name, arguments.columnName)>
		<cfset $removeIndexes(arguments.name, arguments.columnName)>
		<cfreturn "ALTER TABLE #quoteTableName(LCase(arguments.name))# DROP COLUMN #quoteColumnName(arguments.columnName)#">
	</cffunction>
	
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

	<cffunction name="$removeCheckConstraints" access="private" hint="SQL Server: Removes constraints on a given column.">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="columnName" type="any" required="true" hint="column name">
		<cfset var loc = {}>
		<cfquery name="loc.constraints" datasource="#application.wheels.dataSourceName#" username="#application.wheels.dataSourceUserName#" password="#application.wheels.dataSourcePassword#">
			SELECT
				constraint_name
			FROM
				information_schema.constraint_column_usage
			WHERE
				table_name =
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">
				AND column_name =
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.columnName#">
		</cfquery>
		<cfloop query="loc.constraints">
			<cfset $execute("ALTER TABLE #quoteTableName(LCase(arguments.name))# DROP CONSTRAINT #loc.constraints.constraint#")>
		</cfloop>
	</cffunction>

	<cffunction name="$removeDefaultConstraint" access="private" hint="SQL Server: Removes default constraints on a given column.">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="columnName" type="any" required="true" hint="column name">
		<cfset var loc = {}>
		<cfquery name="loc.constraints" datasource="#application.wheels.dataSourceName#" username="#application.wheels.dataSourceUserName#" password="#application.wheels.dataSourcePassword#">
			EXEC sp_helpconstraint #quoteTableName(LCase(arguments.name))#, 'nomsg'
		</cfquery>
		<cfquery name="loc.constraints" dbtype="query">
			SELECT
				*
			FROM
				[loc].[constraints]
			WHERE
				constraint_type =
					<cfqueryparam cfsqltype="cf_sql_varchar" value="DEFAULT on column #arguments.columnName#">
		</cfquery>
		<cfloop query="loc.constraints">
			<cfset $execute("ALTER TABLE #quoteTableName(LCase(arguments.name))# DROP CONSTRAINT #loc.constraints.constraint_name#")>
		</cfloop>
	</cffunction>

	<cffunction name="$removeIndexes" access="private" hint="SQL Server: Removes all indexes on a given column.">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="columnName" type="any" required="true" hint="column name">
		<cfset var loc = {}>
		<!--- Based on info presented in `http://stackoverflow.com/questions/765867/list-of-all-index-index-columns-in-sql-server-db` --->
		<cfquery name="loc.indexes" datasource="#application.wheels.dataSourceName#" username="#application.wheels.dataSourceUserName#" password="#application.wheels.dataSourcePassword#">
			SELECT
				t.name AS table_name,
				col.name AS column_name,
				ind.name AS index_name,
				ind.index_id,
				ic.index_column_id
			FROM
				sys.indexes ind 
				INNER JOIN sys.index_columns ic 
					ON ind.object_id = ic.object_id and ind.index_id = ic.index_id 
				INNER JOIN sys.columns col 
					ON ic.object_id = col.object_id and ic.column_id = col.column_id 
				INNER JOIN sys.tables t 
					ON ind.object_id = t.object_id 
			WHERE
				t.name =
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">
				AND col.name =
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.columnName#">
		</cfquery>
		<cfloop query="loc.indexes">
			<cfset $execute(removeIndex(arguments.name, loc.indexes.index_name))>
		</cfloop>
	</cffunction>

</cfcomponent>