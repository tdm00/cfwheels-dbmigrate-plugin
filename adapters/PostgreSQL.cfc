<cfcomponent extends="Abstract">

	<cfset variables.sqlTypes = {}>
	<cfset variables.sqlTypes['binary'] = {name='BYTEA'}>
	<cfset variables.sqlTypes['boolean'] = {name='BOOLEAN'}>
	<cfset variables.sqlTypes['date'] = {name='DATE'}>
	<cfset variables.sqlTypes['datetime'] = {name='TIMESTAMP'}>
	<cfset variables.sqlTypes['decimal'] = {name='DECIMAL'}>
	<cfset variables.sqlTypes['float'] = {name='FLOAT'}>
	<cfset variables.sqlTypes['integer'] = {name='INTEGER'}>
	<cfset variables.sqlTypes['string'] = {name='CHARACTER VARYING',limit=255}>
	<cfset variables.sqlTypes['char'] = {name='CHARACTER',limit=64}>
	<cfset variables.sqlTypes['text'] = {name='TEXT'}>
	<cfset variables.sqlTypes['time'] = {name='TIME'}>
	<cfset variables.sqlTypes['timestamp'] = {name='TIMESTAMP'}>
	<cfset variables.sqlTypes['money'] = {name='DECIMAL',precision=19,scale=4}>

	<cffunction name="adapterName" returntype="string" access="public" hint="name of database adapter">
		<cfreturn "PostgreSQL">
	</cffunction>

	<cffunction name="addPrimaryKeyOptions" returntype="string" access="public">
		<cfargument name="sql" type="string" required="true" hint="column definition sql">
		<cfargument name="options" type="struct" required="false" default="#StructNew()#" hint="column options">
		<cfscript>
		if (StructKeyExists(arguments.options, "autoIncrement") && arguments.options.autoIncrement)
			arguments.sql = ReplaceNoCase(arguments.sql, "INTEGER", "SERIAL", "all");
		
		arguments.sql = arguments.sql & " PRIMARY KEY";
		</cfscript>
		<cfreturn arguments.sql>
	</cffunction>

	<cffunction name="quoteTableName" returntype="string" access="public" hint="surrounds table with quotes if it's not in plain lowercase">
		<cfargument name="name" type="string" required="true" hint="column name">
		<cfif reFind( "[^a-z]", arguments.name )>
			<cfreturn '"#arguments.name#"'>
		</cfif>
		<cfreturn arguments.name>
	</cffunction>
	
	<cffunction name="quoteColumnName" returntype="string" access="public" hint="surrounds column names with quotes">
		<cfargument name="name" type="string" required="true" hint="column name">
		<cfreturn '"#arguments.name#"'>
	</cffunction>

	<!--- createTable - use default --->
	
	<cffunction name="renameTable" returntype="string" access="public" hint="generates sql to rename a table">
		<cfargument name="oldName" type="string" required="true" hint="old table name">
		<cfargument name="newName" type="string" required="true" hint="new table name">
		<cfreturn "ALTER TABLE #quoteTableName(arguments.oldName)# RENAME TO #quoteTableName(arguments.newName)#">
	</cffunction>

	<!--- dropTable - use default --->
	
	<!--- NOTE FOR addColumnToTable & changeColumnInTable 
		  Rails adaptor appears to be applying default/nulls in separate queries
		  Need to check if that is necessary --->
	<!--- addColumnToTable - ? --->
	<!--- changeColumnInTable - ? --->
	
	<!--- renameColumnInTable - use default --->
	
	<!--- dropColumnFromTable - use default --->
	
	<!--- addForeignKeyToTable - use default --->
	
	<cffunction name="dropForeignKeyFromTable" returntype="string" access="public" hint="generates sql to add a foreign key constraint to a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="keyName" type="any" required="true" hint="foreign key name">
		<cfreturn "ALTER TABLE #quoteTableName(arguments.name)# DROP CONSTRAINT #quoteTableName(arguments.keyname)#">
	</cffunction>
	
	<!--- foreignKeySQL - use default --->
	
	<!--- addIndex - use default --->
	
	<!--- removeIndex - use default --->

</cfcomponent>