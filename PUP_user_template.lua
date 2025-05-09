-- PUP User Template
-- This file contains all user-configurable settings for the PUP GearSwap script.
-- To customize, copy this file to "PUP_user.lua" and make your changes there.
-- PUP_user.lua will be loaded if it exists; otherwise, this template will be used.
---------------------------------------------------------------------------------------------------
-- User Configurable Global Variables
-- These were previously in job_setup() or defined globally in PUP.lua.
---------------------------------------------------------------------------------------------------
PET_MIN_TP_TO_WEAPONSKILL = 850 -- Minimum pet TP to equip pet weaponskill gear.
PET_GEAR_WEAPONSKILL_LOCKOUT_TIMER = 5 -- Seconds to keep pet weaponskill gear equipped.
pos_x = 0 -- Default X (horizontal) position for the HUB.
pos_y = 500 -- Default Y (vertical) position for the HUB.
customGearLock = T {} -- Define slots to lock with CustomGearLock, e.g., T{"head", "waist"}.
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- State and Toggle Definitions
-- These were previously in the user_setup() function.
---------------------------------------------------------------------------------------------------
-- Alt-F10 - Toggles Kiting Mode (handled by Mote-Include).

-- F9 - Cycle Offense Mode
state.OffenseMode:options("MasterPet", "Master", "Trusts")

-- Ctrl-F9 - Cycle Hybrid Mode
state.HybridMode:options("Normal", "Acc", "TP", "DT", "Regen", "Ranged")

-- Ctrl-F10 - Cycle Physical Defense Mode type. F10 - Activate.
state.PhysicalDefenseMode:options("PetDT", "MasterDT")

-- F11 - Activate Magical Defense Mode.
state.MagicalDefenseMode:options("PetMDT")

-- Ctrl-F12 - Cycle Idle Mode.
state.IdleMode:options("Idle", "MasterDT")

-- Pet Mode and Style Cycles
state.PetStyleCycleTank = M {"NORMAL", "DD", "MAGIC", "SPAM"}
state.PetStyleCycleMage = M {"NORMAL", "HEAL", "SUPPORT", "MB", "DD"}
state.PetStyleCycleDD = M {"NORMAL", "BONE", "SPAM", "OD", "ODACC"}
state.PetModeCycle = M {"TANK", "DD", "MAGE"}
state.PetStyleCycle = state.PetStyleCycleTank -- Default Pet Style Cycle

-- Toggles
state.AutoMan = M(false, "Auto Maneuver") -- Alt + E
state.AutoDeploy = M(false, "Auto Deploy") -- //gs c toggle autodeploy or PAGEUP
state.LockPetDT = M(false, "Lock Pet DT") -- Alt + D
state.LockWeapon = M(false, "Lock Weapon") -- Alt + ` (tilde)
state.SetFTP = M(false, "Set FTP") -- //gs c toggle setftp or HOME
state.textHideHUB = M(false, "Hide HUB") -- //gs c hub all
state.textHideMode = M(false, "Hide Mode") -- //gs c hub mode
state.textHideState = M(false, "Hide State") -- //gs c hub state
state.textHideOptions = M(false, "Hide Options") -- //gs c hub options
state.useLightMode = M(false, "Toggles Lite mode") -- //gs c hub lite
state.Keybinds = M(false, "Hide Keybinds") -- //gs c hub keybinds or PAGEDOWN
state.CP = M(false, "CP") -- //gs c toggle CP or END
state.CustomGearLock = M(false, "Custom Gear Lock") -- //gs c toggle customgearlock
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Keybind Definitions
-- These were previously in the user_setup() function.
---------------------------------------------------------------------------------------------------
send_command("bind !f7 gs c cycle PetModeCycle")
send_command("bind ^f7 gs c cycleback PetModeCycle")
send_command("bind !f8 gs c cycle PetStyleCycle")
send_command("bind ^f8 gs c cycleback PetStyleCycle")
send_command("bind !e gs c toggle AutoMan")
send_command("bind !d gs c toggle LockPetDT")
send_command("bind !f6 gs c predict")
send_command("bind ^` gs c toggle LockWeapon") -- Note: ^` is Ctrl+`
send_command("bind home gs c toggle setftp")
send_command("bind PAGEUP gs c toggle autodeploy")
send_command("bind PAGEDOWN gs c toggle keybinds")
send_command("bind end gs c toggle CP")
send_command("bind = gs c clear")
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Gear Set Definitions
-- These were previously in the init_gear_sets() function.
-- Ensure 'sets' table is initialized (Mote-Include usually does this: sets = sets or {}).
---------------------------------------------------------------------------------------------------
sets = sets or {}

-- Gear Variables
-------------------------------------------------------------------------
Animators = {}
Animators.Range = "Animator P II"
Animators.Melee = "Animator P +1"

Artifact_Foire = {}
Artifact_Foire.Head_PRegen = "Foire Taj +1"
Artifact_Foire.Body_WSD_PTank = "Foire Tobe +1"
Artifact_Foire.Hands_Mane_Overload = "Foire Dastanas +1"
Artifact_Foire.Legs_PCure = "Foire Churidars +1"
Artifact_Foire.Feet_Repair_PMagic = "Foire Babouches +1"

Relic_Pitre = {}
Relic_Pitre.Head_PRegen = "Pitre Taj +2"
Relic_Pitre.Body_PTP = "Pitre Tobe +2"
Relic_Pitre.Hands_WSD = "Pitre Dastanas +2"
Relic_Pitre.Legs_PMagic = "Pitre Churidars +2"
Relic_Pitre.Feet_PMagic = "Pitre Babouches +1"

Empy_Karagoz = {}
Empy_Karagoz.Head_PTPBonus = "Karagoz Capello"
Empy_Karagoz.Body_Overload = "Karagoz Farsetto"
Empy_Karagoz.Hands = "Karagoz Guanti"
Empy_Karagoz.Legs_Combat = "Karagoz Pantaloni +1"
Empy_Karagoz.Feet_Tatical = "Karagoz Scarpe +1"

Visucius = {}
Visucius.PetDT = {
    name = "Visucius's Mantle",
    augments = {"Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20", "Accuracy+20 Attack+20",
                "Pet: Accuracy+4 Pet: Rng. Acc.+4", 'Pet: "Regen"+10', "Pet: Damage taken -5%"}
}
Visucius.PetMagic = {
    name = "Visucius's Mantle",
    augments = {"Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20", "Accuracy+20 Attack+20",
                "Pet: Accuracy+4 Pet: Rng. Acc.+4", 'Pet: "Regen"+10', "Pet: Damage taken -5%"}
}

CP_CAPE = "Aptitude Mantle +1" -- Name of your CP cape.
-------------------------------------------------------------------------

-- Master Only Sets
---------------------------------------------------------------------------------
sets.idle = {} -- Base idle set, used when pet is not active.

sets.precast.FC = {
    -- Add your Fast Cast set here
}

sets.midcast = {} -- Can be left empty

sets.midcast.FastRecast = {
    -- Add your Fast Recast set here
}

sets.Kiting = {
    feet = "Hermes' Sandals"
}

sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
    neck = "Magoraga Beads",
    body = "Passion Jacket"
})

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
sets.precast.JA["Repair"] = {
    ammo = "Automat. Oil +3",
    feet = Artifact_Foire.Feet_Repair_PMagic
}
sets.precast.JA["Maintenance"] = set_combine(sets.precast.JA["Repair"], {})
sets.precast.JA.Maneuver = {
    neck = "Buffoon's Collar +1",
    body = "Karagoz Farsetto",
    hands = Artifact_Foire.Hands_Mane_Overload,
    back = "Visucius's Mantle", -- Assuming a generic pet-enhancing mantle or specific maneuver one
    ear1 = "Burana Earring"
}
sets.precast.JA["Activate"] = {
    back = "Visucius's Mantle" -- Generic pet-enhancing mantle
}
sets.precast.JA["Deus Ex Automata"] = sets.precast.JA["Activate"]
sets.precast.JA["Provoke"] = {}

sets.precast.Waltz = {
    -- Add your Waltz set here (CHR and VIT)
}
sets.precast.Waltz["Healing Waltz"] = {}

-- Weaponskill sets
sets.precast.WS = {
    -- Add your default WS set here
}
sets.precast.WS["Stringing Pummel"] = set_combine(sets.precast.WS, {})
sets.precast.WS["Stringing Pummel"].Mod = set_combine(sets.precast.WS, {}) -- Example for mod-specific set
sets.precast.WS["Victory Smite"] = set_combine(sets.precast.WS, {})
sets.precast.WS["Shijin Spiral"] = set_combine(sets.precast.WS, {
    -- Add your Shijin Spiral specific gear here
})
sets.precast.WS["Howling Fist"] = set_combine(sets.precast.WS, {})

-- Idle Sets (Master Only)
sets.idle.MasterDT = {
    -- Add your Master DT idle set here
}

-- Engaged Sets (Master Only)
sets.engaged.Master = {
    -- Add your Master engaged set (Normal Hybrid) here
}
sets.engaged.Master.Acc = {
    -- Add your Master engaged set (Acc Hybrid) here
}
sets.engaged.Master.TP = {
    -- Add your Master engaged set (TP Hybrid) here
}
sets.engaged.Master.DT = {
    -- Add your Master engaged set (DT Hybrid) here
}
---------------------------------------------------------------------------------

-- Hybrid Master/Pet Sets
-----------------------------------------------------------------------------------
sets.engaged.MasterPet = {
    -- Add your MasterPet engaged set (Normal Hybrid) here
}
sets.engaged.MasterPet.Acc = {
    -- Add your MasterPet engaged set (Acc Hybrid) here
}
sets.engaged.MasterPet.TP = {
    -- Add your MasterPet engaged set (TP Hybrid) here
}
sets.engaged.MasterPet.DT = {
    -- Add your MasterPet engaged set (DT Hybrid) here
}
sets.engaged.MasterPet.Regen = {
    -- Add your MasterPet engaged set (Regen Hybrid) here
}
-----------------------------------------------------------------------------------

-- Pet Only Sets
-----------------------------------------------------------------------------------
sets.midcast.Pet = {
    -- Add your generic Pet midcast set here
}
sets.midcast.Pet.Cure = {
    -- Add your Pet Cure set here
}
sets.midcast.Pet["Healing Magic"] = {
    -- Add your Pet Healing Magic set here
}
sets.midcast.Pet["Elemental Magic"] = {
    -- Add your Pet Elemental Magic set here
}
sets.midcast.Pet["Enfeebling Magic"] = {
    -- Add your Pet Enfeebling Magic set here
}
sets.midcast.Pet["Dark Magic"] = {
    -- Add your Pet Dark Magic set here
}
sets.midcast.Pet["Divine Magic"] = {
    -- Add your Pet Divine Magic set here
}
sets.midcast.Pet["Enhancing Magic"] = {
    -- Add your Pet Enhancing Magic set here
}

-- Idle Sets (Pet Active)
sets.idle.Pet = { -- Player Idle, Pet Idle
    head = "Heyoka Cap" -- Example
}
sets.idle.Pet.MasterDT = { -- Player Idle (MasterDT mode), Pet Idle
    -- Add your Master DT set for when pet is idle here
}

-- Pet Enmity and Emergency DT
sets.pet = {} -- Not directly used, but good for structure
sets.pet.Enmity = {
    -- Add your Pet Enmity set here
}
sets.pet.EmergencyDT = {
    -- Add your Pet Emergency DT set here
}

-- Idle Sets (Player Idle, Pet Engaged)
sets.idle.Pet.Engaged = { -- HybridMode = Normal
    head = "Taeon Chapeau" -- Example
}
sets.idle.Pet.Engaged.Acc = {
    -- Add your Pet Engaged (Acc Hybrid) set here
}
sets.idle.Pet.Engaged.TP = {
    -- Add your Pet Engaged (TP Hybrid) set here
}
sets.idle.Pet.Engaged.DT = {
    -- Add your Pet Engaged (DT Hybrid) set here
}
sets.idle.Pet.Engaged.Regen = {
    -- Add your Pet Engaged (Regen Hybrid) set here
}
sets.idle.Pet.Engaged.Ranged = set_combine(sets.idle.Pet.Engaged, {
    legs = Empy_Karagoz.Legs_Combat
})

-- Pet WeaponSkill Sets
sets.midcast.Pet.WSNoFTP = { -- Default for non-FTP WS
    head = "Pitre Taj +2"
    -- Add your non-FTP Pet WS gear here
}
sets.midcast.Pet.WSFTP = { -- Default for FTP WS
    head = Empy_Karagoz.Head_PTPBonus
    -- Add your FTP Pet WS gear here
}
sets.midcast.Pet.WS = set_combine(sets.midcast.Pet.WSNoFTP, { -- Base, can be overridden by specific mods
    head = "Pitre Taj +2"
})
sets.midcast.Pet.WS["STR"] = set_combine(sets.midcast.Pet.WSNoFTP, {
    -- Add STR mod Pet WS gear here
})
sets.midcast.Pet.WS["VIT"] = set_combine(sets.midcast.Pet.WSNoFTP, {
    head = Empy_Karagoz.Head_PTPBonus -- Example override for VIT mod
    -- Add VIT mod Pet WS gear here
})
sets.midcast.Pet.WS["MND"] = set_combine(sets.midcast.Pet.WSNoFTP, {
    -- Add MND mod Pet WS gear here
})
sets.midcast.Pet.WS["DEX"] = set_combine(sets.midcast.Pet.WSNoFTP, {
    -- Add DEX mod Pet WS gear here
})
-----------------------------------------------------------------------------------

-- Miscellaneous Sets
-----------------------------------------------------------------------------------
sets.idle.Town = {
    -- Add your Town gear set here
}

sets.resting = {
    -- Add your Resting set here
}

-- Defense sets for Mote-Include emergency modes
sets.defense.MasterDT = sets.idle.MasterDT -- Or your preferred Master DT set
sets.defense.PetDT = sets.pet.EmergencyDT
sets.defense.PetMDT = set_combine(sets.pet.EmergencyDT, {
    -- Add specific Pet MDT pieces if different from PetDT
})
-----------------------------------------------------------------------------------

-- Make sure the last line is not a comment if issues arise with dofile.
-- print("PUP User Template: Definitions loaded.")
