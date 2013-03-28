<cfcomponent extends="Abstract">

	<cfset variables.sqlTypes = {}>
	<cfset variables.sqlTypes['binary'] = {name='BLOB'}>
	<cfset variables.sqlTypes['boolean'] = {name='TINYINT',limit=1}>
	<cfset variables.sqlTypes['date'] = {name='DATE'}>
	<cfset variables.sqlTypes['datetime'] = {name='DATETIME'}>
	<cfset variables.sqlTypes['decimal'] = {name='DECIMAL'}>
	<cfset variables.sqlTypes['float'] = {name='FLOAT'}>
	<cfset variables.sqlTypes['integer'] = {name='INT'}>
	<cfset variables.sqlTypes['string'] = {name='VARCHAR',limit=255}>
	<cfset variables.sqlTypes['text'] = {name='TEXT'}>
	<cfset variables.sqlTypes['time'] = {name='TIME'}>
	<cfset variables.sqlTypes['timestamp'] = {name='TIMESTAMP'}>
	<cfset variables.sqlTypes['uuid'] = {name='VARBINARY', limit=16}>
	<cfset variables.sqlTypes['money'] = {name='DECIMAL',precision=19,scale=4}>

	<cffunction name="adapterName" returntype="string" access="public" hint="name of database adapter">
		<cfreturn "MySQL">
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
			arguments.sql = arguments.sql & " AUTO_INCREMENT";
		
		arguments.sql = arguments.sql & " PRIMARY KEY";
		</cfscript>
		<cfreturn arguments.sql>
	</cffunction>

	<!---  MySQL uses angle quotes to escape table and column names --->
	<cffunction name="quoteTableName" returntype="string" access="public" hint="surrounds table or index names with quotes">
		<cfargument name="name" type="string" required="true" hint="column name">
		<cfreturn "`#Replace(arguments.name,".","`.`","ALL")#`">
	</cffunction>

	<cffunction name="quoteColumnName" returntype="string" access="public" hint="surrounds column names with quotes">
		<cfargument name="name" type="string" required="true" hint="column name">
		<cfreturn "`#arguments.name#`">
	</cffunction>
	
	<!--- MySQL text fields can't have default --->
	<cffunction name="optionsIncludeDefault" returntype="boolean">
		<cfargument name="type" type="string" required="false" hint="column type">
		<cfargument name="default" type="string" required="false" default="" hint="default value">
		<cfargument name="null" type="boolean" required="false" default="true" hint="whether nulls are allowed">
		<cfif ListFindNoCase("text,float", arguments.type)>
			<cfreturn false>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>
	
	<!--- MySQL can't use rename column, need to recreate column definition and use change instead --->
	<cffunction name="renameColumnInTable" returntype="string" access="public" hint="generates sql to rename an existing column in a table">
		<cfargument name="name" type="string" required="true" hint="table name">
		<cfargument name="columnName" type="string" required="true" hint="old column name">
		<cfargument name="newColumnName" type="string" required="true" hint="new column name">
		<cfreturn "ALTER TABLE #quoteTableName(LCase(arguments.name))# CHANGE COLUMN #quoteColumnName(arguments.columnName)# #quoteColumnName(arguments.newColumnName)# #$getColumnDefinition(tableName=arguments.name,columnName=arguments.columnName)#">
	</cffunction>

	<!--- MySQL requires table name as well as index name --->
	<cffunction name="removeIndex" returntype="string" access="public" hint="generates sql to remove a database index">
		<cfargument name="table" type="string" required="true" hint="table name">
		<cfargument name="indexName" type="string" required="false" default="" hint="index name">
		<cfreturn "DROP INDEX #quoteTableName(arguments.indexName)# ON #quoteTableName(arguments.table)#">
	</cffunction>
	
	<cffunction name="typeToSQL" returntype="string">
		<cfargument name="type" type="string" required="true" hint="column type">
		<cfargument name="options" type="struct" required="false" default="#StructNew()#" hint="column options">
		<cfscript>
			var sql = super.typeToSQL( argumentCollection = arguments );
			if(arguments.type == 'INTEGER' AND StructKeyExists(arguments.options,'limit') ) {
				if(arguments.options.limit IS 'BIG') {
					sql = 'BIGINT';
				} else if(arguments.options.limit IS 'BIG UNSIGNED') {
					sql = 'BIGINT UNSIGNED';
				} else if(arguments.options.limit IS 'UNSIGNED') {
					sql = 'INT UNSIGNED';
				} else if(arguments.options.limit IS 'MEDIUM UNSIGNED') {
					sql = 'MEDIUMINT UNSIGNED';
				} else if(arguments.options.limit IS 'MEDIUM') {
					sql = 'MEDIUMINT';
				} else if(arguments.options.limit IS 'SMALL UNSIGNED') {
					sql = 'SMALLINT UNSIGNED';
				} else if(arguments.options.limit IS 'SMALL') {
					sql = 'SMALLINT';
				} else if(arguments.options.limit IS 'TINY UNSIGNED') {
					sql = 'TINYINT UNSIGNED';
				} else if(arguments.options.limit IS 'TINY') {
					sql = 'TINYINT';
				} else if(isNumeric(arguments.options.limit)){
					sql = 'INT(#arguments.options.limit#)';
				} else {
					sql = 'INT';
				}
			}
		</cfscript>
		<cfreturn sql>
	</cffunction>

</cfcomponent>