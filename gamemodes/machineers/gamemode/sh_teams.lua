GM.TeamBased = true

TEAM_RED   = 1
TEAM_BLUE  = 2
TEAM_GREEN = 3

function GM:CreateTeams()
	team.SetUp(TEAM_RED,'Red',Color(255,0,0),true)
	team.SetUp(TEAM_BLUE,'Blue',Color(0,50,255),true)
	team.SetUp(TEAM_GREEN,'Green',Color(0,255,0),true)
end

gameevent.Listen("OnRequestFullUpdate")
hook.Add("OnRequestFullUpdate", "machineers_requestfullupdate", function(info)
	if(SERVER)then
		Player(info.userid):SetTeam( TEAM_SPECTATOR )
	end
end)