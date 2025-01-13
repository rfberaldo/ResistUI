local _, ResistUI = ...

local showButtons = false

local module = ResistUI:NewModule()
function module:OnLoad()
	SLASH_RELOAD1 = "/rl"
	SlashCmdList["RELOAD"] = function()
		ReloadUI()
	end

	SLASH_FSTACK1 = "/fs"
	SlashCmdList["FSTACK"] = function()
		UIParentLoadAddOn("Blizzard_DebugTools")
		FrameStackTooltip_Toggle()
	end
end
