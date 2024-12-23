local _, ResistUI = ...

local module = ResistUI:NewModule()
function module:OnLoad()
	local except = {
		textures = {
			[CharacterFramePortrait] = true,
			[HonorFramePvPIcon] = true,
		},
		frames = {
			[MagicResFrame1] = true,
			[MagicResFrame2] = true,
			[MagicResFrame3] = true,
			[MagicResFrame4] = true,
			[MagicResFrame5] = true,
		},
	}

	ResistUI:DeepRecolor(CharacterFrame, except)
end
