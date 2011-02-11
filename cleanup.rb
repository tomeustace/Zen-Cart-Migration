def cleanup
   @connection = connection()
   
   #create categories
   #@connection.query("delete from dr_taxonomy_term_data")
   #@connection.query("delete from dr_taxonomy_term_hierarchy")
   
   @connection.query("delete from dr_taxonomy_index")
   @connection.query("delete from dr_field_revision_taxonomy_catalog") 
   @connection.query("delete from dr_field_data_taxonomy_catalog") 
   
   @connection.query("delete from dr_node")
   @connection.query("delete from dr_uc_products")
   @connection.query("delete from dr_file_managed")
   @connection.query("delete from dr_node_revision")
   @connection.query("delete from dr_node_comment_statistics")
      
   @connection.query("delete from dr_field_data_uc_product_image")
   @connection.query("delete from dr_field_revision_uc_product_image")
   @connection.query("delete from dr_field_data_body")
    
   #@connection.query("delete from dr_users where uid > 1")
   @connection.query("delete from dr_uc_orders")

   #@connection.query("delete from dr_field_data_field_description")
   #@connection.query("delete from dr_field_revision_field_description")
      
end
