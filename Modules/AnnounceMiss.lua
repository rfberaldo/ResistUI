local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	local spellIds = {
		-- Rogue
		1766, -- Kick
		6770, -- Sap
		2094, -- Blind
		1776, -- Gouge
		408, -- Kidney Shot

		-- Warrior
		72, -- Shield Bash
		355, -- Taunt
		694, -- Mocking Blow
		6552, -- Pummel

		-- Shaman
		8042, -- Earth Shock

		-- Mage
		2139, -- Counterspell

		-- Druid
		5211, -- Bash
		6795, -- Growl

		-- Hunter
		5384, -- Feign Death
		19386, -- Wyvern Sting
		19503, -- Scatter Shot

		-- Warlock
		19647, -- Spell Lock

		-- Priest
		15487, -- Silence

		-- Paladin
		853, -- Hammer of Justice
		20066, -- Repentance
	}

	-- Save localized spell names (for non-english clients)
	local spellNames = {}
	for _, id in ipairs(spellIds) do
		local info = C_Spell.GetSpellInfo(id)
		if info.name ~= nil then
			spellNames[info.name] = true
		end
	end


	local f = CreateFrame("Frame")
	f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	f:SetScript("OnEvent", function()
		local flags = LE_PARTY_CATEGORY_HOME
		if not IsInGroup(flags) and not IsInRaid(flags) then return end

		-- See: https://wowpedia.fandom.com/wiki/COMBAT_LOG_EVENT
		local log = ({ CombatLogGetCurrentEventInfo() })
		local event = log[2]
		local sourceGUID = log[4]
		local spellName = log[13]

		if (event ~= "SPELL_MISSED") then return end
		if (sourceGUID ~= UnitGUID("player") and sourceGUID ~= UnitGUID("pet")) then return end
		if (not spellNames[spellName]) then return end

		local msg = spellName .. " Miss!"
		SendChatMessage(msg, IsInRaid(flags) and "RAID" or "PARTY")
	end)
end
