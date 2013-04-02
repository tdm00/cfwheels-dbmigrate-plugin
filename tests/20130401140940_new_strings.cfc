<cfcomponent extends="plugins.dbmigrate.Migration" hint="test new string types">
  <cffunction name="up">
    <cfscript>
			t = changeTable(name='string_types');
			t.char("char_none");
			t.char(columnNames="char_ascii",encoding="ascii");
			t.char(columnNames="char_unicode",encoding="unicode");
			t.column(columnName="char_column",columnType="string",encoding="utf8");
			
			t.string("varchar_none");
			t.string(columnNames="varchar_ascii",encoding="ascii");
			t.string(columnNames="varchar_unicode",encoding="unicode");
			t.column(columnName="varchar_column",columnType="string",encoding="utf8");
			
			t.text("text_none");
			t.text(columnNames="text_ascii",encoding="ascii");
			t.text(columnNames="text_unicode",encoding="unicode");
			t.column(columnName="text_column",columnType="string",encoding="utf8");
			
			t.create();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    	dropTable(name='string_types');
    </cfscript>
  </cffunction>
</cfcomponent>
