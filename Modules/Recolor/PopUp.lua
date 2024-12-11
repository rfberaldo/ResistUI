local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	for _, frame in pairs({
		StaticPopup1,
		StaticPopup2,
	}) do
		for _, texture in pairs({
			frame.TopEdge,
			frame.BottomEdge,
			frame.TopRightCorner,
			frame.TopLeftCorner,
			frame.RightEdge,
			frame.LeftEdge,
			frame.BottomRightCorner,
			frame.BottomLeftCorner,
		}) do
			texture:SetDesaturation(1)
			texture:SetVertexColor(ResistUI.frameColor.bg:GetRGBA())
		end
	end
	for _, texture in pairs({
		StaticPopup1EditBoxLeft,
		StaticPopup1EditBoxMid,
		StaticPopup1EditBoxRight,
	}) do
		texture:SetDesaturation(1)
		texture:SetVertexColor(ResistUI.frameColor.fg:GetRGBA())
	end
end
