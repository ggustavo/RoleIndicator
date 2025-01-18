local _, addon = ...


addon.list_healers = {}
addon.list_tanks = {}

addon.max_healers     = 25 -- maximum number of healers allowed in list_healers
addon.max_tanks       = 25 -- maximum number of tanks allowed in list_tanks

addon.list_info = {
    healers = { 
        count = 0, 
        type = "heal", 
        data = addon.list_healers, 
        max = addon.max_healers
    }, 
    
    tanks = { 
        count = 0, 
        type = "tank", 
        data = addon.list_tanks,
        max = addon.max_tanks
    }    
}  

addon.hide_level     = true
addon.nameplate_size = 30
addon.nameplate_X    = 0
addon.nameplate_Y    = 0

addon.nameplate_update_interval = 1.00

addon.debug_mode = false

function addon:debug(...)
    if addon.debug_mode then
        print("[debug] ", ...)
    end
end


-- spells used to identify someone as a healer
addon.list_spell_healers = {

    -- Pala Holy
    ["Holy Shock"] = true, 
    ["Beacon of Light"] = true,

    -- Shaman Restor
    ["Riptide"] = true, 
    ["Earth Shield"] = true,

    -- Priest Disc
    ["Penance"] = true, 
    ["Borrowed Time"] = true, 
    ["Renewed Hope"] = true, 
    ["Grace"] = true,

    -- Priest Holy
    ["Serendipity"] = true, 
    ["Body and Soul"] = true, 
    ["Circle of Healing"] = true, 
    ["Blessed Resilience"] = true,

    -- Druida Restor
    ["Tree of Life"] = true, 
    ["Wild Growth"] = true, 
    ["Swiftmend"] = true,
}

-- spells used to identify someone as a tank
addon.list_spell_tanks = {
    -- Pala Tank
    ["Holy Shield"] = true, 
    ["Hammer of the Righteous"] = true, 
    ["Avenger's Shield"] = true,

    -- Warr Tank
    ["Shockwave"] = true, 
    ["Devastate"] = true, 
    ["Concussion Blow"] = true, 
    ["Last Stand"] = true, 
    ["Safeguard"] = true,

    -- DK Blood
    ["Vampiric Blood"] = true, 
    ["Mark of Blood"] = true, 
    ["Rune Tap"] = true,
}

addon.list_spells_dps = {

    -- Unholy
    ["Scourge Strike"] = true, 
    ["Summon Gargoyle"] = true,

    -- Frost
    ["Frost Strike"] = true, 
    ["Howling Blast"] = true,

    -- Balance
    ["Starfall"] = true, 
    ["Typhoon"] = true, 
    ["Moonkin Form"] = true, 
    ["Moonkin Aura"] = true, 
    ["Earth and Moon"] = true, 
    ["Owlkin Frenzy"] = true,

    -- Feral
    ["Mangle (Cat)"] = true, 
    ["Leader of the Pack"] = true, 
    ["Infected Wounds"] = true,

    -- Retri
    ["Crusader Strike"] = true, 
    ["Divine Storm"] = true, 
    ["Sheath of Light"] = true, 
    ["The Art of War"] = true, 
    ["Righteous Vengeance"] = true,

    -- Shadow
    ["Shadowform"] = true, 
    ["Vampiric Touch"] = true, 
    ["Shadow Weaving"] = true, 
    ["Vampiric Embrace"] = true,

    -- Elemental
    ["Totem of Wrath"] = true, 
    ["Astral Shift"] = true, 
    ["Thunderstorm"] = true,

    -- Enhancement
    ["Stormstrike"] = true, 
    ["Maelstrom Weapon"] = true, 
    ["Lava Lash"] = true, 
    ["Feral Spirit"] = true, 
    ["Shamanistic Rage"] = true,

    -- Arms
    ["Mortal Strike"] = true, 
    ["Unrelenting Assault"] = true, 
    ["Second Wind"] = true, 
    ["Trauma"] = true, 
    ["Sweeping Strikes"] = true, 
    ["Taste for Blood"] = true,

    -- Fury
    ["Rampage"] = true, 
    ["Bloodthirst"] = true, 
    ["Heroic Fury"] = true, 
    ["Furious Attacks"] = true, 
    ["Death Wish"] = true
}

