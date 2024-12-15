local _, ResistUI = ...

ResistUI.fontSize = 12
ResistUI.font = "Fonts\\FRIZQT__.TTF"
ResistUI.texturePath = "Interface\\Addons\\ResistUI\\Textures\\"
ResistUI.barTexture = ResistUI.texturePath .. "StatusBar\\Smooth"
ResistUI.frameColor = {
	bg = CreateColor(0.2, 0.2, 0.2, 1),
	fg = CreateColor(0.45, 0.45, 0.45, 1),
}

ResistUI.modules = {}
ResistUI.lateModules = {}

function ResistUI:NewModule(name)
	local module = {}
	module.name = name
	table.insert(ResistUI.modules, module)
	return module
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	for _, module in pairs(ResistUI.modules) do
		module:OnLoad()
	end

	f:UnregisterAllEvents()
end)
