local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	-- Player
	for _, texture in pairs({ PlayerFrameTexture }) do
		texture:SetDesaturation(1)
		texture:SetVertexColor(ResistUI.frameColor.bg:GetRGBA())
	end

	-- Pet
	for _, texture in pairs({ PetFrameTexture }) do
		texture:SetDesaturation(1)
		texture:SetVertexColor(ResistUI.frameColor.bg:GetRGBA())
	end

	-- Target
	TargetFrameTextureFrameTexture:SetDesaturation(1)
	TargetFrameTextureFrameTexture:SetVertexColor(ResistUI.frameColor.bg:GetRGBA())

	-- ToT
	TargetFrameToTTextureFrameTexture:SetDesaturation(1)
	TargetFrameToTTextureFrameTexture:SetVertexColor(ResistUI.frameColor.bg:GetRGBA())

	-- Party
	for i = 1, 4 do
		local texture = _G["PartyMemberFrame" .. i .. "Texture"]
		texture:SetDesaturation(1)
		texture:SetVertexColor(ResistUI.frameColor.bg:GetRGBA())
	end
end
