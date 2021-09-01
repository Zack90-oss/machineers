
if(CLIENT)then
	SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_knife")
	SWEP.BounceWeaponIcon=false
	SWEP.ViewModelFOV = 75
end

SWEP.Base			= "hmcd_melee_base"
SWEP.PrintName 		= "SOG M37 Seal Pup"
SWEP.Instructions	= "This is your trusty carbon-steel fixed-blade knife. Use it to take the lives of the innocent.\n\nLMB to stab.\nBackstabs do more damage."
SWEP.ViewModel = "models/weapons/v_jnife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.Damage					= 15			-- Damage number 1
SWEP.DamageVar				= 25		-- How much damage will vary. If set to 0 => only default damage numbers will engage
SWEP.Delay 					= 0.5
SWEP.DeploySpeedMul			= 1.0		-- Speed of deploy
SWEP.AttackTimeMul			= 1.5			-- Animation thing
SWEP.RealDeploySpeedMul		= 2.6		-- Speed of readiness
SWEP.AttackDist				= 80
SWEP.DangerLevel			= 50		-- How fast police will react to you holding this thing in hands?
SWEP.DamageForce			= 1000		-- Force applied to phys objects then damaged by weapon. Pass nil to calculate automatically
SWEP.AttackSlowDown			= 0.8

SWEP.AttackSound			= "snd_jack_hmcd_slash.wav"