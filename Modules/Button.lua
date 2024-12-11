local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	local dominos = C_AddOns.IsAddOnLoaded("Dominos")
	local bartender = C_AddOns.IsAddOnLoaded("Bartender4")
	local masque = C_AddOns.IsAddOnLoaded("Masque")

	if (dominos or bartender) and masque then return end

	---@param frameName string
	local function styleButton(frameName)
		local frame = _G[frameName]
		if not frame then return end

		local outBorder = _G[frameName .. "FloatingBG"]
		if outBorder then outBorder:SetTexture(nil) end

		local flyoutBorder = frame.FlyoutBorder
		if flyoutBorder then flyoutBorder:SetTexture(nil) end

		local flyoutBorderShadow = frame.FlyoutBorderShadow
		if flyoutBorderShadow then flyoutBorderShadow:SetTexture(nil) end

		local iconBorder = frame.IconBorder
		if iconBorder then iconBorder:SetTexture(nil) end

		local border = frame.Border
		if border then
			border:SetTexture(ResistUI.texturePath .. "Buttons\\UI-Border-Inner.png")
			border:SetAllPoints(frame)
			ResistUI:TextureOffset(border, frame, 2)
		end

		local activeAuraBorder = select(16, frame:GetRegions())
		if activeAuraBorder and activeAuraBorder:GetTexture() == 130724 then
			activeAuraBorder:SetAllPoints(frame)
			ResistUI:TextureOffset(activeAuraBorder, frame, 2)
		end

		local hotkey = frame.HotKey
		if hotkey then
			hotkey:SetFont(ResistUI.font, ResistUI.fontSize, "OUTLINE")
		end

		local macro = frame.Name
		if macro then
			macro:SetFont(ResistUI.font, ResistUI.fontSize - 1, "OUTLINE")
			macro:Hide()
		end

		local count = frame.Count
		if count then
			count:SetFont(ResistUI.font, ResistUI.fontSize, "OUTLINE")
		end

		local icon = frame.icon
		if icon then
			ResistUI:TextureZoom(icon, 0.08)
			ResistUI:TextureOffset(icon, frame, 2)
		end

		local texture = frame:GetNormalTexture()
		frame:SetNormalTexture(ResistUI.texturePath .. "Buttons\\UI-Border-Dark.png")
		frame.SetNormalTexture = function(...) end
		texture:SetAllPoints(frame)
		texture:SetVertexColor(0, 0, 0, 1)

		local pushedTexture = frame:GetPushedTexture()
		frame:SetPushedTexture(ResistUI.texturePath .. "Buttons\\UI-Border-Push.png")
		pushedTexture:SetVertexColor(0.8, 0.9, 1, 1)
	end

	---@param frame Frame
	local function styleSimpleButton(frame)
		local icon = frame:GetNormalTexture()
		if icon then
			ResistUI:TextureOffset(icon, frame, 1)
		end

		local border = frame:CreateTexture(frame:GetName() .. "BorderRUI", "OVERLAY")
		border:SetTexture(ResistUI.texturePath .. "Buttons\\UI-Border-Dark.png")
		border:SetAllPoints(frame)
		border:SetVertexColor(0, 0, 0, 1)
	end

	-- Not much we can do here
	---@param frame Frame
	local function styleMicroButton(frame)
		local texture = frame:CreateTexture(frame:GetName() .. "TextureRUI", "OVERLAY")
		texture:SetTexture(ResistUI.texturePath .. "Buttons\\UI-Border-Dark.png")
		texture:SetAllPoints(frame)
		ResistUI:TextureOffset(texture, frame, 2)
		texture:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -22)
		texture:SetVertexColor(0, 0, 0, 1)
	end

	local function buttonUpdate(self)
		if GetCVar("alwaysShowActionBars") == "1" then
			self:Show()
		end

		local border = self.Border
		if not border then return end

		if IsEquippedAction(self.action) then
			border:SetVertexColor(0, 0.5, 0, 1)
		end
	end

	local function buttonUpdateUsable(self)
		local texture = self.NormalTexture
		local icon = self.icon
		if not texture then return end

		local isUsable, notEnoughMana = IsUsableAction(self.action)
		if (isUsable) then
			icon:SetVertexColor(1, 1, 1)
			texture:SetVertexColor(0, 0, 0, 1)
		elseif (notEnoughMana) then
			icon:SetVertexColor(0.5, 0.5, 1.0)
			texture:SetVertexColor(0, 0, 0, 1)
		else
			-- action not usable
			icon:SetVertexColor(0.35, 0.35, 0.35)
			texture:SetVertexColor(0, 0, 0, 1)
		end
	end

	local function showGrid(self)
		if GetCVar("alwaysShowActionBars") == "1" then
			self:Show()
		end

		local texture = self.NormalTexture
		if not texture then return end

		texture:SetVertexColor(0, 0, 0, 1)
	end

	local function hideGrid(self)
		if GetCVar("alwaysShowActionBars") == "1" then
			self:Show()
		end
	end

	local function showAllGrids()
		MultiActionBar_UpdateGrid("Action", true)
	end

	local function hideAllGrids()
		MultiActionBar_UpdateGrid("Action", false)
	end

	hooksecurefunc("ActionButton_Update", buttonUpdate)
	hooksecurefunc("ActionButton_UpdateUsable", buttonUpdateUsable)
	hooksecurefunc("ActionButton_ShowGrid", showGrid)
	hooksecurefunc("ActionButton_HideGrid", hideGrid)
	hooksecurefunc("MultiActionBar_ShowAllGrids", showAllGrids)
	hooksecurefunc("MultiActionBar_HideAllGrids", hideAllGrids)

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		for _, name in pairs({
			"ActionButton",
			"MultiBarBottomLeftButton",
			"MultiBarBottomRightButton",
			"MultiBarRightButton",
			"MultiBarLeftButton",
		}) do
			styleButton(name .. i)
		end
	end

	for i = 1, NUM_STANCE_SLOTS do
		styleButton("StanceButton" .. i)
	end

	for i = 1, NUM_PET_ACTION_SLOTS do
		styleButton("PetActionButton" .. i)
	end

	for i = 0, 3 do
		styleButton("CharacterBag" .. i .. "Slot")
	end
	styleButton("MainMenuBarBackpackButton")

	styleSimpleButton(MainMenuBarVehicleLeaveButton)
	styleSimpleButton(TimeManagerStopwatchCheck)

	for _, frame in pairs({
		CharacterMicroButton,
		SpellbookMicroButton,
		TalentMicroButton,
		QuestLogMicroButton,
		SocialsMicroButton,
		WorldMapMicroButton,
		MainMenuMicroButton,
		HelpMicroButton,
		LFGMicroButton,
	}) do
		styleMicroButton(frame)
	end
end
