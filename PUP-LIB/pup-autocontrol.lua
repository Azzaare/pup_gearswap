local AUTOCONTROL_IPC_PREFIX = 'pup_ac:'

local autocontrol_profile_map = {
    st_turtle_tank = {
        pet_mode = const_tank,
        pet_style = 'NORMAL'
    },
    st_bruiser_tank = {
        pet_mode = const_tank,
        pet_style = 'NORMAL'
    },
    st_harle_tank = {
        pet_mode = const_tank,
        pet_style = 'MAGIC'
    },
    st_sharpshot_tank = {
        pet_mode = const_tank,
        pet_style = const_dd
    },
    st_sharpshot_tank_magic_defense = {
        pet_mode = const_tank,
        pet_style = const_dd
    },
    st_standard_dd = {
        pet_mode = const_dd,
        pet_style = 'NORMAL'
    },
    st_ranger_dd = {
        pet_mode = const_dd,
        pet_style = 'NORMAL'
    },
    st_bone_slayer = {
        pet_mode = const_dd,
        pet_style = 'BONE'
    },
    st_white_mage = {
        pet_mode = const_mage,
        pet_style = 'HEAL'
    },
    st_red_mage = {
        pet_mode = const_mage,
        pet_style = 'SUPPORT'
    },
    st_black_mage = {
        pet_mode = const_mage,
        pet_style = const_dd
    },
    st_overdrive_base = {
        pet_mode = const_dd,
        pet_style = 'OD'
    },
    st_overdrive = {
        pet_mode = const_dd,
        pet_style = 'OD'
    },
    st_overdrive_damage = {
        pet_mode = const_dd,
        pet_style = 'OD'
    },
    st_overdrive_accuracy = {
        pet_mode = const_dd,
        pet_style = 'ODACC'
    },
    st_overdrive_physical_defense = {
        pet_mode = const_dd,
        pet_style = 'OD'
    },
    st_overdrive_magic_defense = {
        pet_mode = const_dd,
        pet_style = 'OD'
    }
}

local function set_state_silently(state_name, value)
    if not value then
        return
    end

    local state_var = get_state(state_name)
    if not state_var or state_var.value == value then
        return
    end

    local old_value = state_var.value
    state_var:set(value)

    local description = state_var.description or state_name
    if job_state_change then
        job_state_change(description, state_var.value, old_value)
    end
end

function apply_autocontrol_profile(profile_name, silent)
    local profile = autocontrol_profile_map[profile_name]

    if not profile then
        if not silent then
            add_to_chat(123, 'PUP-LIB: Unknown AutoControl profile [' .. tostring(profile_name) .. '].')
        end
        return false
    end

    set_state_silently(const_PetModeCycle, profile.pet_mode)
    set_state_silently(const_PetStyleCycle, profile.pet_style)

    if updateTextInformation then
        updateTextInformation()
    end

    if handle_equipping_gear then
        handle_equipping_gear(player.status, Pet_State)
    end

    if not silent then
        add_to_chat(122, 'PUP-LIB: Applied AutoControl profile [' .. profile_name .. '].')
    end

    return true
end

windower.register_event('ipc message', function(message)
    if type(message) ~= 'string' or message:sub(1, #AUTOCONTROL_IPC_PREFIX) ~= AUTOCONTROL_IPC_PREFIX then
        return
    end

    local profile_name = message:sub(#AUTOCONTROL_IPC_PREFIX + 1)
    if profile_name ~= '' then
        apply_autocontrol_profile(profile_name, true)
    end
end)
