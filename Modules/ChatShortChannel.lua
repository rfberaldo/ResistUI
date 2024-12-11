local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	local channels = {
		{ "[%1]",  "%[%d+%. General %- (.+)[^%]]*%]" },
		{ "[T]",   "%[%d+%. Trade[^%]]*%]" },
		{ "[WD]",  "%[%d+%. WorldDefense[^%]]*%]" },
		{ "[LD]",  "%[%d+%. LocalDefense[^%]]*%]" },
		{ "[LFG]", "%[%d+%. LookingForGroup[^%]]*%]" },
		{ "[I]",   gsub(CHAT_INSTANCE_CHAT_GET, ".*%[(.*)%].*", "%%[%1%%]") },
		{ "[IL]",  gsub(CHAT_INSTANCE_CHAT_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]") },
		{ "[G]",   gsub(CHAT_GUILD_GET, ".*%[(.*)%].*", "%%[%1%%]") },
		{ "[P]",   gsub(CHAT_PARTY_GET, ".*%[(.*)%].*", "%%[%1%%]") },
		{ "[PL]",  gsub(CHAT_PARTY_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]") },
		{ "[O]",   gsub(CHAT_OFFICER_GET, ".*%[(.*)%].*", "%%[%1%%]") },
		{ "[R]",   gsub(CHAT_RAID_GET, ".*%[(.*)%].*", "%%[%1%%]") },
		{ "[RL]",  gsub(CHAT_RAID_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]") },
		{ "[RW]",  gsub(CHAT_RAID_WARNING_GET, ".*%[(.*)%].*", "%%[%1%%]") },
		{ "[%1]",  "%[(%d+)%. ([^%]]+)%]" },
	}

	local ogAddMessages = {}
	for i = 1, NUM_CHAT_WINDOWS do
		local frameName = "ChatFrame" .. i
		-- Skip Combat Log
		if i ~= 2 then
			ogAddMessages[frameName] = _G[frameName].AddMessage
			_G[frameName].AddMessage = function(frame, text, ...)
				for _, channel in pairs(channels) do
					local tag = channel[1]
					local pattern = channel[2]
					text = gsub(text, pattern, tag)
				end
				-- text = gsub(text, "%[(%d0?)%. .-%]", "[%1]")
				return ogAddMessages[frame:GetName()](frame, text, ...)
			end
		end
	end
end
