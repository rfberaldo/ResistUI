local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	local patterns = {
		"(https?://%S+%.%S+)",
		"(www%.%S+%.%S+)",
	}

	local events = {
		"CHAT_MSG_SAY",
		"CHAT_MSG_YELL",
		"CHAT_MSG_WHISPER",
		"CHAT_MSG_WHISPER_INFORM",
		"CHAT_MSG_GUILD",
		"CHAT_MSG_OFFICER",
		"CHAT_MSG_PARTY",
		"CHAT_MSG_PARTY_LEADER",
		"CHAT_MSG_RAID",
		"CHAT_MSG_RAID_LEADER",
		"CHAT_MSG_RAID_WARNING",
		"CHAT_MSG_INSTANCE_CHAT",
		"CHAT_MSG_INSTANCE_CHAT_LEADER",
		"CHAT_MSG_BATTLEGROUND",
		"CHAT_MSG_BATTLEGROUND_LEADER",
		"CHAT_MSG_BN_WHISPER",
		"CHAT_MSG_BN_WHISPER_INFORM",
		"CHAT_MSG_BN_CONVERSATION",
		"CHAT_MSG_CHANNEL",
		"CHAT_MSG_SYSTEM",
	}

	for _, event in pairs(events) do
		ChatFrame_AddMessageEventFilter(event, function(_, _, msg, ...)
			for _, pattern in pairs(patterns) do
				local result, match = string.gsub(msg, pattern, "|cff0394ff|Hurl:%1|h[%1]|h|r")
				if match > 0 then
					return false, result, ...
				end
			end
		end)
	end

	local ogSetHyperlink = ItemRefTooltip.SetHyperlink
	ItemRefTooltip.SetHyperlink = function(self, link, ...)
		if link and strsub(link, 1, 3) == "url" then
			local editbox = ChatEdit_ChooseBoxForSend()
			ChatEdit_ActivateChat(editbox)
			editbox:Insert(string.sub(link, 5))
			editbox:HighlightText()
			return
		end

		ogSetHyperlink(self, link, ...)
	end
end
