-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------

-- IMPORTANT: Make sure to also get the Mote-Include.lua file (and its supplementary files) to go with this.

-- Initialization function for this job file.
function get_sets()
  mote_include_version = 2
  -- Load and initialize the include file.
  include('Mote-Include.lua')
end


-- Setup vars that are user-independent.
function job_setup()
  -- List of pet weaponskills to check for
  petWeaponskills = S{"Slapstick", "Knockout", "Magic Mortar",
    "Chimera Ripper", "String Clipper",  "Cannibal Blade", "Bone Crusher", "String Shredder",
    "Arcuballista", "Daze", "Armor Piercer", "Armor Shatterer"}

  -- Map automaton heads to combat roles
  petModes = {
    ['Harlequin Head'] = 'Melee',
    ['Sharpshot Head'] = 'Ranged',
    ['Valoredge Head'] = 'Melee',
    ['Stormwaker Head'] = 'Magic',
    ['Soulsoother Head'] = 'Tank',
    ['Spiritreaver Head'] = 'Nuke'
    }

  -- Subset of modes that use magic
  magicPetModes = S{'Nuke','Heal','Magic'}

  -- Var to track the current pet mode.
  state.PetMode = M{['description']='Pet Mode', 'None', 'Melee', 'Ranged', 'Tank', 'Magic', 'Heal', 'Nuke'}

  include('Mote-TreasureHunter')
end


-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
  -- Options: Override default values
  state.OffenseMode:options('Normal', 'Acc', 'Fodder')
  state.WeaponskillMode:options('Normal', 'Acc', 'Fodder')
  state.PhysicalDefenseMode:options('PDT', 'Evasion')
  state.MagicalDefenseMode:options('MDT')
  state.IdleMode:options('Normal','Auto')

  gear.taeon_head_ta   = { name = "Taeon Chapeau", augments = {'STR+5 DEX+5', 'Accuracy+19 Attack+19', '"Triple Atk."+2'}}
  gear.taeon_body_ta   = { name = "Taeon Tabard", augments = {'STR+6 AGI+6', 'Accuracy+12 Attack+12', '"Triple Atk."+2'}}
  gear.taeon_hands_ta  = { name = "Taeon Gloves", augments = {'STR+5 DEX+5', 'Accuracy+17 Attack+17', '"Triple Atk."+2'}}
  gear.taeon_legs_ta   = { name = "Taeon Tights", augments = {'STR+4 VIT+4', 'Accuracy+12 Attack+12', '"Triple Atk."+2'}}
  gear.taeon_feet_ta   = { name = "Taeon Boots", augments = {'STR+7 CHR+7', 'Accuracy+8 Attack+8', '"Triple Atk."+2'}}

  gear.taeon_head_pet  = { name = "Taeon Chapeau", augments = {'"Repair" potency +5%', 'Pet: Damage taken -4%', 'Pet: Accuracy+18 Pet: Rng.Acc.+18'}}
  gear.taeon_body_pet  = { name = "Taeon Tabard", augments = {'"Repair" potency +5%', 'Pet: Haste+4%', 'Pet: "Mag. Atk. Bns."+25'}}
  gear.taeon_hands_pet = { name = "Taeon Gloves", augments = {'"Repair" potency +5%', 'Pet: Haste+5%', 'Pet: "Mag. Atk. Bns."+24'}}
  gear.taeon_legs_pet  = { name = "Taeon Tights", augments = {'Pet: Damage taken -3%', 'Pet: Accuracy+18 Pet: Rng.Acc.+18', 'Pet: "Dbl. Atk."+4'}}
  gear.taeon_feet_pet  = { name = "Taeon Boots", augments = {'Pet: Damage taken -3%', 'Pet: Accuracy+24 Pet: Rng.Acc.+24', 'Pet: "Dbl. Atk."+4'}}

  send_command('bind ^= gs c cycle treasuremode')

  update_pet_mode()
  select_default_macro_book()
end


-- Define sets used by this job file.
function init_gear_sets()

  sets.TreasureHunter = {waist="Chaac Belt"}
  -- Precast Sets

  -- Fast cast sets for spells
  sets.precast.FC = {
    head="Rawhide Mask",neck="Orunmila's Torque",ear1="Loquacious Earring",
    body="Anhur Robe",hands=gear.taeon_hands_ta,ring1="Veneficium Ring",ring2="Prolix Ring",
    back="Swith Cape",waist="Hurch'lan Sash",legs=gear.taeon_legs_ta,feet="Regal Pumps +1"
  }

  sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})


  -- Precast sets to enhance JAs
  sets.precast.JA['Tactical Switch'] = {feet="Karagoz Scarpe +1"}

  sets.precast.JA['Repair'] = {
    main="Nibiru Sainti",ammo="Automaton Oil +3",
    head=gear.taeon_head_pet,ear1="Guignol Earring",ear2="Pratik Earring",
    body=gear.taeon_body_pet,hands=gear.taeon_hands_pet,
    legs="Desultor Tassets",feet="Foire Bab. +1"
  }

  sets.precast.JA['Maintenance'] = {ammo="Automaton Oil"}

  sets.precast.JA.Maneuver = {main="Kenkonken",neck="Bfn. Collar +1",ear2="Burana Earring",body="Karagoz Farsetto +1",hands="Foire Dastanas +1",back="Dispersal Mantle"}

  -- Waltz set (chr and vit)
  sets.precast.Waltz = {
    head=gear.taeon_head_ta,ear1="Roundel Earring",
    body="Pitre Tobe +1",hands="Regimen Mittens",ring1="Spiral Ring",
    back="Refraction Cape",legs="Naga Hakama",feet="Dance Shoes"}

  -- Don't need any special gear for Healing Waltz.
  sets.precast.Waltz['Healing Waltz'] = {}


  -- Weaponskill sets
  -- Default set for any weaponskill that isn't any more specifically defined
  sets.precast.WS = {
    head="Hizamaru somen +1",neck="Fotia Gorget",ear1="Ishvara Earring",ear2="Moonshade Earring",
    body="Hizamaru Haramaki +1",hands="Hizamaru Kote +1",ring1="Rajas Ring",ring2="Epona's Ring",
    back="Dispersal mantle",waist="Fotia Belt",legs="Hizamaru Hizayoroi +1",feet="Herculean boots"}

  -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
  sets.precast.WS['Stringing Pummel'] = set_combine(sets.precast.WS, {
    ear1="Cessance Earring",ear2="Moonshade Earring",
    ring1="Spiral Ring"})

  sets.precast.WS['Victory Smite'] = set_combine(sets.precast.WS, {
    ear1="Cessance Earring",ear2="Moonshade Earring",
    ring1="Pyrosoul Ring"})

  -- Midcast Sets

  -- Midcast sets for pet actions
  sets.midcast.Pet.Cure = {
    head="Naga Somen",
    body="Naga Samue",hands="Regimen Mittens",ring1="Kunaji Ring",ring2="Thurandaut Ring",
    back="Refraction Cape",waist="Gishdubar Sash",legs="Naga Hakama",feet="Foire Bab. +1"}

  sets.midcast.Pet['Elemental Magic'] = {main="Nibiru Sainti",
    head="Rawhide Mask",ear1="Charivari Earring",ear2="Burana Earring",
    body=gear.taeon_body_pet,hands="Naga Tekko",ring2="Thurandaut Ring",
    back="Argochampsa Mantle",waist="Ukko Sash",legs="Karaggoz Pantaloni +1",feet="Pitre Babouches +1"}

  sets.midcast.Pet.WeaponSkill = {
    head="Karagoz Capello +1",neck="Empath Necklace",ear1="Charivari Earring",ear2="Burana Earring",
    body="Pitre Tobe +1",hands="Karagoz Guanti +1",ring1="Overbearing Ring",ring2="Thurandaut Ring",
    back="Dispersal Mantle",waist="Ukko Sash",legs="Karagoz Pantaloni +1",feet="Naga Kyahan"}


  -- Sets to return to when not performing an action.

  -- Resting sets
  sets.resting = {
    head="Pitre Taj +1",neck="Sanctity Necklace",ear1="Infused Earring",ear2="Burana Earring",
    ring1="Sheltered Ring",ring2="Paguroidea Ring",
    back="Contriver's Cape"}

  -- Idle sets
  sets.idle = {
    ammo="Automat. Oil +3",
    head="Pitre Taj +1",neck="Bathy choker",ear1="Infused Earring",ear2="Burana Earring",
    body="Gyve Doublet",hands="Count's Cuffs",ring1="Sheltered Ring",ring2="Paguroidea Ring",
    back="Kumbira Cape",waist="Lycopodium Sash",legs="Rao Haidate +1",feet="Hermes' Sandals"}
  
  sets.idle.Auto = {ammo="Automat. Oil +3",
    head="Anwig salade",neck="Shepherd's chain",ear1="Rimeice Earring",ear2="Domesticator's Earring",
    body="Gyve Doublet",hands="Count's Cuffs",ring1="Defending Ring",ring2="Paguroidea Ring",
    back="Kumbira Cape",waist="Ukko Sash",legs="Rao Haidate +1",feet="Hermes' Sandals"}

  -- Set for idle while pet is out (eg: pet regen gear)
  sets.idle.Pet = set_combine(sets.idle, {main="Ohtas",neck="Empath Necklace",ring2="Thurandaut Ring",back="Contriver's Cape",waist="Isa Belt"})
  sets.idle.Pet.Magic = set_combine(sets.idle, {main="Denouements"})
  sets.idle.Pet.Heal = sets.idle.Pet.Magic
  sets.idle.Pet.Nuke = sets.idle.Pet.Magic

  -- Idle sets to wear while pet is engaged
  sets.idle.Pet.Engaged = {
    ammo="Automat. Oil +3",
    head="Anwig Salade",neck="Shepherd's chain",ear1="Rimeice Earring",ear2="Domesticator's Earring",
    body="Rao Togi",hands="Rao Kote +1",ring1="Defending Ring",ring2="Fortified Ring",
    back="Visucius's mantle",waist="Isa Belt",legs="Rao Haidate +1",feet="Rao Sune-Ate"}

  sets.idle.Pet.Engaged.Ranged = set_combine(sets.idle.Pet.Engaged, {main="Nibiru Sainti",feet="Punchinellos"})
  sets.idle.Pet.Engaged.Nuke = set_combine(sets.idle.Pet.Engaged, {main="Denouements",legs="Karaggoz Pantaloni +1",feet="Pitre Babouches +1"})
  sets.idle.Pet.Engaged.Magic = set_combine(sets.idle.Pet.Engaged, {main="Denouements"})
  sets.idle.Pet.Engaged.Heal = sets.idle.Pet.Engaged.Magic

  sets.idle.Pet.Engaged.Tank = set_combine(sets.idle.Pet.Engaged, {main="Midnights",ammo="Automat. Oil +3",
    head="Anwig Salade",neck="Shepherd's chain",ear1="Rimeice Earring",ear2="Domesticator's Earring",
    body="Rao Togi",hands="Rao Kote +1",ring1="Defending Ring",ring2="Fortified Ring",
    back="Visucius's mantle",waist="Isa Belt",legs="Rao Haidate +1",feet="Rao Sune-Ate"})
  -- Engaged sets

  -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
  -- sets if more refined versions aren't defined.
  -- If you create a set with both offense and defense modes, the offense mode should be first.
  -- EG: sets.engaged.Dagger.Accuracy.Evasion

  -- Normal melee group
  sets.engaged = {
    ammo="Automat. Oil +3",
    head="Hizamaru Somen +1", body="Hiza. Haramaki +1", hands="Hizamaru Kote +1",
    legs="Hiza. Hizayoroi +1", feet="Herculean boots", neck="Clotharius Torque", waist="Olseni belt", back="Visucius's mantle",
    left_ear="Digni. Earring", right_ear="Cessance Earring", left_ring="Rajas Ring", right_ring="Ramuh Ring +1"}

  sets.engaged.Acc = set_combine(sets.engaged, {
    head="Ptica Headgear",neck="Subtlety Spectacles",ear1="Zennaroi Earring",
    body="Pitre Tobe +1",hands=gear.taeon_hands_ta,ring2="Oneiros Annulet",
    waist="Hurch'lan Sash",legs=gear.taeon_legs_ta,feet="Karagoz Scarpe +1"
  })

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------

-- Called when player is about to perform an action
function job_precast(spell, action, spellMap, eventArgs)
  custom_aftermath_timers_precast(spell)
end

function job_aftercast(spell, action, spellMap, eventArgs)
  custom_aftermath_timers_aftercast(spell)
end

-- Called when pet is about to perform an action
function job_pet_midcast(spell, action, spellMap, eventArgs)
  if petWeaponskills:contains(spell.english) then
    classes.CustomClass = "Weaponskill"
  end
end


-------------------------------------------------------------------------------------------------------------------
-- General hooks for other game events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
  if buff == 'Wind Maneuver' then
    handle_equipping_gear(player.status)
  end
end

-- Called when a player gains or loses a pet.
-- pet == pet gained or lost
-- gain == true if the pet was gained, false if it was lost.
function job_pet_change(pet, gain)
  update_pet_mode()
end

-- Called when the pet's status changes.
function job_pet_status_change(newStatus, oldStatus)
  if newStatus == 'Engaged' then
    display_pet_status()
  end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
  if cmdParams[1] == 'maneuver' then
    if pet.isvalid then
      local man = defaultManeuvers[state.PetMode]
      if man and tonumber(cmdParams[2]) then
        man = man[tonumber(cmdParams[2])]
      end

      if man then
        send_command('input /pet "'..man..'" <me>')
      end
    else
      add_to_chat(123,'No valid pet.')
    end
  end
end


-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
  update_pet_mode()
  engage_pet(eventArgs)
end


-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
  local defenseString = ''
  if state.Defense.Active then
    local defMode = state.Defense.PhysicalMode
    if state.Defense.Type == 'Magical' then
      defMode = state.Defense.MagicalMode
    end

    defenseString = 'Defense: '..state.Defense.Type..' '..defMode..', '
  end

  add_to_chat(122,'Melee: '..state.OffenseMode..'/'..state.DefenseMode..', WS: '..state.WeaponskillMode..', '..defenseString..
    'Kiting: '..on_off_names[state.Kiting])

  display_pet_status()

  eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Get the pet mode value based on the equipped head of the automaton.
-- Returns nil if pet is not valid.
function get_pet_mode()
  if pet.isvalid then
    return petModes[pet.head] or 'None'
  else
    return 'None'
  end
end

-- Update state.PetMode, as well as functions that use it for set determination.
function update_pet_mode()
  state.PetMode:set(get_pet_mode())
  update_custom_groups()
end

-- Update custom groups based on the current pet.
function update_custom_groups()
  classes.CustomIdleGroups:clear()
  if pet.isvalid then
    classes.CustomIdleGroups:append(state.PetMode.value)
  end
end

-- Display current pet status.
function display_pet_status()
  if pet.isvalid then
    local petInfoString = pet.name..' ['..pet.head..']: '..tostring(pet.status)..'  TP='..tostring(pet.tp)..'  HP%='..tostring(pet.hpp)

    if magicPetModes:contains(state.PetMode) then
      petInfoString = petInfoString..'  MP%='..tostring(pet.mpp)
    end

    add_to_chat(122,petInfoString)
  end
end

function engage_pet(eventArgs)
  if player.status == 'Engaged' then
    if pet.isvalid then
      send_command('input /pet Deploy <t>')
    end
  end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
  -- Default macro set/book
  if player.sub_job == 'DNC' then
    set_macro_page(2, 6)
  elseif player.sub_job == 'NIN' then
    set_macro_page(2, 6)
  elseif player.sub_job == 'THF' then
    set_macro_page(2, 6)
  else
    set_macro_page(2, 6)
  end
end