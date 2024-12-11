local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	CastingBarFrame.ignoreFramePositionManager = true
	CastingBarFrame:ClearAllPoints()
	CastingBarFrame:SetPoint("TOP", MainMenuBar, "TOP", 0, 80)
	CastingBarFrame:SetStatusBarTexture(ResistUI.barTexture)

	CastingBarFrame.Border:SetPoint("TOP", 0, 26)
	CastingBarFrame.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small")
	CastingBarFrame.Border:SetWidth(CastingBarFrame.Border:GetWidth() + 4)

	CastingBarFrame.BorderShield:SetPoint("TOP", 0, 26)
	CastingBarFrame.BorderShield:SetWidth(CastingBarFrame.BorderShield:GetWidth() + 4)

	CastingBarFrame.Flash:SetPoint("TOP", 0, 26)
	CastingBarFrame.Flash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small")
	CastingBarFrame.Flash:SetWidth(CastingBarFrame.Flash:GetWidth() + 4)

	CastingBarFrame.Spark:SetHeight(42)

	CastingBarFrame.Text:ClearAllPoints()
	CastingBarFrame.Text:SetPoint("CENTER", 0, 1)

	CastingBarFrame.Icon:SetSize(24, 24)
	CastingBarFrame.Icon:Show()

	local playerIconBorder = CastingBarFrame:CreateTexture("CastingBarFrameIconBorderRUI", "ARTWORK", nil, 6)
	playerIconBorder:SetTexture(ResistUI.texturePath .. "Buttons\\UI-Border.png")
	playerIconBorder:ClearAllPoints()
	playerIconBorder:SetAllPoints(CastingBarFrame.Icon)
	playerIconBorder:SetVertexColor(0, 0, 0)

	CastingBarFrame:HookScript("OnShow", function(self)
		if self.Icon:GetTexture() ~= nil then
			playerIconBorder:Show()
		else
			playerIconBorder:Hide()
		end
	end)

	-- Target
	TargetFrameSpellBar:SetStatusBarTexture(ResistUI.barTexture)
	TargetFrameSpellBar:SetScale(1.1)
	TargetFrameSpellBar.Icon:SetSize(18, 18)

	local targetIconBorder = TargetFrameSpellBar:CreateTexture("TargetFrameSpellBarIconBorderRUI", "OVERLAY", nil, 6)
	targetIconBorder:SetTexture(ResistUI.texturePath .. "Buttons\\UI-Border.png")
	targetIconBorder:ClearAllPoints()
	targetIconBorder:SetAllPoints(TargetFrameSpellBar.Icon)
	targetIconBorder:SetVertexColor(0.1, 0.1, 0.1)

	TargetFrameSpellBar.Text:SetPoint("CENTER", 0, 1)
end
