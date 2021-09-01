local PlayerMeta = FindMetaTable("Player")

function GM:PlayerSetModel( ply )
	
end

function GM:PlayerSpawn(ply,trans)
	hook.Run( 'PlayerSetModel', ply )
	if(ply:Team()==TEAM_UNASSIGNED or ply:Team()==TEAM_CONNECTING)then
		ply:SetTeam( TEAM_SPECTATOR )
	end
	ply:Spectate( OBS_MODE_ROAMING )
end

function GM:PlayerInitialSpawn( ply )
	
end

function PlayerMeta:GiveLoadout(loadout)
local weps = table.GetKeys(MACH_Loadouts[loadout])
	for i = 1, #weps do
		local wep=nil
		if(isnumber(weps[i]))then
			wep=MACH_Loadouts[loadout][weps[i]]
			self:Give(wep) 
		else
			wep=weps[i]
			self:Give(wep)
		end
		if(MACH_Loadouts[loadout][wep]~=nil and isnumber(MACH_Loadouts[loadout][wep]))then
			self:GetWeapon(wep):SetClip1(MACH_Loadouts[loadout][wep])
		end
	end
end

