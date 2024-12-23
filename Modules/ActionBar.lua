local _, ResistUI = ...

local showAllBags = false

local module = ResistUI:NewModule()
function module:OnLoad()
	local dominos = C_AddOns.IsAddOnLoaded("Dominos")
	local bartender = C_AddOns.IsAddOnLoaded("Bartender4")

	if dominos or bartender then return end

	local function hideArtworkFrames()
		local hidden = CreateFrame("Frame", "ResistUIHidden")
		hidden:Hide()

		for _, frame in pairs({
			-- Up/Down
			ActionBarDownButton,
			ActionBarUpButton,
			-- Art frames
			MainMenuBarPerformanceBarFrame,
			MainMenuBarArtFrameBackground,
			MainMenuBarLeftEndCap,
			MainMenuBarMaxLevelBar,
			MainMenuBarPageNumber,
			MainMenuBarRightEndCap,
			MainMenuBarTexture0,
			MainMenuBarTexture1,
			MainMenuBarTexture2,
			MainMenuBarTexture3,
			StanceBarLeft,
			StanceBarMiddle,
			StanceBarRight,
			SlidingActionBarTexture0,
			SlidingActionBarTexture1,
		}) do
			frame:SetParent(hidden)
		end

		for i = 1, NUM_STANCE_SLOTS do
			_G["StanceButton" .. i .. "NormalTexture"]:Hide()
			_G["StanceButton" .. i .. "NormalTexture2"]:Hide()
		end
	end

	local function setupMicroMenuAndBags()
		if showAllBags then
			CharacterMicroButton:ClearAllPoints()
			CharacterMicroButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -184, 2)
			MainMenuBarBackpackButton:ClearAllPoints()
			MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -2, 36)
			CharacterBag0Slot:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", 2, 0)
			CharacterBag1Slot:SetPoint("RIGHT", CharacterBag0Slot, "LEFT", 2, 0)
			CharacterBag2Slot:SetPoint("RIGHT", CharacterBag1Slot, "LEFT", 2, 0)
			CharacterBag3Slot:SetPoint("RIGHT", CharacterBag2Slot, "LEFT", 2, 0)
			KeyRingButton:SetPoint("RIGHT", CharacterBag3Slot, "LEFT", 2, 0)
			KeyRingButton:SetScale(0.9)
		else
			for _, frame in pairs({
				CharacterBag0Slot,
				CharacterBag1Slot,
				CharacterBag2Slot,
				CharacterBag3Slot,
				KeyRingButton,
			}) do
				frame:SetParent(ResistUIHidden)
			end

			CharacterMicroButton:ClearAllPoints()
			CharacterMicroButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -217, 2)
			MainMenuBarBackpackButton:ClearAllPoints()
			MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -2, 3)
			MainMenuBarBackpackButton:SetScale(0.98)
		end
	end

	local function setupActionBars()
		local margin = 2

		-- Adjust margin between action buttons
		for i = 2, NUM_ACTIONBAR_BUTTONS do
			_G["ActionButton" .. i]:SetPoint(
				"LEFT", _G["ActionButton" .. (i - 1)], "RIGHT", margin, 0
			)
			_G["MultiBarBottomLeftButton" .. i]:SetPoint(
				"LEFT", _G["MultiBarBottomLeftButton" .. (i - 1)], "RIGHT", margin, 0
			)
			_G["MultiBarBottomRightButton" .. i]:SetPoint(
				"LEFT", _G["MultiBarBottomRightButton" .. (i - 1)], "RIGHT", margin, 0
			)
			_G["MultiBarLeftButton" .. i]:SetPoint(
				"TOP", _G["MultiBarLeftButton" .. (i - 1)], "BOTTOM", 0, -margin
			)
			_G["MultiBarRightButton" .. i]:SetPoint(
				"TOP", _G["MultiBarRightButton" .. (i - 1)], "BOTTOM", 0, -margin
			)
		end

		for i = 2, NUM_STANCE_SLOTS do
			_G["StanceButton" .. i]:SetPoint("LEFT", _G["StanceButton" .. (i - 1)], "RIGHT", margin, 0)
		end

		for i = 2, NUM_PET_ACTION_SLOTS do
			_G["PetActionButton" .. i]:SetPoint("LEFT", _G["PetActionButton" .. (i - 1)], "RIGHT", margin, 0)
		end

		ActionButton1:SetPoint("BOTTOMLEFT", MainMenuBar, "BOTTOMLEFT", 0, 0)

		MultiBarBottomLeft.ignoreFramePositionManager = true
		MultiBarBottomLeft:ClearAllPoints()
		MultiBarBottomLeft:SetPoint("BOTTOMLEFT", ActionButton1, "TOPLEFT", 0, margin)

		local relativeTo = MultiBarBottomLeft:IsVisible() and MultiBarBottomLeft or ActionButton1
		MultiBarBottomRight.ignoreFramePositionManager = true
		MultiBarBottomRight:ClearAllPoints()
		MultiBarBottomRight:SetPoint("BOTTOMLEFT", relativeTo, "TOPLEFT", 0, margin)

		local height = 36
		if MultiBarBottomLeft:IsVisible() then
			height = height + MultiBarBottomLeft:GetHeight() + margin
		end
		if MultiBarBottomRight:IsVisible() then
			height = height + MultiBarBottomRight:GetHeight() + margin
		end

		-- Centered and 32px from bottom
		local width = NUM_ACTIONBAR_BUTTONS * 36 + (NUM_ACTIONBAR_BUTTONS - 1) * margin
		MainMenuBar:ClearAllPoints()
		MainMenuBar:SetSize(width, height)
		MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 32)

		PetActionBarFrame.ignoreFramePositionManager = true
		PetActionBarFrame:ClearAllPoints()
		PetActionBarFrame:SetPoint("BOTTOMLEFT", MainMenuBar, "TOPLEFT", 24, 0)

		StanceBarFrame.ignoreFramePositionManager = true
		StanceBarFrame:ClearAllPoints()
		StanceBarFrame:SetPoint("BOTTOMLEFT", MainMenuBar, "TOPLEFT", 24, 0)

		MainMenuBarVehicleLeaveButton.ignoreFramePositionManager = true
		MainMenuBarVehicleLeaveButton:ClearAllPoints()
		MainMenuBarVehicleLeaveButton:SetPoint("BOTTOMLEFT", MainMenuBar, "TOPLEFT", 0, 2)

		VerticalMultiBarsContainer.ignoreFramePositionManager = true
		VerticalMultiBarsContainer:ClearAllPoints()
		VerticalMultiBarsContainer:SetPoint("RIGHT", UIParent, "RIGHT", 0, 0)

		MultiBarLeft.ignoreFramePositionManager = true
		MultiBarLeft:SetPoint("TOPRIGHT", MultiBarRight, "TOPLEFT", 0, 0)
	end

	local function updateStatusBars()
		-- Remove default textures
		for i = 0, 3 do
			_G["MainMenuXPBarTexture" .. i]:Hide()
			ReputationWatchBar.StatusBar["WatchBarTexture" .. i]:Hide()
			-- Max level stuff to hide (When experience bar is hidden)
			_G["MainMenuMaxLevelBar" .. i]:Hide()
			ReputationWatchBar.StatusBar["XPBarTexture" .. i]:Hide()
		end

		--Exp bar
		local xpBarSize = { 512, 14 }
		MainMenuExpBar:ClearAllPoints()
		MainMenuExpBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
		MainMenuExpBar:SetSize(unpack(xpBarSize))
		MainMenuExpBar:SetStatusBarTexture(ResistUI.barTexture)
		MainMenuBarExpText:SetFont(ResistUI.font, ResistUI.fontSize - 1, "OUTLINE")
		MainMenuBarExpText:ClearAllPoints()
		MainMenuBarExpText:SetPoint("CENTER", MainMenuExpBar, "CENTER", 0, 0)

		local xpBarTexture = MainMenuExpBar:CreateTexture("MainMenuExpBarTextureRUI", "OVERLAY")
		xpBarTexture:SetPoint("LEFT", MainMenuExpBar, "LEFT", 0, 0)
		xpBarTexture:SetAtlas("hud-MainMenuBar-experiencebar-small-single")
		xpBarTexture:SetSize(unpack(xpBarSize))
		xpBarTexture:SetVertexColor(ResistUI.frameColor.bg:GetRGBA())

		-- Rep bar
		local repBarSize = { 512, 10 }
		ReputationWatchBar:ClearAllPoints()
		if MainMenuExpBar:IsVisible() then
			ReputationWatchBar:SetPoint("TOP", MainMenuExpBar, "TOP", 0, 10)
		else
			ReputationWatchBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
		end
		ReputationWatchBar:SetSize(unpack(repBarSize))
		ReputationWatchBar.StatusBar:SetStatusBarTexture(ResistUI.barTexture)
		ReputationWatchBar.StatusBar:SetSize(unpack(repBarSize))
		ReputationWatchBar.OverlayFrame.Text:SetFont(ResistUI.font, ResistUI.fontSize - 1, "OUTLINE")

		local repBarTexture = ReputationWatchBar:CreateTexture("ReputationWatchBarTextureRUI")
		repBarTexture:SetPoint("LEFT", ReputationWatchBar, "LEFT", 0, 0)
		repBarTexture:SetAtlas("hud-MainMenuBar-experiencebar-small-single", true)
		repBarTexture:SetSize(unpack(repBarSize))
		repBarTexture:SetVertexColor(ResistUI.frameColor.bg:GetRGBA())
	end

	hideArtworkFrames()
	setupMicroMenuAndBags()
	setupActionBars()
	updateStatusBars()
	hooksecurefunc("MultiActionBar_Update", setupActionBars)
	hooksecurefunc("MainMenuTrackingBar_Configure", updateStatusBars)
	MainMenuBar:HookScript("OnShow", setupMicroMenuAndBags)
end
