local _, ResistUI = ...

local color = ResistUI.FrameColorBG
local module = ResistUI:NewModule()
function module:OnLoad()
	-- Player
	for _, texture in pairs({ PlayerFrameTexture }) do
		texture:SetDesaturation(1)
		texture:SetVertexColor(color.r, color.g, color.b, color.a)
	end

	-- Target
	TargetFrameTextureFrameTexture:SetDesaturation(1)
	TargetFrameTextureFrameTexture:SetVertexColor(color.r, color.g, color.b, color.a)

	-- ToT
	TargetFrameToTTextureFrameTexture:SetDesaturation(1)
	TargetFrameToTTextureFrameTexture:SetVertexColor(color.r, color.g, color.b, color.a)
end
