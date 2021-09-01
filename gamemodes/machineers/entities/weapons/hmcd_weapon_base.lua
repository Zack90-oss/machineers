
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.PrintName		= "Beretta PX4-Storm SubCompact"
SWEP.Instructions	= "This is your trusty 9x19mm pistol. Use it as you see fit.\n\nLMB to fire.\nRMB to aim.\nRELOAD to reload.\nShot placement counts.\nCrouching helps stability.\nBullets can ricochet and penetrate."
if(CLIENT)then
	SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_smallpistol")
	SWEP.BounceWeaponIcon=false
end
SWEP.ViewModelFOV	= 62
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_pist_jivejeven.mdl"			--"models/weapons/v_pist_jeagle.mdl"	--"models/weapons/v_pist_jivejeven.mdl"	
SWEP.WorldModel		= "models/weapons/w_pist_p228.mdl"

SWEP.Spawnable		= false
SWEP.AdminOnly		= false

SWEP.DangerLevel			= 70		-- How fast police will react to you holding this thing in hands?
SWEP.Primary.ClipSize		= 13		-- Size of a clip
SWEP.Primary.DefaultClip	= 0			-- Default number of bullets in a clip
SWEP.Primary.Automatic		= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "Pistol"
SWEP.Damage					= 39		-- Damage number 1
SWEP.DamageVar				= 42		-- How much damage will vary. If set to 0 => only default damage numbers will engage
SWEP.DamageForce			= nil		-- Force applied to phys objects then damaged by weapon. Pass nil to calculate automatically
SWEP.Shots					= 1			-- Amount of shots per trigger pull
SWEP.Cone					= 0.07		-- Your shot spread
SWEP.AimCone				= 0.005		-- Your shot spread if you aiming
SWEP.Spread					= 0.00		-- Spread from the direction, that calculates from values above. Uses in shotguns
SWEP.Delay 					= 0.19		-- Delay between shots(quick formula for RPM: 60/RPM)
SWEP.IronPos 				= Vector(1.73,0,1.15)
SWEP.SprintAngle 			= Angle(-15,0,0)
SWEP.SprintPos 				= Vector(0,0,1.2)
--SWEP.AimAdd					= 0.06	
SWEP.AimAddMul				= 70		-- How fast you gonna aim(1 second should ~~ 100 units)
--SWEP.SprintAdd				= 8	
SWEP.SprintAddMul			= 70		-- How fast you gonna stop shooting(1 second should ~~ 100 units)
SWEP.RecoilForce			= {1,1}		-- Recoil force, obviously(y,x)
SWEP.InAirRecoilForce		= {0.3,0.0}	-- Recoil while you flying across the map(y,x)
--Disabled--
SWEP.ReloadSpeedMul			= 0.6		-- Speed of reload
SWEP.DeploySpeedMul			= 0.6		-- Speed of deploy
SWEP.RealDeploySpeedMul		= 0.7		-- Speed of readiness
--		  --
SWEP.ReloadSpeedTime		= 0.5		-- Speed of reload in seconds
SWEP.DeploySpeedTime		= 1.		-- Speed of deploy in seconds
SWEP.RealDeploySpeedTime	= 0.7		-- Speed of readiness in seconds

SWEP.AllowAdditionalShot	= 1			-- You want charge your gun with more than 13 shots?(It is a number value)

SWEP.BobScale				= 0.6	 	-- The scale of the viewmodel bob (viewmodel movement from left to right when walking around)
SWEP.SwayScale				= 0.4		-- The scale of the viewmodel sway (viewmodel position lerp when looking around)
SWEP.InertiaScale			= 1.0		-- For now. If set to 0, completely disables inertia	 
SWEP.CarryWeight   			= 785		-- Carry weight. Used in inertia and other systems
SWEP.Instabillity			= 10		-- Instabillity while aiming

SWEP.FireSound				= "snd_jack_hmcd_smp_close.wav"
SWEP.FarFireSound			= "snd_jack_hmcd_smp_far.wav"
SWEP.ReloadSound			= "snd_jack_hmcd_smp_reload.wav"
SWEP.DeploySound			= "snd_jack_hmcd_pistoldraw.wav"

--If passed a string, will find matching sequence--
SWEP.WReloadACT				= PLAYER_RELOAD
SWEP.ReloadACT				= ACT_VM_RELOAD
SWEP.DeployACT				= ACT_VM_DRAW
SWEP.VShootACT				= ACT_VM_PRIMARYATTACK
SWEP.WShootACT				= PLAYER_ATTACK1
SWEP.VLastShootACT			= ACT_VM_PRIMARYATTACK

SWEP.VIdleACT				= ACT_VM_IDLE
--												 --
SWEP.HoldAnim				= 'pistol'
SWEP.HoldAimAnim			= 'revolver'

--Stop giving ammo--
SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= false
SWEP.Secondary.Ammo         = "none"
--				  --

--TODO
-- Make the ammo mass matter(inertia) cause glock is better :(((

function SWEP:SetupDataTables()
	--self:NetworkVar("Bool",0,"Reloading")

end


function SWEP:Initialize()
	self:SetNextPrimaryFire( CurTime() + self.Delay )
	self:SetHoldType( self.HoldAnim )

	self.Reloading=false
	self.ReloadTime=nil	
	self.DeployTime=nil	--Used only for aiming
	self.AimPerc=0
	self.AimStartTime=CurTime()
	self.SprintStartTime=CurTime()
	self.SprintingWeapon=0
	if(self.DamageForce==nil)then
		self.DamageForce=self.Damage*0.05
	end

	self.m_bInitialized = true

end

function SWEP:Equip()
	local va = self:Animate(self.DeployACT,1,false)
	self.UpdateTime=true
	if(va~=nil)then
		self:SetDeploySpeed(self:GetAnimationMul(self.RealDeploySpeedTime,va))
	end	

end

function SWEP:DrawHUD()
		--
end

function SWEP:PrimaryAttack()

	-- Make sure we can shoot first
	if ( !self:CanPrimaryAttack() ) then return end

	-- Play shoot sound 
	self:EmitSound( self.FireSound,75,100 )
	self:EmitSound( self.FarFireSound,75*100,100,1,CHAN_AUTO ) --Changing channel
	-- Shoot bullets
	local AimPerc = self.AimPerc
	if(AimPerc<0.9)then
		self:ShootBullet( math.random(self.Damage,self.DamageVar), self.Shots, self.Cone, self.Spread, self.Primary.Ammo, self.DamageForce, nil )
	else
		self:ShootBullet( math.random(self.Damage,self.DamageVar), self.Shots, self.AimCone, self.Spread, self.Primary.Ammo, self.DamageForce, nil )
	end
	-- Remove 1 bullet from our clip
	self:TakePrimaryAmmo( 1 )

	if( SERVER and !self.Owner:IsNPC() )then
		if(self.Owner:OnGround())then
		 self.Flying = 0
		else
		 self.Flying = 1
		end
		local Ang,Rec,AirForce=self.Owner:EyeAngles(),self.RecoilForce,self.InAirRecoilForce
		local RecoilY=math.Rand(.015,.03)*Rec[1]+(AirForce[1]*self.Flying)
		local RecoilX=math.Rand(-.03,.05)*Rec[2]+(AirForce[2]*self.Flying)
		self.Owner:SetEyeAngles((Ang:Forward()+RecoilY*Ang:Up()+Ang:Right()*RecoilX):Angle())
		--self.Owner:ViewPunchReset()
		self.Owner:ViewPunch( Angle(RecoilY*-50*self.RecoilForce[1],RecoilX*-50*self.RecoilForce[2],0) )
	end

	

end

function SWEP:SecondaryAttack()

end

function SWEP:CanReload()
	local Reloading,Sprinting=self.Reloading,self.SprintingWeapon
	local Ammo =  self.Owner:GetAmmoCount( self:GetPrimaryAmmoType() )
		if(!Reloading and Sprinting==0)then
			if( self:Clip1() < self.Primary.ClipSize+self.AllowAdditionalShot and Ammo>0)then
				return true
			end	
		end
	return false	
end

function SWEP:ReloadWeapon(VA,WA)
if(!self:CanReload())then return end
				self.Reloading=true
				self.ReloadTime=CurTime()+self.ReloadSpeedTime
				local va = self:Animate(VA,1,false)
				local va = self:Animate(VA,self:GetAnimationMul(self.ReloadSpeedTime,va))
				local vm=self.Owner:GetViewModel()
				vm:SetPlaybackRate(self:GetAnimationMul(self.ReloadSpeedTime))
				
				self.Owner:SetAnimation( WA )
		
				

		self:EmitSound(self.ReloadSound,65,100,1,CHAN_AUTO)
end

function SWEP:Reload()
	if(self.Owner:KeyPressed(IN_RELOAD) and self:Clip1() < self.Primary.ClipSize+self.AllowAdditionalShot)then
		self:ReloadWeapon( self.ReloadACT, self.WReloadACT )
	end
end

function SWEP:Think()
	if (not self.m_bInitialized) then
		self:Initialize()
	end	
	if (self.UpdateTime)then
		self.UpdateTime=false
		self.AimStartTime=CurTime()				
		self.SprintStartTime=CurTime()				
	end
	
	local AimPerc = self.AimPerc
	local Reloading,Sprinting = self.Reloading,self.SprintingWeapon
	local AimChanged=IsChanged( self.Owner:KeyDown(IN_ATTACK2), 'aimin', self )

		if( self.Owner:KeyDown(IN_ATTACK2) and AimChanged )then
			self:SetHoldType( self.HoldAimAnim )
			self.Owner:ChatPrint('gay')
		elseif ( not self.Owner:KeyDown(IN_ATTACK2) and AimChanged )then 
			self:SetHoldType( self.HoldAnim )
			self.Owner:ChatPrint('not gay')
		end
		--										--
		
		self.changed=IsChanged( self.Owner:OnGround(), 'grounded', self ) or ( self.DeployTime~=nil and IsChanged( self.DeployTime<=CurTime(), 'deploy', self ) ) or ( self.ReloadTime~=nil and IsChanged( self.ReloadTime<=CurTime(), 'reload', self ) )
		
		if(self.Owner:KeyPressed(IN_ATTACK2) or self.Owner:KeyReleased(IN_ATTACK2) or self.Owner:KeyPressed(IN_SPEED) or self.Owner:KeyReleased(IN_SPEED) or self.changed)then --Long as duck
			self.AimStartTime=CurTime()				--Fuck the time!
			self.SprintStartTime=CurTime()			--Looks bad 
			self.changed=false
		end			

		
			if(self.Owner:KeyDown(IN_ATTACK2) and !Reloading and Sprinting<60 and self.Owner:OnGround())then
			if not(AimPerc>=100)then
				self.AimPerc=math.Clamp(self.AimPerc+(CurTime()-self.AimStartTime)*self.AimAddMul,0,100)
				
			end
			elseif not(AimPerc<=0)then 
				self.AimPerc=math.Clamp(self.AimPerc-(CurTime()-self.AimStartTime)*self.AimAddMul,0,100)
			
			end	
			

		if(self.DeployTime~=nil and self.DeployTime<=CurTime())then
			self.DeployTime=nil
			--self.INDL=true		
		end
		if(self.ReloadTime~=nil and self.ReloadTime<=CurTime())then
			self.ReloadTime=nil
			self.Owner:ChatPrint("HHH")
			--self.INRL=true
			self.Reloading=false
			local Ammo =  self.Owner:GetAmmoCount( self:GetPrimaryAmmoType() )
				if( 0<self:Clip1() and self:Clip1() < self.Primary.ClipSize+self.AllowAdditionalShot)then
				local Difference = math.Clamp(self.Primary.ClipSize+self.AllowAdditionalShot - self:Clip1(),0,Ammo)
					self:SetClip1( self:Clip1()+Difference )
					self.Owner:RemoveAmmo( Difference, self:GetPrimaryAmmoType() )
				else
					local Difference = math.Clamp(self.Primary.ClipSize - self:Clip1(),0,Ammo)
					self:SetClip1( self:Clip1()+Difference )
					self.Owner:RemoveAmmo( Difference, self:GetPrimaryAmmoType() )
				end
		end

		
	--[[
		if(self.VIEWLastAngGotten==nil)then  self.VIEWLastAngGotten=Angle(0,0,0) self.VIEWAngMul=0 end
		 self.VIEWAngMul=math.Clamp(self.InertiaScale,0,1)
		if(self.VIEWLastAngEyeGotten==self.Owner:EyeAngles() and self.VIEWAngMul==1)then self.VIEWAngMul=0 end
		self.VIEWAngGotten		=			LerpAngle(self.VIEWAngMul,self.VIEWLastAngGotten,self.Owner:EyeAngles())
		 self.VIEWLastAngEyeGotten		=		self.Owner:EyeAngles()
		 self.VIEWLastAngGotten		=	self.VIEWAngGotten
		self.VIEWAng		=		self.VIEWAngGotten	
		]]	

		

	
		if(self.Owner:KeyDown(IN_SPEED) and !Reloading)then
			if(Sprinting~=100)then
			self.SprintingWeapon=math.Clamp(self.SprintingWeapon+(CurTime()-self.SprintStartTime)*self.SprintAddMul,0,100)
			end
		elseif(Sprinting~=0)then
			self.SprintingWeapon=math.Clamp(self.SprintingWeapon-(CurTime()-self.SprintStartTime)*self.SprintAddMul,0,100)
		end
		
		if(self.NextIdleTime==nil)then self.NextIdleTime=CurTime()+100 end
		if(self.NextIdleTime<=CurTime())then
				self:Animate(self.VIdleACT)
		end	
		if(SERVER)then
			if(self.InertiaScale~=0)then
			self.angl=self.Owner:GetViewModel():GetAngles()
			if(self.oldAng==nil)then self.oldAng = self.angl end
			if(self.angDiff==nil)then self.angDiff=self.angl end
					 self.sensitivity,self.strength=self.CarryWeight/714,self.CarryWeight/1000
					self.angDiff = LerpAngle(math.Clamp(0.5,0,1), self.angDiff, self.angl - self.oldAng)
					self.oldAng = self.angl
					self.angl = self.angl - self.angDiff * self.sensitivity
			end
		end	
	
end

function SWEP:UpdateNextIdle(Mul)
if(Mul==nil)then Mul=1 end
	local vm=self.Owner:GetViewModel()
	self.NextIdleTime=CurTime()+vm:SequenceDuration()/Mul
end

function SWEP:GetAnimationMul(Mul,Anim)
if(Mul==nil)then Mul=1 end

	local vm=self.Owner:GetViewModel()
	local PreMul=0
	if(Anim~=nil)then
		Anim = vm:SelectWeightedSequence(Anim)
		 PreMul=(vm:SequenceDuration(Anim))/Mul
	else
		 PreMul=(vm:SequenceDuration())/Mul
	end
		return PreMul
end


function SWEP:GetViewModelPosition(pos,ang)

	if(LastAimGotten==nil)then LastAimGotten=0 end
	if(LastSprintGotten==nil)then LastSprintGotten=0 LastAngGotten=self.Owner:EyeAngles() end

		local AimGotten=Lerp(.05,LastAimGotten,self.AimPerc/100)	--I like this, Jack! no joking	
		LastAimGotten=AimGotten
		local Aim=AimGotten
		
		local SprintGotten=Lerp(.05,LastSprintGotten,self.SprintingWeapon/100)	
		LastSprintGotten=SprintGotten
		local Sprint=SprintGotten		
		--[[
		local AngGotten=LerpAngle(.05,LastAngGotten or Angle(0,0,0),self:GetAngleWeapon() or Angle(0,0,0))	
		LastAngGotten=AngGotten
		local Ang=AngGotten
	]]
		--local ang=vm:GetAngles()
		if(self.InertiaScale~=0)then
		if(oldAng==nil)then oldAng = ang end
		if(angDiff==nil)then angDiff=ang end
				local sensitivity,strength=self.CarryWeight/714,self.CarryWeight/1000
				angDiff = LerpAngle(math.Clamp(FrameTime(),0,1), angDiff, ang - oldAng)
				oldAng = ang
				ang = ang - angDiff * sensitivity
				self.AngleWeapon=ang
		end
	
			ang:RotateAroundAxis(ang:Right(),self.SprintAngle.p*Sprint)
			ang:RotateAroundAxis(ang:Up(),self.SprintAngle.y*Sprint)
			ang:RotateAroundAxis(ang:Forward(),self.SprintAngle.r*Sprint)
			
			npos=LerpVector( Aim, Vector( 0, 0, 0 ), self.IronPos )
			spos=LerpVector( Sprint, Vector( 0, 0, 0 ), self.SprintPos )
			return pos+ang:Right()*(npos[1]+spos[1])+ang:Forward()*(npos[2]+spos[2])+ang:Up()*(npos[3]+spos[3]),ang--+nang
end 

--:CalcViewModelView(vm, pos, ang, p, a )
--:GetViewModelPosition(pos,ang)

function SWEP:Holster( wep )
		self.ReloadTime=nil
		self.DeployTime=nil	
	
		self.Reloading=false
	
	return true
end

function SWEP:Deploy()	
	local va = self:Animate(self.DeployACT,1,false)
	self.UpdateTime=true
	if(va~=nil)then
		self:SetDeploySpeed(self:GetAnimationMul(self.RealDeploySpeedTime,va))
	end
	self.HoldedKey=false
	self:SetHoldType( self.HoldAnim )
	self.AimPerc=0
	self.SprintingWeapon=0
	self.NextIdleTime=0
				self.Reloading=true
				local va = self:Animate(self.DeployACT,1,false)
				local va = self:Animate(self.DeployACT,self:GetAnimationMul(self.DeploySpeedTime,va))
				local vm=self.Owner:GetViewModel()
				vm:SetPlaybackRate(self:GetAnimationMul(self.DeploySpeedTime))
				
				
				self.ReloadTime=nil
				self.Reloading=false
	
	self:EmitSound(self.DeploySound,65,100,1,CHAN_AUTO)
	return true
end

function SWEP:Animate(VA,Mul,shouldplay)
if(shouldplay==nil)then shouldplay=true end
if(Mul==nil)then Mul=1 end

	if(isnumber(VA))then
		if(shouldplay)then
			self:SendWeaponAnim( VA )		-- View model animation
			self:UpdateNextIdle(Mul)
		end
		return VA
	else
		local va,vad=self:LookupSequence(VA)	
		local vm=self.Owner:GetViewModel()
		if(shouldplay)then
			vm:SendViewModelMatchingSequence( va )  --You may use it...
			self:UpdateNextIdle(Mul)
		end
		return va
	end
	
end

function SWEP:ShootEffects(VA,WA)
	self:Animate(VA)
	self.Owner:SetAnimation( WA )		-- 3rd Person Animation
	self.Owner:MuzzleFlash()						-- Crappy muzzle light
end

function SWEP:ShootBullet( damage, num_bullets, aimcone, spread, ammo_type, force, tracer )
--self:GetAngleWeapon():Forward()
--self.Owner:GetAimVector()
--self.AngleWeapon:Forward()
if(SERVER and self.InertiaScale!=0)then
	self.dir=self.angl:Forward()
end
if(CLIENT and self.InertiaScale!=0)then
	self.dir=self.AngleWeapon:Forward()
	--dir=(self.Owner:GetAimVector():Angle()-angDiff*7)
end
	if(self.InertiaScale==0)then self.dir=self.Owner:GetAimVector() end
	
	self.dir = (self.dir+VectorRand()*aimcone):GetNormalized()

	local bullet = {}
	bullet.Num		= num_bullets
	bullet.Src		= self.Owner:GetShootPos()			-- Source
	bullet.Dir		= self.dir	-- Dir of bullet
	bullet.Spread	= Vector( spread, spread, 0 )		-- Aim Cone
	bullet.Tracer	= tracer || 0						-- Show a tracer on every x bullets
	bullet.Force	= force || damage*0.05					-- Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = ammo_type || self.Primary.Ammo

	self.Owner:FireBullets( bullet )

	self:ShootEffects(self.VShootACT,self.WShootACT)

end

function SWEP:TakePrimaryAmmo( num )

	-- Doesn't use clips
	if ( self:Clip1() <= 0 ) then

		if ( self:Ammo1() <= 0 ) then return end

		self.Owner:RemoveAmmo( num, self:GetPrimaryAmmoType() )

	return end

	self:SetClip1( self:Clip1() - num )

end

function SWEP:TakeSecondaryAmmo( num )

	-- Doesn't use clips
	if ( self:Clip2() <= 0 ) then

		if ( self:Ammo2() <= 0 ) then return end

		self.Owner:RemoveAmmo( num, self:GetSecondaryAmmoType() )

	return end

	self:SetClip2( self:Clip2() - num )

end

function SWEP:CanPrimaryAttack()
	local Reloading,Sprinting = self.Reloading,self.SprintingWeapon
	if ( self:Clip1() <= 0 or Sprinting>10 or Reloading ) then
		if(Sprinting<=10 and !Reloading )then
			self:EmitSound( "Weapon_Pistol.Empty" )
			self:SetNextPrimaryFire( CurTime() + self.Delay )
			--self:Reload()
		
		end
		return false
	end

	if(self:GetNextPrimaryFire() <= CurTime())then
		self:SetNextPrimaryFire( CurTime() + self.Delay )
		return true
	end
	
end

function SWEP:CanSecondaryAttack()

	if ( self:Clip2() <= 0 ) then

		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextSecondaryFire( CurTime() + 0.2 )
		return false

	end

	return true

end

function SWEP:OnRemove()
end

function SWEP:OwnerChanged()
end

function SWEP:Ammo1()
	return self.Owner:GetAmmoCount( self:GetPrimaryAmmoType() )
end

function SWEP:Ammo2()
	return self.Owner:GetAmmoCount( self:GetSecondaryAmmoType() )
end

function SWEP:SetDeploySpeed( speed )
	self.m_WeaponDeploySpeed = tonumber( speed )
end

function SWEP:DoImpactEffect( tr, nDamageType )

	return false

end