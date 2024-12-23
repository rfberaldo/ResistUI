local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	local f = CreateFrame("Frame")
	f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	f:SetScript("OnEvent", function()
		-- See: https://wowpedia.fandom.com/wiki/COMBAT_LOG_EVENT
		local log = ({ CombatLogGetCurrentEventInfo() })
		local event = log[2]
		local sourceGUID = log[4]
		local destName = log[9]
		local spellId = log[15]
		local spellName = log[16]

		if (event ~= "SPELL_INTERRUPT") then return end
		if (sourceGUID ~= UnitGUID("player")) then return end

		local spell = spellId > 0 and GetSpellLink(spellId) or spellName
		local msg = "Interrupted " .. (spell or destName)

		if IsInGroup() or IsInRaid() then
			SendChatMessage(msg, IsInRaid() and "RAID" or "PARTY")
		else
			print("ResistUI:", msg)
		end
	end)
end
