require 'csv'

###########################################
#Categories and products being inserted catalog block shows empty AS NO CATEGORY IS BEING
#SET FOR THE PRODUCTS BEING INSERTED. LOOK AT UC_PRODUCTS TABLE FOR THIS. PARENT

def parseZenCartProductCsvFiles
	
	#product name(2) and product description(3)
	@products = CSV.open('products.csv', 'r') 
	@products_description = CSV.open('products_description.csv', 'r') 
	
	@product_rows = Array.new
	@product_description_rows = Array.new
	@added_images = Hash.new
	
	#products_uantity(2), products_image(4), products_price(5), products_date_added(9), products_weight(12) - in grams and master_categories_id(30)
	@products.each_with_index do |row, index|
		@row = Array.new	
		row.to_s.split("/t").each_with_index do |field, ind| #split into 7 items
			@row[ind] = field
		end
		@product_rows[index] = @row
	end
	
	@products_description.each_with_index do |row, index|
		@row = Array.new
		row.to_s.split("/t").each_with_index do |field, ind| #split into 7 items
			@row[ind] = field
		end
		@product_description_rows[index] = @row # create an array that can be used to access all the rows
	end
	
	puts @product_rows[0] # is a row
	puts @product_description_rows[0] # is a row

	puts "id is #{@product_rows[0][0]}" # is id	
	puts "id is #{@product_description_rows[0][0]}" # is id
	
	@product_rows.each_with_index do |product_row, index|
		#find id, get title
		product_id = product_row[0]
		
		title = ""
		master_category = ""
		
		@product_description_rows.each do |product_description_row|
			product_description_id = product_description_row[0] 
			if(product_id == product_description_id)
			
				title = product_description_row[2]
				master_category = product_row[28]
			
				puts "product id is #{product_id}, product id descritpion = #{product_description_row[2]}, master category is = #{product_row[28]}"
			end	
		end
		
		drupalFileInserts(index)
		drupalNodeInserts(index, title, master_category)
		drupalTaxonomyInserts(master_category)
		
	end
	#now match the ids
end

def drupalNodeInserts(index, title, master_category)
	
	get_nid()
	get_cid()
	get_vid()
	
	#this is the CORE problem, index is not correct should be using different id for the correct product
	
	
	if(title != nil) 
		#DO LOOK UP FOR INDEX IN HASH
		title = title.gsub(/'/, "\\\\'")
	else
		title = "no title"	
	end
	
	#NODE 1 IS SEAWEED, ID = 181 SHOULD MAP TO 71 WHICH IS FOODS
	#CURRENTLY NODE 1 MAPS TO 94, old id is 407 for toothpaste
	#master_category = @products_row[28] # master_category_id
	#id = @products_row[0]
	#puts "id #{@products_row[0]} maps to master category #{master_category}, title is #{title}"
	
	#MIXING UP PRODUCT_DESCRIPTION AND PRODUCTS, ID 1 IS FROM PRODUCT_DESCRIPTION NOT PRODUCT.
	#COULD BE JUST THE TITLE IS WRONG
	
	#mapping is all wrong 
	#think should build hash that maps id to master_category
	#use products csv files correctly to get mapping
	
	#MASTER CATEGORY IS CORRECT BUT IT SHOULD NOT BE USED FOR NODES AS THEY WILL ALL BE UNIQUE
	
	#78 is Hot Drinks 67 is teas this is correct
	
	@connection = connection()
	@connection.query("INSERT INTO `node` (`nid`, `vid`, `type`, `language`, `title`, `uid`, `status`, `created`, `changed`, `comment`, `promote`, `sticky`, `tnid`, `translate`) VALUES
		(#{@nid}, #{@vid}, 'product', 'und', '#{title}', 1, 1, 1290214089, 1290214089, 2, 1, 0, 0, 0);")
	
	@connection.query("INSERT INTO `uc_products` (`vid`, `nid`, `model`, `list_price`, `cost`, `sell_price`, `weight`, `weight_units`, `length`, `width`, `height`, `length_units`, 
				`pkg_qty`, `default_qty`, `unique_hash`, `ordering`, `shippable`) VALUES
				(#{@vid}, #{@nid}, '142421', '0.00000', '0.00000', '0.00000', 0, 'lb', 0, 0, 0, 'in', 1, 1, '554518cb96fe8e14c65c38755fac3ce9', 0, 1);")
	
	@connection.query("INSERT INTO `node_revision` (`nid`, `vid`, `uid`, `title`, `log`, `timestamp`, `status`, `comment`, `promote`, `sticky`) VALUES
		(#{@nid}, #{@vid}, 1, 'a#{title}', '', 1292174126, 1, 2, 1, 0);")
	
	@connection.query("INSERT INTO `node_comment_statistics` (`nid`, `cid`, `last_comment_timestamp`, `last_comment_name`, `last_comment_uid`, `comment_count`) VALUES
		(#{@nid}, 0, 1292112951, NULL, 1, 0);")
	
	
	@connection.query("INSERT INTO `taxonomy_index` (`nid`, `tid`, `sticky`, `created`) VALUES
		(#{@nid}, #{master_category}, 0, 1292112951);")
	
	################################ TAXONOMY INSERTS ################################################
	
	#@connection.query("INSERT INTO `field_data_taxonomy_catalog` (`etid`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `taxonomy_catalog_tid`) VALUES
	#	(1, 'product', 0, #{@nid}, #{@nid}, 'und', 0, 3);")

	#@connection.query("INSERT INTO `field_data_uc_product_image` (`etid`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `uc_product_image_fid`, `uc_product_image_alt`, `uc_product_image_title`) VALUES
	#		(1, 'product', 0, #{@nid}, #{@nid}, 'und', 0, 1, '', '');")

	#@connection.query("INSERT INTO `field_revision_taxonomy_catalog` (`etid`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `taxonomy_catalog_tid`) VALUES
	#		(1, 'product', 0, #{@nid}, #{@nid}, 'und', 0, 2);")

	#@connection.query("INSERT INTO `field_revision_uc_product_image` (`etid`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `uc_product_image_fid`, `uc_product_image_alt`, `uc_product_image_title`) VALUES
	#		(1, 'product', 0, #{@nid}, #{@nid}, 'und', 0, 1, '', '');")
	
	#@connection.query("INSERT INTO `field_data_field_description` (`etid`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `field_description_value`, `field_description_summary`, `field_description_format`) VALUES
	#		(1, 'product', 0, #{@nid}, 2, 'und', 0, 'the bleedin product!!!', '', 'filtered_html');")

	#@connection.query("INSERT INTO `field_revision_field_description` (`etid`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `field_description_value`, `field_description_summary`, `field_description_format`) VALUES
	#	(#{@nid}, 'product', 0, #{@nid}, 2, 'und', 0, 'the bleedin product!!!', '', 'filtered_html');")
	
	@connection.close
end

def drupalFileInserts(index)
	
	get_fid()
	
	filename = @product_rows[index][4].gsub(/'/, "\\\\'")
	
	if(@added_images.has_value?(filename))
		puts "#{filename} is already in hash"
		filename = filename + @fid.to_s #Make uris unique as we use same image for some products
	end
	#puts "adding #{filename}"
	@added_images[index] = filename
	
	#build array of added images, if image already exists in hash make it unique
	@connection = connection()
	@connection.query("INSERT INTO `file_managed` (`fid`, `uid`, `filename`, `uri`, `filemime`, `filesize`, `status`, `timestamp`) VALUES
		(#{@fid}, 1, '#{filename}', 'public://#{filename}', 'image/jpeg', 8667, 1, 1290214089);")
	
	@connection.close

end

#########################################################################################
#441 is a 10 euro gift certificate in csv it's parent is 93, in current impl there is 210 and 211 that have parent 93, these are incorrect for the parent.  should be 156.
#so the mapping to parent is incorrect, fix taxonomy_index mappings s
#########################################################################################


def drupalTaxonomyInserts(taxonomy_catalog_tid)
	
	get_entity_id()
	#get_uc_image_fid()
	
	#create the taxonomy entries manually
	#taxonomy_id = zencart_masterid
	
	@connection = connection()
	
	@connection.query("INSERT INTO `field_data_taxonomy_catalog` (`etid`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `taxonomy_catalog_tid`) VALUES
		(1, 'product', 0, #{@entity_id}, #{@entity_id}, 'und', 0, #{taxonomy_catalog_tid});")
	
	@connection.query("INSERT INTO `field_data_uc_product_image` (`etid`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `uc_product_image_fid`, `uc_product_image_alt`, `uc_product_image_title`) VALUES
			(1, 'product', 0, #{@entity_id}, #{@entity_id}, 'und', 0, 1, '', '');")

	@connection.query("INSERT INTO `field_revision_taxonomy_catalog` (`etid`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `taxonomy_catalog_tid`) VALUES
			(1, 'product', 0, #{@entity_id}, #{@entity_id}, 'und', 0, #{taxonomy_catalog_tid});")

	@connection.query("INSERT INTO `field_revision_uc_product_image` (`etid`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `uc_product_image_fid`, `uc_product_image_alt`, `uc_product_image_title`) VALUES
			(1, 'product', 0, #{@entity_id}, #{@entity_id}, 'und', 0, 1, '', '');")
	
	@connection.query("INSERT INTO `field_data_field_description` (`etid`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `field_description_value`, `field_description_summary`, `field_description_format`) VALUES
			(1, 'product', 0, #{@entity_id}, #{@entity_id}, 'und', 0, 'the bleedin product!!!', '', 'filtered_html');")

	@connection.query("INSERT INTO `field_revision_field_description` (`etid`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `field_description_value`, `field_description_summary`, `field_description_format`) VALUES
			(1, 'product', 0, #{@entity_id}, #{@entity_id+1}, 'und', 0, 'the bleedin product!!!', '', 'filtered_html');")
	
	@connection.close
end
