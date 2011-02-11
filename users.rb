def createUsers
	
	@users_row = Array.new
	@users_hash = Hash.new
	
	@inserted_names = Hash.new

	@users = CSV.open('orders.csv', 'r') 
	@users.each_with_index do |row, index|
		row.to_s.split("/t").each_with_index do |field, ind| #split into 7 items
			@users_row[ind] = field
		end
	
		@users_hash[index] = @users_row
		 
		name = @users_hash[index][2]
		company = @users_hash[index][3]
		street_address1 = @users_hash[index][4]
		street_address2 = @users_hash[index][5]
		city = @users_hash[index][6]
		postcode = @users_hash[index][7]
		state = @users_hash[index][8]
		country = @users_hash[index][9]
		phone = @users_hash[index][10]
		email = @users_hash[index][11]		
		
		billing_name = @users_hash[index][13]
		billing_company = @users_hash[index][14]
		billing_street_address1 = @users_hash[index][15]
		billing_street_address2 = @users_hash[index][16]
		billing_city = @users_hash[index][17]
		billing_postcode = @users_hash[index][18]
		billing_state = @users_hash[index][19]
		billing_country = @users_hash[index][20]
		
		insertUsers(index, name, company, street_address1, street_address2, city, postcode, state, country, billing_name, billing_company, billing_street_address1, billing_street_address2, billing_city, billing_postcode, billing_state, billing_country, phone, email)
				
	end
		
	
end

def insertUsers(index, fullname, company, street_address1, street_address2, city, postcode, state, country, billing_fullname, billing_company, billing_street_address1, billing_street_address2, billing_city, billing_postcode, billing_state, billing_country, phone, email)
	
	get_uid()
	get_oid()
	
	street_address1 = street_address1.gsub(/'/, "\\\\")
	street_address2 = street_address2.gsub(/'/, "\\\\")
	fullname = fullname.gsub(/'/, "\\\\'")
	name = fullname.split(" ")
	fname = name[0]
	lname = name[1]
	
	billing_street_address1 = billing_street_address1.gsub(/'/, "\\\\")
	billing_street_address2 = billing_street_address2.gsub(/'/, "\\\\")
	billing_fullname = billing_fullname.gsub(/'/, "\\\\'")
	billing_name = billing_fullname.split(" ")
	billing_fname = billing_name[0]
	billing_lname = billing_name[1]
	
	
	if( @inserted_names.has_value?(fullname) ) 
		fullname = fullname + index.to_s
		puts name
	else
		@inserted_names[index] = fullname
	end
	
	@connection = connection()
	@connection.query("INSERT INTO `dr_users` (`uid`, `name`, `pass`, `mail`, `theme`, `signature`, `signature_format`, `created`, `access`, `login`, `status`, `timezone`, `language`, `picture`, `init`, `data`) VALUES
		(#{@uid}, '#{fullname}', 'pass', '#{email}', '', '', NULL, 1290213002, 1295712431, 1295113368, 1, NULL, '', 0, '#{email}', NULL);")

	
	@connection.query("INSERT INTO `dr_uc_orders` (`order_id`, `uid`, `order_status`, `order_total`, `product_count`, `primary_email`, `delivery_first_name`, `delivery_last_name`, `delivery_phone`, `delivery_company`, `delivery_street1`, `delivery_street2`, `delivery_city`, `delivery_zone`, `delivery_postal_code`, `delivery_country`, `billing_first_name`, `billing_last_name`, `billing_phone`, `billing_company`, `billing_street1`, `billing_street2`, `billing_city`, `billing_zone`, `billing_postal_code`, `billing_country`, `payment_method`, `data`, `created`, `modified`, `host`) VALUES (#{@order_id}, #{@uid}, 'completed', '3.18000', 3, '#{email}', '#{fname}', '#{lname}', '#{phone}', '#{company}', '#{street_address1}', '#{street_address2}', '#{city}', 19, '#{postcode}', '#{country}', '#{billing_fname}', '#{billing_lname}', '#{phone}', '#{billing_company}', '#{billing_street_address1}', '#{billing_street_address2}', '#{billing_city}', 19, '#{billing_postcode}', '#{billing_country}', '', 's:0:"";', 1295113430, 1295113430, '127.0.0.1');")
	
						    
	
end


