-- PUP template configuration
-- Keep personal tweaks in user.lua. This template should stay generic and safe for sharing.
--
-- Keybind configuration:
-- layout: "auto", "azerty", or "qwerty"
-- By default this defers to the shared PUP keybind library and stays QWERTY-safe.
PUP_KEYBINDS = {
    layout = "auto",
    enable_binds = true,
    binds = {
        -- Example conflict overrides:
        -- clear = { key = "insert", label = "INSERT" },
        -- cp = { key = "delete", label = "DELETE" },
        -- treasure = { key = "!t", label = "ALT+T" },
        -- lock_weapon = { key = "scrolllock", label = "SCROLLLOCK" },
        -- custom_gear_lock = { key = "pause", label = "PAUSE" }
    },
    labels = {
        -- If you changed Mote default keybinds, update labels here:
        -- idle = "CTRL+F12",
        -- offense = "F9",
        -- physical = "CTRL+F10",
        -- magical = "F11",
        -- hybrid = "CTRL+F9",
        -- custom_gear_lock = "PAUSE"
    }
}

function user_setup()
    -- Alt-F10 - Toggles Kiting Mode.

    --[[
        F9 - Cycle Offense Mode (the offensive half of all 'hybrid' melee modes).

        These are for when you are fighting with or without Pet
        When you are IDLE and Pet is ENGAGED that is handled by the Idle Sets
    ]]
    state.OffenseMode:options("MasterPet", "Master", "Trusts")

    --[[
        Ctrl-F9 - Cycle Hybrid Mode (the defensive half of all 'hybrid' melee modes).

        Used when you are Engaged with Pet
        Used when you are Idle and Pet is Engaged
    ]]
    state.HybridMode:options("Normal", "Acc", "TP", "DT", "Regen", "Ranged")

    --[[
        Alt-F12 - Turns off any emergency mode

        Ctrl-F10 - Cycle type of Physical Defense Mode in use.
        F10 - Activate emergency Physical Defense Mode. Replaces Magical Defense Mode, if that was active.
    ]]
    state.PhysicalDefenseMode:options("PetDT", "MasterDT")

    --[[
        Alt-F12 - Turns off any emergency mode

        F11 - Activate emergency Magical Defense Mode. Replaces Physical Defense Mode, if that was active.
    ]]
    state.MagicalDefenseMode:options("PetMDT")

    --[[ IDLE Mode Notes:

        F12 - Update currently equipped gear, and report current status.
        Ctrl-F12 - Cycle Idle Mode.

        Will automatically set IdleMode to Idle when Pet becomes Engaged and you are Idle
    ]]
    state.IdleMode:options("Idle", "Regen", "Refresh", "MasterDT")

    -- Various Cycles for the different types of PetModes
    state.PetStyleCycleTank = M {"NORMAL", "DD", "MAGIC", "SPAM"}
    state.PetStyleCycleMage = M {"NORMAL", "HEAL", "SUPPORT", "MB", "DD"}
    state.PetStyleCycleDD = M {"NORMAL", "BONE", "SPAM", "OD", "ODACC"}

    -- The actual Pet Mode and Pet Style cycles
    -- Default Mode is Tank
    state.PetModeCycle = M {"TANK", "DD", "MAGE"}
    -- Default Pet Cycle is Tank
    state.PetStyleCycle = state.PetStyleCycleTank

    -- Toggles
    --[[
        Alt + E will turn on or off Auto Maneuver
    ]]
    state.AutoMan = M(false, "Auto Maneuver")

    --[[
        //gs c toggle autodeploy
    ]]
    state.AutoDeploy = M(false, "Auto Deploy")

    --[[
        Alt + D will turn on or off Lock Pet DT
        (Note this will block all gearswapping when active)
    ]]
    state.LockPetDT = M(false, "Lock Pet DT")

    --[[
        Alt + (tilda) will turn on or off the Lock Weapon
    ]]
    state.LockWeapon = M(false, "Lock Weapon")

    --[[
        //gs c toggle setftp
    ]]
    state.SetFTP = M(false, "Set FTP")

    --[[
        This will hide the entire HUB
        //gs c hub all
    ]]
    state.textHideHUB = M(false, "Hide HUB")

    --[[
        This will hide the Mode on the HUB
        //gs c hub mode
    ]]
    state.textHideMode = M(false, "Hide Mode")

    --[[
        This will hide the State on the HUB
        //gs c hub state
    ]]
    state.textHideState = M(false, "Hide State")

    --[[
        This will hide the Options on the HUB
        //gs c hub options
    ]]
    state.textHideOptions = M(false, "Hide Options")

    --[[
        This will toggle the HUB lite mode
        //gs c hub lite
    ]]
    state.useLightMode = M(false, "Toggles Lite mode")

    --[[
        This will toggle the default Keybinds set up for any changeable command on the window
        //gs c hub keybinds
    ]]
    state.Keybinds = M(false, "Hide Keybinds")

    --[[
        This will toggle the CP Mode
        //gs c toggle CP
    ]]
    state.CP = M(false, "CP")
    CP_CAPE = "Aptitude Mantle +1"

    --[[
        Enter the slots you would lock based on a custom set up.
        Can be used in situation like Salvage where you don't want
        certain pieces to change.

        //gs c toggle customgearlock
        ]]
    state.CustomGearLock = M(false, "Custom Gear Lock")
    -- Example customGearLock = T{"head", "waist"}
    customGearLock = T {}

    -- Apply stable direct keybinds, keeping the old physical positions.
    pup_apply_keybinds(PUP_KEYBINDS)

    select_default_macro_book()

    -- Adjust the X (horizontal) and Y (vertical) position here to adjust the window
    pos_x = 0
    pos_y = 500
    setupTextWindow(pos_x, pos_y)

    -- On reload, force one normal GearSwap reevaluation so Town / pet-idle
    -- logic settles the same way as a manual //gs c update.
    send_command('wait 0.5;gs c update')
end

function file_unload()
    pup_unbind_keys()
end

function customize_midcast_set(midcastSet, spell, spellMap)
    if spellMap == "Cure" and spell.target and spell.target.type == "SELF" and sets.midcast.CureSelf then
        midcastSet = set_combine(midcastSet, sets.midcast.CureSelf)
    end

    return midcastSet
end

function pet_weaponskill_setup()
    -- This is to set the mininmum amount of TP you want your pet to have before equiping TP gear (pet is fighting only)
    PET_MIN_TP_TO_WEAPONSKILL = 850
    -- This is the seconds of how long to keep the pet weaponskill gear equipped before reverting to previous set
    PET_GEAR_WEAPONSKILL_LOCKOUT_TIMER = 5
end

function init_gear_sets()
    -- Template note:
    -- Active gear lines below are a practical baseline based on the updated PUP profile.
    -- Many sets also include optional String Theory BiS comments so users can upgrade or
    -- uncomment preferred pieces as they obtain them.
    -- Table of Contents
    ---Gear Variables
    ---Master Only Sets
    ---Hybrid Only Sets
    ---Pet Only Sets
    ---Misc Sets

    -------------------------------------------------------------------------
    --  _____                  __      __        _       _     _
    -- / ____|                 \ \    / /       (_)     | |   | |
    -- | |  __  ___  __ _ _ __   \ \  / /_ _ _ __ _  __ _| |__ | | ___  ___
    -- | | |_ |/ _ \/ _` | '__|   \ \/ / _` | '__| |/ _` | '_ \| |/ _ \/ __|
    -- | |__| |  __/ (_| | |       \  / (_| | |  | | (_| | |_) | |  __/\__ \
    -- \_____|\___|\__,_|_|        \/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/
    -------------------------------------------------------------------------
    --[[
        This section is best ultilized for defining gear that is used among multiple sets
        You can simply use or ignore the below
    ]]
    Weapons = {}
    Weapons.Kenkonken = {
        name = "Kenkonken",
        augments = {'Path: A'}
    }
    Weapons.Ohtas = {
        name = "Ohtas",
        augments = {'Accuracy+70', 'Pet: Accuracy+70', 'Pet: Haste+10%'}
    }
    Weapons.Xiucoatl = {
        name = "Xiucoatl",
        augments = {'Path: C'}
    }
    Weapons.Ohrmazd = {
        name = "Ohrmazd",
        augments = {'Pet: Mag. Evasion+15', 'Pet: Phys. dmg. taken -4%', 'Pet: STR+13 Pet: DEX+13 Pet: VIT+13'}
    }

    Animators = {}
    Animators.Range = "Animator P II +1"
    Animators.Melee = "Animator P +1"
    Animators.Oil = "Automat. Oil +3"

    -- Adjust to your reforge level
    -- Sets up a Key, Value Pair
    Artifact_Foire = {}
    Artifact_Foire.Head_PRegen = "Foire Taj +1" -- missing
    Artifact_Foire.Body_WSD_PTank = "Foire Tobe +1"
    Artifact_Foire.Hands_Mane_Overload = "Foire Dastanas +1"
    Artifact_Foire.Legs_PCure = "Foire Churidars +2"
    Artifact_Foire.Feet_Repair_PMagic = "Foire Babouches +1"

    Relic_Pitre = {}
    Relic_Pitre.Head_PRegen = "Pitre Taj +3" -- Enhances Optimization
    Relic_Pitre.Body_PTP = "Pitre Tobe +3" -- Enhances Overdrive
    Relic_Pitre.Hands_WSD = "Pitre Dastanas +3" -- Enhances Fine-Tuning
    Relic_Pitre.Legs_PMagic = "Pitre Churidars +3" -- Enhances Ventriloquy
    Relic_Pitre.Feet_PMagic = "Pitre Babouches +3" -- Role Reversal

    Empy_Karagoz = {}
    Empy_Karagoz.Head_PTPBonus = "Karagoz Capello +1"
    Empy_Karagoz.Body_Overload = "Karagoz Farsetto +1" -- missing
    Empy_Karagoz.Hands = "Karagoz Guanti +1"
    Empy_Karagoz.Legs_Combat = "Karagoz Pantaloni +1"
    Empy_Karagoz.Feet_Tatical = "Karagoz Scarpe +1" -- missing

    Rao = {}
    Rao.Head_Kabuto = {
        name = "Rao Kabuto +1",
        augments = {"Pet: HP+125", "Pet: Accuracy+20", "Pet: Damage taken -4%"}
    }
    Rao.Body_Togi = {
        name = "Rao Togi +1",
        augments = {"Pet: HP+125", "Pet: Accuracy+20", "Pet: Damage taken -4%"}
    }
    Rao.Hands_Kote = {
        name = "Rao Kote +1",
        augments = {"Pet: HP+125", "Pet: Accuracy+20", "Pet: Damage taken -4%"}
    }
    Rao.Legs_Haidate = {
        name = "Rao Haidate +1",
        augments = {"Pet: HP+125", "Pet: Accuracy+20", "Pet: Damage taken -4%"}
    }
    Rao.Feet_Sune_Ate = {
        name = "Rao Sune-Ate +1",
        augments = {'Pet: HP+125', 'Pet: Accuracy+20', 'Pet: Damage taken -4%'}
    }

    Herculean = {}
    Herculean.HeadPet = {
        name = "Herculean Helm",
        augments = {'Pet: Mag. Acc.+8', 'Pet: "Store TP"+10', 'Pet: Attack+14 Pet: Rng.Atk.+14'}
    }
    Herculean.HandsMaster = {
        name = "Herculean Gloves",
        augments = {'Attack+15', '"Triple Atk."+4', 'DEX+9', 'Accuracy+5'}
    }
    Herculean.HandsPet = {
        name = "Herculean Gloves",
        augments = {'Pet: Accuracy+2 Pet: Rng. Acc.+2', 'Pet: "Store TP"+10', 'Pet: INT+1',
                    'Pet: Attack+14 Pet: Rng.Atk.+14', 'Pet: "Mag.Atk.Bns."+13'}
    }
    Herculean.LegsPet = {
        name = "Herculean Trousers",
        augments = {'Pet: Accuracy+22 Pet: Rng. Acc.+22', 'Pet: "Dbl. Atk."+5', 'Pet: AGI+8'}
    }
    Herculean.FeetMasterAtt = {
        name = "Herculean Boots",
        augments = {'Accuracy+28', '"Triple Atk."+4', 'STR+5', 'Attack+13'}
    }
    Herculean.FeetMasterCrit = {
        name = "Herculean Boots",
        augments = {'Rng.Acc.+16', 'Crit. hit damage +4%', 'DEX+9', 'Accuracy+3', 'Attack+14'}
    }

    Naga = {}
    Naga.Head = {
        name = "Naga Somen",
        augments = {'Pet: MP+80', 'Automaton: "Cure" potency +4%', 'Automaton: "Fast Cast"+3'}
    }
    Naga.Body = {
        name = "Naga Samue",
        augments = {'Pet: MP+80', 'Automaton: "Cure" potency +4%', 'Automaton: "Fast Cast"+3'}
    }
    Naga.Hands = {
        name = "Naga Tekko",
        augments = {'Pet: MP+80', 'Automaton: "Cure" potency +4%', 'Automaton: "Fast Cast"+3'}
    }
    Naga.Feet_Cure = {
        name = "Naga Kyahan",
        augments = {'Pet: MP+80', 'Automaton: "Cure" potency +4%', 'Automaton: "Fast Cast"+3'}
    }
    Naga.Feet = {
        name = "Naga Kyahan",
        augments = {'Pet: HP+100', 'Pet: Accuracy+25', 'Pet: Attack+25'}
    }

    Ryuo = {}
    Ryuo.Head = {
        name = "Ryuo Somen +1",
        augments = {'HP+65', '"Store TP"+5', '"Subtle Blow"+8'}
    }
    Ryuo.Hands = {
        name = "Ryuo Tekko +1",
        augments = {'STR+12', 'DEX+12', 'Accuracy+20'}
    }
    Ryuo.Legs = {
        name = "Ryuo Hakama +1",
        augments = {'Accuracy+25', '"Store TP"+5', 'Phys. dmg. taken -4'}
    }

    Taliah = {}
    Taliah.Head = "Tali'ah Turban +2"
    Taliah.Body = "Tali'ah Manteel +2"
    Taliah.Hands = "Tali'ah Gages +2"
    Taliah.Legs = "Tali'ah Sera. +2"
    Taliah.Feet = "Tali'ah Crackows +2"
    Taliah.Ring = "Tali'ah Ring"

    Hizamaru = {}
    Hizamaru.Head = "Hiza. Somen +2"
    Hizamaru.Body = "Hiza. Haramaki +2"
    Hizamaru.Hands = "Hizamaru Kote +2"
    Hizamaru.Legs = "Hiza. Hizayoroi +2"
    Hizamaru.Feet = "Hiza. Sune-Ate +2"
    Hizamaru.Ring = "Hizamaru Ring"

    Heyoka = {}
    Heyoka.Head = "Heyoka Cap +1"
    Heyoka.Body = "He. Harness +1"
    Heyoka.Hands = "He. Mittens +1"
    Heyoka.Legs = "Heyoka Subligar +1"
    Heyoka.Feet = "He. Leggings +1"

    Taeon = {}
    Taeon.Head = {
        name = "Taeon Chapeau",
        augments = {'Pet: Accuracy+22 Pet: Rng. Acc.+22', 'Pet: "Dbl. Atk."+5', 'Pet: Damage taken -4%'}
    }
    Taeon.Body = {
        name = "Taeon Tabard",
        augments = {'Pet: Accuracy+22 Pet: Rng. Acc.+22', 'Pet: "Dbl. Atk."+5', 'Pet: Damage taken -4%'}
    }
    Taeon.Hands = {
        name = "Taeon Gloves",
        augments = {'Pet: Accuracy+25 Pet: Rng. Acc.+25', 'Pet: "Dbl. Atk."+5', 'Pet: Damage taken -4%'}
    }
    Taeon.Legs = {
        name = "Taeon Tights",
        augments = {'Pet: Accuracy+22 Pet: Rng. Acc.+22', 'Pet: "Dbl. Atk."+5', 'Pet: Damage taken -4%'}
    }
    Taeon.Feet = {
        name = "Taeon Boots",
        augments = {'Pet: Accuracy+24 Pet: Rng. Acc.+24', 'Pet: "Dbl. Atk."+5', 'Pet: Damage taken -4%'}
    }

    Visucius = {}
    Visucius.PetMDT = {
        name = "Visucius's Mantle",
        augments = {'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20', 'Accuracy+20 Attack+20',
                    'Pet: "Regen"+10', 'Pet: Magic dmg. taken-10%'}
    }
    Visucius.MasterMEva = {
        name = "Visucius's Mantle",
        augments = {'Mag. Evasion+15'}
    }
    Visucius.PetTP = {
        name = "Visucius's Mantle",
        augments = {'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20', 'Accuracy+20 Attack+20', 'Pet: Haste+10'}
    }
    Visucius.MasterWSCrit = {
        name = "Visucius's Mantle",
        augments = {'STR+20', 'Accuracy+20 Attack+20', 'STR+10', 'Crit.hit rate+10'}
    }
    Visucius.MasterDA = {
        name = "Visucius's Mantle",
        augments = {'STR+20', 'Accuracy+20 Attack+20', 'Accuracy+10', '"Dbl.Atk."+10'}
    }
    Visucius.PetMA = {
        name = "Visucius's Mantle",
        augments = {'Pet: M.Acc.+20 Pet: M.Dmg.+20', 'Pet: Magic Damage+10'}
    }

    Earrings = {}
    Earrings.Moonshade = {
        name = "Moonshade Earring",
        augments = {'Attack+4', 'TP Bonus +250'}
    }

    Heads = {}
    Heads.Salad = {
        name = "Anwig Salade",
        augments = {'Attack+3', 'Pet: Damage taken -10%', 'Attack+3', 'Pet: "Regen"+1'}
    }

    Backs = {}
    Backs.Dispersal_Mantle = {
        name = "Dispersal Mantle",
        augments = {'STR+3', 'DEX+1', 'Pet: TP Bonus+480'}
    }

    -- Optional Treasure Hunter scaffold.
    -- Mote-TreasureHunter handles the mode logic; uncomment or replace the TH pieces you own.
    sets.TreasureHunter = {
        -- ammo = "Per. Lucky Egg",
        -- waist = "Chaac Belt",
        -- body = { name = "Herculean Vest", augments = {'Treasure Hunter +1'} },
    }

    --------------------------------------------------------------------------------
    --  __  __           _               ____        _          _____      _
    -- |  \/  |         | |             / __ \      | |        / ____|    | |
    -- | \  / | __ _ ___| |_ ___ _ __  | |  | |_ __ | |_   _  | (___   ___| |_ ___
    -- | |\/| |/ _` / __| __/ _ \ '__| | |  | | '_ \| | | | |  \___ \ / _ \ __/ __|
    -- | |  | | (_| \__ \ ||  __/ |    | |__| | | | | | |_| |  ____) |  __/ |_\__ \
    -- |_|  |_|\__,_|___/\__\___|_|     \____/|_| |_|_|\__, | |_____/ \___|\__|___/
    --                                                  __/ |
    --                                                 |___/
    ---------------------------------------------------------------------------------
    -- This section is best utilized for Master Sets
    --[[
        Will be activated when Pet is not active, otherwise refer to sets.idle.Pet
    ]]
    sets.idle = {
        main = Weapons.Kenkonken,
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = Hizamaru.Head,
        body = Hizamaru.Body,
        hands = Hizamaru.Hands,
        legs = Hizamaru.Legs,
        feet = Hizamaru.Feet,
        neck = "Adad Amulet",
        waist = "Moonbow Belt +1",
        left_ear = "Eabani Earring",
        right_ear = "Domes. Earring",
        left_ring = Hizamaru.Ring,
        right_ring = "Yacuruna Ring",
        Visucius.MasterMEva
    }

    -- String Theory: Idle (Regen)
    -- Purpose: master idle set with passive sustain / natural regen between pulls.
    -- Optional String Theory BiS upgrades: Denouements, Pitre Taj +3, Bathy Choker +1, Chirich Ring +1.
    sets.idle.Regen = set_combine(sets.idle, {
        left_ear = "Infused Earring",
        right_ring = "Setae Ring",
        back = "Moonbeam Cape"
    })

    -- String Theory: Idle (Refresh)
    -- Purpose: master idle set focused on refresh / MP recovery.
    -- Optional String Theory BiS upgrades: Denouements, Rawhide Mask, Vrikodara Jupon, Stikini Ring +1, Fucho-no-Obi, Assid. Pants +1.
    sets.idle.Refresh = set_combine(sets.idle, {
        head = Naga.Head,
        body = Naga.Body,
        hands = Naga.Hands,
        feet = Naga.Feet_Cure
    })

    -------------------------------------Fastcast
    sets.precast.FC = {
        -- Add your set here
    }

    -------------------------------------Midcast
    sets.midcast = {} -- Can be left empty

    sets.midcast.FastRecast = {
        -- Add your set here
    }

    -- String Theory: Cure Potency
    -- Purpose: cures cast by the master. Standard healing baseline.
    sets.midcast.Cure = set_combine(sets.precast.FC, {
        head = "Ipoca Beret",
        neck = "Incanter's Torque",
        left_ear = "Mendi. Earring",
        right_ear = "Meili Earring",
        body = "Vrikodara Jupon",
        hands = "Weath. Cuffs +1",
        left_ring = "Sirona's Ring",
        right_ring = "Lebeche Ring",
        back = Visucius.MasterMEva,
        waist = "Bishop's Sash",
        legs = "Gyve Trousers",
        feet = "Regal Pumps +1"
    })

    -- String Theory: Cure Potency Received
    -- Purpose: self-cures. Layered on top of the base Cure set via customize_midcast_set().
    sets.midcast.CureSelf = set_combine(sets.midcast.Cure, {
        main = "Eshus",
        neck = "Phalaina Locket",
        left_ear = "Oneiros Earring",
        left_ring = "Kunaji Ring",
        right_ring = "Asklepian Ring",
        waist = "Gishdubar Sash"
    })

    -------------------------------------Kiting
    sets.Kiting = {
        -- feet = "Hermes' Sandals"
    }

    -------------------------------------JA
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        -- neck = "Magoraga Beads",
        -- body = "Passion Jacket"
    })

    -- Precast sets to enhance JAs
    sets.precast.JA = {} -- Can be left empty

    sets.precast.JA["Tactical Switch"] = {
        feet = Empy_Karagoz.Feet_Tatical
    }

    sets.precast.JA["Ventriloquy"] = {
        legs = Relic_Pitre.Legs_PMagic
    }

    sets.precast.JA["Role Reversal"] = {
        feet = Relic_Pitre.Feet_PMagic
    }

    sets.precast.JA["Overdrive"] = {
        body = Relic_Pitre.Body_PTP
    }

    -- String Theory: intentional mix of "Repair Potency" and "Pet +Max HP"
    -- Purpose: hybrid Repair set, balancing stronger healing with pet max HP.
    -- Optional String Theory BiS upgrades: Nibiru Sainti, Pratik Earring, Foire Babouches +3, Foire Tobe +3, Gnafron's Adargas.
    sets.precast.JA["Repair"] = {
        ammo = Animators.Oil,
        head = Rao.Head_Kabuto,
        body = Herculean.Body_Repair,
        hands = Rao.Hands_Kote,
        legs = "Desultor Tassets",
        feet = Artifact_Foire.Feet_Repair_PMagic,
        left_ear = "Guignol Earring",
        right_ring = "Overbearing Ring",
        back = Visucius
    }

    sets.precast.JA["Maintenance"] = set_combine(sets.precast.JA["Repair"], {})

    -- String Theory: Maneuvers
    -- Purpose: overload suppression / duration / comfort set for maneuver spam.
    -- Optional String Theory BiS upgrades: Kara. Farsetto +2, Foire Dastanas +3.
    sets.precast.JA.Maneuver = {
        main = Weapons.Kenkonken,
        range = Animators.Melee,
        hands = Artifact_Foire.Hands_Mane_Overload,
        neck = "Bfn. Collar +1",
        left_ear = "Burana Earring",
        back = Visucius
    }

    sets.precast.JA["Activate"] = {
        back = Visucius
    }

    sets.precast.JA["Deus Ex Automata"] = sets.precast.JA["Activate"]

    -- String Theory: Master Enmity
    -- Purpose: generate master enmity before Ventriloquy / tank opener.
    -- BiS targets for this set: Mafic Cudgel, Unmoving Collar +1, Cryptic Earring, Trux Earring, Passion Jacket, Kurys Gloves, Supershear Ring, Eihwaz Ring, Goading Belt, Obatala Subligar, Ahosi Leggings.
    sets.precast.JA["Provoke"] = {}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        -- Add your set here
    }

    sets.precast.Waltz["Healing Waltz"] = {}

    -------------------------------------WS
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        -- Add your set here
    }

    -- Specific weaponskill sets. Uses the base set if an appropriate WSMod version isn't found.

    -- String Theory: Stringing Pummel
    -- Purpose: physical multi-hit critical WS for the master.
    -- Optional String Theory BiS upgrades: Blistering Sallet +1, Gere Ring.
    sets.precast.WS["Stringing Pummel"] = set_combine(sets.precast.WS, {
        main = Weapons.Kenkonken,
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = Heyoka.Head,
        body = Heyoka.Body,
        hands = Ryuo.Hands,
        legs = Hizamaru.Legs,
        feet = Heyoka.Feet,
        neck = "Fotia Gorget",
        waist = "Fotia Belt",
        left_ear = "Brutal Earring",
        right_ear = Moonshade,
        left_ring = "Niqmaddu Ring",
        right_ring = "Epona's Ring",
        back = Visucius.MasterWSCrit
    })

    sets.precast.WS["Stringing Pummel"].Mod = set_combine(sets.precast.WS, {
        main = Weapons.Kenkonken,
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = Heyoka.Head,
        body = Heyoka.Body,
        hands = Ryuo.Hands,
        legs = Hizamaru.Legs,
        feet = Heyoka.Feet,
        neck = "Fotia Gorget",
        waist = "Fotia Belt",
        left_ear = "Brutal Earring",
        right_ear = Moonshade,
        left_ring = "Niqmaddu Ring",
        right_ring = "Epona's Ring",
        back = Visucius.MasterWSCrit
    })

    -- String Theory: Victory Smite
    -- Purpose: STR-focused critical WS, very strong with offensive buffs.
    -- Optional String Theory BiS upgrades: Verethragna (Level 119 III), Blistering Sallet +1, Gere Ring, Samnuha Tights.
    sets.precast.WS["Victory Smite"] = set_combine(sets.precast.WS, {
        main = Weapons.Kenkonken,
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = Heyoka.Head,
        body = Heyoka.Body,
        hands = Ryuo.Hands,
        legs = Hizamaru.Legs,
        feet = Heyoka.Feet,
        neck = "Fotia Gorget",
        waist = "Moonbow Belt +1",
        left_ear = "Brutal Earring",
        right_ear = Moonshade,
        left_ring = "Niqmaddu Ring",
        right_ring = "Epona's Ring",
        back = Visucius.MasterWSCrit
    })

    -- String Theory: Shijin Spiral
    -- Purpose: DEX-based multi-hit / accuracy WS.
    -- Optional String Theory BiS upgrades: Godhands, Mache Earring +1, Regal Ring, Samnuha Tights.
    sets.precast.WS["Shijin Spiral"] = set_combine(sets.precast.WS, {
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = Heyoka.Head,
        body = Taliah.Body,
        hands = Herculean.HandsMaster,
        legs = Hizamaru.Legs,
        feet = Herculean.FeetMasterCrit,
        neck = "Fotia Gorget",
        waist = "Fotia Belt",
        left_ear = "Brutal Earring",
        right_ear = Moonshade,
        left_ring = "Niqmaddu Ring",
        right_ring = "Epona's Ring",
        back = Visucius.MasterWSCrit
    })

    -- String Theory: Howling Fist & Raging Fists
    -- Purpose: master multi-hit WS; this Howling set can also serve as the base for Raging Fists later.
    -- Optional String Theory BiS upgrades: Godhands, Pup. Collar +2, Gere Ring, Samnuha Tights.
    sets.precast.WS["Howling Fist"] = set_combine(sets.precast.WS, {
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = Heyoka.Head,
        body = Taliah.Body,
        hands = "Tali'ah Gages +2",
        legs = Hizamaru.Legs,
        feet = Herculean.FeetMasterAtt,
        neck = "Fotia Gorget",
        waist = "Moonbow Belt +1",
        left_ear = "Brutal Earring",
        right_ear = Moonshade,
        left_ring = "Niqmaddu Ring",
        right_ring = "Epona's Ring",
        back = Visucius.MasterDA
    })

    -- String Theory: Asuran Fists
    -- Purpose: 8-hit WS focused on accuracy / attack.
    -- Optional String Theory BiS upgrades: Karambit, Balder Earring +1, Regal Ring.
    sets.precast.WS["Asuran Fists"] = set_combine(sets.precast.WS, {
        main = "Karambit",
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = Relic_Pitre.Head_PRegen,
        body = Relic_Pitre.Body_PTP,
        hands = Relic_Pitre.Hands_WSD,
        legs = Relic_Pitre.Legs_PMagic,
        feet = Relic_Pitre.Feet_PMagic,
        neck = "Fotia Gorget",
        waist = "Fotia Belt",
        left_ear = "Telos Earring",
        right_ear = "Domes. Earring",
        left_ring = "Niqmaddu Ring",
        right_ring = "Epona's Ring",
        back = Visucius.MasterWSCrit
    })

    -- String Theory: Aeolian Edge
    -- Purpose: utility magical cleave option when subbing dagger.
    sets.precast.WS["Aeolian Edge"] = set_combine(sets.precast.WS, {
        main = "Tauret",
        sub = "Kaja Knife",
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = "Herculean Helm",
        neck = "Baetyl Pendant",
        left_ear = "Friomisi Earring",
        right_ear = Moonshade,
        body = "Cohort Cloak +1",
        hands = "Herculean Gloves",
        left_ring = "Metamor. Ring +1",
        right_ring = "Epaminondas's Ring",
        back = Visucius.MasterMEva,
        waist = "Orpheus's Sash",
        legs = "Herculean Trousers",
        feet = "Herculean Boots"
    })

    -------------------------------------Idle
    --[[
        Player is Idle.
        Pet is NOT active.
        Idle Mode (Ctrl-F12) = MasterDT.
    ]]
    -- String Theory: Idle (Damage Taken)
    -- Purpose: defensive master idle / safety set.
    -- Optional String Theory BiS upgrades: Malignance Chapeau, Malignance Tabard, Malignance Gloves, Malignance Tights, Malignance Boots, Warder's Charm +1, Odnowa Earring +1, Defending Ring, Purity Ring.
    sets.idle.MasterDT = {
        head = Naga.Head,
        body = Hizamaru.Body,
        hands = Herculean.HandsMaster,
        legs = Ryuo.Legs,
        feet = Herculean.FeetMasterAtt,
        neck = "Adad Amulet",
        waist = "Moonbow Belt +1",
        left_ear = "Infused Earring",
        right_ear = "Eabani Earring",
        left_ring = "Yacuruna Ring",
        right_ring = "Setae Ring",
        back = "Moonbeam Cape"
    }

    -------------------------------------Engaged
    --[[
        Player is Engaged.
        Offense Mode (F9) = Master (Pet is not active or not prioritized for gear).
        Hybrid Mode (Ctrl-F9) = Normal.
    ]]
    -- String Theory: Master Only TP (Dream Tier)
    -- Purpose: pure master TP set when the pet is not the focus.
    -- Optional String Theory BiS upgrades: Balder Earring +1, Gere Ring.
    sets.engaged.Master = {
        main = Weapons.Kenkonken,
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = Ryuo.Head,
        body = Taliah.Body,
        hands = Herculean.HandsMaster,
        legs = Ryuo.Legs,
        feet = Herculean.FeetMasterAtt,
        neck = "Shulmanu Collar",
        waist = "Moonbow Belt +1",
        left_ear = "Telos Earring",
        right_ear = "Cessance Earring",
        left_ring = "Niqmaddu Ring",
        right_ring = "Epona's Ring",
        back = Visucius.MasterDA
    }

    -------------------------------------Acc
    --[[
        Player is Engaged.
        Offense Mode (F9) = Master.
        Hybrid Mode (Ctrl-F9) = Acc.
    ]]
    -- String Theory: Master Only TP accuracy-oriented variant.
    -- Purpose: safer / higher-accuracy version of the master set.
    sets.engaged.Master.Acc = {
        main = Weapons.Kenkonken,
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = Ryuo.Head,
        body = Taliah.Body,
        hands = Herculean.HandsMaster,
        legs = Ryuo.Legs,
        feet = Herculean.FeetMasterAtt,
        neck = "Shulmanu Collar",
        waist = "Moonbow Belt +1",
        left_ear = "Telos Earring",
        right_ear = "Cessance Earring",
        left_ring = "Niqmaddu Ring",
        right_ring = "Epona's Ring",
        back = Visucius.MasterDA
    }

    -------------------------------------TP
    --[[
        Player is Engaged.
        Offense Mode (F9) = Master.
        Hybrid Mode (Ctrl-F9) = TP.
    ]]
    -- String Theory: Master Only TP TP-oriented / offensive sustain variant.
    -- Purpose: standard grind / melee version of the master set.
    sets.engaged.Master.TP = {
        main = Weapons.Kenkonken,
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = Ryuo.Head,
        body = Taliah.Body,
        hands = Herculean.HandsMaster,
        legs = Ryuo.Legs,
        feet = Herculean.FeetMasterAtt,
        neck = "Shulmanu Collar",
        waist = "Moonbow Belt +1",
        left_ear = "Telos Earring",
        right_ear = "Cessance Earring",
        left_ring = "Niqmaddu Ring",
        right_ring = "Epona's Ring",
        back = Visucius.MasterDA
    }

    -------------------------------------DT
    --[[
        Player is Engaged.
        Offense Mode (F9) = Master.
        Hybrid Mode (Ctrl-F9) = DT.
    ]]
    sets.engaged.Master.DT = {
        -- Add your set here
    }

    ----------------------------------------------------------------------------------
    --  __  __         _           ___     _     ___      _
    -- |  \/  |__ _ __| |_ ___ _ _| _ \___| |_  / __| ___| |_ ___
    -- | |\/| / _` (_-<  _/ -_) '_|  _/ -_)  _| \__ \/ -_)  _(_-<
    -- |_|  |_\__,_/__/\__\___|_| |_| \___|\__| |___/\___|\__/__/
    -----------------------------------------------------------------------------------

    --[[
        These sets are designed to be a hybrid of player and pet gear for when you are
        fighting along side your pet. Basically gear used here should benefit both the player
        and the pet.
    ]]
    --[[
        Player is Engaged.
        Offense Mode (F9) = MasterPet (Player and Pet are fighting together).
        Hybrid Mode (Ctrl-F9) = Normal.
    ]]
    -- String Theory: Dual TP / Dream Tier
    -- Purpose: hybrid master + pet melee set, without Ohtas.
    -- Optional String Theory BiS upgrades: Dedition Earring, Gere Ring.
    sets.engaged.MasterPet = {
        main = Weapons.Kenkonken,
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = Heyoka.Head,
        body = Taliah.Body,
        hands = Herculean.HandsMaster,
        legs = Heyoka.Legs,
        feet = Herculean.FeetMasterAtt,
        neck = "Shulmanu Collar",
        waist = "Moonbow Belt +1",
        left_ear = "Telos Earring",
        right_ear = "Cessance Earring",
        left_ring = "Niqmaddu Ring",
        right_ring = "Epona's Ring",
        back = Visucius.PetTP
    }

    -------------------------------------Acc
    --[[
        Player is Engaged.
        Offense Mode (F9) = MasterPet.
        Hybrid Mode (Ctrl-F9) = Acc.
    ]]
    -- String Theory: Dual TP accuracy-oriented variant.
    sets.engaged.MasterPet.Acc = {
        main = Weapons.Kenkonken,
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = Heyoka.Head,
        body = Taliah.Body,
        hands = Herculean.HandsMaster,
        legs = Heyoka.Legs,
        feet = Herculean.FeetMasterAtt,
        neck = "Shulmanu Collar",
        waist = "Moonbow Belt +1",
        left_ear = "Telos Earring",
        right_ear = "Cessance Earring",
        left_ring = "Niqmaddu Ring",
        right_ring = "Epona's Ring",
        back = Visucius.PetTP
    }

    -------------------------------------TP
    --[[
        Player is Engaged.
        Offense Mode (F9) = MasterPet.
        Hybrid Mode (Ctrl-F9) = TP.
    ]]
    -- String Theory: Dual TP TP-oriented variant.
    sets.engaged.MasterPet.TP = {
        main = Weapons.Kenkonken,
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = Heyoka.Head,
        body = Taliah.Body,
        hands = Herculean.HandsMaster,
        legs = Heyoka.Legs,
        feet = Herculean.FeetMasterAtt,
        neck = "Shulmanu Collar",
        waist = "Moonbow Belt +1",
        left_ear = "Telos Earring",
        right_ear = "Cessance Earring",
        left_ring = "Niqmaddu Ring",
        right_ring = "Epona's Ring",
        back = Visucius.PetTP
    }

    -------------------------------------DT
    --[[
        Player is Engaged.
        Offense Mode (F9) = MasterPet.
        Hybrid Mode (Ctrl-F9) = DT.
    ]]
    sets.engaged.MasterPet.DT = {
        -- Add your set here
    }

    -------------------------------------Regen
    --[[
        Player is Engaged.
        Offense Mode (F9) = MasterPet.
        Hybrid Mode (Ctrl-F9) = Regen.
    ]]
    sets.engaged.MasterPet.Regen = {
        -- Add your set here
    }

    ----------------------------------------------------------------
    --  _____     _      ____        _          _____      _
    -- |  __ \   | |    / __ \      | |        / ____|    | |
    -- | |__) |__| |_  | |  | |_ __ | |_   _  | (___   ___| |_ ___
    -- |  ___/ _ \ __| | |  | | '_ \| | | | |  \___ \ / _ \ __/ __|
    -- | |  |  __/ |_  | |__| | | | | | |_| |  ____) |  __/ |_\__ \
    -- |_|   \___|\__|  \____/|_| |_|_|\__, | |_____/ \___|\__|___/
    --                                  __/ |
    --                                 |___/
    ----------------------------------------------------------------

    -------------------------------------Magic Midcast
    -- String Theory: Magic Damage
    -- Purpose: automaton nuke / magic burst set.
    -- Optional String Theory BiS upgrades: Udug Jacket, Pup. Collar +2, Enmerkar Earring, C. Palug Ring.
    sets.midcast.Pet = {
        main = Weapons.Xiucoatl,
        -- range = Animators.Range,
        ammo = Animators.Oil,
        head = Taliah.Head,
        body = Taliah.Body,
        hands = Herculean.HandsPet,
        legs = Relic_Pitre.Legs_PMagic,
        feet = Relic_Pitre.Feet_PMagic,
        neck = "Adad Amulet",
        waist = "Ukko Sash",
        left_ear = "Burana Earring",
        right_ear = "Kyrene's Earring",
        left_ring = "Tali'ah Ring",
        right_ring = "Thurandaut Ring",
        back = Visucius.PetMA
    }

    -- String Theory: White Mage / Pet cure set
    -- Purpose: automaton healing set when the game identifies a pet heal action.
    -- Optional String Theory BiS upgrades: Denouements, Empath Necklace.
    sets.midcast.Pet.Cure = {
        main = Weapons.Xiucoatl,
        -- range = Animators.Range,
        ammo = Animators.Oil,
        head = Naga.Head,
        body = Naga.Body,
        hands = Naga.Hands,
        legs = Relic_Pitre.Legs_PMagic,
        feet = Naga.Feet_Cure,
        neck = "Adad Amulet",
        waist = "Ukko Sash",
        left_ear = "Burana Earring",
        back = Visucius.PetMA
    }

    -- String Theory: White Mage / Pet cure set
    -- Purpose: healing magic alias for automaton healing spells.
    -- Optional String Theory BiS upgrades: Denouements, Empath Necklace.
    sets.midcast.Pet["Healing Magic"] = {
        main = Weapons.Xiucoatl,
        -- range = Animators.Range,
        ammo = Animators.Oil,
        head = Naga.Head,
        body = Naga.Body,
        hands = Naga.Hands,
        legs = Relic_Pitre.Legs_PMagic,
        feet = Naga.Feet_Cure,
        neck = "Adad Amulet",
        waist = "Ukko Sash",
        left_ear = "Burana Earring",
        back = Visucius.PetMA
    }

    -- String Theory: Magic Damage
    -- Purpose: elemental alias reusing the pet nuke set.
    sets.midcast.Pet["Elemental Magic"] = set_combine(sets.midcast.Pet, {})

    sets.midcast.Pet["Enfeebling Magic"] = {
        -- Add your set here
    }

    sets.midcast.Pet["Dark Magic"] = {
        -- Add your set here
    }

    sets.midcast.Pet["Divine Magic"] = {
        -- Add your set here
    }

    sets.midcast.Pet["Enhancing Magic"] = {
        -- Add your set here
    }

    -------------------------------------Idle
    --[[
        This set will become default Idle Set when the Pet is Active
        and the base sets.idle will be ignored.
        Player is Idle (not fighting).
        Pet is Idle (not fighting).
        Idle Mode (Ctrl-F12) = Idle.
    ]]
    -- String Theory: most practical equivalent of "Pet:Precast/Idle"
    -- Purpose: stable set when the pet is out but its next action is not yet predictable.
    -- Optional String Theory BiS upgrades: Denouements, Empath Necklace.
    sets.idle.Pet = {
        main = Weapons.Xiucoatl,
        range = Animators.Range,
        ammo = Animators.Oil,
        head = Naga.Head,
        body = Naga.Body,
        hands = Naga.Hands,
        legs = Relic_Pitre.Legs_PMagic,
        feet = Naga.Feet_Cure,
        neck = "Adad Amulet",
        waist = "Ukko Sash",
        left_ear = "Burana Earring",
        back = Visucius.PetMA
    }

    sets.idle.Regen.Pet = set_combine(sets.idle.Pet, {})
    sets.idle.Refresh.Pet = set_combine(sets.idle.Pet, {})

    --[[
        Player is Idle (not fighting).
        Pet is Active and Idle (not fighting).
        Idle Mode (Ctrl-F12) = MasterDT.
    ]]
    sets.idle.Pet.MasterDT = {
        -- Add your set here
    }

    -------------------------------------Enmity
    sets.pet = {} -- Not Used

    -- Equipped automatically
    -- String Theory: +Enmity
    -- Purpose: swap-in pieces for Strobe / Flashbulb to help maintain hate.
    sets.pet.Enmity = {
        head = Heyoka.Head,
        body = Heyoka.Body,
        hands = Heyoka.Hands,
        legs = Heyoka.Legs,
        feet = Heyoka.Feet,
        left_ear = "Rimeice Earring",
        right_ear = "Domes. Earring"
    }

    --[[
        Activated by Alt+D or
        F10 if Physical Defense Mode = PetDT
    ]]
    -- String Theory: Pet Tanking (Turtle / Introduction) depending on progression.
    -- Purpose: emergency pet DT set when you want to hard-lock survivability.
    -- BiS targets for this set: Ohrmazd or Gnafron's Adargas, Anwig Salade, Shepherd's Chain, Enmerkar Earring, Thur. Ring +1, a well-augmented Visucius PetMDT cape, and an appropriate Taeon/Rao setup.
    sets.pet.EmergencyDT = {
        -- Add your set here
    }

    -------------------------------------Engaged for Pet Only
    --[[
      For Technical Users - This is layout of below
      sets.idle[idleScope][state.IdleMode][ Pet[Engaged] ][CustomIdleGroups]

      For Non-Technical Users:
      If you the player is not fighting and your pet is fighting the first set that will activate is sets.idle.Pet.Engaged
      You can further adjust this by changing the HyrbidMode using Ctrl+F9 to activate the Acc/TP/DT/Regen/Ranged sets
    ]]
    --[[
        Player is Idle (not fighting).
        Pet is Engaged.
        Idle Mode (Ctrl-F12) = Idle.
        Hybrid Mode (Ctrl-F9) = Normal.
        This is the base set when player is idle and pet is fighting.
    ]]
    -- String Theory: Pet Tanking (Bruiser) / introductory pet tank set.
    -- Purpose: base engaged pet set with a good survival / damage balance.
    -- Optional String Theory BiS upgrades: Enmerkar Earring, C. Palug Ring, Thur. Ring +1.
    sets.idle.Pet.Engaged = {
        main = Weapons.Ohtas,
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = Heads.salad,
        body = Taeon.Body,
        hands = Taeon.Hands,
        legs = Taeon.Legs,
        feet = Taeon.Feet,
        neck = "Shulmanu Collar",
        waist = "Isa Belt",
        left_ear = "Rimeice Earring",
        right_ear = "Domes. Earring",
        left_ring = "Thurandaut Ring",
        right_ring = "Overbearing Ring",
        back = Visucius.PetMDT
    }

    --[[
        Player is Idle (not fighting).
        Pet is Engaged.
        Idle Mode (Ctrl-F12) = Idle.
        Hybrid Mode (Ctrl-F9) = Acc.
    ]]
    sets.idle.Pet.Engaged.Acc = {
        -- Add your set here
    }

    --[[
        Player is Idle (not fighting).
        Pet is Engaged.
        Idle Mode (Ctrl-F12) = Idle.
        Hybrid Mode (Ctrl-F9) = TP.
    ]]
    -- String Theory: Pet Only TP (Double Attack Melee)
    -- Purpose: pet melee / TP gain set focused on double attack.
    -- Optional String Theory BiS upgrades: Enmerkar Earring, C. Palug Ring, Thur. Ring +1, Incarnation Sash.
    sets.idle.Pet.Engaged.TP = {
        main = Weapons.Ohtas,
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = Taeon.Head,
        body = Relic_Pitre.Body_PTP,
        hands = Taeon.Hands,
        legs = Taeon.Legs,
        feet = Taeon.Feet,
        neck = "Shulmanu Collar",
        waist = "Klouskap Sash",
        left_ear = "Rimeice Earring",
        right_ear = "Domes. Earring",
        left_ring = "Varar Ring +1",
        right_ring = "Thurandaut Ring",
        back = Visucius.PetTP
    }

    --[[
        Player is Idle (not fighting).
        Pet is Engaged.
        Idle Mode (Ctrl-F12) = Idle.
        Hybrid Mode (Ctrl-F9) = DT.
    ]]
    -- String Theory: Pet Tanking (Turtle)
    -- Purpose: pet DT / heavy defensive buffer set.
    -- Optional String Theory BiS upgrades: Gnafron's Adargas, Shepherd's Chain, Enmerkar Earring, Thur. Ring +1.
    sets.idle.Pet.Engaged.DT = {
        main = Weapons.Ohrmazd,
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = Heads.salad,
        body = Rao.Body_Togi,
        hands = Rao.Hands_Kote,
        legs = Rao.Legs_Haidate,
        feet = Rao.Feet_Sune_Ate,
        neck = "Shulmanu Collar",
        waist = "Isa Belt",
        left_ear = "Rimeice Earring",
        right_ear = "Burana Earring",
        left_ring = "Thurandaut Ring",
        right_ring = "Overbearing Ring",
        back = Visucius.PetMDT
    }

    --[[
        Player is Idle (not fighting).
        Pet is Engaged.
        Idle Mode (Ctrl-F12) = Idle.
        Hybrid Mode (Ctrl-F9) = Regen.
    ]]
    -- String Theory: pet regen / sustain variant.
    -- Purpose: endurance on long fights when the pet stays deployed.
    sets.idle.Pet.Engaged.Regen = {
        -- Add your set here
    }

    --[[
        Player is Idle (not fighting).
        Pet is Engaged.
        Idle Mode (Ctrl-F12) = Idle.
        Hybrid Mode (Ctrl-F9) = Ranged.
    ]]
    -- String Theory: Pet Only TP (Store TP Ranger Automaton)
    -- Purpose: ranged / sharpshot pet set.
    -- Optional String Theory BiS upgrades: Enmerkar Earring, Klouskap Sash +1.
    sets.idle.Pet.Engaged.Ranged = set_combine(sets.idle.Pet.Engaged, {
        main = Weapons.Xiucoatl,
        -- range = Animators.Range,
        ammo = Animators.Oil,
        head = Herculean.HeadPet,
        body = Relic_Pitre.Body_PTP,
        hands = Herculean.HandsPet,
        legs = Taliah.Legs,
        feet = Taliah.Feet,
        neck = "Shulmanu Collar",
        waist = "Ukko Sash",
        left_ear = "Kyrene's Earring",
        right_ear = "Burana Earring",
        left_ring = "Varar Ring +1",
        right_ring = "Thurandaut Ring",
        back = Visucius.PetTP
    })

    -- String Theory: Sharpshot Overdrive
    -- Purpose: ranged overdrive / TP bonus set for Daze-Arcuballista.
    -- Optional String Theory BiS upgrades: Kara. Cappello +3, Karagoz Guanti +3, Thur. Ring +1, C. Palug Ring, Klouskap Sash +1.
    sets.idle.Pet.Engaged.OD = set_combine(sets.idle.Pet.Engaged.Ranged, {
        main = Weapons.Xiucoatl,
        body = Relic_Pitre.Body_PTP,
        back = Backs.Dispersal_Mantle
    })

    -- String Theory: Valoredge Overdrive
    -- Purpose: melee overdrive / double attack set.
    -- Optional String Theory BiS upgrades: Enmerkar Earring, Thur. Ring +1, C. Palug Ring, Klouskap Sash +1.
    sets.idle.Pet.Engaged.ODACC = set_combine(sets.idle.Pet.Engaged.TP, {
        main = Weapons.Xiucoatl,
        head = Taeon.Head,
        body = Taeon.Body,
        hands = Taeon.Hands,
        legs = Taeon.Legs,
        feet = Taeon.Feet,
        back = Visucius.PetTP
    })

    -------------------------------------WS
    --[[
        Default pet weaponskill set when state.SetFTP is false.
        Used when pet performs a weaponskill that does not benefit from TP overflow.
    ]]
    -- String Theory: generic Pet WS set / closest to Arcuballista-Daze or Bone Crusher depending on modifier.
    -- Purpose: base pet WS set outside of TP overflow use cases.
    -- Optional String Theory BiS upgrades: Thur. Ring +1, C. Palug Ring.
    sets.midcast.Pet.WSNoFTP = {
        main = Weapons.Xiucoatl,
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = Empy_Karagoz.Head_PTPBonus,
        body = Relic_Pitre.Body_PTP,
        hands = Herculean.HandsMaster,
        legs = Herculean.LegsPet,
        feet = Naga.Feet,
        neck = "Shulmanu Collar",
        waist = "Klouskap Sash",
        left_ear = "Burana Earring",
        right_ear = "Domes. Earring",
        left_ring = "Thurandaut Ring",
        right_ring = "Overbearing Ring",
        back = Visucius.PetTP
    }

    --[[
        Pet weaponskill set used when state.SetFTP is true.
        Used for pet weaponskills that can benefit from TP overflow (WSFTP).
    ]]
    -- String Theory: [[Arcuballista]] / [[Daze]] FTP set
    -- Purpose: pet WS set for weapon skills that scale well with TP Bonus.
    -- Optional String Theory BiS upgrades: Kara. Cappello +3, Karagoz Guanti +3, Kara. Pantaloni +3, Thur. Ring +1, Klouskap Sash +1.
    sets.midcast.Pet.WSFTP = {
        main = Weapons.Xiucoatl,
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = Empy_Karagoz.Head_PTPBonus,
        body = Relic_Pitre.Body_PTP,
        hands = Empy_Karagoz.Hands_PTPBonus,
        legs = Empy_Karagoz.Legs_PTPBonus,
        feet = Naga.Feet,
        neck = "Shulmanu Collar",
        waist = "Klouskap Sash",
        left_ear = "Burana Earring",
        right_ear = "Kyrene's Earring",
        left_ring = "Thurandaut Ring",
        right_ring = "Overbearing Ring",
        back = Backs.Dispersal_Mantle
    }

    -- Base set without modifier, uses WSNoFTP by default
    sets.midcast.Pet.WS = set_combine(sets.midcast.Pet.WSNoFTP, {
        -- Add your gear here that would be different from sets.midcast.Pet.WSNoFTP
        head = Relic_Pitre.Head_PRegen
    })

    -- Chimera Ripper, String Clipper
    sets.midcast.Pet.WS["STR"] = set_combine(sets.midcast.Pet.WSNoFTP, {
        -- Add your gear here that would be different from sets.midcast.Pet.WSNoFTP
    })

    -- Bone crusher, String Shredder
    -- String Theory: [[Bone Crusher]]
    -- Purpose: blunt pet WS / undead killer set.
    -- Optional String Theory BiS upgrades: Thur. Ring +1, C. Palug Ring, Incarnation Sash.
    sets.midcast.Pet.WS["VIT"] = set_combine(sets.midcast.Pet.WSNoFTP, {
        -- Add your gear here that would be different from sets.midcast.Pet.WSNoFTP
        head = Empy_Karagoz.Head_PTPBonus
    })

    -- Cannibal Blade
    sets.midcast.Pet.WS["MND"] = set_combine(sets.midcast.Pet.WSNoFTP, {})

    -- Armor Piercer, Armor Shatterer
    sets.midcast.Pet.WS["DEX"] = set_combine(sets.midcast.Pet.WSNoFTP, {})

    ---------------------------------------------
    --  __  __ _             _____      _
    -- |  \/  (_)           / ____|    | |
    -- | \  / |_ ___  ___  | (___   ___| |_ ___
    -- | |\/| | / __|/ __|  \___ \ / _ \ __/ __|
    -- | |  | | \__ \ (__   ____) |  __/ |_\__ \
    -- |_|  |_|_|___/\___| |_____/ \___|\__|___/
    ---------------------------------------------
    -- Town Set
    sets.idle.Town = {
        main = Weapons.Kenkonken,
        range = Animators.Melee,
        ammo = Animators.Oil,
        head = Hizamaru.Head,
        body = Hizamaru.Body,
        hands = Hizamaru.Hands,
        legs = Hizamaru.Legs,
        feet = Hizamaru.Feet,
        neck = "Adad Amulet",
        waist = "Moonbow Belt +1",
        left_ear = "Eabani Earring",
        right_ear = "Domes. Earring",
        left_ring = Hizamaru.Ring,
        right_ring = "Yacuruna Ring",
        Visucius.MasterMEva
    }

    -- Optional city-group override sample.
    -- This will automatically be used in Eastern/Western Adoulin instead of sets.idle.Town.
    -- You can also define exact-zone overrides with:
    -- sets.idle.Town["Eastern Adoulin"] = set_combine(sets.idle.Town.Adoulin, {...})
    sets.idle.Town.Adoulin = set_combine(sets.idle.Town, {
        -- Add Adoulin-specific swaps here.
    })

    -- Optional city-group override sample for all Jeuno zones:
    -- Ru'Lude Gardens, Upper Jeuno, Lower Jeuno, and Port Jeuno.
    -- sets.idle.Town.Jeuno = set_combine(sets.idle.Town, {
    --     -- Add Jeuno-specific swaps here.
    -- })

    -- Optional exact-zone override sample.
    -- Exact zone names take priority over grouped city overrides.
    -- sets.idle.Town["Aht Urhgan Whitegate"] = set_combine(sets.idle.Town, {
    --     -- Add Whitegate-specific swaps here.
    -- })

    -- Resting sets
    sets.resting = {
        -- Add your set here
    }

    sets.defense.MasterDT = sets.idle.MasterDT

    sets.defense.PetDT = sets.pet.EmergencyDT

    sets.defense.PetMDT = set_combine(sets.pet.EmergencyDT, {})
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == "WAR" then
        set_macro_page(3, 1)
    elseif player.sub_job == "NIN" then
        set_macro_page(3, 1)
    elseif player.sub_job == "DNC" then
        set_macro_page(3, 1)
    else
        set_macro_page(3, 1)
    end
end
