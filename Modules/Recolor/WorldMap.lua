local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	for _, texture in pairs(
		ResistUI:GetAllTextures({
			WorldMapFrame.MiniBorderFrame,
			WorldMapFrame.BorderFrame,
		})
	) do
		texture:SetDesaturation(1)
		texture:SetVertexColor(ResistUI.frameColor.bg:GetRGBA())
	end

	for _, texture in pairs(
		ResistUI:GetAllTextures({
			WorldMapZoneDropDown,
			WorldMapZoneMinimapDropDown,
			WorldMapContinentDropDown,
		})
	) do
		texture:SetDesaturation(1)
		texture:SetVertexColor(ResistUI.frameColor.fg:GetRGBA())
	end
end
