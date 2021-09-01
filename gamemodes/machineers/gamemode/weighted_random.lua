function WeightedRandomSelect(tab)
	local totalWeight=0
	for i = 1, #tab do
		totalWeight=totalWeight+tab[i][2]
	end
	local randnum=math.random(1,totalWeight)
	local num=0
	
	for i = 1, #tab do
		num=num+tab[i][2]
		if(num>=randnum)then  
			return tab[i][1]
		end
	end	
end