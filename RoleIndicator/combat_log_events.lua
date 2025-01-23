local _, addon = ...

------------------------ COMBAT_LOG_EVENT_UNFILTERED FRAME ----------------------
local function OnEvent(self, event, ...)
    local a, subevent, source_GUID, source_name, _, _, dest_name, _, prefix_param1, spell_name, _, suffix_param1, suffix_param2 = ...

    -- Ignore events from unknown sources
    if source_name == nil or source_name == "Unknown" then return end

     --  Ignore events from the player
     if source_name == UnitName("player") then return end
    
    -- Ignore Mark of Blood heals
    if spell_name == "Mark of Blood" and subevent == "SPELL_HEAL" then return end 

    -- Ignore events from mages when they cast tank or healer spells stolen via spellsteal
    if source_GUID then
        local _, english_class, _, english_race, sex, _, realm = GetPlayerInfoByGUID(source_GUID)
        if english_class == "MAGE" then return end
    end

    -- If the spell is on the healer spell list
    if addon.list_spell_healers[spell_name] then 

        -- If the player was previously a tank and has now changed to healer we should remove him from the tank list
        if addon.list_tanks[source_name] ~= nil then
            addon:remove_role_indicator(source_name, addon.list_info.tanks, spell_name)
        end

        if addon.list_healers[source_name] == nil then -- add healer to list
            addon:insert_new_role_indicator(source_name, addon.list_info.healers, spell_name)
            return
        end
    end

    -- If the spell is on the tank spell list
    if addon.list_spell_tanks[spell_name] then 

        -- If the player was previously a healer and has now changed to tank we should remove him from the healer list 
        if addon.list_healers[source_name] ~= nil then 
            addon:remove_role_indicator(source_name, addon.list_info.healers, spell_name)
        end

        if addon.list_tanks[source_name] == nil then -- add tank to list
            addon:insert_new_role_indicator(source_name, addon.list_info.tanks, spell_name)
            return
        end
    end

    -- If the player changes roles to DPS, the addon should remove the icon from the nameplate.
    if addon.list_spells_dps[spell_name] then

        if addon.list_healers[source_name] then
            addon:remove_role_indicator(source_name, addon.list_info.healers, spell_name)
            return
        end

        if addon.list_tanks[source_name] then
            addon:remove_role_indicator(source_name, addon.list_info.tanks, spell_name)
            return
        end
    end

end
local combat_frame = CreateFrame("Frame")
combat_frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
combat_frame:SetScript("OnEvent", OnEvent)


------------------------ TIMER NAMEPLATES FRAME ----------------------
local timer_frame = CreateFrame("Frame")
timer_frame.interval = 0
timer_frame:SetScript("OnUpdate", function(self, elapsed)
     self.interval = self.interval + elapsed
      if self.interval >= addon.nameplate_update_interval then
        addon:find_nameplates(WorldFrame:GetChildren())
        self.interval = 0
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
    addon.list_info.healers.count = 0
    addon.list_info.tanks.count = 0
end
player_entering_world_frame:SetScript("OnEvent", eventHandler);

