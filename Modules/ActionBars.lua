local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	-- Hide gryphons
	MainMenuBarLeftEndCap:Hide()
	MainMenuBarRightEndCap:Hide()

	-- MainMenuExpBar:Hide()
	-- MainMenuBarMaxLevelBar:SetAlpha(0) -- hide the xp bar

	-- Hide background textures
	-- MainMenuBarTexture0:Hide()
	-- MainMenuBarTexture1:Hide()
	-- MainMenuBarTexture2:Hide()
	-- MainMenuBarTexture3:Hide()

	-- SlidingActionBarTexture0:SetAlpha(0)
	-- SlidingActionBarTexture1:SetAlpha(0) -- hide pet bar background

	-- ActionBarUpButton:Hide()
	-- ActionBarDownButton:Hide()
	-- MainMenuBarPageNumber:SetAlpha(0)

	-- CharacterMicroButton:Hide()
	-- SpellbookMicroButton:Hide()
	-- TalentMicroButton:Hide()
	-- QuestLogMicroButton:Hide()
	-- SocialsMicroButton:Hide()
	-- WorldMapMicroButton:Hide()
	-- MainMenuMicroButton:Hide()
	-- HelpMicroButton:Hide()
	-- MainMenuBarPerformanceBarFrameButton:Hide()
	-- MainMenuBarBackpackButton:Hide()
end
