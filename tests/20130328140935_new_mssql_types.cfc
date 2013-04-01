<cfcomponent extends="plugins.dbmigrate.Migration" hint="test new mssql types">
  <cffunction name="up">
    <cfscript>
			t = changeTable(name='mssql_types');
			t.tinyInteger("test_tinyint");
			t.smallInteger("test_smallint");
			t.integer("test_int");
			t.bigInteger("test_bigint");
			t.date(columnNames="test_date");
			t.datetime(columnNames="test_datetime");
			t.datetime(columnNames="test_smalldatetime",precision="small");
			t.money(columnNames="test_money");
			t.money(columnNames="test_smallmoney",precision="small");
			t.create();
			addRecord(table='mssql_types',test_tinyint=1,test_int=2,test_bigint=3,test_date=now(),test_datetime=now(),test_smalldatetime=now(),test_money=4.56,test_smallmoney=7.89 );
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    dropTable(name='mssql_types');
    </cfscript>
  </cffunction>
</cfcomponent>
