
SWEP.PrintName		= "Just Crowbar"
SWEP.Instructions	= "This is a tool"
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
SWEP.ViewModel		= "models/weapons/c_crowbar.mdl"			--"models/weapons/v_pist_jeagle.mdl"	--"models/weapons/v_pist_jivejeven.mdl"	
SWEP.WorldModel		= "models/weapons/w_stunbaton.mdl"

SWEP.Spawnable		= false
SWEP.AdminOnly		= false

SWEP.DangerLevel			= 50		-- How fast police will react to you holding this thing in hands?
SWEP.Primary.ClipSize		= 0			-- Size of a clip
SWEP.Primary.DefaultClip	= 0			-- Default number of bullets in a clip
SWEP.Primary.Automatic		= true		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"
SWEP.Damage					= 24			-- Damage number 1
SWEP.DamageVar				= 32		-- How much damage will vary. If set to 0 => only default damage numbers will engage
SWEP.DamageForce			= 3000		-- Force applied to phys objects then damaged by weapon. Pass nil to calculate automatically
SWEP.Delay 					= 1.0		-- Delay between shots
SWEP.DeploySpeedMul			= 0.6		-- Speed of deploy
SWEP.RealDeploySpeedMul		= 1.0		-- Speed of readiness
SWEP.AttackDist				= 70
SWEP.Cone					= 0.35		-- Your attack cone
SWEP.WeaponDamageType		= DMG_SLASH
SWEP.AttackTimeMul			= 1			-- Animation thing
SWEP.AttackSlowDown			= 1

SWEP.SprintPos 				= Vector(0,0,1.2)
SWEP.SprintAngle 			= Angle(15,0,0)
SWEP.SprintAddMul			= 70		-- How fast you gonna stop shooting(1 second should ~~ 1000 units)
SWEP.AttackSprintStep		= 90		-- 100 = can attack any time. 10 = can attack only then almost ready

SWEP.BobScale				= 0.6	 	-- The scale of the viewmodel bob (viewmodel movement from left to right when walking around)
SWEP.SwayScale				= 0.4		-- The scale of the viewmodel sway (viewmodel position lerp when looking around)
SWEP.InertiaScale			= 1.0		-- For now. If set to 0, completely disables inertia	 
SWEP.CarryWeight   			= 785		-- Carry weight. Used in inertia and other systems

SWEP.AttackSound			= "snd_jack_hmcd_smp_close.wav"

--If passed a string, will find matching sequence--
SWEP.VAttackACT				= ACT_VM_MISSCENTER
SWEP.VHitACT				= ACT_VM_HITCENTER
SWEP.WAttackACT				= PLAYER_ATTACK1

SWEP.VDeployACT				= ACT_VM_DRAW
SWEP.VIdleACT				= ACT_VM_IDLE
--												 --

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

function SWEP:SetupDataTables()

end

function SWEP:Initialize()
	self:SetNextPrimaryFire( CurTime() )
	self:SetHoldType( "melee" )
	self.SprintStartTime=CurTime()
	self.SprintingWeapon=0
	

	--self:UpdateNextIdle()
	
	
	self.Deployed=false
	
	if(self.DamageForce==nil)then
		self.DamageForce=self.Damage*0.05
	end
	self.m_WeaponDeploySpeed=self.RealDeploySpeedMul
end

function SWEP:DrawHUD()
		--
end

function SWEP:PrimaryAttack()

	-- Make sure we can shoot first
	if ( !self:CanPrimaryAttack() ) then return end

	self:Animate(self.VAttackACT,self.AttackTimeMul)
	self.Owner:GetViewModel():SetPlaybackRate(self.AttackTimeMul)
	self:AttackEffects()
	
	-- Play shoot sound 
	self:EmitSound( self.AttackSound,75,100 )
end

function SWEP:AttackEffects()
	if(CLIENT)then return end
		local Dir = self.Owner:GetAimVector()
		local Ent=nil
		local HitPos=Vector(0,0,0)
		local HitNorm=Vector(0,0,0)
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + Dir * self.AttackDist,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )	
	if(IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) )then
		Ent,HitPos=tr.Entity,tr.HitPos
	else
		 Ent,HitPos,HitNorm=HMCD_WhomILookinAt(self.Owner,self.Cone,self.AttackDist)
	end
	if((IsValid(Ent))or((Ent)and(Ent.IsWorld)and(Ent:IsWorld())))then
		local DMG=DamageInfo()
		DMG:SetAttacker(self.Owner)
		DMG:SetInflictor(self.Weapon)
		DMG:SetDamage(math.random(self.Damage,self.DamageVar))
		DMG:SetDamageForce(Dir*self.DamageForce)		
		DMG:SetDamageType(self.WeaponDamageType)
		DMG:SetDamagePosition(HitPos)
		SuppressHostEvents( NULL )	---Let the gibs spawn
		Ent:TakeDamageInfo(DMG)
		SuppressHostEvents( self.Owner )
		
		
	end

end

function SWEP:SecondaryAttack()
--
end


function SWEP:Reload()
--
end

function SWEP:Think()
local Sprinting = self.SprintingWeapon

		if(self.Owner:KeyPressed(IN_SPEED) or self.Owner:KeyReleased(IN_SPEED))then 
			self.SprintStartTime=CurTime()			
		end		
		
		if(self.Owner:KeyDown(IN_SPEED))then
			if(Sprinting~=100)then
			self.SprintingWeapon=math.Clamp(self.SprintingWeapon+(CurTime()-self.SprintStartTime)*self.SprintAddMul,0,100)
			end
		elseif(Sprinting~=0)then
			self.SprintingWeapon=math.Clamp(self.SprintingWeapon-(CurTime()-self.SprintStartTime)*self.SprintAddMul,0,100)
		end	
		
		if(self.NextIdleTime==nil)then self.NextIdleTime=CurTime()+100 end
		if(self.NextIdleTime<=CurTime())then
				self:Animate(self.VIdleACT)
				--self:UpdateNextIdle()
		end
		
end

function SWEP:UpdateNextIdle(Mul)
if(Mul==nil)then Mul=1 end
	local vm=self.Owner:GetViewModel()
	self.NextIdleTime=CurTime()+vm:SequenceDuration()/Mul
end

function SWEP:GetViewModelPosition(pos,ang)
		if(LastSprintGotten==nil)then LastSprintGotten=0 end

		local SprintGotten=Lerp(.05,LastSprintGotten,self.SprintingWeapon/100)	
		LastSprintGotten=SprintGotten
		local Sprint=SprintGotten
		spos=LerpVector( Sprint, Vector( 0, 0, 0 ), self.SprintPos )
		nang=LerpAngle( Sprint, Angle( 0, 0, 0 ), self.SprintAngle )
		
		
			return pos+ang:Right()*(spos[1])+ang:Forward()*(spos[2])+ang:Up()*(spos[3]),ang+nang
end 

--:CalcViewModelView(vm, pos, ang, p, a )
--:GetViewModelPosition(pos,ang)
function SWEP:Holster( wep )
	

	return true
end

function SWEP:Deploy()
	self:Animate(self.VDeployACT,self.DeploySpeedMul)
	self.Owner:GetViewModel():SetPlaybackRate(self.DeploySpeedMul)
	--self:UpdateNextIdle()
	self.SprintingWeapon=0
	self.Deployed=false
	self:SetNextPrimaryFire( CurTime() )
	return true
end

function SWEP:Animate(VA,Mul,shouldplay)
if(shouldplay==nil)then shouldplay=true end
if(Mul==nil)then Mul=1 end
--print(VA,Mul)
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

function SWEP:CanPrimaryAttack()
	local 	Sprinting = self.SprintingWeapon 
	if(Sprinting>self.AttackSprintStep)then
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

function SWEP:SetDeploySpeed( speed )
	self.m_WeaponDeploySpeed = tonumber( speed )
end

function SWEP:DoImpactEffect( tr, nDamageType )

	return false

end