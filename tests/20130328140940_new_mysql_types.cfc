<cfcomponent extends="plugins.dbmigrate.Migration" hint="test new mysql types">
  <cffunction name="up">
    <cfscript>
			t = createTable(name='mysql_types');
			t.tinyInteger("test_tinyint1");
			t.tinyInteger("test_tinyint2", "unsigned");
			t.integer("test_tinyint3", "tiny unsigned");
			t.smallInteger("test_smallint1");
			t.smallInteger("test_smallint2", "unsigned");
			t.integer("test_smallint3", "small unsigned");
			t.mediumInteger("test_mediumint1");
			t.mediumInteger("test_mediumint2", "unsigned");
			t.integer("test_mediumint3", "medium unsigned");
			t.integer("test_int1");
			t.integer("test_int2", "unsigned");
			t.integer("test_int3", "int");
			t.integer("test_int4", "int unsigned");
			t.bigInteger("test_bigint1");
			t.bigInteger("test_bigint2", "unsigned");
			t.integer("test_bigint3", "big unsigned");
			t.create();
			addRecord(table='mysql_types'
					,test_tinyint1=1,test_tinyint2=2,test_tinyint3=3
					,test_smallint1=1,test_smallint2=2,test_smallint3=3
					,test_mediumint1=1,test_mediumint2=2,test_mediumint3=3
					,test_int1=1,test_int2=2,test_int2=2,test_int3=3,test_int4=4
					,test_bigint1=1,test_bigint2=2,test_bigint3=3

			);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    dropTable(name='mysql_types');
    </cfscript>
  </cffunction>
</cfcomponent>
