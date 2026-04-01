-- PUP Keybinds: binding + HUB label management
-- Logic lives here; configuration lives in PUP-USER/user.lua (PUP_KEYBINDS table)

local AZERTY_2 = "\194\178" -- UTF-8 for "²" (kept ASCII in file via escapes)

local function detect_keyboard_layout()
    local env_layout = os.getenv("KEYBOARD_LAYOUT")
    if env_layout and env_layout:lower() == "azerty" then
        return "azerty"
    end
    return "qwerty"
end

local function normalize_layout(layout)
    if not layout or layout == "" or layout:lower() == "auto" then
        return detect_keyboard_layout()
    end
    layout = layout:lower()
    if layout == "azerty" or layout == "qwerty" then
        return layout
    end
    return "qwerty"
end

local function strip_parens(label)
    if not label or label == "" then
        return ""
    end
    if label:sub(1, 1) == "(" and label:sub(-1) == ")" then
        return label:sub(2, -2)
    end
    return label
end

local function normalize_label(label)
    if not label or label == "" then
        return ""
    end
    if label:sub(1, 1) == "(" then
        return label
    end
    return "(" .. label .. ")"
end

local function key_to_label(key)
    if not key or key == "" then
        return ""
    end

    local mods = {}
    local rest = key
    local consumed = true
    while consumed and #rest > 0 do
        consumed = false
        local first = rest:sub(1, 1)
        if first == "!" then
            table.insert(mods, "ALT")
            rest = rest:sub(2)
            consumed = true
        elseif first == "^" then
            table.insert(mods, "CTRL")
            rest = rest:sub(2)
            consumed = true
        elseif first == "@" then
            table.insert(mods, "WIN")
            rest = rest:sub(2)
            consumed = true
        end
    end

    local key_label = rest:upper()
    if #mods > 0 then
        return normalize_label(table.concat(mods, "+") .. "+" .. key_label)
    end
    return normalize_label(key_label)
end

local function combine_labels(primary, secondary)
    primary = strip_parens(primary or "")
    secondary = strip_parens(secondary or "")
    if primary == "" then
        return normalize_label(secondary)
    end
    if secondary == "" then
        return normalize_label(primary)
    end
    return normalize_label(primary .. "/" .. secondary)
end

local default_actions = {
    pet_mode = {
        key = "!f7",
        command = "gs c cycle PetModeCycle",
        label = nil
    },
    pet_mode_back = {
        key = "^f7",
        command = "gs c cycleback PetModeCycle",
        label = nil
    },
    pet_style = {
        key = "!f8",
        command = "gs c cycle PetStyleCycle",
        label = nil
    },
    pet_style_back = {
        key = "^f8",
        command = "gs c cycleback PetStyleCycle",
        label = nil
    },
    auto_maneuver = {
        key = "!e",
        command = "gs c toggle AutoMan",
        label = nil
    },
    lock_pet_dt = {
        key = "!d",
        command = "gs c toggle LockPetDT",
        label = nil
    },
    predict = {
        key = "!f6",
        command = "gs c predict",
        label = nil
    },
    lock_weapon = {
        key_by_layout = {
            qwerty = "^`",
            azerty = "^" .. AZERTY_2
        },
        label_by_layout = {
            qwerty = "CTRL+`",
            azerty = "CTRL+" .. AZERTY_2
        },
        command = "gs c toggle LockWeapon",
        label = nil
    },
    set_ftp = {
        key = "home",
        command = "gs c toggle setftp",
        label = nil
    },
    custom_gear_lock = {
        key = nil,
        command = "gs c toggle customgearlock",
        label = nil
    },
    auto_deploy = {
        key = "pageup",
        command = "gs c toggle autodeploy",
        label = nil
    },
    hub_keybinds = {
        key = "pagedown",
        command = "gs c hide keybinds",
        label = nil
    },
    cp = {
        key = "end",
        command = "gs c toggle CP",
        label = nil
    },
    clear = {
        key = "=",
        command = "gs c clear",
        label = nil
    }
}

local default_hub_labels = {
    idle = "(CTRL+F12)",
    offense = "(F9)",
    physical = "(CTRL+F10)",
    magical = "(F11)",
    hybrid = "(CTRL+F9)",
    custom_gear_lock = ""
}

local function resolve_action(default_action, override, layout)
    local action = {}
    for k, v in pairs(default_action) do
        action[k] = v
    end
    if override then
        for k, v in pairs(override) do
            action[k] = v
        end
    end

    if action.key_by_layout and not action.key then
        action.key = action.key_by_layout[layout] or action.key_by_layout.qwerty
    end
    if action.label_by_layout and not action.label then
        action.label = action.label_by_layout[layout] or action.label_by_layout.qwerty
    end

    if action.key == false or action.key == "" then
        action.key = nil
    end
    if action.label == false then
        action.label = nil
    end

    if not action.label and action.key then
        action.label = key_to_label(action.key)
    elseif action.label then
        action.label = normalize_label(action.label)
    end

    return action
end

local function build_actions(config, layout)
    local actions = {}
    local overrides = (config and config.binds) or {}

    for name, default_action in pairs(default_actions) do
        actions[name] = resolve_action(default_action, overrides[name], layout)
    end

    -- Allow label-only overrides for Mote binds or other HUB-only labels
    local label_overrides = (config and config.labels) or {}
    for label_key, label_value in pairs(label_overrides) do
        actions[label_key] = actions[label_key] or {}
        actions[label_key].label = normalize_label(label_value)
    end

    return actions
end

local function update_hub_keybinds(actions)
    local labels = {}

    labels.pet_mode = combine_labels(actions.pet_mode and actions.pet_mode.label, actions.pet_mode_back and actions.pet_mode_back.label)
    labels.pet_style = combine_labels(actions.pet_style and actions.pet_style.label, actions.pet_style_back and actions.pet_style_back.label)

    labels.idle = (actions.idle and actions.idle.label) or default_hub_labels.idle
    labels.offense = (actions.offense and actions.offense.label) or default_hub_labels.offense
    labels.physical = (actions.physical and actions.physical.label) or default_hub_labels.physical
    labels.magical = (actions.magical and actions.magical.label) or default_hub_labels.magical
    labels.hybrid = (actions.hybrid and actions.hybrid.label) or default_hub_labels.hybrid

    labels.auto_maneuver = actions.auto_maneuver and actions.auto_maneuver.label or ""
    labels.lock_pet_dt = actions.lock_pet_dt and actions.lock_pet_dt.label or ""
    labels.lock_weapon = actions.lock_weapon and actions.lock_weapon.label or ""
    labels.set_ftp = actions.set_ftp and actions.set_ftp.label or ""
    labels.custom_gear_lock = (actions.custom_gear_lock and actions.custom_gear_lock.label) or default_hub_labels.custom_gear_lock
    labels.auto_deploy = actions.auto_deploy and actions.auto_deploy.label or ""
    labels.predict = actions.predict and actions.predict.label or ""
    labels.clear = actions.clear and actions.clear.label or ""
    labels.hub_keybinds = actions.hub_keybinds and actions.hub_keybinds.label or ""
    labels.cp = actions.cp and actions.cp.label or ""

    keybinds_on['key_bind_pet_mode'] = labels.pet_mode or ""
    keybinds_on['key_bind_pet_style'] = labels.pet_style or ""
    keybinds_on['key_bind_idle'] = labels.idle or ""
    keybinds_on['key_bind_offense'] = labels.offense or ""
    keybinds_on['key_bind_physical'] = labels.physical or ""
    keybinds_on['key_bind_magical'] = labels.magical or ""
    keybinds_on['key_bind_hybrid'] = labels.hybrid or ""
    keybinds_on['key_bind_auto_maneuver'] = labels.auto_maneuver or ""
    keybinds_on['key_bind_pet_dt'] = labels.lock_pet_dt or ""
    keybinds_on['key_bind_lock_weapon'] = labels.lock_weapon or ""
    keybinds_on['key_bind_set_ftp'] = labels.set_ftp or ""
    keybinds_on['key_bind_custom_gear_lock'] = labels.custom_gear_lock or ""
    keybinds_on['key_bind_auto_deploy'] = labels.auto_deploy or ""
    keybinds_on['key_bind_predict'] = labels.predict or ""
    keybinds_on['key_bind_clear'] = labels.clear or ""
    keybinds_on['key_bind_hub_keybinds'] = labels.hub_keybinds or ""
    keybinds_on['key_bind_cp'] = labels.cp or ""

    keybinds_off['key_bind_pet_mode'] = ''
    keybinds_off['key_bind_pet_style'] = ''
    keybinds_off['key_bind_idle'] = ''
    keybinds_off['key_bind_offense'] = ''
    keybinds_off['key_bind_physical'] = ''
    keybinds_off['key_bind_magical'] = ''
    keybinds_off['key_bind_hybrid'] = ''
    keybinds_off['key_bind_auto_maneuver'] = ''
    keybinds_off['key_bind_pet_dt'] = ''
    keybinds_off['key_bind_lock_weapon'] = ''
    keybinds_off['key_bind_set_ftp'] = ''
    keybinds_off['key_bind_custom_gear_lock'] = ''
    keybinds_off['key_bind_auto_deploy'] = ''
    keybinds_off['key_bind_predict'] = ''
    keybinds_off['key_bind_clear'] = ''
    keybinds_off['key_bind_hub_keybinds'] = ''
    keybinds_off['key_bind_cp'] = ''
end

local function bind_actions(actions, enable_binds)
    if not enable_binds then
        return
    end

    pup_keybinds_state = pup_keybinds_state or {}
    pup_keybinds_state.bound_keys = pup_keybinds_state.bound_keys or {}

    -- Unbind any previously bound keys from this system
    for key, _ in pairs(pup_keybinds_state.bound_keys) do
        send_command("unbind " .. key)
    end
    pup_keybinds_state.bound_keys = {}

    for _, action in pairs(actions) do
        if action and action.key and action.command and action.enabled ~= false then
            send_command("bind " .. action.key .. " " .. action.command)
            pup_keybinds_state.bound_keys[action.key] = true
        end
    end
end

function pup_apply_keybinds(user_config)
    local config = user_config or {}
    local layout = normalize_layout(config.layout or config.keyboard_layout)
    local actions = build_actions(config, layout)
    update_hub_keybinds(actions)
    bind_actions(actions, config.enable_binds ~= false)
end

function pup_unbind_keys()
    if not pup_keybinds_state or not pup_keybinds_state.bound_keys then
        return
    end
    for key, _ in pairs(pup_keybinds_state.bound_keys) do
        send_command("unbind " .. key)
    end
    pup_keybinds_state.bound_keys = {}
end
