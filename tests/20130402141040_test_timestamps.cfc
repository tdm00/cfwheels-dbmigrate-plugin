<cfcomponent extends="plugins.dbmigrate.Migration" hint="test createdat / updatedat">
	<cffunction name="up">
		<cfscript>
			t = createTable(name='test_timestamps');
			t.string("label");
			t.timestamps();
			t.create();

			addRecord(table='test_timestamps',label="Foo");
			addRecord(table='test_timestamps',label="Bar");
			updateRecord(table='test_timestamps',where="label='Bar'",label="Bar2");
		</cfscript>
	</cffunction>
	<cffunction name="down">
		<cfscript>
			dropTable(name='test_timestamps');
		</cfscript>
	</cffunction>
	</cfcomponent>
