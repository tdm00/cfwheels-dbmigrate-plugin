<cfcomponent extends="plugins.dbmigrate.Migration" hint="test mysql boolean/bit">
  <cffunction name="up">
    <cfscript>
			t = createTable(name='mysql_bit');
			t.boolean("foo");
			t.create();
      
			addRecord(table='mysql_bit',foo=true);
			addRecord(table='mysql_bit',foo=false);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    	dropTable(name='mysql_bit');
    </cfscript>
  </cffunction>
</cfcomponent>
