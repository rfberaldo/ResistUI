local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	local function ResistUI_UnitColor(self)
		if not UnitExists(self.unit) then return end

		self:SetStatusBarDesaturated(1)

		if UnitIsPlayer(self.unit) and UnitIsConnected(self.unit) and UnitClass(self.unit) then
			local _, class = UnitClass(self.unit)
			local color = RAID_CLASS_COLORS[class]
			-- if not color then return end
			self:SetStatusBarColor(color.r, color.g, color.b)
			return
		end

		if UnitIsPlayer(self.unit) and not UnitIsConnected(self.unit) then
			self:SetStatusBarColor(0.5, 0.5, 0.5)
			return
		end

		-- if UnitIsTapDenied(self.unit) and not UnitPlayerControlled(self.unit) then
		if UnitIsTapDenied(self.unit) then
			self:SetStatusBarColor(0.5, 0.5, 0.5)
			return
		end

		local reaction = FACTION_BAR_COLORS[UnitReaction(self.unit, "player")]
		if reaction then
			self:SetStatusBarColor(reaction.r, reaction.g, reaction.b)
		end
	end

	hooksecurefunc("UnitFrameHealthBar_Update", ResistUI_UnitColor)
	hooksecurefunc("HealthBar_OnValueChanged", ResistUI_UnitColor)
end
