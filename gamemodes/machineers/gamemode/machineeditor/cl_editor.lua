
MCHN_Editor = MCHN_Editor or {}
MCHN_Editor.Settings 	= {}
MCHN_Editor.Variables 	= {}
MCHN_Editor.Tools 		= {}

MCHN_Editor.Variables["Render_Models"]				= {}
MCHN_Editor.Variables["NextClickTime"]				= 0
MCHN_Editor.Variables["DoubleClickCompensation"]	= 0.1


MCHN_Editor.Settings["EDITOR_SELECT"]				= IN_ATTACK

function MCHN_Editor:Toggle()

	if( MCHN_Editor.GetMainPanel~=nil and IsValid(MCHN_Editor:GetMainPanel()))then
		MCHN_Editor:Close()
		return nil
	end
		local selfsize={ 288, ScrH() * 0.5 }

		local menu = vgui.Create( "DFrame" )
		menu:SetSize( selfsize[1], selfsize[2] )
		menu:SetPos( ScrW()-selfsize[1], ScrH()-selfsize[2] )
		menu:MakePopup()
		menu:SetKeyboardInputEnabled(false)
		menu:SetDraggable(false)
		menu:ShowCloseButton(false)
		menu:SetTitle("")
		menu:DockPadding(4,4,4,4)

		function MCHN_Editor:GetMainPanel()
			return menu
		end
		
		MCHN_Editor:ConstructSpawnList()
end

concommand.Add("Machineers_editor", MCHN_Editor.Toggle )

function MCHN_Editor:Close()
	hook.Call("MachineersEditor_OnClose")
	MCHN_Editor:GetMainPanel():Remove()
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

function MCHN_Editor:AddModel( ModelName, Position )
	
end