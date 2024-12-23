local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	for _, texture in pairs(
		ResistUI:GetAllTextures({
			Minimap,
			MinimapCluster,
			MinimapBackdrop,
			TimeManagerClockButton,
			TimeManagerFrame,
		})
	) do
		texture:SetDesaturation(1)
		texture:SetVertexColor(ResistUI.frameColor.bg:GetRGBA())
	end

	for _, texture in pairs(
		ResistUI:GetAllTextures({
			TimeManagerAlarmHourDropDown,
			TimeManagerAlarmMinuteDropDown,
			TimeManagerAlarmMessageEditBox,
		})
	) do
		texture:SetDesaturation(1)
		texture:SetVertexColor(ResistUI.frameColor.fg:GetRGBA())
	end

	-- Except the globe
	TimeManagerGlobe:SetDesaturation(0)
	TimeManagerGlobe:SetVertexColor(1, 1, 1, 1)

	-- Zoom buttons
	for _, texture in pairs(
		ResistUI:GetAllTextures({ MinimapZoomIn, MinimapZoomOut })
	) do
		texture:SetVertexColor(ResistUI.frameColor.fg:GetRGBA())
	end

	-- Other buttons
	for _, texture in pairs({
		MiniMapBattlefieldBorder,
		MiniMapTrackingBorder,
		MiniMapMailBorder,
		MiniMapLFGBorder,
		LFGMinimapFrameBorder,
		GameTimeTexture,
	}) do
		texture:SetDesaturation(1)
		texture:SetVertexColor(ResistUI.frameColor.bg:GetRGBA())
	end

	local function addonButtons()
		for _, frame in pairs({ Minimap:GetChildren() }) do
			if frame:GetName() and frame:GetName():find("LibDBIcon10_") then
				for _, texture in pairs(
					ResistUI:GetAllTextures({ frame }, "OVERLAY")
				) do
					texture:SetDesaturation(1)
					texture:SetVertexColor(ResistUI.frameColor.bg:GetRGBA())
				end
			end
		end

		-- LFG button also is not loaded upfront
		LFGMinimapFrameBorder:SetDesaturation(1)
		LFGMinimapFrameBorder:SetVertexColor(ResistUI.frameColor.bg:GetRGBA())
	end

	-- Make sure the buttons are created
	-- couldn't find an event/hook for this
	C_Timer.After(1, addonButtons)
end
