load "ids.rb"
load "db_connection.rb"
load "import_products.rb"
load "create_categories.rb"
load "users.rb"
load "cleanup.rb"


cleanup()
createUsers()
createCategories()
parseZenCartProductCsvFiles()

