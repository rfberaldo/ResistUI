local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	for i = 1, NUM_CHAT_WINDOWS do
		for _, texture in pairs({
			_G["ChatFrame" .. i .. "TabLeft"],
			_G["ChatFrame" .. i .. "TabMiddle"],
			_G["ChatFrame" .. i .. "TabRight"],
			_G["ChatFrame" .. i .. "EditBoxLeft"],
			_G["ChatFrame" .. i .. "EditBoxMid"],
			_G["ChatFrame" .. i .. "EditBoxRight"],
		}) do
			texture:SetDesaturation(1)
			texture:SetVertexColor(ResistUI.frameColor.bg:GetRGBA())
		end
	end
	-- Chat settings frame
	for _, texture in pairs({
		ChatConfigFrame.TopRightCorner,
		ChatConfigFrame.RightEdge,
		ChatConfigFrame.BottomRightCorner,
		ChatConfigFrame.BottomEdge,
		ChatConfigFrame.BottomLeftCorner,
		ChatConfigFrame.LeftEdge,
		ChatConfigFrame.TopLeftCorner,
		ChatConfigFrame.TopEdge,
		ChatConfigFrameHeader,
	}) do
		texture:SetDesaturation(1)
		texture:SetVertexColor(ResistUI.frameColor.bg:GetRGBA())
	end
end
