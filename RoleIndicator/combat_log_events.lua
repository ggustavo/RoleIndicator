local _, addon = ...

------------------------ COMBAT_LOG_EVENT_UNFILTERED FRAME ----------------------
local function OnEvent(self, event, ...)
    local _, subevent, _, sourceName, _, _, destName, _, prefixParam1, spell_name, _, suffixParam1, suffixParam2 = ...
    
    -- Ignore events from the player
    if sourceName == UnitName("player") then return end

    -- Ignore Mark of Blood heals
    if spell == "Mark of Blood" and subevent == "SPELL_HEAL" then return end 

    if addon.list_spell_healers[spell_name] then
        if addon.list_healers[sourceName] == nil then
            addon:insert_new_role_indicator(sourceName, addon.list_healers, addon.max_healers, addon.current_size.healers)
            addon:debug("New Healer:", sourceName, spell_name)
            addon:find_nameplates(WorldFrame:GetChildren())
            return
        end
    end

    if addon.list_spell_tanks[spell_name] then
        if addon.list_tanks[sourceName] == nil then
            addon:insert_new_role_indicator(sourceName, addon.list_tanks, addon.max_tanks, addon.current_size.tanks)
            addon:debug("New Tank:", sourceName, spell_name)
            addon:find_nameplates(WorldFrame:GetChildren())
            return
        end
    end

    -- If the player changes roles, the addon should remove the icon from the nameplate.
    if addon.list_spells_dps[spell_name] then
        if addon.list_healers[sourceName] then
            addon:remove_role_indicator(sourceName, addon.list_healers, addon.current_size.healers)
            addon:debug("Removing Healer:", sourceName, spell_name)
            addon:find_nameplates(WorldFrame:GetChildren())
            return
        end

        if addon.list_tanks[sourceName] then
            addon:remove_role_indicator(sourceName, addon.list_tanks, addon.current_size.tanks)
            addon:debug("Removing Tank:", sourceName, spell_name)
            addon:find_nameplates(WorldFrame:GetChildren())
            return
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
    addon:debug("reseting healer and tank lists")
    for k in pairs(addon.list_healers) do
        addon.list_healers[k] = nil
    end
    for k in pairs(addon.list_tanks) do
        addon.list_tanks[k] = nil
    end
end
player_entering_world_frame:SetScript("OnEvent", eventHandler);

