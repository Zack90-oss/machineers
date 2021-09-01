local ChangedTable={}

function IsChanged(val,id,meta)
	if(meta==nil)then 
		meta = ChangedTable 
	end
	if(meta.ChangedTable==nil)then
		meta['ChangedTable']={}
	end
	
	if( meta.ChangedTable[id] == val )then return false end
	
	meta.ChangedTable[id]=val
	return true
end