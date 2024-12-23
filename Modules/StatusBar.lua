local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	local _, class = UnitClass("player")
	local classColor = RAID_CLASS_COLORS[class]

	local function createTextAnchoredTo(relativeTo)
		local text = UIParent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		text:SetFont(ResistUI.font, ResistUI.fontSize + 1, "OUTLINE")
		text:SetTextColor(classColor.r, classColor.g, classColor.b)
		text:ClearAllPoints()
		if relativeTo == nil then
			text:SetPoint("BOTTOMLEFT", 8, 8)
		else
			text:SetPoint("LEFT", relativeTo, "RIGHT", 8, 0)
		end

		return text
	end

	local fpsText = createTextAnchoredTo()
	local latencyText = createTextAnchoredTo(fpsText)
	local durabilityText = createTextAnchoredTo(latencyText)
	local speedText = createTextAnchoredTo(durabilityText)
	local xpHourText = createTextAnchoredTo(speedText)

	-- FPS
	local function setupFps()
		local function updateFps()
			fpsText:SetText("|c00ffffff" .. floor(GetFramerate()) .. "|r fps")
		end

		C_Timer.NewTicker(1, updateFps)
		updateFps()
	end

	-- Latency
	local function setupLatency()
		local function updateLatency()
			local latency = select(4, GetNetStats())
			local color = latency > 500 and "ff3232" or "ffffff"
			latencyText:SetText("|c00" .. color .. latency .. "|r ms")
		end

		C_Timer.NewTicker(15, updateLatency)
		updateLatency()
	end

	-- Durability
	local function setupDurability()
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
	end

	-- Mov. speed
	local function setupSpeed()
		local speed = 0

		local function updateSpeed()
			speed = GetUnitSpeed("player") / 7 * 100
			speedText:SetText(string.format("|c00ffffff%d%%|r speed", speed))
		end

		C_Timer.NewTicker(0.15, updateSpeed)
	end

	-- XP/h
	local function setupXpHour()
		if ResistUI:IsMaxLevel("player") then return end

		local started = time() - 1
		local xpGainedTotal = 0
		local xpPerHour = 0
		local elapsed = 0
		local levelIn = 0
		local restedPercent = 0

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

		local function update()
			if ResistUI:IsMaxLevel("player") then return end

			elapsed = time() - started
			local rate = xpGainedTotal / elapsed
			xpPerHour = math.floor(3600 * rate)
			levelIn = (UnitXPMax("player") - UnitXP("player")) / rate
			levelIn = math.max(0, levelIn)
			restedPercent = (GetXPExhaustion() or 0) / UnitXPMax("player") * 100

			xpHourText:SetText(string.format("|c00ffffff%.1fk|r XP/h", xpPerHour / 1000))
		end

		xpHourText:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:ClearLines()
			GameTooltip:AddLine("XP per hour: " .. string.format("|c00ffffff%.1fk|r", xpPerHour / 1000))
			GameTooltip:AddLine("Total exp. gained: |c00ffffff" .. xpGainedTotal .. "|r")
			GameTooltip:AddLine("Rested: " .. string.format("|c00ffffff%d%%|r", restedPercent))
			GameTooltip:AddLine("Leveling in: |c00ffffff" .. ResistUI:FormatTime(levelIn) .. "|r")
			GameTooltip:AddLine("Elapsed: |c00ffffff" .. ResistUI:FormatTime(elapsed) .. "|r")
			GameTooltip:AddLine("(Click to reset session)", 0.6, 0.6, 0.6)
			GameTooltip:Show()
		end)

		xpHourText:SetScript("OnLeave", function(auto)
			GameTooltip:Hide()
		end)

		xpHourText:SetScript("OnMouseDown", function(self, btn)
			if btn ~= "LeftButton" then return end

			started = time() - 1
			xpGainedTotal = 0
			xpPerHour = 0
			elapsed = 0
			levelIn = 0
			update()
		end)

		update()
		C_Timer.NewTicker(2, update)
	end

	setupFps()
	setupLatency()
	setupDurability()
	setupSpeed()
	setupXpHour()
end
