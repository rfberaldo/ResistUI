local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	if not ResistUICfg.classPortraits then return end

	local function update(self)
		if not self.portrait then return end
		if not UnitIsPlayer(self.unit) then return end

		local _, class = UnitClass(self.unit)
		if not class then return end

		local classIconAtlas = GetClassAtlas(class)
		if not classIconAtlas then return end

		self.portrait:SetAtlas(classIconAtlas, false)

		if self.mask then return end

		self.mask = self:CreateMaskTexture()
		self.mask:SetAllPoints(self.portrait)
		self.mask:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
		self.portrait:AddMaskTexture(self.mask)
	end

	hooksecurefunc("UnitFramePortrait_Update", update)
end
