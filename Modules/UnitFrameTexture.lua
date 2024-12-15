local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	hooksecurefunc("UnitFrameHealthBar_Update", function(self)
		self:SetStatusBarTexture(ResistUI.barTexture)
	end)
	hooksecurefunc("UnitFrameManaBar_UpdateType", function(self)
		self:SetStatusBarTexture(ResistUI.texturePath .. "StatusBar\\Flat")
	end)
end
