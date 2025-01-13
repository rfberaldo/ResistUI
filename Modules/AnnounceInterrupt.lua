local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	if not ResistUICfg.announceInterrupt then return end

	local f = CreateFrame("Frame")
	f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	f:SetScript("OnEvent", function()
		local flags = LE_PARTY_CATEGORY_HOME
		if not IsInGroup(flags) and not IsInRaid(flags) then return end

		-- See: https://wowpedia.fandom.com/wiki/COMBAT_LOG_EVENT
		local log = ({ CombatLogGetCurrentEventInfo() })
		local event = log[2]
		local sourceGUID = log[4]
		local destName = log[9]
		local spellName = log[16]

		if (event ~= "SPELL_INTERRUPT") then return end
		if (sourceGUID ~= UnitGUID("player")) then return end

		local msg = "Interrupted " .. (spellName or destName)

		local channel
		if IsInInstance() then
			channel = "SAY"
		elseif IsInRaid(flags) then
			channel = "RAID"
		else
			channel = "PARTY"
		end

		SendChatMessage(msg, channel)
	end)
end
