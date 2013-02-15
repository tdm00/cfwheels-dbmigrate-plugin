<cfsetting enablecfoutputonly="true">

<cfset dbmigrateMeta = {}>
<cfset dbmigrateMeta.version = "1.0.0">

<cfif isDefined("Form.version")>
	<cfset flashInsert(dbmigrateFeedback=application.wheels.plugins.dbmigrate.migrateTo(Form.version))>
	<cfset redirectTo(back=true)>
<cfelseif isDefined("Form.migrationName")>
	<cfparam name="Form.templateName" default="">
	<cfparam name="Form.migrationPrefix" default="">
	<cfset flashInsert(dbmigrateFeedback2=application.wheels.plugins.dbmigrate.createMigration(Form.migrationName,Form.templateName,Form.migrationPrefix))>
	<cfset redirectTo(back=true)>
<cfelseif isDefined("url.migrateToVersion") And Len(Trim(url.migrateToVersion)) GT 0 And IsNumeric(url.migrateToVersion)>
  <cfif isDefined("url.password") And Trim(url.password) EQ application.wheels.reloadPassword>
  	<cfset flashInsert(dbmigrateFeedback=application.wheels.plugins.dbmigrate.migrateTo(url.migrateToVersion))>
  	<cfset redirectTo(back=true)>
  </cfif>
</cfif>

<!--- Get current database version --->
<cfset currentVersion = application.wheels.plugins.dbmigrate.getCurrentMigrationVersion()>

<!--- Get current list of migrations --->
<cfset migrations = application.wheels.plugins.dbmigrate.getAvailableMigrations()>
<cfif ArrayLen(migrations)>
	<cfset lastVersion = migrations[ArrayLen(migrations)].version>
<cfelse>
	<cfset lastVersion = 0>
</cfif>

<cfoutput>

<cfinclude template="css.cfm">

<h1>DBMigrate v#dbmigrateMeta.version#</h1>
<h2>inspired by Active Record migrations</h2>
<p>Database Migrations are an easy way to build and alter your database structure using cfscript.</p>

<cfif flashKeyExists("dbmigrateFeedback")>
	<h2>Migration result</h2>
	<pre>#flash("dbmigrateFeedback")#</pre>
</cfif>

<table class="table table-condensed table-bordered">
	<tr>
		<th>Database Version</th>
		<th>Datasource</th>
		<th>Database Type</th>
	</tr>
	<tr>
		<td>#currentVersion#</td>
		<td>#application.wheels.dataSourceName#</td>
		<td></td>
	</tr>
</table>

<cfif ArrayLen(migrations) gt 0>
	<h2>Migrate</h2>
	<form action="#CGI.script_name & '?' & CGI.query_string#&requesttimeout=99999" method="post">
	<p>Migrate to version
	<select name="version">
	<cfif lastVersion neq 0><option value="#lastVersion#" selected="selected">All non-migrated</option></cfif>
	<cfif currentVersion neq "0"><option value="0">0 - empty</option></cfif>
	<cfloop array="#migrations#" index="migration">
	<option value="#migration.version#">#migration.version# - #migration.name# <cfif migration.status eq "migrated">(migrated)<cfelse>(not migrated)</cfif></option>
	</cfloop>
	</select>
	<input type="submit" value="Get Migrating!" class="btn btn-success">
	</p>
	</form>

	<!--- List migrations available --->
	<h2>Available migrations</h2>
		<table class="table table-condensed table-bordered">
			<tr>
				<th>Version</th>
				<th>Details</th>
			</tr>
			<cfloop array="#migrations#" index="migration">
				<cfif migration.status eq "migrated">
					<cfset rowClass = "alert alert-success">
				<cfelseif migration.loadError neq "">
					<cfset rowClass = "alert alert-error">
				<cfelse>
					<cfset rowClass = "">
				</cfif>
				<tr class="#rowClass#">
					<td>#migration.version#</td>
					<td>
						Name: #migration.name# <br>
						<cfif migration.details neq "">Details: #migration.details# <br></cfif>
						<cfif migration.loadError neq "">Error: #migration.loadError# <br></cfif>
					</td>
				</tr>
			</cfloop>
		</table>
</cfif>

	<h2 style="padding-top:10px;">Create new migration file from template</h2>
	
	<cfif flashKeyExists("dbmigrateFeedback2")>
	<pre style="margin-top:10px;">#flash("dbmigrateFeedback2")#</pre>
	</cfif>
	
	<form action="#CGI.script_name & '?' & CGI.query_string#" method="post">
	<p style="padding-top:10px;">Select template:
	<select name="templateName">
	 <option value="blank">Blank migration</option>
	 <option value="">-- Table Operations --</option>
	 <option value="create-table">Create table</option>
	 <option value="change-table">Change table (multi-column)</option>
	 <option value="rename-table">Rename table</option>
	 <option value="remove-table">Remove table</option>
	 <option value="">-- Column Operations --</option>
	 <option value="create-column">Create single column</option>
	 <option value="change-column">Change single column</option>
	 <option value="rename-column">Rename single column</option>
	 <option value="remove-column">Remove single column</option>
	 <option value="">-- Index Operations --</option>
	 <option value="create-index">Create index</option>
	 <option value="remove-index">Remove index</option>
	 <option value="">-- Record Operations --</option>
	 <option value="create-record">Create record</option>
	 <option value="update-record">Update record</option>
	 <option value="remove-record">Remove record</option>
	 <option value="">-- Miscellaneous Operations --</option>
	 <option value="announce">Announce operation</option>
	 <option value="execute">Execute operation</option>
	</select>
	</p>
	
	<cfif ArrayLen(migrations) eq 0>
	<p>Migration prefix:
	<select name="migrationPrefix">
	 <option value="timestamp">Timestamp (e.g. #dateformat(now(),'yyyymmdd')##timeformat(now(),'hhmmss')#)</option>
	 <option value="numeric">Numeric (e.g. 001)</option>
	</select>
	</p>
	</cfif>
	
	<p>Migration description: 
	<input name="migrationName" type="text" size="30">
	(eg. 'creates member table') </p>
	<p><input type="submit" value="create"></p>
	</form>

</cfoutput>

<cfsetting enablecfoutputonly="false">
