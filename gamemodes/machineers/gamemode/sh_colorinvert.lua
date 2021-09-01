local RGBMax = 255

function InvertColor(Col)
	local r,g,b,a = Col:Unpack()
	return Color(RGBMax-r, RGBMax-g, RGBMax-b)
end