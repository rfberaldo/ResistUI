local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	local _, class = UnitClass("player")
	if class == "WARRIOR" then return end
	if class == "ROGUE" then return end

	local TICK_INTERVAL = 2 -- const
	local FSR_INTERVAL = 5 -- const

	local lastMana = UnitPower("player")
	local lastTick = 0
	local duration = 0
	local expirationTime = 0

	---@return boolean
	local function hasFastRegenBuff()
		local isDrinking = ResistUI:PlayerHasBuff(430)
		local hasInnervate = ResistUI:PlayerHasBuff(29166)
		local hasEvocation = ResistUI:PlayerHasBuff(12051)

		return isDrinking or hasInnervate or hasEvocation
	end

	local function regenFromBuff()
		local MP5_TO_MP2 = 0.4 -- const

		-- Greater BoW is MP5
		local greaterBowRegen = {
			[1] = 30 * MP5_TO_MP2,
			[2] = 33 * MP5_TO_MP2,
		}

		-- BoW is MP5
		local bowRegen = {
			[1] = 10 * MP5_TO_MP2,
			[2] = 15 * MP5_TO_MP2,
			[3] = 20 * MP5_TO_MP2,
			[4] = 25 * MP5_TO_MP2,
			[5] = 30 * MP5_TO_MP2,
			[6] = 33 * MP5_TO_MP2,
		}

		-- Mana Spring is MP2
		local manaSpringRegen = {
			[1] = 4,
			[2] = 6,
			[3] = 8,
			[4] = 10,
		}

		-- Rend is MP5
		local rendRegen = 10 * MP5_TO_MP2

		local regen = 0

		local hasGBow, gBowRank = ResistUI:PlayerHasBuff(25894)
		if hasGBow then
			regen = regen + greaterBowRegen[gBowRank]
		end

		local hasBow, bowRank = ResistUI:PlayerHasBuff(19742)
		if hasBow then
			regen = regen + bowRegen[bowRank]
		end

		local hasManaSpring, manaSpringRank = ResistUI:PlayerHasBuff(5677)
		if hasManaSpring then
			regen = regen + manaSpringRegen[manaSpringRank]
		end

		local rend = ResistUI:PlayerHasBuff(16609)
		if rend then
			regen = regen + rendRegen
		end

		return regen
	end

	---@param gained number
	---@return boolean
	local function isValidTick(gained)
		local MANA_REGEN_SENS = 0.2 -- const
		local baseMp1 = GetManaRegen()
		local baseMp2 = baseMp1 * TICK_INTERVAL
		local lowMp2 = baseMp2 - baseMp2 * MANA_REGEN_SENS
		local highMp2 = baseMp2 + baseMp2 * MANA_REGEN_SENS + regenFromBuff()

		if lowMp2 <= gained and gained <= highMp2 then
			return true
		end

		if gained > highMp2 and hasFastRegenBuff() then
			return true
		end

		return false
	end

	local function tickHandler(self, _, unit, type)
		if unit ~= "player" then return end
		if type ~= "MANA" then return end

		local ts = GetTime()
		local curr = UnitPower("player")

		local isRegenerating = curr > lastMana
		if isRegenerating and isValidTick(curr - lastMana) then
			self:Show()
			self.Spark:Show()
			duration = TICK_INTERVAL
			expirationTime = ts + duration
			lastTick = ts
		end

		local hasSpent = curr < lastMana
		if hasSpent then
			self:Show()
			self.Spark:Show()
			-- time until next tick aligned with 2s intervals
			local remaining = 1 - (ts - lastTick) % TICK_INTERVAL
			duration = FSR_INTERVAL + remaining

			-- if it's a new tick
			if remaining < 0 then
				duration = duration + TICK_INTERVAL
			end

			expirationTime = ts + duration
		end

		lastMana = curr
	end

	local function updateHandler(self)
		if not self:IsShown() then return end

		local ts = GetTime()

		local powerType = UnitPowerType("player")
		if powerType ~= Enum.PowerType.Mana then
			self:Hide()
			self.Spark:Hide()
			return
		end

		local timeLeft = expirationTime - ts
		if timeLeft <= 0 then
			local curr = UnitPower("player")
			local max = UnitPowerMax("player")
			if curr >= max then
				duration = TICK_INTERVAL
				expirationTime = ts + duration
				lastTick = ts
			end

			return
		end

		local progress = ResistUI:Clamp((duration - timeLeft) / duration, 0, 1)
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
