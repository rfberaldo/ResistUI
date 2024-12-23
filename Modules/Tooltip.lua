local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	GameTooltipStatusBar:SetStatusBarTexture(ResistUI.barTexture)
end
