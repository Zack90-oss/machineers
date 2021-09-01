--shotgun
SWEP.Base			= "hmcd_weapon_base"
SWEP.PrintName		= "Remington 870"
SWEP.Instructions	= "This is a typical civilian pump-action hunting shotgun. It has a 6-round magazine and fires 12-guage 2-3/4 inch cartridges. \n\nLMB to fire.\nRMB to aim.\nRELOAD to reload.\nShot placement counts.\nCrouching helps stability.\nBullets can ricochet and penetrate."
SWEP.RecoilForce	= {2,2}	
SWEP.InAirRecoilForce		= {0.2,0.0}
SWEP.ViewModelFlip	= false
SWEP.ViewModel = "models/weapons/v_shot_m3juper90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3juper90.mdl"
SWEP.CarryWeight   			= 3600		-- Carry weight. Used in inertia and other systems
SWEP.IronPos 				= Vector(-1.95,-1.5,1.1)
SWEP.SprintAngle 			= Angle(-15,45,-10)
SWEP.SprintPos 				= Vector(5,-5,-1.2)

SWEP.Primary.ClipSize		= 6			-- Size of a clip
SWEP.Damage					= 13		-- Damage number 1
SWEP.DamageVar				= 16		-- How much damage will vary. If set to 0 => only default damage numbers will engage

SWEP.Delay 					= 0.9	-- Delay between shots
SWEP.Shots					= 8			-- Amount of shots per trigger pull
SWEP.Cone					= 0.07		-- Your shot spread
SWEP.AimCone				= 0.005		-- Your shot spread if you aiming
SWEP.Spread					= .0285
SWEP.AimAddMul				= 40		-- How fast you gonna aim(1 second should ~~ 10 units)
SWEP.SprintAddMul			= 30		-- How fast you gonna stop shooting(1 second should ~~ 1000 units)

SWEP.AllowAdditionalShot	= 0			-- You want charge your gun with more than 13 shots?(It is a number value)

SWEP.ReloadSpeedTime		= 1			-- Speed of reload in seconds
SWEP.DeploySpeedTime		= 2.5		-- Speed of deploy in seconds
SWEP.RealDeploySpeedTime	= 2.2		-- Speed of readiness in seconds