local _, ResistUI = ...

ResistUI.UIFactory = {}

local MARGIN = 32 -- const
local lastEl = {}
local f

---@param title string
---@return Frame
function ResistUI.UIFactory:NewFrame(title)
	f = CreateFrame("Frame", "ResistUIOptionsPanel", UIParent)
	f.name = title

	local fs = f:CreateFontString("ARTWORK", nil, "GameFontHighlightHuge")
	fs:SetPoint("TOPLEFT", MARGIN, -MARGIN)
	fs:SetText(title)

	lastEl = fs
	return f
end

---@param text string
---@return FontString
function ResistUI.UIFactory:NewTitle(text)
	local fs = f:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
	fs:SetPoint("TOPLEFT", lastEl, 0, -MARGIN * 1.5)
	fs:SetText(text)

	lastEl = fs
	return fs
end

---@param text string
---@return CheckButton
function ResistUI.UIFactory:NewCheckbox(text)
	local cb = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
	cb:SetPoint("TOPLEFT", lastEl, 0, -MARGIN)
	cb.Text:SetText(text)
	cb.Text:SetFontObject("GameFontNormal")
	cb.Text:SetPoint("LEFT", cb, "RIGHT", 4, 0)

	lastEl = cb
	return cb
end

---@param text string
---@return Button
function ResistUI.UIFactory:NewButton(text, width)
	local btn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	btn:SetPoint("TOPLEFT", lastEl, 0, -MARGIN * 1.5)
	btn:SetText(text)
	btn:SetWidth(width)

	lastEl = btn
	return btn
end
