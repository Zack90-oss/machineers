GM.Name = "Machineers"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "N/A"

AddCSLuaFile( "weighted_random.lua" )
AddCSLuaFile( "translation.lua" )
AddCSLuaFile( "value.lua" )
AddCSLuaFile( "sh_teams.lua" )


include( "weighted_random.lua" )
include( "translation.lua" )
include( "value.lua" )
include( "sh_teams.lua" )

MCHN_WIDGET_DISC 	= Material( "widgets/disc.png" )	--Not from machineers btw..
MCHN_WIDGET_ARROW 	= Material( "widgets/arrow.png" )