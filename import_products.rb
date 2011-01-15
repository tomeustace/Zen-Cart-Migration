require 'csv'

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
	
	@product_rows.each_with_index do |product_row, index|
		#find id, get title
		product_id = product_row[0]
		
		title = ""
		master_category = ""
		price = ""
		weight = ""
		quantity = ""
		image_fid = ""
		description = ""
		
		@product_description_rows.each do |product_description_row|
			product_description_id = product_description_row[0] 
			if(product_id == product_description_id)
			
				title = product_description_row[2]
				description = product_description_row[3]
				master_category = product_row[28]
				price = product_row[5]
				weight = product_row[12]	
				quantity = product_row[2]				
				image_fid = product_row[4]
								
				puts "product id is #{product_id}, product id title = #{product_description_row[2]}, master category is = #{product_row[28]}"
			end	
		end
		
		drupalFileInserts(index)
		drupalNodeInserts(index, title, master_category, price, weight, quantity)
		drupalTaxonomyInserts(index, master_category, image_fid, title, description)
		
	end
	#now match the ids
end

def drupalNodeInserts(index, title, master_category, price, weight, quantity)
	
	get_nid()
	get_vid()
	
	if(title != nil) 
		#DO LOOK UP FOR INDEX IN HASH
		title = title.gsub(/'/, "\\\\'")
	else
		title = "no title"	
	end
	
	@connection = connection()
	@connection.query("INSERT INTO `node` (`nid`, `vid`, `type`, `language`, `title`, `uid`, `status`, `created`, `changed`, `comment`, `promote`, `sticky`, `tnid`, `translate`) VALUES
		(#{@nid}, #{@vid}, 'product', 'und', '#{title}', 1, 1, 1290214089, 1290214089, 2, 1, 0, 0, 0);")
	
	@connection.query("INSERT INTO `uc_products` (`vid`, `nid`, `model`, `list_price`, `cost`, `sell_price`, `weight`, `weight_units`, `length`, `width`, `height`, `length_units`, 
				`pkg_qty`, `default_qty`, `unique_hash`, `ordering`, `shippable`) VALUES
				(#{@vid}, #{@nid}, '142421', '#{price}', '#{price}', '#{price}', #{weight}, 'grams', 0, 0, 0, 'in', #{quantity}, 10, '554518cb96fe8e14c65c38755fac3ce9', 0, 1);")
	
	@connection.query("INSERT INTO `node_revision` (`nid`, `vid`, `uid`, `title`, `log`, `timestamp`, `status`, `comment`, `promote`, `sticky`) VALUES
		(#{@nid}, #{@vid}, 1, 'a#{title}', '', 1292174126, 1, 2, 1, 0);")
	
	@connection.query("INSERT INTO `node_comment_statistics` (`nid`, `cid`, `last_comment_timestamp`, `last_comment_name`, `last_comment_uid`, `comment_count`) VALUES
		(#{@nid}, 0, 1292112951, NULL, 1, 0);")
	
	
	@connection.query("INSERT INTO `taxonomy_index` (`nid`, `tid`, `sticky`, `created`) VALUES
		(#{@nid}, #{master_category}, 0, 1292112951);")
	
	@connection.close
end

def drupalFileInserts(index)
	
	get_fid()
	
	filename = @product_rows[index][4].gsub(/'/, "\\\\'")
	
	if(@added_images.has_value?(filename))
		puts "#{filename} is already in hash"
		filename = filename + index.to_s #Make uris unique as we use same image for some products
	end
	#puts "adding #{filename}"
	@added_images[index] = filename
	
	#build array of added images, if image already exists in hash make it unique
	@connection = connection()
	@connection.query("INSERT INTO `file_managed` (`fid`, `uid`, `filename`, `uri`, `filemime`, `filesize`, `status`, `timestamp`) VALUES
		(#{index}, 1, '#{filename}', 'public://#{filename}', 'image/jpeg', 8667, 1, 1290214089);")
	
	@connection.close

end

def drupalTaxonomyInserts(index, taxonomy_catalog_tid, image_fid, title, description)
	
	title = title.gsub(/'/, "\\\\'")
	description = description.gsub(/'/, "\\\\'")

	get_entity_id()
		
	@connection = connection()
	
	@connection.query("INSERT INTO `field_data_taxonomy_catalog` (`etid`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `taxonomy_catalog_tid`) VALUES
		(1, 'product', 0, #{@entity_id}, #{@entity_id}, 'und', 0, #{taxonomy_catalog_tid});")
	
	@connection.query("INSERT INTO `field_data_uc_product_image` (`etid`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `uc_product_image_fid`, `uc_product_image_alt`, `uc_product_image_title`) VALUES
		(1, 'product', 0, #{@entity_id}, #{@entity_id}, 'und', 0, #{index}, '#{title}', '#{title}');")

	@connection.query("INSERT INTO `field_revision_taxonomy_catalog` (`etid`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `taxonomy_catalog_tid`) VALUES
			(1, 'product', 0, #{@entity_id}, #{@entity_id}, 'und', 0, #{taxonomy_catalog_tid});")

	@connection.query("INSERT INTO `field_revision_uc_product_image` (`etid`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `uc_product_image_fid`, `uc_product_image_alt`, `uc_product_image_title`) VALUES
			(1, 'product', 0, #{@entity_id}, #{@entity_id}, 'und', 0, 1, '', '');")
	
	@connection.query("INSERT INTO `field_data_field_description` (`etid`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `field_description_value`, `field_description_summary`, `field_description_format`) VALUES
		(1, 'product', 0, #{@entity_id}, #{@entity_id}, 'und', 0, '#{description}', '', 'filtered_html');")

	#@connection.query("INSERT INTO `field_revision_field_description` (`etid`, `bundle`, `deleted`, `entity_id`, `revision_id`, `language`, `delta`, `field_description_value`, `field_description_summary`, `field_description_format`) VALUES
	#		(1, 'product', 0, #{@entity_id}, #{@entity_id+1}, 'und', 0, 'the bleedin product!!!', '', 'filtered_html');")
	
	@connection.close
end
