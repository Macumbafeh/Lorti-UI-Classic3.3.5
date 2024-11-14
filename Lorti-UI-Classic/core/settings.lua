local Name, ns = ...;
local Title = select(2, GetAddOnInfo(Name)):gsub("%s*v?[%d%.]+$", "");
local cfg = ns.cfg

Lorti = { keyhide, macrohide, stealth, switchtimer, gloss, movebuff, thickness, classbars, ClassPortraits, flatbars, hitindicator, ColoredHP, ActionbarTexture }

local default = {
    keyhide = false,
    macrohide = false,
    stealth = false,
    switchtimer = false,
    gloss = false,
    movebuff = false,
    thickness = false,
    ClassPortraits = false,
    classbars = false,
    flatbars = false,
    hitindicator = true,
    ColoredHP = true,
    ActionbarTexture = false,
}

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

local function CheckBtn(title, desc, panel, onClick)
    local frame = CreateFrame("CheckButton", title, panel, "InterfaceOptionsCheckButtonTemplate")
    frame:SetScript("OnClick", function(self)
        local enabled = self:GetChecked()
        onClick(self, enabled and true or false)
    end)
    frame.text = _G[frame:GetName() .. "Text"]
    frame.text:SetText(title)
    frame.tooltipText = desc
    return frame
end

function f:ADDON_LOADED()
    for i, j in pairs(default) do
        if type(j) == "table" then
            for k, v in pairs(j) do
                if Lorti[i][k] == nil then
                    Lorti[i][k] = v
                end
            end
        else
            if Lorti[i] == nil then
                Lorti[i] = j
            end
        end
    end

    if not f.options then
        f.options = f:CreateGUI()
    end

    f:UnregisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", nil)
end

function f:CreateGUI()
    local Panel = CreateFrame("Frame", nil, InterfaceOptionsPanelContainer)
    do
        Panel.name = Title;
        InterfaceOptions_AddCategory(Panel);--	Panel Registration

        local title = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
        title:SetPoint("TOPLEFT", 12, -15);
        title:SetText(Title);

        local Reload = CreateFrame("Button", nil, Panel, "UIPanelButtonTemplate")
        Reload:SetPoint("TOPLEFT", 300, -380)
        Reload:SetWidth(100)
        Reload:SetHeight(25)
        Reload:SetText("Save & Reload")
        Reload:SetScript(
                "OnClick",
                function(self, button, down)
                    ReloadUI()
                end
        )

        local HotKeyButton = CheckBtn("Hide hotkeys", nil, Panel, function(self, value)
            Lorti.keyhide = value
        end)
        HotKeyButton:SetPoint("TOPLEFT", 10, -40)
        HotKeyButton:SetChecked(Lorti.keyhide)

		local MacroButton = CheckBtn("Hide macro text", nil, Panel, function(self, value) Lorti.macrohide = value end)
		MacroButton:SetPoint("TOPLEFT", 10, -80)
		MacroButton:SetChecked(Lorti.macrohide)

		--[[local StealthButton = CheckBtn("Disable stealth stance bar switching", nil, Panel, function(self, value) Lorti.stealth = value end)
		StealthButton:SetPoint("TOPLEFT", 10, -120)
		StealthButton:SetChecked(Lorti.stealth)]]

		local BuffButton = CheckBtn("Use Blizzard's default Buff timer position", nil, Panel, function(self, value) Lorti.switchtimer = value end)
		BuffButton:SetPoint("TOPLEFT", 10, -120)
		BuffButton:SetChecked(Lorti.switchtimer)

		--[[local GlossyButton = CheckBtn("Enable High Gloss on buttons", nil, Panel, function(self, value) Lorti.gloss = value end)
		GlossyButton:SetPoint("TOPLEFT", 10, -200)
		GlossyButton:SetChecked(Lorti.gloss) ]]

		local MoveBuffButton = CheckBtn("Macumba's Bufframe position", nil, Panel, function(self, value) Lorti.movebuff = value end)
		MoveBuffButton:SetPoint("TOPLEFT", 10, -160)
		MoveBuffButton:SetChecked(Lorti.movebuff)

		local ThickFramesButton = CheckBtn("Thick Frames", nil, Panel, function(self, value) Lorti.thickness = value end)
		ThickFramesButton:SetPoint("TOPLEFT", 10, -200)
		ThickFramesButton:SetChecked(Lorti.thickness)

		local ClassBarsButton = CheckBtn("Class colored Health bars", nil, Panel, function(self, value) Lorti.classbars = value end)
		ClassBarsButton:SetPoint("TOPLEFT", 10, -240)
		ClassBarsButton:SetChecked(Lorti.classbars)

		local ClassPortraits = CheckBtn("Class Portraits", nil, Panel, function(self, value) Lorti.ClassPortraits = value end)
		ClassPortraits:SetPoint("TOPLEFT", 10, -280)
		ClassPortraits:SetChecked(Lorti.ClassPortraits)

		local FlatBarsButton = CheckBtn("Enable Flat HP/Mana Bar Texture", nil, Panel, function(self, value) Lorti.flatbars = value end)
		FlatBarsButton:SetPoint("TOPLEFT", 10, -320)
		FlatBarsButton:SetChecked(Lorti.flatbars)

		local IndicatorButton = CheckBtn("Hide PlayerFrame Hit Indicator", nil, Panel, function(self, value) Lorti.hitindicator = value end)
		IndicatorButton:SetPoint("TOPLEFT", 10, -360)
		IndicatorButton:SetChecked(Lorti.hitindicator)

		local ColoredHPButton = CheckBtn("Red Health for enemies and mobs", nil, Panel, function(self, value) Lorti.ColoredHP = value end)
		ColoredHPButton:SetPoint("TOPLEFT", 150, -80)
		ColoredHPButton:SetChecked(Lorti.ColoredHP)

		local ColoredHPButton = CheckBtn("Hide actionbar/menu/bags background", nil, Panel, function(self, value) Lorti.ActionbarTexture = value end)
		ColoredHPButton:SetPoint("TOPLEFT", 150, -40)
		ColoredHPButton:SetChecked(Lorti.ActionbarTexture)


    end
    return Panel
end



