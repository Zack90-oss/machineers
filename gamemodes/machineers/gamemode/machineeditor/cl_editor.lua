
MCHN_Editor = MCHN_Editor or {}
MCHN_Editor.Settings 	= {}
MCHN_Editor.Variables 	= {}
MCHN_Editor.Tools 		= {}

MCHN_Editor.Variables["Render_Models"]				= {}
MCHN_Editor.Variables["NextClickTime"]				= 0
MCHN_Editor.Variables["LastSelectedModel"]			= nil

MCHN_Editor.Settings["EDITOR_SELECT"]				= IN_ATTACK
MCHN_Editor.Settings["EDITOR_HIDE"]					= IN_WALK
MCHN_Editor.Settings["EDITOR_MULTIPLE"]				= IN_DUCK
MCHN_Editor.Settings["EDITOR_HOLDMENU"]				= KEY_C
MCHN_Editor.Settings["DoubleClickCompensation"]		= 0.1
MCHN_Editor.Settings["TraceLen"]					= 1000
MCHN_Editor.Settings["Color_Selected"]				= Color(0,255,0,200)
MCHN_Editor.Settings["Color_LastSelected"]			= Color(0,255,180,200)

MCHN_Editor.Variables["SelectedTool"]				= "Translation"

hook.Add( "Think", "MachineersEditor_Think", function()
	if( !MCHN_Editor:IsOpened() )then return nil end
	hook.Call( MCHN_Editor.Tools[ MCHN_Editor.Variables["SelectedTool"] ]["ToolHook"] )
	
	local holdKey
	local binding = input.LookupBinding("+menu_context")
	if(binding)then
		holdKey = input.GetKeyCode(binding)
	else
		holdKey = MCHN_Editor.Settings["EDITOR_HOLDMENU"] or KEY_C
	end
	
	local menu=MCHN_Editor:GetMainPanel()
	
	if(input.IsKeyDown(holdKey))then
		menu:SetKeyboardInputEnabled(false)
		menu:SetMouseInputEnabled(true)
	else
		menu:SetKeyboardInputEnabled(false)
		menu:SetMouseInputEnabled(false)	
	end
end)

function MCHN_Editor:Toggle()

	if( MCHN_Editor:IsOpened() )then
		MCHN_Editor:Close()
		return nil
	end
		local selfsize={ 288, ScrH() * 0.5 }

		local menu = vgui.Create( "DFrame" )
		menu:SetSize( selfsize[1], selfsize[2] )
		menu:SetPos( ScrW()-selfsize[1], ScrH()-selfsize[2] )
		menu:MakePopup()
		menu:SetKeyboardInputEnabled(false)
		menu:SetMouseInputEnabled(false)	
		menu:SetDraggable(false)
		menu:ShowCloseButton(false)
		menu:SetTitle("")
		menu:DockPadding(4,4,4,4)

		function MCHN_Editor:GetMainPanel()
			return menu
		end
		
		MCHN_Editor:ConstructSpawnList()
		hook.Call("MachineersEditor_OnOpen")
end

function MCHN_Editor:IsOpened()
	return MCHN_Editor.GetMainPanel~=nil and IsValid(MCHN_Editor:GetMainPanel())
end

concommand.Add("Machineers_editor", MCHN_Editor.Toggle )

function MCHN_Editor:Close()
	MCHN_Editor:RemoveAllModels()
	MCHN_Editor:GetMainPanel():Remove()
	hook.Call("MachineersEditor_OnClose")
end

function MCHN_Editor:ConstructSpawnList()
	local menu = MCHN_Editor:GetMainPanel()
	local items = MCHN_Editor:FindModels()
	local categoryList = vgui.Create( "DCategoryList", menu )
	categoryList:Dock( FILL )
	for key, object in pairs(items) do
		local category = categoryList:Add(key)
		local spawnList = vgui.Create( "DIconLayout",category )
		category:SetContents(spawnList)
		for key2, modelName in pairs(object) do
			local spawnIcon = vgui.Create( "SpawnIcon" )
			spawnIcon:SetModel( modelName )
			spawnIcon.Class = "prop"	--Because it is prop!
			function spawnIcon:DoClick()
				MCHN_Editor:CreateEntityOnCursor( self.Class, self:GetModelName() )
			end
			
			spawnList:Add( spawnIcon )
		end
	end
end

function MCHN_Editor:FindModels()
	local foundModels = {}
	local tableid = MCHN_Editor_ModelPaths
	local tableid2 = MCHN_Editor_ModelList
	for key, object in pairs( tableid ) do
		foundModels[key] = {}
		for key2, path in pairs( object ) do
			table.Add( foundModels[key], MCHN_Editor:FindModelsFromPath( path ) )
		end
	end
	for key, object in pairs(tableid2) do
		if( !foundModels[key] )then
			foundModels[key]={}
		end
		table.Add(foundModels[key],MCHN_Editor_ModelList[key])
	end
	return foundModels
end

function MCHN_Editor:FindModelsFromPath( srctable )
	local foundModels = {}
	local path = srctable[1]..srctable[2]
	local files, _ = file.Find( path, srctable[3] )
	for key3, modelName in pairs(files) do
		table.insert(foundModels,srctable[1]..modelName)
	end
	return foundModels
end

function MCHN_Editor:CreateEntity( Class, Model )
	local entity = ClientsideModel( Model or nil )
	entity.Class = Class
	table.insert( MCHN_Editor.Variables["Render_Models"], entity )
	hook.Call("MachineersEditor_OnCreateEntity")
	return entity
end

function MCHN_Editor:CreateEntityOnCursor( Class, Model )
	local entity = MCHN_Editor:CreateEntity( Class, Model )
	local endpos = LocalPlayer():EyePos()+LocalPlayer():GetAimVector()*MCHN_Editor.Settings["TraceLen"]
	local traceData = {
		start = LocalPlayer():EyePos(),
		endpos = endpos
	}
	local trace = util.TraceLine( traceData )
	if(trace.Hit)then
		entity:SetPos(trace.HitPos)
	else
		entity:SetPos(endpos)
	end
	return entity
end

function MCHN_Editor:RemoveAllModels()
	for _, object in pairs(MCHN_Editor.Variables["Render_Models"]) do
		object:Remove()
	end
	table.Empty(MCHN_Editor.Variables["Render_Models"])
	hook.Call("MachineersEditor_OnRemoveAllModels")
end

function MCHN_Editor:FindModelsAlongViewTrace( SaveData )
	local foundModels = {}
	local startPos = LocalPlayer():EyePos()
	local endVector = LocalPlayer():GetAimVector()*MCHN_Editor.Settings["TraceLen"]
	for _, object in pairs(MCHN_Editor.Variables["Render_Models"])do
		local hitPos = util.IntersectRayWithOBB( startPos, endVector, object:GetPos(), object:GetAngles(), object:GetModelBounds() )
		if(hitPos)then
			local distance = startPos:Distance(hitPos)
			if( SaveData )then
				table.insert( foundModels, {Object = object, HitPos = hitPos, Distance2 = distance} )
			else
				table.insert( foundModels, {Object = object} )
			end
		end
	end
	--PrintTable(foundModels)
	return foundModels
end

--//Returns "Object"//--
function MCHN_Editor:FindClosestFromTable(List)
	local prevDistance
	local entity
	for _,listObject in pairs(List)do
		local object = listObject.Object
		--PrintTable(listObject)
		local hitPos = listObject.HitPos
		local distance
		if(listObject.Distance2)then
			distance = listObject.Distance2
		else
			distance = LocalPlayer():GetShootPos():DistToSqr(object:GetPos())
		end
		if(!prevDistance)then
			prevDistance=distance
			entity={Object = object, HitPos = hitPos, Distance2 = distance }
		end
		if(distance<prevDistance)then
			prevDistance=distance
			entity={Object = object, HitPos = hitPos, Distance2 = distance }
		end
	end
	--PrintTable(entity)
	return entity	-- "Object"
end

--//Uses this "Object" to get euclidean distance//--
--These names are very confusing => explain
function MCHN_Editor:GetDistanceFromObjectToView(Object)
	return Object.HitPos:Distance(LocalPlayer():GetShootPos())
end

function MCHN_Editor:GetLastSelectedModel()
	return MCHN_Editor.Variables["LastSelectedModel"]
end

function MCHN_Editor:SetLastSelectedModel( Ent )
	local lastModel = MCHN_Editor.Variables["LastSelectedModel"]
	if(IsValid(lastModel))then
		lastModel:SetRenderMode(RENDERMODE_TRANSCOLOR)
		lastModel:SetColor(MCHN_Editor.Settings["Color_Selected"])
	end
	MCHN_Editor.Variables["LastSelectedModel"] = Ent
	Ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
	Ent:SetColor(MCHN_Editor.Settings["Color_LastSelected"])
end

function MCHN_Editor:SelectEntity( Ent )
	Ent.Selected=true
	Ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
	Ent:SetColor(MCHN_Editor.Settings["Color_Selected"])
	MCHN_Editor:SetLastSelectedModel( Ent )
	hook.Call("MachineersEditor_OnSelectEntity",nil,Ent)
end

function MCHN_Editor:UnSelectEntity( Ent )
	Ent.Selected=false
	Ent:SetRenderMode(RENDERMODE_NORMAL)
	Ent:SetColor(Color(255,255,255))
	hook.Call("MachineersEditor_OnUnSelectEntity",nil,Ent)
end
