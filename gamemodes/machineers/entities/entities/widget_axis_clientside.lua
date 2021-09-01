
AddCSLuaFile()

--
-- widget_axis_arrow
--

DEFINE_BASECLASS( "widget_arrow" )

local widget_axis_arrow = { Base = "widget_arrow" }

function widget_axis_arrow:Initialize()

	BaseClass.Initialize( self )

end

function widget_axis_arrow:SetupDataTables()

	BaseClass.SetupDataTables( self )
	self:NetworkVar( "Int", 0, "AxisIndex" )

end

function widget_axis_arrow:ArrowDragged( pl, mv, dist )

	self:GetParent():OnArrowDragged( self:GetAxisIndex(), dist, pl, mv )

end

scripted_ents.Register( widget_axis_arrow, "widget_axis_arrow" )

--
-- widget_axis_disc
--

DEFINE_BASECLASS( "widget_disc" )

local widget_axis_disc = { Base = "widget_disc" }

function widget_axis_disc:Initialize()
	BaseClass.Initialize( self )

end

function widget_axis_disc:GetGrabPos( Pos, Forward )

	local fwd = Forward
	local eye = Pos
	local arrowdir = self:GetAngles():Forward()

	local planepos = self:GetPos()
	local planenrm = ( eye - planepos ):GetNormal()

	local hitpos = util.IntersectRayWithPlane( eye, fwd, planepos, arrowdir )
	--print(hitpos)
	if ( !hitpos ) then return end

	-- The whole circle should be 360
	--hitpos = self:WorldToLocal( hitpos )
	--hitpos:Normalize()

	--local angle = math.atan2( hitpos.y, hitpos.z ) + math.pi
	--angle = math.deg( angle ) * -1
	
	--Red
	--Green
	--Blue
	
	local angle = (hitpos-planepos):Angle()
	print(self:GetAxisIndex(),angle)
	return  angle

end

function widget_axis_disc:SetupDataTables()

	BaseClass.SetupDataTables( self )
	self:NetworkVar( "Int", 0, "AxisIndex" )

end


function widget_axis_disc:ArrowDragged( pl, mv, dist )

	self:GetParent():OnArrowDragged( self:GetAxisIndex(), dist, pl, mv )

end

scripted_ents.Register( widget_axis_disc, "widget_axis_disc" )

DEFINE_BASECLASS( "widget_base" )

--
-- Set our dimensions etc
--
function ENT:Initialize()

	BaseClass.Initialize( self )

	self:SetCollisionBounds( Vector( -1, -1, -1 ), Vector( 1, 1, 1 ) )
	self:SetSolid( SOLID_NONE )

end

function ENT:Setup( ent, boneid, rotate )
	local Position = ent:GetPos()
	
	--self:FollowBone( ent, boneid )
	--self:SetLocalPos( vector_origin )
	--self:SetLocalAngles( angle_zero )

	local Size = 16

	local EntName = "widget_axis_arrow"
	if ( rotate ) then EntName = "widget_axis_disc" end

	self.ArrowX = ents.CreateClientside( EntName )
	self.ArrowX:Initialize()
	self.ArrowX:SetSize(16)
	self.ArrowX:SetPos( Position )
	self.ArrowX:SetParent( self )
	self.ArrowX:SetColor( Color( 255, 0, 0, 255 ) )
	self.ArrowX:Spawn()
	--self.ArrowX:SetPos( vector_origin )
	self.ArrowX:SetAngles( Vector( 1, 0, 0 ):Angle() )
	self.ArrowX:SetAxisIndex( 1 )

	self.ArrowY = ents.CreateClientside( EntName )
	self.ArrowY:Initialize()
	self.ArrowY:SetSize(16)
	self.ArrowY:SetPos( Position )
	self.ArrowY:SetParent( self )
	self.ArrowY:SetColor( Color( 0, 230, 50, 255 ) )
	self.ArrowY:Spawn()
	--self.ArrowY:SetPos( vector_origin )
	self.ArrowY:SetAngles( Vector( 0, 1, 0 ):Angle() )
	self.ArrowY:SetAxisIndex( 2 )

	self.ArrowZ = ents.CreateClientside( EntName )
	self.ArrowZ:Initialize()
	self.ArrowZ:SetSize(16)
	self.ArrowZ:SetPos( Position )
	self.ArrowZ:SetParent( self )
	self.ArrowZ:SetColor( Color( 50, 100, 255, 255 ) )
	self.ArrowZ:Spawn()
	--self.ArrowZ:SetPos( vector_origin )
	self.ArrowZ:SetAngles( Vector( 0, 0, 1 ):Angle() )
	self.ArrowZ:SetAxisIndex( 3 )

	self.Ready = true
	self.EntityParent = ent

	if ( self.IsScaleArrow && EntName == "widget_axis_arrow" ) then
		if ( IsValid( self.ArrowX ) ) then self.ArrowX:SetIsScaleArrow( true ) end
		if ( IsValid( self.ArrowY ) ) then self.ArrowY:SetIsScaleArrow( true ) end
		if ( IsValid( self.ArrowZ ) ) then self.ArrowZ:SetIsScaleArrow( true ) end
	end

end

function ENT:RemoveArrows()
	self.ArrowX:Remove()
	self.ArrowY:Remove()
	self.ArrowZ:Remove()
end

function ENT:UpdatePos()
	if(!self.Ready)then return end
	if(!IsValid(self.EntityParent))then return end
	local Position = self.EntityParent:GetPos()
	
	self.ArrowX:SetPos( Position )
	self.ArrowY:SetPos( Position )
	self.ArrowZ:SetPos( Position )
end

function ENT:SetPriority( x )

	if ( IsValid( self.ArrowX ) ) then self.ArrowX:SetPriority( x ) end
	if ( IsValid( self.ArrowY ) ) then self.ArrowY:SetPriority( x ) end
	if ( IsValid( self.ArrowZ ) ) then self.ArrowZ:SetPriority( x ) end

end

function ENT:Draw()
	
end

function ENT:OnArrowDragged( num, dist, pl, mv )

	-- MsgN( num, dist, pl, mv )

end