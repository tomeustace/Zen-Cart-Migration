load "ids.rb"
load "db_connection.rb"
load "import_products.rb"
load "create_categories.rb"
load "cleanup.rb"

cleanup()
createCategories()
parseZenCartProductCsvFiles()

