local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	local f = ResistUI.UIFactory:NewFrame("ResistUI")

	local category = Settings.RegisterCanvasLayoutCategory(f, "ResistUI")
	Settings.RegisterAddOnCategory(category)

	do -- Announce Interrupt
		local cb = ResistUI.UIFactory:NewCheckbox("Announce on Interrupt")
		cb:HookScript("OnClick", function()
			ResistUICfg.announceInterrupt = cb:GetChecked()
		end)
		cb:SetChecked(ResistUICfg.announceInterrupt)
	end

	do -- Announce Miss
		local cb = ResistUI.UIFactory:NewCheckbox("Announce on Important Missed Spells")
		cb:HookScript("OnClick", function()
			ResistUICfg.announceMiss = cb:GetChecked()
		end)
		cb:SetChecked(ResistUICfg.announceMiss)
	end

	do -- Auto Track
		local cb = ResistUI.UIFactory:NewCheckbox(
			"Auto Track |c00c8c8c8cast Find Herbs/Minerals whenever you ressurrect, except on battlegrounds|r"
		)
		cb:HookScript("OnClick", function()
			ResistUICfg.autoTrack = cb:GetChecked()
		end)
		cb:SetChecked(ResistUICfg.autoTrack)
	end

	do -- Blue Shaman
		local cb = ResistUI.UIFactory:NewCheckbox("Blue Shaman")
		cb:HookScript("OnClick", function()
			ResistUICfg.shamanBlue = cb:GetChecked()
		end)
		cb:SetChecked(ResistUICfg.shamanBlue)
	end

	do -- Class Portraits
		local cb = ResistUI.UIFactory:NewCheckbox("Class Icon Portraits")
		cb:HookScript("OnClick", function()
			ResistUICfg.classPortraits = cb:GetChecked()
		end)
		cb:SetChecked(ResistUICfg.classPortraits)
	end

	do -- Custom Action Bars
		local cb = ResistUI.UIFactory:NewCheckbox("Custom Action Bars")
		cb:HookScript("OnClick", function()
			ResistUICfg.customActionBars = cb:GetChecked()
		end)
		cb:SetChecked(ResistUICfg.customActionBars)
	end

	do -- Energy Tick
		local cb = ResistUI.UIFactory:NewCheckbox("Energy Tick")
		cb:HookScript("OnClick", function()
			ResistUICfg.energyTick = cb:GetChecked()
		end)
		cb:SetChecked(ResistUICfg.energyTick)
	end

	do -- Five Second Rule
		local cb = ResistUI.UIFactory:NewCheckbox("Mana Tick / Five Second Rule")
		cb:HookScript("OnClick", function()
			ResistUICfg.fiveSecondRule = cb:GetChecked()
		end)
		cb:SetChecked(ResistUICfg.fiveSecondRule)
	end

	do -- Show All Bags
		local cb = ResistUI.UIFactory:NewCheckbox("Show All Bags")
		cb:HookScript("OnClick", function()
			ResistUICfg.showAllBags = cb:GetChecked()
		end)
		cb:SetChecked(ResistUICfg.showAllBags)
	end

	do -- Apply button
		local btn = ResistUI.UIFactory:NewButton("Apply", 80)
		btn:SetScript("OnClick", function()
			ReloadUI()
		end)
	end
end
