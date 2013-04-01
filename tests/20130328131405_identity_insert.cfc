<cfcomponent extends="plugins.dbmigrate.Migration" hint="identity_insert test">
  <cffunction name="up">
    <cfscript>
    t = createTable(name='ident_insert',id=false);
    t.primaryKey(name="pk",type="integer",autoIncrement=true);
    t.change(true);
    addRecord(table='ident_insert',pk='10');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    dropTable(name='ident_insert');
    </cfscript>
  </cffunction>
</cfcomponent>
