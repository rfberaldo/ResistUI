local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	for _, texture in pairs({
		AddonListTopBorder,
		AddonListTopRightCorner,
		AddonListRightBorder,
		AddonListBotRightCorner,
		AddonListBtnCornerRight,
		AddonListBotLeftCorner,
		AddonListBtnCornerLeft,
		AddonListLeftBorder,
		AddonListTopLeftCorner,
		AddonListBottomBorder,
		AddonListButtonBottomBorder,

		AddonListInsetInsetTopBorder,
		AddonListInsetInsetTopRightCorner,
		AddonListInsetInsetRightBorder,
		AddonListInsetInsetBotRightCorner,
		AddonListInsetInsetBottomBorder,
		AddonListInsetInsetBotLeftCorner,
		AddonListInsetInsetLeftBorder,

		AddonListEnableAllButton_RightSeparator,
		AddonListDisableAllButton_RightSeparator,
		AddonListOkayButton_LeftSeparator,
		AddonListCancelButton_LeftSeparator,

		AddonCharacterDropDownLeft,
		AddonCharacterDropDownMiddle,
		AddonCharacterDropDownRight,
	}) do
		texture:SetDesaturation(1)
		texture:SetVertexColor(ResistUI.frameColor.bg:GetRGBA())
	end
	for _, texture in pairs({
		AddonListBg,
		AddonList.TitleBg,
	}) do
		texture:SetDesaturation(1)
		texture:SetVertexColor(ResistUI.frameColor.fg:GetRGBA())
	end
end
