def cleanup
   @connection = connection()
   
   @connection.query("delete from taxonomy_term_data")
   @connection.query("delete from taxonomy_term_hierarchy")
   @connection.query("delete from node")
   @connection.query("delete from uc_products")
   @connection.query("delete from file_managed")
   @connection.query("delete from node_revision")
   @connection.query("delete from node_comment_statistics")
   @connection.query("delete from field_revision_field_description")
   @connection.query("delete from field_data_field_description")
   @connection.query("delete from taxonomy_index")
   
   @connection.query("delete from field_data_taxonomy_catalog")
   @connection.query("delete from field_data_uc_product_image")
   @connection.query("delete from field_revision_taxonomy_catalog")
   @connection.query("delete from field_revision_uc_product_image")
   @connection.query("delete from field_data_field_description")
   @connection.query("delete from field_revision_field_description")
end
