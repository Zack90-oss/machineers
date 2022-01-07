MCHN_Editor.Tools["Translation"]								= {}
MCHN_Editor.Tools["Translation"]["ToolHook"]					= "MachineersEditor_Tools_Translation_Think"

MCHN_Editor.Tools["Translation"]["Settings"]					= {}
MCHN_Editor.Tools["Translation"]["Settings"]["MOVE"] 			= IN_ATTACK2
MCHN_Editor.Tools["Translation"]["Settings"]["TRANSLATE"] 		= KEY_R

hook.Add("MachineersEditor_OnClose", "machineers_default_editor_close", function()
	MCHN_Editor:RemoveTranslationWidget()
end)

function MCHN_Editor:IsTranslationPanelExists()
	return MCHN_Editor.GetTranslationWidgetPanel and IsValid(MCHN_Editor:GetTranslationWidgetPanel())
end

function MCHN_Editor:CreateTranslationWidget()
	if( MCHN_Editor:IsTranslationPanelExists() or MCHN_Editor:GetLastSelectedModel()==nil )then 
		return 
	end
	local modelname=vgui.Create( "DFrame" )
	local size = {400,200}
	modelname:SetSize(size[1],size[2])
	modelname:SetPos(0,ScrH()-size[2]-64)
	modelname:CenterHorizontal()
	--modelname:SetDraggable(false)
	modelname:ShowCloseButton(false)
	modelname:MakePopup()
	modelname:SetTitle("Translation Panel")
	
	--local modelAngles = LastSelectedModel:GetAngles()
	local rotationAngles = MCHN_Editor:GetLastSelectedModel():GetAngles()
	
	local sliderX=vgui.Create( "DNumSlider", modelname )
	sliderX:Dock( TOP )
	sliderX:SetText( " Angles X " )
	sliderX:SetMin( 0 )
	sliderX:SetMax( 360 )
	sliderX:SetDecimals( 0 )
	sliderX:SetValue( rotationAngles[1] )
	sliderX.OnValueChanged = function( self, value )
		rotationAngles[1] = value
		MCHN_Editor:RotateSelectedModels(rotationAngles)
	end

	local sliderY=vgui.Create( "DNumSlider", modelname )
	sliderY:Dock( TOP )
	sliderY:SetText( " Angles Y " )
	sliderY:SetMin( 0 )
	sliderY:SetMax( 360 )
	sliderY:SetDecimals( 0 )
	sliderY:SetValue( rotationAngles[2] )
	sliderY.OnValueChanged = function( self, value )
		rotationAngles[2] = value
		MCHN_Editor:RotateSelectedModels(rotationAngles)
	end

	local sliderZ=vgui.Create( "DNumSlider", modelname )
	sliderZ:Dock( TOP )
	sliderZ:SetText( " Angles Z " )
	sliderZ:SetMin( 0 )
	sliderZ:SetMax( 360 )
	sliderZ:SetDecimals( 0 )
	sliderZ:SetValue( rotationAngles[3] )
	sliderZ.OnValueChanged = function( self, value )
		rotationAngles[3] = value
		MCHN_Editor:RotateSelectedModels(rotationAngles)
	end	

	local movePosition = MCHN_Editor:GetLastSelectedModel():GetPos()
	
	local sliderPosX=vgui.Create( "DTextEntry", modelname )
	sliderPosX:Dock( TOP )
	sliderPosX:SetText( " Position X " )
	sliderPosX:SetNumeric( true )
	sliderPosX:SetValue( movePosition[1] )
	sliderPosX.OnChange = function( self )
		movePosition[1] = tonumber(self:GetValue()) or 0
		MCHN_Editor:MoveSelectedModels(movePosition)
	end

	local sliderPosY=vgui.Create( "DTextEntry", modelname )
	sliderPosY:Dock( TOP )
	sliderPosY:SetText( " Position Y " )
	sliderPosY:SetNumeric( true )
	sliderPosY:SetValue( movePosition[2] )
	sliderPosY.OnChange = function( self )
		movePosition[2] = tonumber(self:GetValue()) or 0
		MCHN_Editor:MoveSelectedModels(movePosition)
	end

	local sliderPosZ=vgui.Create( "DTextEntry", modelname )
	sliderPosZ:Dock( TOP )
	sliderPosZ:SetText( " Position Z " )
	sliderPosZ:SetNumeric( true )
	sliderPosZ:SetValue( movePosition[3] )
	sliderPosZ.OnChange = function( self )
		movePosition[3] = tonumber(self:GetValue()) or 0
		MCHN_Editor:MoveSelectedModels(movePosition)
	end
	
	function MCHN_Editor:GetTranslationWidgetPanel()
		return modelname
	end
	
end

function MCHN_Editor:RotateSelectedModels(RotationAngles)
	local lastModel = MCHN_Editor:GetLastSelectedModel()
	local rotationDelta = RotationAngles-lastModel:GetAngles()
	for key=1, #MCHN_Editor.Variables["Render_Models"] do
		local model = MCHN_Editor.Variables["Render_Models"][key]
		if(model.DragOffset~=nil)then
			local modelAngles = model:GetAngles()
			local lastModelAngles = lastModel:GetAngles()
			model:SetAngles(modelAngles+rotationDelta)
			if(model==lastModel)then
				--
				
			else
				model.DragOffset:Rotate(rotationDelta)
				model:SetPos(lastModel:GetPos()+model.DragOffset)
			end
		end		
	end
end

function MCHN_Editor:RemoveTranslationWidget()
	if(MCHN_Editor:IsTranslationPanelExists())then
		MCHN_Editor:GetTranslationWidgetPanel():Remove()
	end
end

local function InputThink_Translation()
	if(MCHN_Editor.Variables["NextClickTime"]==nil)then 
		MCHN_Editor.Variables["NextClickTime"]=CurTime()+MCHN_Editor.Settings["DoubleClickCompensation"] 
	end
	
	if( LocalPlayer():KeyPressed( MCHN_Editor.Settings["EDITOR_SELECT"] ) and MCHN_Editor.Variables["NextClickTime"]<=CurTime() )then
		MCHN_Editor.Variables["NextClickTime"] = CurTime()+MCHN_Editor.Settings["DoubleClickCompensation"] 
		local outObject = MCHN_Editor:FindModelsAlongViewTrace()
		outObject=MCHN_Editor:FindClosestFromTable(outObject)
		if(outObject)then 
			outObject =	outObject.Object
		end
		--print("Selected: "..outObject:GetModel())
		
		if( !outObject and !LocalPlayer():KeyDown( MCHN_Editor.Settings["EDITOR_MULTIPLE"] ) )then
			for key,model in pairs (MCHN_Editor.Variables["Render_Models"]) do
				if( model.Selected~=nil )then
					MCHN_Editor:UnSelectEntity( model )
				end
			end
		end
		
		if( !outObject and LocalPlayer():KeyDown( MCHN_Editor.Settings["EDITOR_HIDE"] ) )then
			for key=1, #MCHN_Editor.Variables["Render_Models"] do
				local model = MCHN_Editor.Variables["Render_Models"][key]
				if( model.Hided~=nil )then
					MCHN_Editor:UnhideProp( model )
				end
			end			
		end
		
		if( outObject and !LocalPlayer():KeyDown( MCHN_Editor.Settings["EDITOR_MULTIPLE"] )  )then
			if(outObject~=model)then
				for key=1, #MCHN_Editor.Variables["Render_Models"] do
					local model = MCHN_Editor.Variables["Render_Models"][key]
					MCHN_Editor:UnSelectEntity( model )
				end
				MCHN_Editor.Variables["LastSelectedModel"] = nil
			end
		end		
		
		if(outObject)then
			if(!outObject.Selected)then
				if(!LocalPlayer():KeyDown( MCHN_Editor.Settings["EDITOR_HIDE"] ))then
					MCHN_Editor:SelectEntity( outObject )
				else
					MCHN_Editor:HideProp( outObject )
				end
			else
				MCHN_Editor:UnSelectEntity( outObject )
			end
		end
		
	end
	
	if( input.IsKeyDown( MCHN_Editor.Tools["Translation"]["Settings"]["TRANSLATE"] ) )then
		if(!MCHN_Editor:IsTranslationPanelExists())then
			MCHN_Editor:CreateTranslationWidget()
		end
	elseif(MCHN_Editor:IsTranslationPanelExists())then
		MCHN_Editor:RemoveTranslationWidget()
	end
	
	
	if( LocalPlayer():KeyDown( MCHN_Editor.Tools["Translation"]["Settings"]["MOVE"] ) and !RotatingObject )then
		local info = MCHN_Editor:FindModelsAlongViewTrace( true )
		info = MCHN_Editor:FindClosestFromTable(info)
		for key=1, #MCHN_Editor.Variables["Render_Models"] do
			local model = MCHN_Editor.Variables["Render_Models"][key]
			if(model.DragOffset==nil and model.Selected==true)then
				if(istable(info) and !table.IsEmpty(info))then
					local HitPos = info.HitPos
					local Distance = MCHN_Editor:GetDistanceFromObjectToView(info)
					--print(HitPos,Distance)
					if(HitPos)then
						model.DragOffset=HitPos-model:GetPos()
						model.DragDistance=Distance
					end
				end
			end
			if(model.DragOffset~=nil)then
				model:SetPos(LocalPlayer():EyePos()+LocalPlayer():GetAimVector()*model.DragDistance-model.DragOffset)
			end
		end
	end
	
	if( LocalPlayer():KeyReleased( MCHN_Editor.Tools["Translation"]["Settings"]["MOVE"] ) and !RotatingObject )then
		for key,model in pairs(MCHN_Editor.Variables["Render_Models"]) do
			model.DragOffset=nil
		end
	end
end

hook.Add("MachineersEditor_Tools_Translation_Think", "MachineersEditor_Tools_Translation", InputThink_Translation)

local function OnUnselectEntity_Translation( Ent )
	Ent.DragOffset=nil
end
hook.Add("MachineersEditor_OnUnSelectEntity", "MachineersEditor_Tools_Translation", OnUnselectEntity_Translation)