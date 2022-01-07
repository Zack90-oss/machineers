--"Internal" thingy, avoid this then making tool addons
if(SERVER)then
	AddCSLuaFile( "tools/translation.lua" )
	AddCSLuaFile( "tools/welder.lua" )
end
if(CLIENT)then
	include( "tools/translation.lua" )
	include( "tools/welder.lua" )
end