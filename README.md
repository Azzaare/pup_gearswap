# Puppetmaster GearSwap For Windower

This README is for the PUP-specific GearSwap package located under:
- `GearSwap/data/PUP-LIB`
- `GearSwap/data/PUP-USER`

## User File Model
The intended workflow is:
- keep library logic in `PUP-LIB`
- keep your personal configuration and sets in `PUP-USER/user.lua`

You should only need to customize:
- `GearSwap/data/PUP-USER/user.lua`

This structure is meant to make updates easier, because the user file can be kept while the shared library files evolve.

## Main Features
This PUP GearSwap provides:
- player gear sets
- pet gear sets
- pet WS gear timing support
- pet mode and style prediction
- maneuver maintenance support
- hub / GUI support
- configurable keybind display and bindings
- optional coordination with AutoControl

## PUP-Specific States
This setup uses custom Puppetmaster-oriented state handling.

### Pet Modes
- `TANK`
- `DD`
- `MAGE`

### Pet Styles
Current style cycles are split by mode:

- Tank styles:
  - `NORMAL`
  - `DD`
  - `MAGIC`
  - `SPAM`

- DD styles:
  - `NORMAL`
  - `BONE`
  - `SPAM`
  - `OD`
  - `ODACC`

- Mage styles:
  - `NORMAL`
  - `HEAL`
  - `SUPPORT`
  - `MB`
  - `DD`

These states are used to decide which player and pet gear sets are equipped.

## Important Commands

### Predict
Attempts to determine the current puppet role from head/frame/attachments.

- `//gs c predict`

This is useful after manually changing attachments or when you want GearSwap to re-evaluate the current automaton role.

### Auto Maneuver
Toggles maintenance of currently active maneuvers.

- `//gs c automan`

### Set FTP
Toggles the FTP-oriented pet WS behavior used when relevant DD conditions are met.

- `//gs c setftp`

### Clear Maneuver Queue
Clears the local list of maneuvers that GearSwap intends to recast.

- `//gs c clear`

### Pet Mode / Pet Style
- `//gs c cycle PetModeCycle`
- `//gs c cycleback PetModeCycle`
- `//gs c cycle PetStyleCycle`
- `//gs c cycleback PetStyleCycle`

### HUB Controls
- `//gs c hub all`
- `//gs c hub state`
- `//gs c hub mode`
- `//gs c hub options`
- `//gs c hub keybinds`
- `//gs c hub lite`

### Utility Commands
- `//gs c wstimer <seconds>`
- `//gs c tpmin <tp>`

## Keybinds
The PUP user file now supports user-side keybind configuration.

That means:
- the logic lives in the library
- the actual binding choices live in `GearSwap/data/PUP-USER/user.lua`

This allows:
- AZERTY / QWERTY customization
- personal remapping
- hub labels matching your configured keys

If your binds conflict with another addon, edit them in:
- `GearSwap/data/PUP-USER/user.lua`

## Idle / Engaged / Pet Sets
This GearSwap uses standard player sets plus additional pet-engaged logic.

Examples of common set families already supported in the user file:
- idle
- regen idle
- refresh idle
- master DT
- master melee
- master + pet melee
- pet engaged
- pet WS
- pet tanking
- pet magic
- overdrive variants

The user file is expected to contain your actual gear choices and comments about String Theory mapping or missing upgrades.

## Optional Relation With AutoControl
This PUP GearSwap has an optional and non-required relationship with the AutoControl addon.

### What AutoControl Handles
AutoControl is better suited for:
- automaton head / frame / attachment loadouts
- named attachment preset management
- swapping attachment families quickly

### What This GearSwap Handles
This PUP GearSwap is better suited for:
- master gear
- pet gear
- pet WS gear logic
- mode / style states
- hub display
- lock states and player-side controls

### How They Work Together
When both addons are loaded:
- AutoControl can equip a built-in String Theory attachment family
- AutoControl then sends a lightweight IPC hint
- this PUP GearSwap can update its `PetModeCycle` / `PetStyleCycle` to match the selected attachment family

This is intentionally limited in scope:
- AutoControl does not take over player gear logic
- GearSwap does not take over attachment management
- the integration is there only to keep both systems coherent

### If AutoControl Is Missing
Nothing breaks.

This GearSwap still works normally:
- all player gear logic still works
- all pet gear logic still works
- prediction can still be done manually with `//gs c predict`

### If GearSwap Is Missing
AutoControl still works normally on its own for attachment management.

### Why This Matters
The goal is cooperation, not dependency.

You can use:
- only GearSwap
- only AutoControl
- both together

without forcing one addon to exist for the other to function.

## AutoControl-Specific Commands Recognized By GearSwap
The PUP GearSwap also exposes a small helper command:

- `//gs c acprofile <profile>`

This is mainly useful for testing the AutoControl integration manually.

Examples:
- `//gs c acprofile st_overdrive`
- `//gs c acprofile st_black_mage`

Normally you do not need this during regular use, because AutoControl sends the profile hint automatically when appropriate.

## Notes About Prediction
Prediction is based on current pet head/frame/attachments and is meant to be practical rather than perfect.

This means:
- some families map cleanly
- some flexible String Theory variants intentionally still map to the same GearSwap mode/style

For example:
- several overdrive variants still resolve to the same DD overdrive style family
- multiple tank flex variants may still resolve to the same tank style

That is expected, because the purpose is to keep gear selection coherent, not to encode every attachment nuance as a separate full GearSwap mode.

## Maintenance Notes
If you update this package:
- preserve `GearSwap/data/PUP-USER/user.lua`
- review `PUP-LIB` changes as library updates
- re-check custom binds and comments if a newer version changes hub fields or state names

## Recommended Usage Pattern
If you use both addons, the practical flow is:

1. Use AutoControl to manage attachment presets.
2. Let GearSwap handle player and pet gear.
3. Use `//gs c predict` manually only when needed.
4. Keep your personal tuning in `GearSwap/data/PUP-USER/user.lua`.
