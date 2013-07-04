<cfcomponent extends="plugins.dbmigrate.Migration" hint="test insert/update null values">
	<cffunction name="up">
		<cfscript>
			t = createTable(name='test_null');
			t.string("label",50,"",false,"unicode");
			t.string("email",50,"null",true,"unicode");
			t.create();
			
			addRecord(table="test_null",label="Foo",email="foo@foo.com");
			addRecord(table="test_null",label="Bar");
			addRecord(table="test_null",label="Snork",email="NULL");
		</cfscript>
	</cffunction>
	<cffunction name="down">
		<cfscript>
			dropTable('test_null');
		</cfscript>
	</cffunction>
	</cfcomponent>
