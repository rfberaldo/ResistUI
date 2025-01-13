local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	if not ResistUICfg.classPortraits then return end

	local texture = ResistUI.texturePath .. "ClassPortraits\\%s.tga"

	local function update(self)
		if not self.portrait then return end
		if not UnitIsPlayer(self.unit) then return end

		local _, class = UnitClass(self.unit)
		if not class then return end

		self.portrait:SetTexture(format(texture, class))
	end

	hooksecurefunc("UnitFramePortrait_Update", update)
end
