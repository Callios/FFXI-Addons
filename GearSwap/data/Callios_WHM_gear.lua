-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Afflatus Solace'] = buffactive['Afflatus Solace'] or false
    state.Buff['Afflatus Misery'] = buffactive['Afflatus Misery'] or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT')


    gear.WHMFCCape = { name="Alaunus's Cape", augments={'"Fast Cast"+10',}}
    gear.WHMCURECape = { name="Alaunus's Cape", augments={'MND+20','"Cure" potency +10%',}}

    select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- Precast Sets

    -- Fast cast sets for spells
    sets.precast.FC = {
    main="C. Palug Hammer",
    sub="Genmei Shield",
    ammo="Staunch Tathlum +1",
    head="Bunzi's Hat",
    body="Inyanga Jubbah +2",
    hands="Chironic Gloves",
    legs="Aya. Cosciales +2",
    feet="Regal Pumps +1",
    neck="Baetyl Pendant",
    waist="Embla Sash",
    left_ear="Malignance Earring",
    right_ear="Loquac. Earring",
    left_ring="Rahab Ring",
    right_ring="Kishar Ring",
    back ="Fi Follet Cape +1",
    }
        
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Embla Sash"})

    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {head="Umuthi Hat"})

    sets.precast.FC['Healing Magic'] = {
    main="C. Palug Hammer",
    sub="Genmei Shield",
    ammo="Staunch Tathlum +1",
    head="Bunzi's Hat",
    body="Inyanga Jubbah +2",
    hands="Chironic Gloves",
    legs="Ebers Pant. +1",
    feet="Nyame Sollerets",
    neck="Baetyl Pendant",
    waist="Embla Sash",
    left_ear="Malignance Earring",
    right_ear="Loquac. Earring",
    left_ring="Rahab Ring",
    right_ring="Kishar Ring",
    back ="Fi Follet Cape +1",
    }

    sets.precast.FC.StatusRemoval = sets.precast.FC['Healing Magic']

    sets.precast.FC.Cure = {
    main="C. Palug Hammer",
    sub="Genmei Shield",
    ammo="Staunch Tathlum +1",
    head="Bunzi's Hat",
    body="Inyanga Jubbah +2",
    hands="Chironic Gloves",
    legs="Ebers Pantaloons +1",
    feet="Regal Pumps +1",
    neck="Baetyl Pendant",
    waist="Embla Sash",
    left_ear="Malignance Earring",
    right_ear="Loquac. Earring",
    left_ring="Rahab Ring",
    right_ring="Kishar Ring",
    back ="Fi Follet Cape +1",}



    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.CureSolace = sets.precast.FC.Cure
    -- CureMelee spell map should default back to Healing Magic.
    
    -- Precast sets to enhance JAs
    sets.precast.JA.Benediction = {body="Piety Briault"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Nahtirah Hat",ear1="Roundel Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",
        back="Refraction Cape",legs="Gendewitha Spats",feet="Gendewitha Galoshes"}
    
    
    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    gear.default.weaponskill_neck = "Asperity Necklace"
    gear.default.weaponskill_waist = ""
    sets.precast.WS = {
        head="Nahtirah Hat",neck=gear.ElementalGorget,ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring1="Rajas Ring",ring2="K'ayres Ring",
        back="Refraction Cape",waist=gear.ElementalBelt,legs="Gendewitha Spats",feet="Gendewitha Galoshes"}
    
    sets.precast.WS['Flash Nova'] = {
        head="Nahtirah Hat",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring1="Rajas Ring",ring2="Strendu Ring",
        back="Toro Cape",waist="Thunder Belt",legs="Gendewitha Spats",feet="Gendewitha Galoshes"}
    

    -- Midcast Sets
    
    sets.midcast.FastRecast = {
        head="Bunzi's Hat",ear2="Loquacious Earring",
        body="Inyanga Jubbah +2",hands="Dynasty Mitts",ring1="Prolix Ring",
        back="Swith Cape +1",waist="Goading Belt",legs="Gendewitha Spats",feet="Gendewitha Galoshes"}
    
    -- Cure sets
    gear.default.obi_waist = "Goading Belt"
    gear.default.obi_back = "Mending Cape"

    sets.midcast.CureSolace = { main="Gada",
    sub="Sors Shield",
    ammo="Hydrocera",
    head="Kaykaus Mitra +1",
    body="Kaykaus Bliaut +1",
    hands="Kaykaus Cuffs +1",
    legs="Ebers Pantaloons +1",
    feet="Kaykaus boots +1",
    neck="Voltsurge Torque",
    waist="Embla Sash",
    left_ear="Gwati Earring",
    right_ear="Nourish. Earring",
    left_ring="Sirona's Ring",
    right_ring="Lebeche Ring",
    back=gear.WHMCURECape}

    sets.midcast.Cure = { main="Gada",
    sub="Sors Shield",
    ammo="Hydrocera",
    head="Kaykaus Mitra +1",
    body="Kaykaus Bliaut +1",
    hands="Kaykaus Mitra +1",
    legs="Ebers Pantaloons +1",
    feet="Kaykaus boots +1",
    neck="Cleric's Torque +1",
    waist="Embla Sash",
    left_ear="Gwati Earring",
    right_ear="Nourish. Earring",
    left_ring="Sirona's Ring",
    right_ring="Lebeche Ring",
    back=gear.WHMCURECape}

    sets.midcast.Curaga = { main="Gada",
    sub="Sors Shield",
    ammo="Hydrocera",
    head="Theo. Cap +1",
    body="Annoint. Kalasiris",
    hands="Theo. Mitts +1",
    legs="Ebers Pantaloons +1",
    feet="Regal Pumps",
    neck="Voltsurge Torque",
    waist="Embla Sash",
    left_ear="Gwati Earring",
    right_ear="Nourish. Earring",
    left_ring="Sirona's Ring",
    right_ring="Lebeche Ring",
    back=gear.WHMCURECape}

    sets.midcast.CureMelee = {ammo="Incantor Stone",
        head="Gendewitha Caubeen",neck="Orison Locket",ear1="Lifestorm Earring",ear2="Orison Earring",
        body="Vanir Cotehardie",hands="Bokwus Gloves",ring1="Prolix Ring",ring2="Sirona's Ring",
        back="Tuilha Cape",waist=gear.ElementalObi,legs="Orison Pantaloons +2",feet="Piety Duckbills +1"}

    sets.midcast.Cursna = {main="Beneficus",sub="Genbu's Shield",
        head="Orison Cap +2",neck="Malison Medallion",
        body="Orison Bliaud +2",hands="Hieros Mittens",ring1="Ephedra Ring",ring2="Sirona's Ring",
        back="Mending Cape",waist="Goading Belt",legs="Theophany Pantaloons",feet="Gendewitha Galoshes"}

    sets.midcast.StatusRemoval = {
        main="Yagrush",head="Orison Cap +2",legs="Orison Pantaloons +2", neck="Cleric's Torque +1"}

    -- 110 total Enhancing Magic Skill; caps even without Light Arts
    sets.midcast['Enhancing Magic'] = {main="Beneficus",sub="Genbu's Shield",
        head="Telchine Cap",neck="Incater's torque",
        body="Telchine chasuble",hands="Telchine Gloves",
        back="Mending Cape",waist="Embla sash",legs="Telchine Braconi",feet="Theo. Duckbills +1 "}

        sets.midcast['Haste'] = {main="Beneficus",sub="Genbu's Shield",
        head="Telchine Cap",neck="Incater's torque",
        body="Telchine chasuble",hands="Telchine Gloves",
        back="Fi Follet Cape +1",waist="Embla Sash",legs="Telchine Braconi",feet="Theo. Duckbills +1 "}


    sets.midcast.Stoneskin = {
        head="Nahtirah Hat",neck="Orison Locket",ear2="Loquacious Earring",
        body="Vanir Cotehardie",hands="Dynasty Mitts",
        back="Swith Cape +1",waist="Siegel Sash",legs="Gendewitha Spats",feet="Gendewitha Galoshes"}

    sets.midcast.Auspice = {hands="Dynasty Mitts",feet="Orison Duckbills +2"}

    sets.midcast.BarElement = {main="Beneficus",sub="Genbu's Shield",
        head="Orison Cap +2",neck="Colossus's Torque",
        body="Orison Bliaud +2",hands="Orison Mitts +2",
        back="Mending Cape",waist="Olympus Sash",legs="Piety Pantaloons",feet="Orison Duckbills +2"}

    sets.midcast.Regen = {
        main="Bolelabunga",
        sub="Sors Shield",
        ammo="Hydrocera",
        head="Inyanga Tiara +2",
        body="Cleric's Briault",
        hands="Telchine Gloves", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',},
        legs="Theo. Pant. +1",
        feet="Theo. Duckbills",
        neck="Voltsurge Torque",
        waist="Embla Sash",
        left_ear="Andoaa Earring",
        right_ear="Nourish. Earring",
        left_ring="Sirona's Ring",
        right_ring="Kishar Ring",
        back="Disperser's Cape",
    }

    sets.midcast.Protectra = {ring1="Sheltered Ring",feet="Piety Duckbills +1"}

    sets.midcast.Shellra = {ring1="Sheltered Ring",legs="Piety Pantaloons"}


    sets.midcast['Divine Magic'] = {main="Bolelabunga",sub="Genbu's Shield",
        head="Nahtirah Hat",neck="Colossus's Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring2="Sangoma Ring",
        back="Refraction Cape",waist=gear.ElementalObi,legs="Theophany Pantaloons",feet="Gendewitha Galoshes"}

    sets.midcast['Dark Magic'] = {main="Bolelabunga", sub="Genbu's Shield",
        head="Nahtirah Hat",neck="Aesir Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring1="Strendu Ring",ring2="Sangoma Ring",
        back="Refraction Cape",waist="Demonry Sash",legs="Bokwus Slops",feet="Piety Duckbills +1"}

    -- Custom spell classes
    sets.midcast.MndEnfeebles = {main="Lehbrailg +2", sub="Mephitis Grip",
        head="Nahtirah Hat",neck="Weike Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring1="Aquasoul Ring",ring2="Sangoma Ring",
        back="Refraction Cape",waist="Demonry Sash",legs="Bokwus Slops",feet="Piety Duckbills +1"}

    sets.midcast.IntEnfeebles = {main="Lehbrailg +2", sub="Mephitis Grip",
        head="Nahtirah Hat",neck="Weike Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring1="Icesoul Ring",ring2="Sangoma Ring",
        back="Refraction Cape",waist="Demonry Sash",legs="Bokwus Slops",feet="Piety Duckbills +1"}

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {main=gear.Staff.HMP, 
        body="Gendewitha Bliaut",hands="Serpentes Cuffs",
        waist="Austerity Belt",legs="Nares Trews",feet="Chelona Boots +1"}
    

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle ={
    main="Daybreak",
    sub="Genmei Shield",
    ammo="Staunch Tathlum +1",
    head="Inyanga Tiara +2",
    body="Inyanga Jubbah +2",
    hands="Inyan. Dastanas +2",
    legs="Inyanga Shalwar +2",
    feet="Nyame Sollerets",
    neck="Warder's Charm +1",
    waist="Carrier's Sash",
    left_ear="Hearty Earring",
    right_ear="Odnowa Earring +1",
    left_ring="Inyanga Ring",
    right_ring="Defending Ring",
    back="Solemnity Cape",}

    sets.idle.PDT = {main="Bolelabunga", sub="Genbu's Shield",ammo="Incantor Stone",
        head="Nahtirah Hat",neck="Twilight Torque",ear1="Bloodgem Earring",ear2="Loquacious Earring",
        body="Gendewitha Bliaut",hands="Gendewitha Gages",ring1="Defending Ring",ring2=gear.DarkRing.physical,
        back="Umbra Cape",waist="Witful Belt",legs="Gendewitha Spats",feet="Herald's Gaiters"}

    sets.idle.Town = {    
        main="Daybreak",
        sub="Genmei Shield",
        ammo="Staunch Tathlum +1",
        head="Inyanga Tiara +2",
        body="Inyanga Jubbah +2",
        hands="Inyan. Dastanas +2",
        legs="Inyanga Shalwar +2",
        feet="Nyame Sollerets",
        neck="Warder's Charm +1",
        waist="Carrier's Sash",
        left_ear="Hearty Earring",
        right_ear="Odnowa Earring +1",
        left_ring="Inyanga Ring",
        right_ring="Defending Ring",
        back="Solemnity Cape",}
    
    sets.idle.Weak = {main="Bolelabunga",sub="Genbu's Shield",ammo="Incantor Stone",
        head="Nahtirah Hat",neck="Twilight Torque",ear1="Bloodgem Earring",ear2="Loquacious Earring",
        body="Gendewitha Bliaut",hands="Yaoyotl Gloves",ring1="Defending Ring",ring2="Meridian Ring",
        back="Umbra Cape",waist="Witful Belt",legs="Nares Trews",feet="Gendewitha Galoshes"}
    
    -- Defense sets

    sets.defense.PDT = {main=gear.Staff.PDT,sub="Achaq Grip",
        head="Gendewitha Caubeen",neck="Twilight Torque",
        body="Gendewitha Bliaut",hands="Gendewitha Gages",ring1="Defending Ring",ring2=gear.DarkRing.physical,
        back="Umbra Cape",legs="Gendewitha Spats",feet="Gendewitha Galoshes"}

    sets.defense.MDT = {main=gear.Staff.PDT,sub="Achaq Grip",
        head="Nahtirah Hat",neck="Twilight Torque",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring1="Defending Ring",ring2="Shadow Ring",
        back="Tuilha Cape",legs="Bokwus Slops",feet="Gendewitha Galoshes"}

    sets.Kiting = {feet="Herald's Gaiters"}

    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Basic set for if no TP weapon is defined.
    sets.engaged = {

    main="Yagrush",
    sub="C. Palug Hammer",
    ammo="Amar Cluster",
    head="Aya. Zucchetto +2",
    body="Ayanmo Corazza +2",
    hands="Aya. Manopolas +2",
    legs="Aya. Cosciales +2",
    feet="Aya. Gambieras +2",
    neck="Combatant's Torque",
    waist="Windbuffet Belt +1",
    left_ear="Suppanomimi",
    right_ear="Eabani Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Moonbeam Cape",
    
    }


    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Divine Caress'] = {hands="Orison Mitts +2",back="Mending Cape"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.english == "Paralyna" and buffactive.Paralyzed then
        -- no gear swaps if we're paralyzed, to avoid blinking while trying to remove it.
        eventArgs.handled = true
    end
    
    if spell.skill == 'Healing Magic' then
        gear.default.obi_back = "Mending Cape"
    else
        gear.default.obi_back = "Toro Cape"
    end
end


function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Apply Divine Caress boosting items as highest priority over other gear, if applicable.
    if spellMap == 'StatusRemoval' and buffactive['Divine Caress'] then
        equip(sets.buff['Divine Caress'])
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main','sub','range')
        else
            enable('main','sub','range')
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if (default_spell_map == 'Cure' or default_spell_map == 'Curaga') and player.status == 'Engaged' then
            return "CureMelee"
        elseif default_spell_map == 'Cure' and state.Buff['Afflatus Solace'] then
            return "CureSolace"
        elseif spell.skill == "Enfeebling Magic" then
            if spell.type == "WhiteMagic" then
                return "MndEnfeebles"
            else
                return "IntEnfeebles"
            end
        end
    end
end


function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    if cmdParams[1] == 'user' and not areas.Cities:contains(world.area) then
        local needsArts = 
            player.sub_job:lower() == 'sch' and
            not buffactive['Light Arts'] and
            not buffactive['Addendum: White'] and
            not buffactive['Dark Arts'] and
            not buffactive['Addendum: Black']
            
        if not buffactive['Afflatus Solace'] and not buffactive['Afflatus Misery'] then
            if needsArts then
                send_command('@input /ja "Afflatus Solace" <me>;wait 1.2;input /ja "Light Arts" <me>')
            else
                send_command('@input /ja "Afflatus Solace" <me>')
            end
        end
    end
end


-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(4, 14)
end