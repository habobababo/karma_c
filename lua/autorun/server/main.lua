
local KarmaRefreshTime	= 120

local function UpdatePlayerKarma(ply, karma)
	karma = karma or ply:GetLiveKarma()
	if ply:IsPlayer() and not ply:IsBot() then
		corequery("UPDATE `karma` SET `karma` = '"..karma.."' WHERE `steamid` = '"..ply:SteamID64().."'  ")
	end
end

local function SetKarmaOnSpawn(ply)
	if ply:IsPlayer() and not ply:IsBot() then
		corequery("SELECT karma FROM karma WHERE steamid = " .. ply:SteamID64(), function(data)
			if table.Count(data) > 0 then
				local row = data[1]
				local karma = row.karma
				ply:SetLiveKarma(karma)
				ply:SetBaseKarma(karma)
			else
				corequery("INSERT INTO karma ( steamid, karma ) VALUES ( " .. ply:SteamID64() .. ", " .. ply:GetLiveKarma() .. " )")
			end
		end)
	end
end
hook.Add("PlayerInitialSpawn", "Core_SetKarmaOnSpawn", SetKarmaOnSpawn)

local function RefreshKarma(ply)
	if ply.karma_kicked then
		local k = math.Clamp(GetConVar("ttt_karma_starting"):GetFloat() * 0.8, GetConVar("ttt_karma_low_amount"):GetFloat() * 1.1, GetConVar("ttt_karma_max"):GetFloat())
		UpdatePlayerKarma(ply, k)
		return
	end
	UpdatePlayerKarma(ply)
end
hook.Add("PlayerDisconnected", "Core_RefreshKarmaOnDC", RefreshKarma)

local function RefreshKarmaMap()
	for _, ply in pairs(player.GetAll()) do
		UpdatePlayerKarma(ply)
	end
end
hook.Add("ShutDown", "Core_RefreshKarmaOnMapchange", RefreshKarmaMap)

local function ServerCrashKarmaSaver()
	for _, ply in pairs(player.GetAll()) do
		UpdatePlayerKarma(ply)
	end
end
timer.Create("Core_SaveKarmaOnCrash", KarmaRefreshTime, 0, ServerCrashKarmaSaver)
