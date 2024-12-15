local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	local _, class = UnitClass("player")
	local classColor = RAID_CLASS_COLORS[class]

	local function createTextAnchoredTo(relativeTo)
		local text = UIParent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		text:SetFont(ResistUI.font, ResistUI.fontSize+1, "OUTLINE")
		text:SetTextColor(classColor.r, classColor.g, classColor.b)
		text:ClearAllPoints()
		if relativeTo == nil then
			text:SetPoint("BOTTOMLEFT", 8, 8)
		else
			text:SetPoint("LEFT", relativeTo, "RIGHT", 8, 0)
		end

		return text
	end

	-- FPS

	local fpsText = createTextAnchoredTo()

	local function updateFps()
		fpsText:SetText("|c00ffffff" .. floor(GetFramerate()) .. "|r fps")
	end

	C_Timer.NewTicker(1, updateFps)
	updateFps()

	-- Latency

	local latencyText = createTextAnchoredTo(fpsText)

	local function updateLatency()
		local latency = select(4, GetNetStats())
		local color = latency > 500 and "ff3232" or "ffffff"
		latencyText:SetText("|c00" .. color .. latency .. "|r ms")
	end

	C_Timer.NewTicker(15, updateLatency)
	updateLatency()

	-- Durability

	local durabilityText = createTextAnchoredTo(latencyText)

	local function updateDurability()
		local slotsToTrack = { 1, 3, 5, 6, 7, 8, 9, 15, 16, 17, 18 }
		local currentSum = 0
		local maximumSum = 0
		for _, id in ipairs(slotsToTrack) do
			local current, maximum = GetInventoryItemDurability(id)
			if maximum then
				currentSum = currentSum + current
				maximumSum = maximumSum + maximum
			end
		end
		if maximumSum == 0 then return end
		durabilityText:SetText(string.format("|c00ffffff%d%%|r durability", currentSum / maximumSum * 100))
	end

	local fd = CreateFrame("Frame")
	fd:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	fd:SetScript("OnEvent", updateDurability)
	updateDurability()

	-- Mov. speed

	local speedText = createTextAnchoredTo(durabilityText)
	local speed = nil

	local function updateSpeed()
		if speed == GetUnitSpeed("player") then return end

		speed = GetUnitSpeed("player")
		speedText:SetText(string.format("|c00ffffff%d%%|r speed", speed / 7 * 100))
	end

	C_Timer.NewTicker(0.1, updateSpeed)

	-- XP/h

	local xpHourText = createTextAnchoredTo(speedText)

	local function setupXpHour()
		if ResistUI:IsMaxLevel("player") then return end

		local started = time() - 1
		local xpGainedTotal = 0
		local xpPerHour = 0
		local elapsed = 0
		local levelIn = 0

		local fxp = CreateFrame("Frame")
		fxp:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
		fxp:SetScript("OnEvent", function(_, _, ...)
			if ResistUI:IsMaxLevel("player") then
				fxp:UnregisterAllEvents()
				return
			end
			local xpGained = string.match(string.match(..., "%d+ experience"), "%d+")
			xpGainedTotal = xpGainedTotal + tonumber(xpGained)
		end)

		local function formatTime(secs)
			if secs < 60 then
				return "<1 min."
			end

			if secs < 3600 then
				return string.format("%d min.", secs / 60)
			end

			return string.format("%.1f h", secs / 3600)
		end

		local function update()
			if xpGainedTotal == 0 then return end
			if ResistUI:IsMaxLevel("player") then return end

			elapsed = time() - started
			local rate = xpGainedTotal / elapsed
			xpPerHour = math.floor(3600 * rate)
			levelIn = (UnitXPMax("player") - UnitXP("player")) / rate
			levelIn = math.max(0, levelIn)

			xpHourText:SetText(string.format("|c00ffffff%.1fk|r XP/h", xpPerHour / 1000))
		end

		xpHourText:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:ClearLines();
			GameTooltip:AddLine("XP per hour: " .. string.format("%.1fk", xpPerHour / 1000));
			GameTooltip:AddLine("Total exp. gained: " .. xpGainedTotal);
			GameTooltip:AddLine("Leveling in: " .. formatTime(levelIn));
			GameTooltip:AddLine("Elapsed: " .. formatTime(elapsed));
			GameTooltip:Show();
		end)

		xpHourText:SetScript("OnLeave", function(auto)
			GameTooltip:Hide();
		end)

		C_Timer.NewTicker(2, update)
	end

	setupXpHour()
end
