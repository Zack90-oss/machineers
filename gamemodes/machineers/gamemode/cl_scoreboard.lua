local scoreboard = scoreboard or {}
scoreboard.texGradientLeft = Material( "gui/mchn_gradient_down.png" )

surface.CreateFont( "ScoreboardPlayer" , {
	font = "coolvetica",
	size = 32,
	weight = 500,
	antialias = true,
	italic = false
})

surface.CreateFont( "ScoreboardTop" , {
	font = "Tahoma",
	size = 30,
	weight = 500,
	antialias = true,
	italic = false
})

function scoreboard:show()

	menu = vgui.Create("DFrame")
	menu:SetSize(ScrW() * 0.4, ScrH() * 0.4)
	menu:Center()
	menu:MakePopup()
	menu:SetKeyboardInputEnabled(false)
	menu:SetDraggable(false)
	menu:ShowCloseButton(false)
	menu:SetTitle("")
	menu:DockPadding(4,4,4,4)
	self:MakeTeamList()

end

function scoreboard:MakeTeamList()
	local teamcount = table.Count(team.GetAllTeams())-2
	local offset = menu:GetWide()/(teamcount)-1
	local loop_times=0
	for key, teaminfo in pairs(team.GetAllTeams())do
		if not(key==TEAM_CONNECTING or key==TEAM_UNASSIGNED)then
			loop_times=loop_times+1
			teamtable = vgui.Create("DScrollPanel", menu)
			teamtable:SetSize(offset , 64)
			teamtable.team=key

			teamname=vgui.Create("DLabel", teamtable)
			teamname:Dock( TOP )
			teamname:DockMargin( 0, 0, 0, 5 )
			teamname:SetText(team.GetName(key))
			teamname:SetFont("ScoreboardTop")
			function teamname.Paint( sel, w, h )
				surface.SetDrawColor(team.GetColor(key))
				surface.SetMaterial(self.texGradientLeft)
				surface.DrawTexturedRect( 0, 0, w, h )
			end
			
			--[[
			function teamtable.Paint( sel, w, h )
				surface.SetTextColor(team.GetColor(key))
				surface.SetTextPos(0,2)
				surface.DrawText(team.GetName(key))
			end
	]]
			for key, player in pairs(team.GetPlayers(key)) do
				local namepanel=vgui.Create("DButton")
				namepanel:Dock( TOP )
				namepanel:DockMargin( 0, 0, 0, 5 )
				namepanel:SetTall(40)
				namepanel:SetText("")
				--namepanel:SetText(player:Name())
				namepanel:SetFont("ScoreboardPlayer")
				namepanel:SetTextColor(Color(0,0,0))
				namepanel.player=player
				function namepanel:Paint( w, h )
					surface.SetDrawColor(team.GetColor(self.player:Team()))
					surface.SetMaterial(scoreboard.texGradientLeft)
					surface.DrawTexturedRect(0, 0, w, h)

					--surface.SetDrawColor(255,255,255,10)
					--surface.DrawRect(0, 0, w, h * 0.45 )

					surface.SetDrawColor(color_black)
					surface.DrawOutlinedRect(0, 0, w, h)
					draw.DrawText(player:Ping(), "ScoreboardPlayer", w-40, 7, color_black, 0)
					draw.DrawText(player:Nick(), "ScoreboardPlayer", 11, 7, color_black, 0)
				end
				teamtable:Add(namepanel)
			end
			
			
			
			if(loop_times==teamcount)then
				teamtable:Dock( FILL )
			else
				teamtable:Dock( LEFT )
			end
		end
	end
end
	

function scoreboard:hide()
	menu:Remove()
end


function GM:ScoreboardShow()
	scoreboard:show()
end

function GM:ScoreboardHide()
	scoreboard:hide()
end