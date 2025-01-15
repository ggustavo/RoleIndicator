local _, addon  = ...
local select = _G.select

local function update_icon(role, nameplate, level)

    if not nameplate.gra then 
        nameplate.gra = nameplate:CreateTexture(nil, "OVERLAY")
        nameplate.gra.role = ""
    end

    local anchor
    if TidyPlates and nameplate.extended then
        anchor = nameplate.extended
    elseif KkthnxUI and nameplate.hp then
        anchor = nameplate.hp
    end
    
    if level then
        if addon.hide_level then
            level:SetAlpha(0)
        else
            level:SetAlpha(1)
        end
    end
        
    if not (nameplate.gra.role == role) then
        nameplate.gra.role = role
        nameplate.gra:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-ROLES")
        nameplate.gra:SetTexCoord(GetTexCoordsForRole(role))
        nameplate.gra:SetWidth(addon.nameplate_size)
        nameplate.gra:SetHeight(addon.nameplate_size)
    end
    
    if not anchor then
        nameplate.gra:SetPoint("CENTER", level, "CENTER", addon.nameplate_X, addon.nameplate_Y)
    else
        nameplate.gra:SetPoint("LEFT", anchor, "RIGHT", addon.nameplate_X, addon.nameplate_Y)
    end
    
    nameplate.gra:Show()
    
end

local function update_nameplate(nameplate)
    if nameplate.gra then nameplate.gra:Hide() end
    local _, _, _, _, _, _, oldname, oldlevel = nameplate:GetRegions()
    local name = (TidyPlates and nameplate.extended) and nameplate.extended.unit.name or oldname:GetText()
    local level = (TidyPlates and nameplate.extended) and nameplate.extended.visual.level or oldlevel
    
    if tContains(addon.list_healers, name) then -- HEALERS
        update_icon("HEALER", nameplate, level)
        return
    elseif tContains(addon.list_tanks, name) then -- TANKS
        update_icon("TANK", nameplate, level)
        return
    end

    if level:IsShown() then level:SetAlpha(1) end
end


function addon:find_nameplates(...)
    for i = 1, select('#', ...) do
         local frame = select(i, ...)
         local region = frame:GetRegions()
 
         if (not frame:GetName() and region and region:GetObjectType() == "Texture" and region:GetTexture() == "Interface\\TargetingFrame\\UI-TargetingFrame-Flash") -- NamePlate nativo da blizz
         or (TidyPlates and frame.extended) -- TidyPlates
         or (KkthnxUI and frame.hp) then -- KkthnxUI NamePlates
            update_nameplate(frame)
         end
    end
end