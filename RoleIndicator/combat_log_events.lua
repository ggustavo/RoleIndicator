local _, addon = ...

------------------------ COMBAT_LOG_EVENT_UNFILTERED FRAME ----------------------
local function OnEvent(self, event, ...)
    local a, subevent, _, sourceName, _, _, destName, _, prefixParam1, spell_name, _, suffixParam1, suffixParam2 = ...
    
    --  Ignore events from the player
    if sourceName == UnitName("player") then return end

    -- Ignore events from unknown sources
    if sourceName == "Unknown" then return end
    
    -- Ignore Mark of Blood heals
    if spell_name == "Mark of Blood" and subevent == "SPELL_HEAL" then return end 


    -- If the spell is on the healer spell list
    if addon.list_spell_healers[spell_name] then 

        -- if the player was previously a tank and has now changed to healer we should remove him from the tank list
        if addon.list_tanks[sourceName] ~= nil then
            addon:remove_role_indicator(sourceName, addon.list_info.tanks, spell_name)
        end

        if addon.list_healers[sourceName] == nil then -- add healer to list
            addon:insert_new_role_indicator(sourceName, addon.list_info.healers, spell_name)
            return
        end
    end

    -- If the spell is on the tank spell list
    if addon.list_spell_tanks[spell_name] then 

        -- If the player was previously a healer and has now changed to tank we should remove him from the healer list 
        if addon.list_healers[sourceName] ~= nil then 
            addon:remove_role_indicator(sourceName, addon.list_info.healers, spell_name)
        end

        if addon.list_tanks[sourceName] == nil then -- add tank to list
            addon:insert_new_role_indicator(sourceName, addon.list_info.tanks, spell_name)
            return
        end
    end

    -- If the player changes roles to DPS, the addon should remove the icon from the nameplate.
    if addon.list_spells_dps[spell_name] then

        if addon.list_healers[sourceName] then
            addon:remove_role_indicator(sourceName, addon.list_info.healers, spell_name)
            return
        end

        if addon.list_tanks[sourceName] then
            addon:remove_role_indicator(sourceName, addon.list_info.tanks, spell_name)
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
    addon:debug("Reseting healer and tank lists")
    for k in pairs(addon.list_healers) do
        addon.list_healers[k] = nil
    end
    for k in pairs(addon.list_tanks) do
        addon.list_tanks[k] = nil
    end
end
player_entering_world_frame:SetScript("OnEvent", eventHandler);

