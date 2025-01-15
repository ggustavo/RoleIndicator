local _, addon = ...

local tContains = tContains
local select = _G.select

------------------------ COMBAT_LOG_EVENT_UNFILTERED FRAME ----------------------
local function OnEvent(self, event, ...)
    local _, subevent, _, sourceName, _, _, destName, _, prefixParam1, spell_name, _, suffixParam1, suffixParam2 = ...
    
    local caster_player = sourceName == UnitName("player")

    if tContains(addon.list_spell_healers, spell_name) then
        if not tContains(addon.list_healers, sourceName) and not caster_player then
            -- print("Healer: " .. sourceName .. " - " .. spell_name)
            tinsert(addon.list_healers, sourceName)
            addon:find_nameplates(WorldFrame:GetChildren())
        end
    end

    if tContains(addon.list_spell_tanks, spell_name) then
        if spell == "Mark of Blood" and subevent == "SPELL_HEAL" then return end
        if not tContains(addon.list_tanks, sourceName) and not caster_player then
            -- print("Tank: " .. sourceName .. " - " .. spell_name)
            tinsert(addon.list_tanks, sourceName)
            addon:find_nameplates(WorldFrame:GetChildren())
        end
    end
end
local combat_frame = CreateFrame("Frame")
combat_frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
combat_frame:SetScript("OnEvent", OnEvent)

  
------------------------ TIMER NAMEPLATES FRAME ----------------------
local timer_frame = CreateFrame("Frame")
timer_frame.intervalo = 0
timer_frame:SetScript("OnUpdate", function(self, elapsed)
     self.intervalo = self.intervalo + elapsed
      if self.intervalo >= addon.nameplate_update_interval then
          addon:find_nameplates(WorldFrame:GetChildren())
        self.intervalo = 0
      end
end)

------------------------ PLAYER_ENTERING_WORLD FRAME ----------------------
local player_entering_world_frame = CreateFrame("Frame");
player_entering_world_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
local function eventHandler(self, event, ...)
    -- print("reseting healer and tank lists")
    addon.list_healers = table.wipe(addon.list_healers)
    addon.list_tanks = table.wipe(addon.list_tanks)
end
player_entering_world_frame:SetScript("OnEvent", eventHandler);

