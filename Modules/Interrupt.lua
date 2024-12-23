local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	local f = CreateFrame("Frame")
	f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	f:SetScript("OnEvent", function()
		if not IsInGroup() and not IsInRaid() then return end

		local _, event, _, sourceGUID, _, _, _, _, destName = CombatLogGetCurrentEventInfo()
		if (event ~= "SPELL_INTERRUPT") then return end
		if (sourceGUID ~= UnitGUID("player")) then return end

		local chatChannel = "PARTY"
		if IsInRaid() then
			chatChannel = "RAID"
		end

		local msg = "Interrupted " .. destName

		SendChatMessage(msg, chatChannel)
	end)
end
