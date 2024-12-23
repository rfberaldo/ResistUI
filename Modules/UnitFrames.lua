local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	-- Player
	local function ResistUI_PlayerFrame(self)
		self.name:Hide()

		self.healthbar:SetHeight(26)
		self.healthbar:SetPoint("TOPLEFT", 106, -24)
		self.healthbar.LeftText:SetFont(ResistUI.font, ResistUI.fontSize, "OUTLINE")
		self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 8, 0)
		self.healthbar.RightText:SetFont(ResistUI.font, ResistUI.fontSize, "OUTLINE")
		self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -5, 0)
		self.healthbar.TextString:SetFont(ResistUI.font, ResistUI.fontSize, "OUTLINE")
		self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)

		self.manabar:SetHeight(13)
		self.manabar:SetPoint("TOPLEFT", 106, -52)
		self.manabar.LeftText:SetFont(ResistUI.font, ResistUI.fontSize, "OUTLINE")
		self.manabar.LeftText:SetPoint("LEFT", self.manabar, "LEFT", 8, 0)
		self.manabar.RightText:SetFont(ResistUI.font, ResistUI.fontSize, "OUTLINE")
		self.manabar.RightText:SetPoint("RIGHT", self.manabar, "RIGHT", -5, 0)
		self.manabar.TextString:SetFont(ResistUI.font, ResistUI.fontSize, "OUTLINE")
		self.manabar.TextString:SetPoint("CENTER", self.manabar, "CENTER", 0, 0)

		PlayerStatusTexture:SetTexture() -- Remove status glow

		PlayerFrameTexture:SetTexture(ResistUI.texturePath .. "UnitFrames\\UI-TargetingFrame")
		PlayerFrameGroupIndicatorText:Hide()
		PlayerFrameGroupIndicatorLeft:Hide()
		PlayerFrameGroupIndicatorMiddle:Hide()
		PlayerFrameGroupIndicatorRight:Hide()

		PlayerPVPIcon:SetAlpha(0.5)
	end

	hooksecurefunc("PlayerFrame_ToPlayerArt", ResistUI_PlayerFrame)

	-- Target
	local function ResistUI_TargetFrame(self)
		self.name:SetPoint("LEFT", self, 15, 36)
		self.nameBackground:Hide()
		self.name:SetFont(ResistUI.font, ResistUI.fontSize)
		self.highLevelTexture:SetPoint("CENTER", self.levelText, "CENTER", 0, 0)
		self.deadText:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)

		if self.healthbar.LeftText then
			self.healthbar.LeftText:SetFont(ResistUI.font, ResistUI.fontSize, "OUTLINE")
			self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 8, 0)
		end
		if self.healthbar.RightText then
			self.healthbar.RightText:SetFont(ResistUI.font, ResistUI.fontSize, "OUTLINE")
			self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -5, 0)
		end
		if self.healthbar.TextString then
			self.healthbar.TextString:SetFont(ResistUI.font, ResistUI.fontSize, "OUTLINE")
			self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)
		end
		self.healthbar:SetSize(115, 26)
		self.healthbar:SetPoint("TOPLEFT", 5, -24)

		if self.manabar.LeftText then
			self.manabar.LeftText:SetFont(ResistUI.font, ResistUI.fontSize, "OUTLINE")
			self.manabar.LeftText:SetPoint("LEFT", self.manabar, "LEFT", 8, 0)
		end
		if self.manabar.RightText then
			self.manabar.RightText:SetFont(ResistUI.font, ResistUI.fontSize, "OUTLINE")
			self.manabar.RightText:SetPoint("RIGHT", self.manabar, "RIGHT", -5, 0)
		end
		if self.manabar.TextString then
			self.manabar.TextString:SetFont(ResistUI.font, ResistUI.fontSize, "OUTLINE")
			self.manabar.TextString:SetPoint("CENTER", self.manabar, "CENTER", 0, 0)
		end
		self.manabar:SetPoint("TOPLEFT", 5, -52)
		self.manabar:SetSize(115, 13)

		local classification = UnitClassification(self.unit)
		if (classification == "worldboss" or classification == "elite") then
			self.borderTexture:SetTexture(ResistUI.texturePath .. "UnitFrames\\UI-TargetingFrame-Elite")
		elseif (classification == "rareelite") then
			self.borderTexture:SetTexture(ResistUI.texturePath .. "UnitFrames\\UI-TargetingFrame-Rare-Elite")
		elseif (classification == "rare") then
			self.borderTexture:SetTexture(ResistUI.texturePath .. "UnitFrames\\UI-TargetingFrame-Rare")
		else
			self.borderTexture:SetTexture(ResistUI.texturePath .. "UnitFrames\\UI-TargetingFrame")
		end

		self.haveElite = true
		self.Background:SetSize(115, 42)
		self.healthbar.lockColor = true
	end

	hooksecurefunc("TargetFrame_CheckClassification", ResistUI_TargetFrame)
end
