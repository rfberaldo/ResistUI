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
