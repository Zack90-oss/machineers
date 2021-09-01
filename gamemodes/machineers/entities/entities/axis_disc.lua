
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.Spawnable = false
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()

	self:DrawShadow( false )
	self:EnableCustomCollisions()
	self.Color = Color( 0, 255, 255 )
	self.Color_Hover = color_white

	if ( SERVER ) then
		self:SetSize( 20 )
		--self:SetPriority( 1 )
	end

end

function ENT:SetupDataTables()

	self:NetworkVar( "Float", 0, "SizeVar" ) -- Size (bounds)

end

function ENT:GetSize()
	return self:GetSizeVar()
end

function ENT:SetSize( size )

	if ( self:GetSize() == size ) then return end

	self:SetSizeVar( size )
	self:SetSolid( SOLID_BBOX )
	self:SetCollisionBounds( Vector( size, size, size) * -0.5, Vector( size, size, size) * 0.5 )

end

function ENT:Setup( ent, boneid, rotate )
	
end


function ENT:Draw()
	local size = self:GetSize()
	--print(size)
	cam.Start3D2D(self:GetPos() , self:GetAngles() , 1)
		surface.SetDrawColor( 255, 165, 0, 255 )
		surface.SetMaterial( MCHN_WIDGET_DISC )
		surface.DrawTexturedRect( 0, 0, size, size )
		--surface.SetDrawColor( 255, 165, 0, 255 )
		--surface.DrawRect(0,0,8,8)
	cam.End3D2D() 
end

function ENT:OnArrowDragged( num, dist, pl, mv )

	-- MsgN( num, dist, pl, mv )

end