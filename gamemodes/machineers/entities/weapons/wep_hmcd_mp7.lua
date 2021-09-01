
SWEP.Base			= "hmcd_weapon_base"
SWEP.PrintName		= "HK MP7"
SWEP.Instructions	= "This 4.6x30mm machine-pistol, reliable and stable. \n\nLMB to fire.\nRMB to aim.\nRELOAD to reload.\nShot placement counts.\nCrouching helps stability.\nBullets can ricochet and penetrate."
SWEP.RecoilForce	= {1,0.2}	
SWEP.InAirRecoilForce		= {0.2,0.0}
SWEP.ViewModelFlip	= false
SWEP.ViewModel = "models/weapons/tfa_ins2/c_mp7.mdl"
SWEP.WorldModel = "models/weapons/tfa_ins2/w_mp7.mdl"
SWEP.Delay 					= 60/950	-- Delay between shots
SWEP.CarryWeight   			= 1800		-- Carry weight. Used in inertia and other systems
SWEP.IronPos 				= Vector(-2.8,0,0.75)
SWEP.SprintAngle 			= Angle(-15,45,-10)
SWEP.SprintPos 				= Vector(5,-5,-1.2)
SWEP.Cone					= 0.05		-- Your shot spread
SWEP.AimCone				= 0.003		-- Your shot spread if you aiming

SWEP.Primary.ClipSize		= 40		-- Size of a clip
SWEP.Primary.Automatic		= true		-- Automatic/Semi Auto
SWEP.InertiaScale			= 1.0		-- For now. If set to 0, completely disables inertia(any values <> 0 just enables inertia)
SWEP.VShootACT				= ACT_VM_PRIMARYATTACK_1
SWEP.AimAddMul				= 40		-- How fast you gonna aim(1 second should ~~ 10 units)
SWEP.SprintAddMul			= 30		-- How fast you gonna stop shooting(1 second should ~~ 1000 units)

SWEP.Damage					= 37		-- Damage number 1
SWEP.DamageVar				= 39		-- How much damage will vary. If set to 0 => only default damage numbers will engage

SWEP.ReloadSpeedTime		= 5		-- Speed of reload in seconds
SWEP.DeploySpeedTime		= 2.5		-- Speed of deploy in seconds
SWEP.RealDeploySpeedTime	= 2.2		-- Speed of readiness in seconds