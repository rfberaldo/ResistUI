local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	if not ResistUICfg.autoTrack then return end

	local FIND_MINERALS_ID = 2580 -- const
	local FIND_HERBS_ID = 2383   -- const

	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_UNGHOST")
	f:RegisterEvent("PLAYER_ALIVE")
	f:SetScript("OnEvent", function()
		local _, instType = IsInInstance()
		if instType == "pvp" or instType == "arena" then return end

		if GetTrackingTexture() ~= nil then return end

		-- Find Minerals
		if IsSpellKnown(FIND_MINERALS_ID) then
			CastSpellByID(FIND_MINERALS_ID)
		end

		-- Find Herbs
		if IsSpellKnown(FIND_HERBS_ID) then
			CastSpellByID(FIND_HERBS_ID)
		end
	end)
end
