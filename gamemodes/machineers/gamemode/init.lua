
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_stuff.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "sh_colorinvert.lua" )
AddCSLuaFile( "machineeditor/cl_editor.lua" )
AddCSLuaFile( "machineeditor/sh_editor.lua" )

include( "sv_player.lua" )
include( "sh_stuff.lua" )
include( "shared.lua" )
include( "sh_colorinvert.lua" )
include( "machineeditor/sh_editor.lua" )

util.AddNetworkString("StartNewRound")

--TODO--
--Rewrite translation
--	  --

function GM:Initialize()
	RegisterLangs()
end

function GM:Think()
	
end

function GM:AllowPlayerPickup()
	return false
end

function GM:PlayerCanPickupItem()
	return false
end

function GM:PlayerCanPickupWeapon()
	return false
end