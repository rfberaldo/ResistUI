local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	-- Overwriting the global function used to show buff duration
	function SecondsToTimeAbbrev(seconds)
		if seconds > 86400 then
			return format("%dd", ceil(seconds / 86400))
		end
		if seconds > 3600 then
			return format("%dh", ceil(seconds / 3600))
		end
		if seconds > 90 then
			return format("%dm", ceil(seconds / 60))
		end
		return format("%ds", seconds)
	end

	---@param frame Frame
	---@param frameName string
	---@param size number default: 32
	local function styleIcon(frame, frameName, size)
		if not frame then return end

		size = size or 32
		frame:SetSize(size, size)

		if frame.ResistUIStyled then return end

		local icon = _G[frameName .. "Icon"]

		-- Icon Zoom
		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		local offset = size >= 32 and 2 or 1
		icon:SetPoint("TOPLEFT", frame, "TOPLEFT", offset, -offset)
		icon:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -offset, offset)

		local mask = frame:CreateTexture(frameName .. "Mask", "OVERLAY", nil, 7)
		mask:SetTexture(ResistUI.texturePath .. "Mask\\Gloss.png")
		mask:ClearAllPoints()
		mask:SetAllPoints(frame)

		if _G[frameName .. "Border"] then
			_G[frameName .. "Border"]:Hide()
		end

		if frameName:match("TempEnchant") then
			mask:SetVertexColor(0.7, 0, 1)
		elseif frameName:match("Debuff") then
			mask:SetVertexColor(0.9, 0, 0)
		else
			mask:SetVertexColor(0.05, 0.05, 0.05)
		end

		if frame.duration then
			frame.duration:SetFont(ResistUI.font, ResistUI.fontSize, "OUTLINE")
		end
		if frame.count then
			frame.count:SetFont(ResistUI.font, ResistUI.fontSize, "OUTLINE")
		end

		frame.ResistUIStyled = true
	end

	-- Player
	hooksecurefunc("BuffFrame_Update", function()
		for i = 1, BUFF_ACTUAL_DISPLAY do
			local frameName = "BuffButton" .. i
			local frame = _G[frameName]

			if frame then
				styleIcon(frame, frameName)
			end

			frameName = "DebuffButton" .. i
			frame = _G[frameName]

			if frame then
				styleIcon(frame, frameName)
			end
		end

		for i = 1, BuffFrame.numEnchants do
			local frameName = "TempEnchant" .. i
			local frame = _G[frameName]

			if frame then
				styleIcon(frame, frameName)
			end
		end

		if BuffButton1 and BuffFrame.numEnchants > 1 then
			BuffButton1:ClearAllPoints()
			BuffButton1:SetPoint("TOPRIGHT", TemporaryEnchantFrame, "TOPLEFT", -10, 0)
		end
	end)

	-- Target
	hooksecurefunc("TargetFrame_UpdateAuras", function()
		for i = 1, MAX_TARGET_BUFFS do
			local frameName = "TargetFrameBuff" .. i
			local frame = _G[frameName]
			styleIcon(frame, frameName, 24)
		end
		for i = 1, MAX_TARGET_DEBUFFS do
			local frameName = "TargetFrameDebuff" .. i
			local frame = _G[frameName]
			styleIcon(frame, frameName, 28)
		end
	end)
end
