local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	local _, class = UnitClass("player")
	local classColor = RAID_CLASS_COLORS[class]
	local defaultHex = "ffffff"

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
			local fps = floor(GetFramerate())
			fpsText:SetText(format("|c00%s%d|r fps", defaultHex, fps))
		end

		C_Timer.NewTicker(1, updateFps)
		updateFps()
	end

	-- Latency
	local function setupLatency()
		local function updateLatency()
			local latency = select(4, GetNetStats())
			local hex = latency > 500 and "ff3232" or defaultHex
			latencyText:SetText(format("|c00%s%d|r ms", hex, latency))
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

			local durability = currentSum / maximumSum * 100
			local hex = durability <= 25 and "ff3232" or defaultHex
			durabilityText:SetText(format("|c00%s%d%%|r durability", hex, durability))
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
			speedText:SetText(format("|c00%s%d%%|r speed", defaultHex, speed))
		end

		C_Timer.NewTicker(0.15, updateSpeed)
	end

	-- XP/h
	local function setupXpHour()
		if ResistUI:IsMaxLevel("player") then return end

		local started = GetServerTime()
		local xpGainedTotal = 0
		local xpPerHour = 0
		local elapsed = 0
		local levelIn = 0
		local restedPercent = 0
		local xpPrevious = UnitXP("player")
		local xpMax = UnitXPMax("player")

		local fLvlup = CreateFrame("Frame")
		fLvlup:RegisterEvent("PLAYER_LEVEL_UP")
		fLvlup:SetScript("OnEvent", function()
			local missingXp = xpMax - xpPrevious
			xpGainedTotal = xpGainedTotal + missingXp
			xpMax = UnitXPMax("player")
			xpPrevious = 0
		end)

		local function update()
			if ResistUI:IsMaxLevel("player") then return end

			local xp = UnitXP("player")
			local xpGained = xp - xpPrevious
			xpGainedTotal = xpGainedTotal + xpGained
			xpPrevious = xp

			elapsed = GetServerTime() - started + 1 -- +1 to avoid division by zero
			local rate = xpGainedTotal / elapsed
			xpPerHour = rate * 3600
			levelIn = math.max(0, (xpMax - xp) / rate)
			restedPercent = (GetXPExhaustion() or 0) / xpMax * 100

			xpHourText:SetText(format("|c00%s%.1fk|r XP/h", defaultHex, xpPerHour / 1000))
		end

		xpHourText:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:ClearLines()
			GameTooltip:AddLine("XP per hour: " .. format("|c00%s%.1fk|r", defaultHex, xpPerHour / 1000))

			if xpGainedTotal > 0 then
				GameTooltip:AddLine("Total exp. gained: " .. format("|c00%s%d|r", defaultHex, xpGainedTotal))
			end

			if restedPercent >= 1 then
				GameTooltip:AddLine("Rested: " .. format("|c00%s%d%%|r", defaultHex, restedPercent))
			end

			if not ResistUI:IsInf(levelIn) then
				GameTooltip:AddLine("Leveling in: " .. format("|c00%s%s|r", defaultHex, ResistUI:FormatTime(levelIn)))
			end

			GameTooltip:AddLine("Elapsed: " .. format("|c00%s%s|r", defaultHex, ResistUI:FormatTime(elapsed)))
			GameTooltip:AddLine("(Click to reset session)", 0.6, 0.6, 0.6)
			GameTooltip:Show()
		end)

		xpHourText:SetScript("OnLeave", function(auto)
			GameTooltip:Hide()
		end)

		xpHourText:SetScript("OnMouseDown", function(self, btn)
			if btn ~= "LeftButton" then return end

			started = GetServerTime()
			xpGainedTotal = 0
			xpPerHour = 0
			elapsed = 0
			levelIn = 0
			update()
		end)

		update()
		C_Timer.NewTicker(1, update)
	end

	setupFps()
	setupLatency()
	setupDurability()
	setupSpeed()
	setupXpHour()
end
