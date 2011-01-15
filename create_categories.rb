def createCategories
	
	@categories_desc_row = Array.new
	@categories_row = Array.new
	@categories_hash = Hash.new

	
	#categories.txt has been sorted so all root categories are listed first
	#categories_id(0), categories_name(2)
	@categories_desc = CSV.open('test_categories_description.csv', 'r') 
	@categories_desc.each_with_index do |row, index|
		@categories_hash[index] = row.to_s.split("/t")
		#puts @categories_hash[index]
	end
	
	#categories_id(0), parent_id(2)
	@categories = CSV.open('test_categories.csv', 'r') 
	@categories.each_with_index do |row, index|
		row.to_s.split("/t").each_with_index do |field, ind| #split into 7 items
			@categories_row[ind] = field
		end
		
		row = @categories_hash[index]
		category_name = row[2]
		category_id = row[0]
		
		#cats and sub cats are added to term_data regardless
		insertCategory(category_id, category_name)
		insertCategoryHierarchy(@categories_row[0], @categories_row[2])	
		
	end
		
end
	
def insertCategory(tid, name)
	#puts "category name is #{name}"
	name = name.gsub('.', " ")
		
	#puts "INSERT INTO `taxonomy_term_data` (`tid`, `vid`, `name`, `description`, `format`, `weight`) VALUES (#{tid}, 2, '#{name}', '', 'filtered_html', 0);"
	
	puts name
	@connection = connection()
	@connection.query("INSERT INTO `taxonomy_term_data` (`tid`, `vid`, `name`, `description`, `format`, `weight`) VALUES (#{tid}, 2, '#{name}', '', 'filtered_html', 0);")
end

def insertCategoryHierarchy(sub_category, parent_category)
	@connection = connection()
	@connection.query("INSERT INTO `taxonomy_term_hierarchy` (`tid`, `parent`) VALUES (#{sub_category}, #{parent_category});")	
end

