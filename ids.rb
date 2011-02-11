def get_vid()
  @my = connection()
  result = @my.query("SELECT MAX(vid) FROM dr_node") 
  
  while row = result.fetch_hash do
    @vid = row['MAX(vid)'].to_i
    @vid += 1
  end
  
  result.free
  @my.close
end

def get_nid()
  @my = connection()
  result = @my.query("SELECT MAX(nid) FROM dr_node") 
  
  while row = result.fetch_hash do
    @nid = row['MAX(nid)'].to_i
    @nid += 1
  end
  result.free
  @my.close
end   

def get_uid()
  @my = connection()
  result = @my.query("SELECT MAX(uid) FROM dr_users") 
  
  while row = result.fetch_hash do
    @uid = row['MAX(uid)'].to_i
    @uid += 1
  end
  result.free
  @my.close
end   

def get_oid()
  @my = connection()
  result = @my.query("SELECT MAX(order_id) FROM dr_uc_orders") 
  
  while row = result.fetch_hash do
    @order_id = row['MAX(order_id)'].to_i
    @order_id += 1
  end
  result.free
  @my.close
end   

def get_fid()
  @my = connection()
  result = @my.query("SELECT MAX(fid) FROM dr_file_managed") 
  
  while row = result.fetch_hash do
    @fid = row['MAX(fid)'].to_i
    @fid += 1
  end
  
  result.free
  @my.close
end

def get_aid()
  @my = connection()
  result = @my.query("SELECT MAX(aid) FROM dr_access") 
  while row = result.fetch_hash do
    @aid = row['MAX(aid)'].to_i
    @aid += 1
  end
  result.free
  @my.close
end

def get_entity_id()
  @my = connection()
  result = @my.query("SELECT MAX(entity_id) FROM dr_field_data_taxonomy_catalog") 
  while row = result.fetch_hash do
    @entity_id = row['MAX(entity_id)'].to_i
    @entity_id += 1
  end
  result.free
  @my.close
end

def get_cid()
  @my = connection()
  result = @my.query("SELECT MAX(cid) FROM dr_node_comment_statistics") 
  while row = result.fetch_hash do
    @cid = row['MAX(cid)'].to_i
    @cid += 1
  end
  
  if(@cid == nil)
  	@cid = 1
  end
  result.free
  @my.close
end

