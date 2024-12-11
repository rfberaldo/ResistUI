local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	local _, class = UnitClass("player")
	local classColor = RAID_CLASS_COLORS[class]

	local function createText(relativeTo)
		local text = UIParent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		text:SetFont(ResistUI.font, ResistUI.fontSize + 2, "OUTLINE")
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

	local fpsText = createText()

	local function updateFps()
		fpsText:SetText("|c00ffffff" .. floor(GetFramerate()) .. "|r fps")
	end

	C_Timer.NewTicker(1, updateFps)
	updateFps()

	-- Latency

	local latencyText = createText(fpsText)

	local function updateLatency()
		local latency = select(4, GetNetStats())
		local color = latency > 500 and "ff3232" or "ffffff"
		latencyText:SetText("|c00" .. color .. latency .. "|r ms")
	end

	C_Timer.NewTicker(15, updateLatency)
	updateLatency()

	-- Durability

	local durabilityText = createText(latencyText)

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
		durabilityText:SetText("|c00ffffff" .. string.format("%d", currentSum / maximumSum * 100) .. "%|r durability")
	end

	local f = CreateFrame("Frame")
	f:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	f:SetScript("OnEvent", updateDurability)
	updateDurability()

	-- Mov. speed

	local speedText = createText(durabilityText)
	local speed = nil

	local function updateSpeed()
		if speed == GetUnitSpeed("player") then return end

		speed = GetUnitSpeed("player")
		speedText:SetText("|c00ffffff" .. string.format("%d", speed / 7 * 100) .. "%|r speed")
	end

	C_Timer.NewTicker(0.1, updateSpeed)
end
