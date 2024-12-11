local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	local addonToWait = "Blizzard_TalentUI"
	local function recolor()
		local except = {
			textures = {
				[PlayerTalentFramePortrait] = true,
			},
		}
		ResistUI:DeepRecolor(PlayerTalentFrame, except)
	end

	if C_AddOns.IsAddOnLoaded(addonToWait) then
		recolor()
	else
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(_, _, addon)
			if addon == addonToWait then
				recolor()
				f:UnregisterEvent("ADDON_LOADED")
			end
		end)
	end
end
