local _, ResistUI = ...

---@param texture Texture
---@param relativeTo Frame
---@param offset number
function ResistUI:TextureOffset(texture, relativeTo, offset)
	texture:SetPoint("TOPLEFT", relativeTo, "TOPLEFT", offset, -offset)
	texture:SetPoint("BOTTOMRIGHT", relativeTo, "BOTTOMRIGHT", -offset, offset)
end

---@param texture Texture
---@param factor number
function ResistUI:TextureZoom(texture, factor)
	texture:SetTexCoord(factor, 1 - factor, factor, 1 - factor)
end

---@param frame Frame
function ResistUI:ResetPosition(frame)
	frame.ignoreFramePositionManager = true
	frame:ClearAllPoints()
end

---@param frames table
---@param layer DrawLayer
function ResistUI:GetAllTextures(frames, layer)
	local result = {}
	for _, frame in pairs(frames) do
		for _, region in pairs({ frame:GetRegions() }) do
			if region:GetObjectType() == "Texture" then
				if not layer or region:GetDrawLayer() == layer then
					table.insert(result, region)
				end
			end
		end
	end
	return result
end

---@param frame Frame
---@param except table
function ResistUI:DeepRecolor(frame, except)
	except = except or { frames = {}, textures = {} }

	for _, texture in pairs(
		ResistUI:GetAllTextures({ frame })
	) do
		if not except.textures or not except.textures[texture] then
			texture:SetVertexColor(ResistUI.frameColor.fg:GetRGBA())
		end
	end

	for _, child in pairs({ frame:GetChildren() }) do
		local name = child:GetName() or ""
		if (child:GetObjectType() ~= "Button" or name:find("Tab")) and
				child:GetObjectType() ~= "CheckButton" and
				child:GetObjectType() ~= "Slider" and
				(not except.frames or not except.frames[child])
		then
			ResistUI:DeepRecolor(child, except)
		end
	end
end

---@param unit string
---@return boolean
function ResistUI:IsMaxLevel(unit)
	return UnitLevel(unit) == MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()]
end

---@param secs number
function ResistUI:FormatTime(secs)
	local NINETY_MINUTES = 5400 -- const
	local ONE_DAY = 86400      -- const

	if ResistUI:IsInf(secs) then
		return "..."
	end

	if secs > ONE_DAY then
		return format("%dd", ceil(secs / 86400))
	end

	if secs > NINETY_MINUTES then
		return format("%dh", ceil(secs / 3600))
	end

	if secs > 90 then
		return format("%dm", ceil(secs / 60))
	end

	return format("%ds", secs)
end

---@param value number
function ResistUI:IsInf(value)
	return value == math.huge or value == -math.huge
end

---@param value number
---@param min number
---@param max number
function ResistUI:Clamp(value, min, max)
	return math.min(max, math.max(min, value))
end

---@param spellId number any rank
---@return boolean hasBuff, number rank
function ResistUI:PlayerHasBuff(spellId)
	-- localized spell name (for non-english clients)
	local spell = C_Spell.GetSpellInfo(spellId)

	if spell == nil then
		return false, 0
	end

	for i = 1, 40 do
		local aura = C_UnitAuras.GetAuraDataByIndex("player", i, "HELPFUL")
		if aura == nil then break end

		if aura.name == spell.name then
			local subtext = GetSpellSubtext(aura.spellId)
			-- rank from text
			local rank = tonumber(string.match(subtext, "%d+")) or 1
			return true, rank
		end
	end

	return false, 0
end
