local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	if not ResistUICfg.energyTick then return end

	local availbleClasses = {
		["ROGUE"] = true,
		["DRUID"] = true,
	}
	local _, class = UnitClass("player")
	if not availbleClasses[class] then return end

	local INTERVAL = 2 -- const
	local last = UnitPower("player")
	local expirationTime = 0

	local function tickHandler(self, _, unit, type)
		if unit ~= "player" then return end
		if type ~= "ENERGY" then return end

		local ts = GetTime()

		local curr = UnitPower("player")
		local max = UnitPowerMax("player")

		if last < curr and curr < max then
			self:Show()
			self.Spark:Show()
			expirationTime = ts + INTERVAL
		end
		last = curr
	end

	local function updateHandler(self)
		if not self:IsShown() then return end

		local ts = GetTime()

		local powerType = UnitPowerType("player")
		if powerType ~= Enum.PowerType.Energy then
			self:Hide()
			self.Spark:Hide()
			return
		end

		local timeLeft = expirationTime - ts
		if timeLeft <= 0 then
			local curr = UnitPower("player")
			local max = UnitPowerMax("player")
			if curr >= max then
				expirationTime = ts + INTERVAL
			end

			return
		end

		local progress = ResistUI:Clamp((INTERVAL - timeLeft) / INTERVAL, 0, 1)
		self:SetValue(progress * 100)

		local sparkX = progress * self:GetWidth()
		self.Spark:SetPoint("CENTER", self, "LEFT", sparkX, 0)
	end

	local f = CreateFrame("StatusBar")
	f:RegisterEvent("UNIT_POWER_UPDATE")
	f:SetScript("OnEvent", tickHandler)
	f:SetScript("OnUpdate", updateHandler)

	f:SetAllPoints(PlayerFrameManaBar)
	f:SetWidth(PlayerFrameManaBar:GetWidth())
	f:SetHeight(PlayerFrameManaBar:GetHeight())
	f:SetMinMaxValues(0, 100)
	f:SetStatusBarColor(1, 0.5, 0.1, 1)
	f:SetValue(0)
	f:Hide()

	f.Spark = f:CreateTexture(nil, "OVERLAY")
	f.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	f.Spark:SetWidth(12)
	f.Spark:SetHeight(f:GetHeight() * 2)
	f.Spark:SetBlendMode("ADD")
	f.Spark:Hide()
end
