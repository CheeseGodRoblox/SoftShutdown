--Services
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

--ScreenGuis
local infoGui = script.InfoGui

if (game.VIPServerId ~= "" and game.VIPServerOwnerId == 0) then
	-- this is a reserved server without a VIP server owner
	for _, player in pairs(Players:GetPlayers()) do
		local infoGuiClone = infoGui:Clone()
		infoGui.Parent = player.PlayerGui
	end
	local waitTime = 5

	Players.PlayerAdded:connect(function(player)
		wait(waitTime)
		waitTime = waitTime / 2
		TeleportService:Teleport(game.PlaceId, player)
	end)

	for _,player in pairs(Players:GetPlayers()) do
		TeleportService:Teleport(game.PlaceId, player)
		wait(waitTime)
		waitTime = waitTime / 2
	end
else
	game:BindToClose(function()
		if (#Players:GetPlayers() == 0) then
			return
		end

		if (game:GetService("RunService"):IsStudio()) then
			return
		end
		
		for _, player in pairs(Players:GetPlayers()) do
			local infoGuiClone = infoGui:Clone()
			infoGui.Parent = player.PlayerGui
		end
		wait(2)
		local reservedServerCode = TeleportService:ReserveServer(game.PlaceId)

		for _,player in pairs(Players:GetPlayers()) do
			TeleportService:TeleportToPrivateServer(game.PlaceId, reservedServerCode, { player })
		end
		Players.PlayerAdded:connect(function(player)
			TeleportService:TeleportToPrivateServer(game.PlaceId, reservedServerCode, { player })
		end)
		while (#Players:GetPlayers() > 0) do
			wait(1)
		end	
	end)
end
