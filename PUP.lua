----------------------------------------------------------------------------------------
--  __  __           _                     __   _____                        _
-- |  \/  |         | |                   / _| |  __ \                      | |
-- | \  / | __ _ ___| |_ ___ _ __    ___ | |_  | |__) |   _ _ __  _ __   ___| |_ ___
-- | |\/| |/ _` / __| __/ _ \ '__|  / _ \|  _| |  ___/ | | | '_ \| '_ \ / _ \ __/ __|
-- | |  | | (_| \__ \ ||  __/ |    | (_) | |   | |   | |_| | |_) | |_) |  __/ |_\__ \
-- |_|  |_|\__,_|___/\__\___|_|     \___/|_|   |_|    \__,_| .__/| .__/ \___|\__|___/
--                                                         | |   | |
--                                                         |_|   |_|
-----------------------------------------------------------------------------------------
--[[

    Originally Created By: Faloun
    Programmers: Arrchie, Kuroganashi, Byrne, Tuna
    Testers:Arrchie, Kuroganashi, Haxetc, Patb, Whirlin, Petsmart
    Contributors: Xilkk, Byrne, Blackhalo714

    ASCII Art Generator: http://www.network-science.de/ascii/

]] -- Initialization function for this job file.
-- IMPORTANT: Make sure to also get the Mote-Include.lua file (and its supplementary files) to go with this.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include("Mote-Include.lua")
end

-- This function is called by GearSwap when the job file is unloaded.
function file_unload()
    send_command("unbind !f7")
    send_command("unbind ^f7")
    send_command("unbind !f8")
    send_command("unbind ^f8")
    send_command("unbind !e")
    send_command("unbind !d")
    send_command("unbind !f6")
    send_command("unbind ^`")
    send_command("unbind home")
    send_command("unbind PAGEUP")
    send_command("unbind PAGEDOWN")
    send_command("unbind end")
    send_command("unbind =")
end

-- This function is called by GearSwap after the job file is loaded.
-- It's used to set up job-specific variables, load user configurations, and include library files.
function job_setup()
    -- Load user-specific settings or fall back to the template.
    -- PUP_user.lua should be a copy of PUP_user_template.lua, modified by the user.
    local user_config_loaded, user_config_err
    local template_config_loaded, template_config_err

    user_config_loaded, user_config_err = pcall(dofile, "PUP_user.lua")

    if user_config_loaded then
        print("PUP User Settings: PUP_user.lua loaded successfully.")
    else
        -- Check if the error is because the file doesn't exist or due to a syntax error.
        if type(user_config_err) == 'string' and string.match(user_config_err, "cannot open .*PUP_user.lua") then
            print("PUP User Settings: PUP_user.lua not found. Loading PUP_user_template.lua.")
            template_config_loaded, template_config_err = pcall(dofile, "PUP_user_template.lua")
            if not template_config_loaded then
                print("PUP CRITICAL ERROR: PUP_user_template.lua failed to load. Error: " ..
                          tostring(template_config_err))
                print("PUP CRITICAL ERROR: Script may not function correctly.")
            else
                print("PUP User Settings: PUP_user_template.lua loaded successfully.")
            end
        else
            -- PUP_user.lua exists but has errors.
            print("PUP User Settings: Error loading PUP_user.lua. Error: " .. tostring(user_config_err))
            print("PUP User Settings: Attempting to load PUP_user_template.lua as a fallback.")
            template_config_loaded, template_config_err = pcall(dofile, "PUP_user_template.lua")
            if not template_config_loaded then
                print("PUP CRITICAL ERROR: Fallback PUP_user_template.lua also failed to load. Error: " ..
                          tostring(template_config_err))
                print("PUP CRITICAL ERROR: Script may not function correctly.")
            else
                print("PUP User Settings: Fallback PUP_user_template.lua loaded successfully.")
            end
        end
    end

    -- Include the main library file for PUP. This contains core logic.
    include("PUP-LIB/pup-main.lua")

    -- Select the default macro book based on subjob.
    -- This function is now called here after user/template settings (which might define player object) are loaded.
    select_default_macro_book()

    -- Setup the text window (HUB).
    -- pos_x and pos_y should be defined in the loaded user/template file.
    -- setupTextWindow is defined in PUP-LIB/pup-gui.lua, which is included via pup-main.lua.
    if type(pos_x) == 'number' and type(pos_y) == 'number' and setupTextWindow then
        setupTextWindow(pos_x, pos_y)
    else
        print("PUP WARNING: pos_x, pos_y, or setupTextWindow not defined. HUB may not display correctly.")
        if not setupTextWindow then
            print("PUP DEBUG: setupTextWindow is nil")
        end
        if type(pos_x) ~= 'number' then
            print("PUP DEBUG: pos_x is " .. type(pos_x))
        end
        if type(pos_y) ~= 'number' then
            print("PUP DEBUG: pos_y is " .. type(pos_y))
        end
    end
end

-- Select default macro book on initial load or subjob change.
-- This function is now standalone and called from job_setup after settings are loaded.
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

--[[
    The user_setup() function has been moved to PUP_user_template.lua (and by extension PUP_user.lua).
    It defined state variables, keybinds, and initial HUB position.
]]

--[[
    The init_gear_sets() function has been moved to PUP_user_template.lua (and by extension PUP_user.lua).
    It defined all gear sets.
]]
