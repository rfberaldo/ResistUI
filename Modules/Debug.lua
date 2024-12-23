local _, ResistUI = ...

local showButtons = false

local module = ResistUI:NewModule()
function module:OnLoad()
	local function setupButtons()
		if not showButtons then return end

		local btnRl = CreateFrame("Button", nil, UIParent, "UIPanelButtonTemplate")

		btnRl:ClearAllPoints()
		btnRl:SetPoint("RIGHT", -100, 100)
		btnRl:SetSize(100, 28)
		btnRl:SetText("Reload UI")
		btnRl:SetScript("OnClick", function()
			ReloadUI()
		end)

		local btnFs = CreateFrame("Button", nil, UIParent, "UIPanelButtonTemplate")

		btnFs:ClearAllPoints()
		btnFs:SetPoint("RIGHT", -100, 130)
		btnFs:SetSize(100, 28)
		btnFs:SetText("FStack")
		btnFs:SetScript("OnClick", function()
			UIParentLoadAddOn("Blizzard_DebugTools")
			FrameStackTooltip_Toggle()
		end)
	end

	local function setupCommands()
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

	setupButtons()
	setupCommands()
end
