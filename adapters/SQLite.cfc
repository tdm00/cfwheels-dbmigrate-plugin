<cfcomponent extends="Abstract">

	<cfset variables.sqlTypes = {}>
	<cfset variables.sqlTypes['primaryKey'] = "integer NOT NULL PRIMARY KEY AUTOINCREMENT">
	<cfset variables.sqlTypes['binary'] = {name='blob'}>
	<cfset variables.sqlTypes['boolean'] = {name='integer',limit=1}>
	<cfset variables.sqlTypes['date'] = {name='integer'}>
	<cfset variables.sqlTypes['datetime'] = {name='integer'}>
	<cfset variables.sqlTypes['decimal'] = {name='real'}>
	<cfset variables.sqlTypes['float'] = {name='real'}>
	<cfset variables.sqlTypes['integer'] = {name='integer'}>
	<cfset variables.sqlTypes['string'] = {name='text',limit=255}>
	<cfset variables.sqlTypes['text'] = {name='text'}>
	<cfset variables.sqlTypes['time'] = {name='integer'}>
	<cfset variables.sqlTypes['timestamp'] = {name='integer'}>

	<cffunction name="adapterName" returntype="string" access="public" hint="name of database adapter">
		<cfreturn "SQLite">
	</cffunction>

	<!---  SQLite uses double quotes to escape table and column names --->
	<cffunction name="quoteColumnName" returntype="string" access="public" hint="surrounds column names with quotes">
		<cfargument name="name" type="string" required="true" hint="column name">
		<cfreturn '"#arguments.name#"'>
	</cffunction>
	
</cfcomponent>