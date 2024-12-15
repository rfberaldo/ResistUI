local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	for _, texture in pairs({
		CastingBarFrame.Border,
		TargetFrameSpellBar.Border,
	}) do
		texture:SetDesaturation(1)
		texture:SetVertexColor(ResistUI.frameColor.bg:GetRGBA())
	end
end
