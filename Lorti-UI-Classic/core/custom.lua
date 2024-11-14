local function MoveBuffs(buttonName, index)
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -120, -10)
end

local function OtherFunctions()
    if select(2, UnitClass("player")) == "ROGUE" then
        HasBonusActionBar = function()
            return false
        end
    end
end

local function OnEvent(self, event)
    if (event == "PLAYER_LOGIN") then
        if Lorti.stealth then
            OtherFunctions()
        end
        if Lorti.movebuff then
			MoveBuffs()
		end
    else
        return nil
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript('OnEvent', OnEvent)