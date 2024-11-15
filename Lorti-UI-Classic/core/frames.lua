--get the addon namespace
local addon, ns = ...
--get the config values
local cfg = ns.cfg
local dragFrameList = ns.dragFrameList

local addonlist = {
    ["Shadowed Unit Frames"] = true,
    ["PitBull Unit Frames 4.0"] = true,
    ["X-Perl UnitFrames"] = true,
    ["Z-Perl UnitFrames"] = true,
    ["EasyFrames"] = true,
    ["RougeUI"] = true,
    ["ElvUI"] = true,
    ["Uber UI Classic"] = true,
    ["whoaThickFrames_BCC"] = true,
    ["whoaUnitFrames_BCC"] = true,
    ["AbyssUI"] = true,
    ["KkthnxUI"] = true,
    ["TextureScript"] = true,
    ["DarkModeUI"] = true,
    ["SUI"] = true,
    ["RiizUI"] = true
}

-- v:SetVertexColor(.35, .35, .35) GREY
-- v:SetVertexColor(.05, .05, .05) DARKEST

local events = {
    "PLAYER_LOGIN",
    "PLAYER_ENTERING_WORLD",
    "GROUP_ROSTER_UPDATE"
}

---------------------------------------
-- ACTIONS
---------------------------------------

-- REMOVING UGLY PARTS OF UI

local errormessage_blocks = {
    'Способность пока недоступна',
    'Выполняется другое действие',
    'Невозможно делать это на ходу',
    'Предмет пока недоступен',
    'Недостаточно',
    'Некого атаковать',
    'Заклинание пока недоступно',
    'У вас нет цели',
    'Вы пока не можете этого сделать',

    'Ability is not ready yet',
    'Another action is in progress',
    'Can\'t attack while mounted',
    'Can\'t do that while moving',
    'Item is not ready yet',
    'Not enough',
    'Nothing to attack',
    'Spell is not ready yet',
    'You have no target',
    'You can\'t do that yet',
}

local uierrorsframe_addmessage = uierrorsframe_addmessage
local old_uierrosframe_addmessage
local ipairs = ipairs
local pairs = pairs

local function uierrorsframe_addmessage (frame, text, red, green, blue, id)
    for _, v in ipairs(errormessage_blocks) do
        if text and text:match(v) then
            return
        end
    end
    old_uierrosframe_addmessage(frame, text, red, green, blue, id)
end

local function enable()
    old_uierrosframe_addmessage = UIErrorsFrame.AddMessage
    UIErrorsFrame.AddMessage = uierrorsframe_addmessage
end

-- Classification
local function ApplyThickness()
    hooksecurefunc("TargetFrame_CheckClassification", function(self, forceNormalTexture)
        local classification = UnitClassification(self.unit);
        if (classification == "worldboss" or classification == "elite") then
            self.borderTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\target\\Thick-Elite")
            self.borderTexture:SetVertexColor(1, 1, 1)
        elseif (classification == "rareelite") then
            self.borderTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\target\\Thick-Rare-Elite")
            self.borderTexture:SetVertexColor(1, 1, 1)
        elseif (classification == "rare") then
            self.borderTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\target\\Thick-Rare")
            self.borderTexture:SetVertexColor(1, 1, 1)
        else
            self.borderTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\unitframes\\UI-TargetingFrame")
            self.borderTexture:SetVertexColor(0.05, 0.05, 0.05)
        end

        self.highLevelTexture:SetPoint("CENTER", self.levelText, "CENTER", 0, 0);
        self.nameBackground:Hide();
        self.name:SetPoint("LEFT", self, 15, 36);
        self.healthbar:SetSize(119, 27);
        self.healthbar:SetPoint("TOPLEFT", 5, -24);
        self.manabar:SetPoint("TOPLEFT", 7, -52);
        self.manabar:SetSize(119, 13);
        
       
        if self.Background then
            if (forceNormalTexture) then
                self.haveElite = nil
                self.Background:SetSize(119, 42)
                self.Background:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 7, 35)
            else
                self.haveElite = true
                self.Background:SetSize(119, 42)
            end
        end
    end)

    --Player Name

    PlayerFrame.name:ClearAllPoints()
    PlayerFrame.name:SetPoint('TOP', PlayerFrameHealthBar, 0, 15)

    --Rest Glow

    PlayerStatusTexture:SetTexture()
    PlayerRestGlow:SetAlpha(0)

    --Player Frame

    local function LortiUIPlayerFrame(self)
        PlayerFrameTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\unitframes\\UI-TargetingFrame");
        self.name:Hide();
        self.name:ClearAllPoints();
        self.name:SetPoint("CENTER", PlayerFrame, "CENTER", 50.5, 36);
        self.healthbar:SetPoint("TOPLEFT", 106, -24);
        self.healthbar:SetHeight(27);
        PlayerFrameHealthBarText:SetPoint("CENTER", 50, 12);
        self.manabar:SetPoint("TOPLEFT", 106, -52);
        self.manabar:SetHeight(13);
       TargetFrameTextureFrameHealthBarText:SetPoint("CENTER", -50, 12);
        PlayerFrameGroupIndicatorText:ClearAllPoints();
        PlayerFrameGroupIndicatorText:SetPoint("BOTTOMLEFT", PlayerFrame, "TOP", 0, -20);
        PlayerFrameGroupIndicatorLeft:Hide();
        PlayerFrameGroupIndicatorMiddle:Hide();
        PlayerFrameGroupIndicatorRight:Hide();
        PlayerFrameGroupIndicatorText:Hide();
        PlayerFrameGroupIndicator:Hide();
    end
    hooksecurefunc("PlayerFrame_ToPlayerArt", LortiUIPlayerFrame)
    hooksecurefunc("PlayerFrame_ToVehicleArt", LortiUIPlayerFrame)

    --Target of Target Frame Texture

    TargetFrameToTTextureFrameTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\unitframes\\UI-TargetofTargetFrame");
    TargetFrameToTHealthBar:SetHeight(8)
    FocusFrameToTTextureFrameTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\unitframes\\UI-TargetofTargetFrame");
    FocusFrameToTHealthBar:SetHeight(8)
end

local function Classify(self, forceNormalTexture)
    local classification = UnitClassification(self.unit);
    if (classification == "minus") then
        self.borderTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Minus");
        self.borderTexture:SetVertexColor(.05, .05, .05)
        self.nameBackground:Hide();
        self.manabar.pauseUpdates = true;
        self.manabar:Hide();
        self.manabar.TextString:Hide();
        self.manabar.LeftText:Hide();
        self.manabar.RightText:Hide();
        forceNormalTexture = true;
    elseif (classification == "worldboss" or classification == "elite") then
        self.borderTexture:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\target\\elite")
        self.borderTexture:SetVertexColor(1, 1, 1)
    elseif (classification == "rareelite") then
        self.borderTexture:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\target\\rare-elite")
        self.borderTexture:SetVertexColor(1, 1, 1)
    elseif (classification == "rare") then
        self.borderTexture:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\target\\rare")
        self.borderTexture:SetVertexColor(1, 1, 1)
    else
        self.borderTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame")
        self.borderTexture:SetVertexColor(.05, .05, .05)
    end
end

local function ColorRaid()
    for g = 1, NUM_RAID_GROUPS do
        local group = _G["CompactRaidGroup" .. g .. "BorderFrame"]
        if group then
            for _, region in pairs({ group:GetRegions() }) do
                if region:IsObjectType("Texture") then
                    region:SetVertexColor(.05, .05, .05)
                end
            end
        end

        for m = 1, 5 do
            local frame = _G["CompactRaidGroup" .. g .. "Member" .. m]
            if frame then
                groupcolored = true
                for _, region in pairs({ frame:GetRegions() }) do
                    if region:GetName():find("Border") then
                        region:SetVertexColor(.05, .05, .05)
                    end
                end
            end

            local frame = _G["CompactRaidFrame" .. m]
            if frame then
                singlecolored = true
                for _, region in pairs({ frame:GetRegions() }) do
                    if region:GetName():find("Border") then
                        region:SetVertexColor(.05, .05, .05)
                    end
                end
            end
        end
    end

    for _, region in pairs({ CompactRaidFrameContainerBorderFrame:GetRegions() }) do
        if region:IsObjectType("Texture") then
            region:SetVertexColor(.05, .05, .05)
        end
    end
end

local function DarkFrames()
    for _, v in pairs({
        PlayerFrameAlternateManaBarBorder,
        PlayerFrameAlternateManaBarLeftBorder,
        PlayerFrameAlternateManaBarRightBorder,
        PlayerFrameAlternatePowerBarBorder,
        PlayerFrameAlternatePowerBarLeftBorder,
        PlayerFrameAlternatePowerBarRightBorder,
        PlayerFrameTexture,
        TargetFrameTextureFrameTexture,
        TargetFrameToTTextureFrameTexture,
        PetFrameTexture,
        PartyMemberFrame1Texture,
        PartyMemberFrame2Texture,
        PartyMemberFrame3Texture,
        PartyMemberFrame4Texture,
        PartyMemberFrame1PetFrameTexture,
        PartyMemberFrame2PetFrameTexture,
        PartyMemberFrame3PetFrameTexture,
        PartyMemberFrame4PetFrameTexture,
        CastingBarFrame.Border,
        FocusFrameToTTextureFrameTexture,
        TargetFrameSpellBar.Border,
        FocusFrameSpellBar.Border,
        TargetFrameSpellBar.BorderShield,
        FocusFrameSpellBar.BorderShield,
        MirrorTimer1Border,
        MirrorTimer2Border,
        MirrorTimer3Border,
        MiniMapTrackingButtonBorder,
        Rune1BorderTexture,
        Rune2BorderTexture,
        Rune3BorderTexture,
        Rune4BorderTexture,
        Rune5BorderTexture,
        Rune6BorderTexture,
        ArenaEnemyFrame1Texture,
        ArenaEnemyFrame2Texture,
        ArenaEnemyFrame3Texture,
        ArenaEnemyFrame4Texture,
        ArenaEnemyFrame5Texture,
        ArenaEnemyFrame1SpecBorder,
        ArenaEnemyFrame2SpecBorder,
        ArenaEnemyFrame3SpecBorder,
        ArenaEnemyFrame4SpecBorder,
        ArenaEnemyFrame5SpecBorder,
        ArenaEnemyFrame1PetFrameTexture,
        ArenaEnemyFrame2PetFrameTexture,
        ArenaEnemyFrame3PetFrameTexture,
        ArenaEnemyFrame4PetFrameTexture,
        ArenaEnemyFrame5PetFrameTexture,
        ArenaPrepFrame1Texture,
        ArenaPrepFrame2Texture,
        ArenaPrepFrame3Texture,
        ArenaPrepFrame4Texture,
        ArenaPrepFrame5Texture,
        ArenaPrepFrame1SpecBorder,
        ArenaPrepFrame2SpecBorder,
        ArenaPrepFrame3SpecBorder,
        ArenaPrepFrame4SpecBorder,
    }) do
        v:SetVertexColor(.05, .05, .05)
    end

    if IsAddOnLoaded("Blizzard_RaidUI") and CompactRaidFrameManager then
        for _, region in pairs({ CompactRaidFrameManager:GetRegions() }) do
            if region:IsObjectType("Texture") then
                region:SetVertexColor(.05, .05, .05)
            end
        end

        for _, region in pairs({ CompactRaidFrameManagerContainerResizeFrame:GetRegions() }) do
            if region:GetName():find("Border") then
                region:SetVertexColor(.05, .05, .05)
            end
        end
    end

    for _, v in pairs({
        MainMenuBarLeftEndCap,
        MainMenuBarRightEndCap,
        StanceBarLeft,
        StanceBarMiddle,
        StanceBarRight
    }) do
        v:SetVertexColor(.35, .35, .35)
    end

    for _, v in pairs({
        MinimapBorder,
        MinimapBorderTop,
        MiniMapMailBorder,
        MiniMapTrackingBorder,
        MiniMapBattlefieldBorder,
        MiniMapTrackingButtonBorder
    }) do
        v:SetVertexColor(.05, .05, .05)
    end

    for _, v in pairs({
        LootFrameBg,
        LootFrameRightBorder,
        LootFrameLeftBorder,
        LootFrameTopBorder,
        LootFrameBottomBorder,
        LootFrameTopRightCorner,
        LootFrameTopLeftCorner,
        LootFrameBotRightCorner,
        LootFrameBotLeftCorner,
        LootFrameInsetInsetTopRightCorner,
        LootFrameInsetInsetTopLeftCorner,
        LootFrameInsetInsetBotRightCorner,
        LootFrameInsetInsetBotLeftCorner,
        LootFrameInsetInsetRightBorder,
        LootFrameInsetInsetLeftBorder,
        LootFrameInsetInsetTopBorder,
        LootFrameInsetInsetBottomBorder,
        LootFramePortraitFrame,
        ContainerFrame1BackgroundTop,
        ContainerFrame1BackgroundMiddle1,
        ContainerFrame1BackgroundBottom,
        ContainerFrame2BackgroundTop,
        ContainerFrame2BackgroundMiddle1,
        ContainerFrame2BackgroundBottom,
        ContainerFrame3BackgroundTop,
        ContainerFrame3BackgroundMiddle1,
        ContainerFrame3BackgroundBottom,
        ContainerFrame4BackgroundTop,
        ContainerFrame4BackgroundMiddle1,
        ContainerFrame4BackgroundBottom,
        ContainerFrame5BackgroundTop,
        ContainerFrame5BackgroundMiddle1,
        ContainerFrame5BackgroundBottom,
        ContainerFrame6BackgroundTop,
        ContainerFrame6BackgroundMiddle1,
        ContainerFrame6BackgroundBottom,
        ContainerFrame7BackgroundTop,
        ContainerFrame7BackgroundMiddle1,
        ContainerFrame7BackgroundBottom,
        ContainerFrame8BackgroundTop,
        ContainerFrame8BackgroundMiddle1,
        ContainerFrame8BackgroundBottom,
        ContainerFrame9BackgroundTop,
        ContainerFrame9BackgroundMiddle1,
        ContainerFrame9BackgroundBottom,
        ContainerFrame10BackgroundTop,
        ContainerFrame10BackgroundMiddle1,
        ContainerFrame10BackgroundBottom,
        ContainerFrame11BackgroundTop,
        ContainerFrame11BackgroundMiddle1,
        ContainerFrame11BackgroundBottom,
        MerchantFrameTopBorder,
        MerchantFrameBtnCornerRight,
        MerchantFrameBtnCornerLeft,
        MerchantFrameBottomRightBorder,
        MerchantFrameBottomLeftBorder,
        MerchantFrameButtonBottomBorder,
        MerchantFrameBg,
    }) do
        v:SetVertexColor(.35, .35, .35)
    end

    -- PlayerFrame:SetScale(1.3)
    -- TargetFrame:SetScale(1.3)
    -- FocusFrame:SetScale(1.3)
    -- PartyMemberFrame1:SetScale(1.5)
    -- PartyMemberFrame2:SetScale(1.5)
    -- PartyMemberFrame3:SetScale(1.5)
    -- PartyMemberFrame4:SetScale(1.5)
    for _, v in pairs({
        ArenaEnemyFrame1PVPIcon,
        ArenaEnemyFrame2PVPIcon,
    }) do
        v:SetVertexColor(.5, .5, .5)
    end

    
end

local function ThirdFrames()
    

    --THINGS THAT SHOULD REMAIN THE REGULAR COLOR
    for _, v in pairs({
        BankPortraitTexture,
        BankFrameTitleText,
        MerchantFramePortrait,
        WhoFrameTotals
    }) do
        v:SetVertexColor(1, 1, 1)
    end

    for _, v in pairs({
        SlidingActionBarTexture0,
        SlidingActionBarTexture1,
        MainMenuBarTexture0,
        MainMenuBarTexture1,
        MainMenuBarTexture2,
        MainMenuBarTexture3,
        MainMenuMaxLevelBar0,
        MainMenuMaxLevelBar1,
        MainMenuMaxLevelBar2,
        MainMenuMaxLevelBar3,
        MainMenuXPBarTexture0,
        MainMenuXPBarTexture1,
        MainMenuXPBarTexture2,
        MainMenuXPBarTexture3,
        MainMenuXPBarTexture4,
       

    }) do
        v:SetVertexColor(.2, .2, .2)
    end

    
    hooksecurefunc("GameTooltip_ShowCompareItem", function(self)
        if self then
            local shoppingTooltip1, shoppingTooltip2 = unpack(self.shoppingTooltips)
            shoppingTooltip1:SetBackdropBorderColor(.05, .05, .05)
            shoppingTooltip2:SetBackdropBorderColor(.05, .05, .05)
        end
    end)

    GameTooltip:SetBackdropBorderColor(.05, .05, .05)
    GameTooltip.SetBackdropBorderColor = function()
    end

    

    local a, b, c, d, e, f, g, h, i = QuestFrameProgressPanel:GetRegions()
    for _, v in pairs({ a, b, c, d, e, f, g, h, i }) do
        v:SetVertexColor(0.35, 0.35, 0.35)
    end

    QuestFrameProgressPanel.Material = QuestFrameProgressPanel:CreateTexture(nil, 'OVERLAY', nil, 7)
    QuestFrameProgressPanel.Material:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\quest\\QuestBG")
    QuestFrameProgressPanel.Material:SetWidth(514)
    QuestFrameProgressPanel.Material:SetHeight(522)
    QuestFrameProgressPanel.Material:SetPoint('TOPLEFT', QuestFrameProgressPanel, 22, -74)
    QuestFrameProgressPanel.Material:SetVertexColor(0.7, 0.7, 0.7)

    

    -- Dropdown Lists
    for _, v in pairs({
        DropDownList1MenuBackdrop.BottomEdge,
        DropDownList1MenuBackdrop.BottomLeftCorner,
        DropDownList1MenuBackdrop.BottomRightCorner,
        DropDownList1MenuBackdrop.LeftEdge,
        DropDownList1MenuBackdrop.RightEdge,
        DropDownList1MenuBackdrop.TopEdge,
        DropDownList1MenuBackdrop.TopLeftCorner,
        DropDownList1MenuBackdrop.TopRightCorner,
        DropDownList2MenuBackdrop.BottomEdge,
        DropDownList2MenuBackdrop.BottomLeftCorner,
        DropDownList2MenuBackdrop.BottomRightCorner,
        DropDownList2MenuBackdrop.LeftEdge,
        DropDownList2MenuBackdrop.RightEdge,
        DropDownList2MenuBackdrop.TopEdge,
        DropDownList2MenuBackdrop.TopLeftCorner,
        DropDownList2MenuBackdrop.TopRightCorner,
    }) do
        v:SetVertexColor(0, 0, 0)
    end

    -- Color Picker Frame

    for _, v in pairs({
        ColorPickerFrame.BottomEdge,
        ColorPickerFrame.BottomLeftCorner,
        ColorPickerFrame.BottomRightCorner,
        ColorPickerFrame.LeftEdge,
        ColorPickerFrame.RightEdge,
        ColorPickerFrame.TopEdge,
        ColorPickerFrame.TopLeftCorner,
        ColorPickerFrame.TopRightCorner,
        ColorPickerFrameHeader,
    }) do
        v:SetVertexColor(0.35, 0.35, 0.35)
    end

    
end

local function ThemeBlizzAddons(addon)

    

    if CraftFrame ~= nil then
        local vectors = { CraftFrame:GetRegions() }
        for i = 1, 6 do
            vectors[i]:SetVertexColor(0.35, 0.35, 0.35)
        end
    end

    if TradeFrame ~= nil then
        local vectors = { TradeFrame:GetRegions() }
        for i = 2, 1 do
            vectors[i]:SetVertexColor(0.35, 0.35, 0.35)
        end

        for _, v in pairs({
            TradeFrameBg,
            TradeFrameBottomBorder,
            TradeFrameButtonBottomBorder,
            TradeFrameLeftBorder,
            TradeFrameRightBorder,
            TradeFrameTitleBg,
            TradeFrameTopBorder,
            TradeFrameTopRightCorner,
            TradeFrameBtnCornerLeft,
            TradeFrameBtnCornerRight,
            TradeFramePortraitFrame,
            TradeRecipientLeftBorder,
            TradeRecipientBG,
            TradeRecipientPortraitFrame,
            TradeRecipientBotLeftCorner,
        }) do
            v:SetVertexColor(0.35, 0.35, 0.35)
        end
    end

    

    
end

local function colour(statusbar, unit)
    if not statusbar then
        return
    end

    if unit then
        if UnitIsConnected(unit) and unit == statusbar.unit then
            if UnitIsPlayer(unit) and UnitClass(unit) and Lorti.classbars == true then
                local _, class = UnitClass(unit)
                local c = RAID_CLASS_COLORS[class]
                if c then
                    statusbar:SetStatusBarColor(c.r, c.g, c.b)
                end
            elseif ( not UnitPlayerControlled(unit) and UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) and not UnitIsTappedByAllThreatList(unit) ) then
	
			statusbar:SetStatusBarColor(.5, .5, .5)
            elseif Lorti.ColoredHP == true then
				statusbar:SetStatusBarColor(.5, .5, .5)
                local red, green = UnitSelectionColor(unit)
                if red == 0 then
                    statusbar:SetStatusBarColor(0, 1, 0)
                elseif green == 0 then
                    statusbar:SetStatusBarColor(1, 0, 0)
                else
                    statusbar:SetStatusBarColor(1, 1, 0)
                end
            end
        end
    end
end
hooksecurefunc("UnitFrameHealthBar_Update", colour)
hooksecurefunc("HealthBar_OnValueChanged", function(self)
    if self and self.unit then
        colour(self, self.unit)
    end
end)

-- Class portrait frames

local function OnLoad()
    TargetFrameToTPortrait:ClearAllPoints()
    TargetFrameToTPortrait:SetPoint("LEFT", TargetFrameToT, "LEFT", 4.8, -.5)
    FocusFrameToTPortrait:ClearAllPoints()
    FocusFrameToTPortrait:SetPoint("LEFT", FocusFrameToT, "LEFT", 4.8, -.5)
end

local lastTargetToTGuid = nil
local lastFocusToTGuid = nil
local CP = {}

function CP:CreateToTPortraits()
    if not self.TargetToTPortrait then
        self.TargetToTPortrait = TargetFrameToT:CreateTexture(nil, "ARTWORK")
        self.TargetToTPortrait:SetSize(TargetFrameToT.portrait:GetSize())
        for i = 1, TargetFrameToT.portrait:GetNumPoints() do
            self.TargetToTPortrait:SetPoint(TargetFrameToT.portrait:GetPoint(i))
        end
    end

    if not self.FocusToTPortrait then
        self.FocusToTPortrait = FocusFrameToT:CreateTexture(nil, "ARTWORK")
        self.FocusToTPortrait:SetSize(FocusFrameToT.portrait:GetSize())
        for i = 1, FocusFrameToT.portrait:GetNumPoints() do
            self.FocusToTPortrait:SetPoint(FocusFrameToT.portrait:GetPoint(i))
        end
    end
end

local CLASS_TEXTURE = "Interface\\AddOns\\Lorti-UI-Classic\\textures\\classes\\%s.tga"

--Class Portraits
local function ApplyClassPortraits(self)
    if self.unit == "pet" then
        return
    end

    if self.portrait and not (self.unit == "targettarget" or self.unit == "focus-target") then
        if UnitIsPlayer(self.unit) then
            local _, class = UnitClass(self.unit)
            if (class and UnitIsPlayer(self.unit)) then
                self.portrait:SetTexture(CLASS_TEXTURE:format(class))
                -- if self.unit == "target" or self.unit == "focus" then
                -- self.portrait:SetTexCoord(0, 1.06, 0, 1.06)
                -- end
            else
                format(self.unit)
                -- if self.unit == "target" or self.unit == "focus" then
                -- self.portrait:SetTexCoord(0,1,0,1)
                -- end
            end
        end
    end

    if UnitExists("targettarget") ~= nil then
        if UnitGUID("targettarget") ~= lastTargetToTGuid then
            lastTargetToTGuid = UnitGUID("targettarget")
            if UnitIsPlayer("targettarget") then
                local _, class = UnitClass("targettarget")
                CP.TargetToTPortrait:SetTexture(CLASS_TEXTURE:format(class))
                CP.TargetToTPortrait:Show()
            else
                CP.TargetToTPortrait:Hide()
            end
        end
    else
        CP.TargetToTPortrait:Hide()
        lastTargetToTGuid = nil
    end

    if UnitExists("focus-target") ~= nil then
        if UnitGUID("focus-target") ~= lastFocusToTGuid then
            lastFocusToTGuid = UnitGUID("focus-target")
            if UnitIsPlayer("focus-target") then
                local _, class = UnitClass("focus-target")
                CP.FocusToTPortrait:SetTexture(CLASS_TEXTURE:format(class))
                CP.FocusToTPortrait:Show()
            else
                CP.FocusToTPortrait:Hide()
            end
        end
    else
        CP.FocusToTPortrait:Hide()
        lastFocusToTGuid = nil
    end
end

--Player, Target, and Target Name Background Bar Textures
local function ApplyFlatBars()

    FocusFrameNameBackground:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat")
    TargetFrameNameBackground:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat")
    PlayerFrame.healthbar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat");
    TargetFrame.healthbar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat");
    FocusFrame.healthbar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat");
    --Party Frames Health Bar Textures

    for i = 1, 4 do
        _G["PartyMemberFrame" .. i .. "HealthBar"]:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat")
    end

    --Mirror Timers Textures (Breath meter, etc)

    MirrorTimer1StatusBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat")
    MirrorTimer2StatusBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat")
    MirrorTimer3StatusBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat")

    --Castbar Bar Texture

    CastingBarFrame:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat")

    --Pet Frame Bar Textures

    PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat");
    TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat");
    FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat");

    --Tooltip Health Bar Texture

    GameTooltipStatusBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat")

    --XP and Rep Bar Textures

    if MainMenuBarReputationBar then
    MainMenuBarReputationBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat")
	end
    MainMenuExpBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat");

    --Mana Bar Texture

    local function LortiUIManaTexture (manaBar)
        local powerType, powerToken, altR, altG, altB = UnitPowerType(manaBar.unit);
        local info = PowerBarColor[powerToken];
        if (info) then
            if (not manaBar.lockColor) then
                manaBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat");
            end
        end
    end
    hooksecurefunc("UnitFrameManaBar_UpdateType", LortiUIManaTexture)
end

local function PvPIcon()
    for _, v in pairs({
        PlayerPVPIcon,
        TargetFrameTextureFramePVPIcon,
        FocusFrameTextureFramePvPIcon,
    }) do
        v:SetAlpha(0.35)
    end

    for i = 1, 4 do
        _G["PartyMemberFrame" .. i .. "PVPIcon"]:SetAlpha(0)
       
    end
end

local Framecolor = CreateFrame("Frame")
Framecolor:RegisterEvent("ADDON_LOADED")
Framecolor:SetScript("OnEvent", function(self, _, addon)
    DarkFrames()

    ThirdFrames()
    self:UnregisterEvent("ADDON_LOADED")
    self:SetScript("OnEvent", nil)
end)

-- This will never unregister, because no sane person loads all the addons during the session.
local BlizzOfc = CreateFrame("Frame")
BlizzOfc:RegisterEvent("ADDON_LOADED")
BlizzOfc:SetScript("OnEvent", function(self, event, addon)
    if event then
        ThemeBlizzAddons(addon)
    end
end)

local function OnEvent(self, event)
    if (event == "PLAYER_LOGIN") then
        OnLoad()
        enable()

        if Lorti.ClassPortraits then
            CP:CreateToTPortraits()
            hooksecurefunc("UnitFramePortrait_Update", ApplyClassPortraits)
        end

        if Lorti.flatbars then
            ApplyFlatBars()
        end

        if Lorti.hitindicator then
            hooksecurefunc(PlayerHitIndicator, "Show", PlayerHitIndicator.Hide)
            hooksecurefunc(PetHitIndicator, "Show", PetHitIndicator.Hide)
        end

        for addon in pairs(addonlist) do
            if IsAddOnLoaded(addon) then
                C_Timer.After(5, function()
                    DarkFrames()
                end)
                return
                self:UnregisterEvent("PLAYER_LOGIN")
            end
        end

        if Lorti.thickness then
            ApplyThickness()
        else
            hooksecurefunc("TargetFrame_CheckClassification", Classify)
        end
    end

    if (event == "PLAYER_ENTERING_WORLD") then
        PvPIcon()

        if CompactRaidGroup1 and not groupcolored == true then
            ColorRaid()
        end

        if CompactRaidFrame1 and not singlecolored == true then
            ColorRaid()
        end
    end

    if (event == "GROUP_ROSTER_UPDATE") then
        if CompactRaidGroup1 and not groupcolored == true then
            ColorRaid()
        end

        if CompactRaidFrame1 and not singlecolored == true then
            ColorRaid()
        end
    end

    self:UnregisterEvent("PLAYER_LOGIN")
end

local e = CreateFrame("Frame")
for _, v in pairs(events) do
    e:RegisterEvent(v)
end
e:SetScript("OnEvent", OnEvent)