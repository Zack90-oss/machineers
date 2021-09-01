
SWEP.Base			= "hmcd_weapon_base"
SWEP.PrintName		= "Test"
SWEP.Instructions	= "This is your trusty 9x19mm pistol. Use it as you see fit.\n\nLMB to fire.\nRMB to aim.\nRELOAD to reload.\nShot placement counts.\nCrouching helps stability.\nBullets can ricochet and penetrate."
SWEP.RecoilForce	= {1,1}	
SWEP.InAirRecoilForce		= {0.2,0.0}
SWEP.ViewModelFlip	= true
SWEP.ReloadSpeedTime		= 4		-- Speed of reload in seconds
SWEP.DeploySpeedTime		= 2.		-- Speed of deploy in seconds
SWEP.RealDeploySpeedTime	= 1.6		-- Speed of readiness in seconds

function SWEP:ShootBullet( damage, num_bullets, aimcone, spread, ammo_type, force, tracer )

if(SERVER and self.InertiaScale!=0)then
	self.dir=self.angl:Forward()
end
if(CLIENT and self.InertiaScale!=0)then
	self.dir=self.AngleWeapon:Forward()
end
	if(self.InertiaScale==0)then self.dir=self.Owner:GetAimVector() end
	
	self.dir = (self.dir+VectorRand()*aimcone):GetNormalized()

	local bullet = {}
	bullet.Num		= num_bullets
	bullet.Src		= self.Owner:GetShootPos()			-- Source
	bullet.Dir		= self.dir	-- Dir of bullet
	bullet.Spread	= Vector( spread, spread, 0 )		-- Aim Cone
	bullet.Vel		= 1
	bullet.Damage	= damage
	bullet.AmmoType = ammo_type || self.Primary.Ammo
	bullet.Inflictor= self.Weapon
	bullet.Attacker = self.Owner

	gay=Ballistics:FireBullets(bullet)

	self:ShootEffects(self.VShootACT,self.WShootACT)

end