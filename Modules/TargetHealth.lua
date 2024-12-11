local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	local anchorSettings = {
		[TargetFrameHealthBar] = {
			TextString = { "CENTER", -50, 3 },
			LeftText = { "LEFT", 8, 3 },
			RightText = { "RIGHT", -110, 3 },
		},
		[TargetFrameManaBar] = {
			TextString = { "CENTER", -50, -8 },
			LeftText = { "LEFT", 8, -8 },
			RightText = { "RIGHT", -110, -8 },
		},
	}

	-- Create text objects
	for statusFrame, anchors in pairs(anchorSettings) do
		for key, anchor in pairs(anchors) do
			local text = TargetFrameTextureFrame:CreateFontString(nil, "OVERLAY", "TextStatusBarText")
			text:SetPoint(unpack(anchor))
			statusFrame[key] = text

			statusFrame.breakUpLargeNumbers = true
		end
	end

	local function healthbarUpdate(statusFrame, unit)
		if not statusFrame then return end
		if statusFrame.lockValues then return end
		if unit ~= statusFrame.unit then return end
		if not statusFrame.showPercentage then return end

		local isPlayerOrPet = UnitIsPlayer(unit) or UnitGUID(unit):find("Pet")
		local isInGroup = UnitPlayerOrPetInRaid(unit) or UnitPlayerOrPetInParty(unit)
		if isPlayerOrPet and not isInGroup then return end

		-- Update text
		statusFrame.showPercentage = false
		TextStatusBar_UpdateTextString(statusFrame)
	end

	hooksecurefunc("UnitFrameHealthBar_Update", healthbarUpdate)
end
