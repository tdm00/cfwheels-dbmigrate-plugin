# Changelog


* 0.9.0
  * Enhancement: Updated the TableDefinitions.cfc methods to allow chaining to have a bit cleaner code in the migrations.
  * Fixed: Removed an argument for addColumnOptions in adapters/Abstract.cfc that was no longer needed.
  * Enhancement: Expose more functionality around primary keys to be able to model real world databases. This includes being able to specify primary keys that also have foreign key references and creating a table with multiple primary keys.
  * Enhancement: Allow the references method in TableDefinition.cfc to take in all possible column arguments.
  * Fixed: Simple syntax error in Migration.cfc was causing the createObjectFromRoot to throw an exception. Fixed syntax error and migrations work again.  - [https://github.com/talltroym/cfwheels-dbmigrate-plugin/issues/41](https://github.com/talltroym/cfwheels-dbmigrate-plugin/issues/41)
  * Fixed: String values with more then one single quote aren't being escaped in generated SQL  - [https://github.com/talltroym/cfwheels-dbmigrate-plugin/issues/42](https://github.com/talltroym/cfwheels-dbmigrate-plugin/issues/42)

* 0.8.2
  * Fixed: updateRecord incorrectly adds single quotes to date values - [https://github.com/talltroym/cfwheels-dbmigrate-plugin/issues/39](https://github.com/talltroym/cfwheels-dbmigrate-plugin/issues/39)

* 0.8.1
  * Fixed: When generating SQL INSERT code with values that use an apostrophe or single quote, these values are escaped properly - [https://github.com/talltroym/cfwheels-dbmigrate-plugin/issues/36](https://github.com/talltroym/cfwheels-dbmigrate-plugin/issues/36)
  * Update compatibility for ColdFusion on Wheels framework 1.1.6 - [https://github.com/talltroym/cfwheels-dbmigrate-plugin/issues/38](https://github.com/talltroym/cfwheels-dbmigrate-plugin/issues/38)

* 0.8.0
  * New: Add Oracle code specific block to basefunctions.cfm - [code changes from Raúl Riera](https://github.com/talltroym/cfwheels-dbmigrate-plugin/issues/27)
  * New: Add transaction wrapping in dbmigrate.cfc - [code changes from Raúl Riera](https://github.com/talltroym/cfwheels-dbmigrate-plugin/issues/27)
  * New: Add foreign key column removal when dropping a table in migration.cfc - [code changes from Raúl Riera](https://github.com/talltroym/cfwheels-dbmigrate-plugin/issues/27)
  * New: Add ability to [trigger migrations by calling plugin from URL](https://github.com/talltroym/cfwheels-dbmigrate-plugin/issues/28) with migrateToVersion URL parameter
  * Fixed: DBMigrate automatically [determines correct path for Extends](https://github.com/talltroym/cfwheels-dbmigrate-plugin/issues/33) in migration files
  * New: Add [plugin version number](https://github.com/talltroym/cfwheels-dbmigrate-plugin/issues/31) to plugin page
  * Resolve [issue #6](https://github.com/talltroym/cfwheels-dbmigrate-plugin/issues/6) when using renameColumn() with MySQL
  
* 0.7.2
  * Update README.md with renamed project URL's
  * Create CHANGELOG.md file

* 0.7.1
  * Fixed: Renamed references to DBMigrate to be dbmigrate to resolve a problem with case-sensitive file-systems, such as *nix

* 0.7.0
  * Update plugin compatibility for CFWheels 1.1.3, 1.1.4 and 1.1.5
  * Create update-record template that includes parameters table and example code
  * Create remove-record template that includes parameters table and example code  
  * Create add-record template that includes parameters table and example code
  * Create remove-index template that includes parameters table and example code
  * Create create-index template that includes parameters table and example code
  * Create remove-column template that includes parameters table and example code
  * Create rename-column template that includes parameters table and example code
  * Create change-column template that includes parameters table and example code
  * Create create-column template that includes parameters table and example code
  * Create remove-table template that includes parameters table and example code
  * Create rename-table template that includes parameters table and example code
  * Create create-table template that includes parameters table and example code
  * Fix problem with MySQL statements for inserting values into date/time fields

* 0.6.0
  * N/A
  
* 0.5.0
  * N/A  
  
* 0.4.0
  * Fixed issues with descriptions and filenaming when creating migrations from templates - Issue 1
  * references() and timestamps() now use lowercase column names to fit with cfwheels recommended conventions - Issue 2
  * Creating migration files from template fixed for case-sensitive platforms - Issue 3
  * Support for longer migration names - Issue 5
  * Timestamp bug fixed for 24 hour time - Issue 6
  * Removed cftransaction wrapper - alternate version provided (more info)

* 0.3 Migration Tracking
  * Fixed migration version tracking so you can run all non-migrated versions
  * SQL Server and Oracle adapter updates
  * Access to Wheels model() function within migrations

* 0.2 Migration Templates Update
  * Added functionality to plugin page to create migrations from templates

* 0.1 Initial Release
  * Initial Release for feedback and suggestions
  * Tested with MySQL and Coldfusion 8