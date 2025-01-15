local _, addon = ...


addon.list_healers = {}
addon.list_tanks = {}

addon.hide_level = true
addon.nameplate_size = 30
addon.nameplate_X = 0
addon.nameplate_Y = 0
addon.nameplate_update_interval = 1.00

-- Spells utilizadas para identificar alguém como healer
addon.list_spell_healers = {
    -- Pala Holy
    "Holy Shock", "Beacon of Light",
    -- Shaman Restor
    "Riptide", "Earth Shield",
    -- Priest Disc
    "Penance", "Borrowed Time", "Renewed Hope", "Grace",
    -- Priest Holy
    "Serendipity", "Body and Soul", "Circle of Healing", "Blessed Resilience",
    -- Druida Restor
    "Tree of Life", "Wild Growth", "Swiftmend",
}

-- Spells utilizadas para identificar alguém como tank
addon.list_spell_tanks = {
    -- Pala Tank
    "Holy Shield", "Hammer of the Righteous", "Avenger's Shield",
    -- Warr Tank
    "Shockwave", "Devastate", "Concussion Blow", "Last Stand", "Safeguard",
    -- DK Blood
    -- "Heart Strike", "Dancing Rune Weapon", "Vampiric Blood", "Hysteria", "Mark of Blood", "Bloody Vengeace",
    "Vampiric Blood", "Mark of Blood", "Rune Tap"
}
