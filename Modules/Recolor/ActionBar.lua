local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	for _, texture in pairs({
		SlidingActionBarTexture0,
		SlidingActionBarTexture1,
		MainMenuBarTexture0,
		MainMenuBarTexture1,
		MainMenuBarTexture2,
		MainMenuBarTexture3,
		MainMenuMaxLevelBar0,
		MainMenuMaxLevelBar1,
		MainMenuMaxLevelBar2,
		MainMenuMaxLevelBar3,
		MainMenuXPBarTexture0,
		MainMenuXPBarTexture1,
		MainMenuXPBarTexture2,
		MainMenuXPBarTexture3,
		MainMenuXPBarTexture4,
		ReputationWatchBar.StatusBar.WatchBarTexture0,
		ReputationWatchBar.StatusBar.WatchBarTexture1,
		ReputationWatchBar.StatusBar.WatchBarTexture2,
		ReputationWatchBar.StatusBar.WatchBarTexture3,
		ReputationWatchBar.StatusBar.XPBarTexture0,
		ReputationWatchBar.StatusBar.XPBarTexture1,
		ReputationWatchBar.StatusBar.XPBarTexture2,
		ReputationWatchBar.StatusBar.XPBarTexture3,
	}) do
		texture:SetDesaturation(1)
		texture:SetVertexColor(ResistUI.frameColor.bg:GetRGBA())
	end

	for _, texture in pairs({
		MainMenuBarLeftEndCap,
		MainMenuBarRightEndCap,
		StanceBarLeft,
		StanceBarMiddle,
		StanceBarRight,
		ActionBarUpButton:GetRegions(),
		ActionBarDownButton:GetRegions(),
	}) do
		texture:SetVertexColor(ResistUI.frameColor.fg:GetRGBA())
	end

	select(2, KeyRingButton:GetRegions()):SetVertexColor(ResistUI.frameColor.fg:GetRGBA())
end
