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
    indi_timer = ''
    indi_duration = 180
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT')

    gear.default.weaponskill_waist = "Fotia Belt"
	gear.default.obi_waist = "Yamabuki-no-Obi"

	state.MagicBurst = M(false, 'Magic Burst')
	send_command('bind @f11 gs c toggle MagicBurst')
	set_lockstyle()
    select_default_macro_book()
end


-- Define sets and vars used by this job file.
function init_gear_sets()

    --------------------------------------
    -- Precast sets
    --------------------------------------

	--include('yer_augmented-items.lua')
	
	PetRegen = { name="Nantosuelta's Cape", augments={'INT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Pet: "Regen"+10','Pet: "Regen"+5',}}
	MaccCape = { name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10',}}
    
	
	-- Precast sets to enhance JAs
    sets.precast.JA.Bolster = {body="Bagua Tunic +1"}
    sets.precast.JA['Life Cycle'] = {body="Geomancy Tunic +1", back="Nantosuelta's Cape"}
	sets.precast.JA['Radial Arcana'] = {feet="Bagua Sandals +1"}
	sets.precast.JA['Full Circle'] = {head="Azimuth Hood +1"}
	sets.precast.JA['Curative Recantation'] = {hands="Bagua Mitaines +1"}

    -- Fast cast sets for spells

    sets.precast.FC = {main="Idris",sub="Ammurapi Shield",range="Dunna",
        head="Merlinic Hood",
		neck="Baetyl Pendant",ear1="Loquacious Earring",ear2="Etiolation Earring",
        body="Merlinic Jubbah",
		hands="Jhakri Cuffs +2",
		ring1="Jhakri Ring",ring2="Kishar Ring",
        back="Lifestream Cape",
		waist="Witful Belt",
		legs="Geomancy Pants +1",
		feet="Jhakri Pigaches +1"
	}

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
		main="Vadose Rod",sub="Genbu's Shield",
		head="Vanya Hood",ear="Mendicant's Earring",
		body="Vanya Robe",hands="Vanya Cuffs",
		back="Pahtli Cape",legs="Doyen pants",feet="Vanya Clogs"})
		
	sets.precast.FC.Curaga = set_combine(sets.precast.FC, {
		main="Vadose Rod",sub="Genbu's Shield",
		head="Vanya Hood",ear="Mendicant's Earring",
		body="Vanya Robe",hands="Vanya Cuffs",
		back="Pahtli Cape",legs="Vanya Slops",feet="Vanya Clogs"})

	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
		main="Idris",sub="Ammurapi Shield", waist="Witful Belt"})
			
    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {
		ear1="Barkarole Earring",hands="Bagua Mitaines +1"})

	sets.precast.FC.Impact = {main="Idris",sub="Ammurapi Shield",ammo="Impatiens",
        head=MerHat_FC,
		neck="Incanter's Torque",ear1="Gifted Earring",ear2="Etiolation Earring",
        body="Twilight Cloak",
		hands=MerGloves_FC,
		ring1="Weatherspoon Ring +1",ring2="Kishar Ring",
        back="Lifestream Cape",
		waist="Witful Belt",
		legs="Geomancy Pants +2",
		feet=MerBoots_FC}
	
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head="Jhakri Coronal +2",neck="Fotia Gorget",ear1="Cessance Earring",ear2="Moonshade Earring",
        body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Apate Ring",ring2="Rufescent Ring",
        back="Aurist's Cape",waist="Fotia Belt",legs="Jhakri Slops +2",feet="Jhakri Pigaches +1"}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Flash Nova'] = {ammo="Pemphredo Tathlum",
        head="Jhakri Coronal +2",
		neck="Fotia Gorget",
		ear1="Regal Earring",ear2="Ishvara Earring",
        body="Jhakri Robe +2",
		hands="Jhakri Cuffs +2",
		ring1="Weatherspoon Ring +1",ring2="Rufescent Ring",
        back=MaccCape,
		waist="Fotia Belt",
		legs="Jhakri Slops +2",
		feet="Bagua Sandals +3"}
		
	sets.precast.WS['Hexa Strike'] = {
        head="Jhakri Coronal +2",
		neck="Fotia Gorget",
		ear1="Hecate's Earring",ear2="Crematio Earring",
        body="Jhakri Robe +2",
		hands="Jhakri Cuffs +2",
		ring1="Weatherspoon Ring +1",ring2="Acumen Ring",
        back=MaccCape,
		waist="Fotia Belt",
		legs="Jhakri Slops +2",
		feet="Jhakri Pigaches +2"}
		
	sets.precast.WS['Judgment'] = {
        head="Jhakri Coronal +2",neck="Fotia Gorget",ear1="Cessance Earring",ear2="Moonshade Earring",
        body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Apate Ring",ring2="Rufescent Ring",
        back="Aurist's Cape",
		waist="Fotia Belt",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"}

    sets.precast.WS['Starlight'] = {ear2="Moonshade Earring"}

    sets.precast.WS['Moonlight'] = {ear2="Moonshade Earring"}


    --------------------------------------
    -- Midcast sets = 18% + 3% + 10% + 5% + 6% + 10% = 49%
    sets.midcast.Cure = {main="Nibiru Cudgel",sub="Sors Shield",
        head="Vanya Hood",neck="Nodens Gorget",ear1="Regal Earring",ear2="Beatific Earring",
        body="Vanya Robe",hands="Vanya Cuffs",ring1="Ephedra Ring",ring2="Sirona's Ring",
        back="Tempered Cape +1",waist="Bishop's Sash",legs="Vanya Slops",feet="Vanya Clogs"}
		
	sets.midcast['Enhancing Magic'] = {main="Gada",sub="Ammurapi Shield",
		head="Telchine Cap",neck="Incanter's Torque", ear1="Andoaa Earring",
		body="Telchine Chasuble",hands="Telchine Gloves",
		back="Fi Follet Cape +1",waist="Olympus Sash",legs="Telchine Braconi",feet="Telchine Pigaches"}
		
	sets.midcast.Refresh = {main="Gada",sub="Ammurapi Shield",
		head="Amalric Coif",
		neck="Incanter's Torque",
		body="Telchine Chasuble",
		hands="Telchine Gloves",
		legs="Telchine Braconi",
		feet="Telchine Pigaches",
		waist="Gishdubar Sash"}
		
    sets.midcast['Enfeebling Magic'] = {main="Idris",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
        head=MerHat_Nuke,
		neck="Erra Pendant",ear1="Barkarole Earring",ear2="Regal Earring",
        body="Geomancy Tunic +3",
		hands="Regal Cuffs",
		ring1="Sangoma Ring",ring2="Kishar Ring",
        back=MaccCape,
		waist="Luminary Sash",
		legs="Psycloth Lappas",
		feet="Geomancy Sandals +3"}
		
    sets.midcast['Dark Magic'] = {main="Idris",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
        head=MerHat_Nuke,
		neck="Erra Pendant",ear1="Barkarole Earring",ear2="Regal Earring",
        body="Geomancy Tunic +3",
		hands="Regal Cuffs",
		ring1="Weatherspoon Ring +1",ring2="Sangoma Ring",
        back=MaccCape,
		waist="Rumination Sash",
		legs="Geomancy Pants +2",
		feet="Geomancy Sandals +3"}
		
    sets.midcast['Elemental Magic'] = {main="Idris",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",
		neck="Sanctity Necklace",
		ear1="Barkarole Earring",ear2="Regal Earring",
        body="Merlinic Jubbah",
		hands="Bagua Mitaines +1",
		ring1="Shiva Ring",ring2="Shiva Ring",
        back="Izdubar Mantle",
		waist="Eschan Stone",
		legs="Merlinic Shalwar",
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+30','Magic burst dmg.+8%','VIT+3','"Mag.Atk.Bns."+14',}},
	}
		
	sets.magic_burst = {main="Idris",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",
		neck="Mizukage-no-Kubikazari",
		ear1="Barkarole Earring",ear2="Regal Earring",
        body="Merlinic Jubbah",
		hands="Amalric gages",
		ring1="Locus Ring",ring2="Mujin Band",
        back="Izdubar Mantle",
		waist="Eschan Stone",
		legs="Merlinic Shalwar",
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+30','Magic burst dmg.+8%','VIT+3','"Mag.Atk.Bns."+14',}},
	}
		
	sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {head=empty,body="Twilight Cloak",
		neck="Incanter's Torque",ear1="Regal Earring",ear2="Dignitary's Earring",
		hands="Regal Cuffs",ring1="Weatherspoon Ring +1",ring2="Sangoma Ring",
		back=MaccCape,
		waist="Luminary Sash",legs="Geomancy Pants +2",feet="Geomancy Sandals +3"})
		
	sets.midcast.Drain = {main="Idris",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
        head="Striga Crown",
		neck="Erra Pendant",
		ear1="Dignitary's Earring",ear2="Regal Earring",
        body="Geomancy Tunic +3",
		hands="Regal Cuffs",
		ring1="Weatherspoon Ring +1",ring2="Evanescence Ring",
        back=MaccCape,
		waist="Fucho-no-Obi",
		legs="Geomancy Pants +1",
		feet=MerBoots_Nuke
		}
		
	sets.midcast.Aspir = sets.midcast.Drain
    --------------------------------------

    -- Base fast recast for spells
    sets.midcast.FastRecast = {main="Idris",sub="Ammurapi Shield",
        head="Merlinic Hood",
		neck="Incanter's Torque",ear1="Loquacious Earring",
        body="Merlinic Jubbah",
		hands="Bagua Mitaines +1",
		ring1="Prolix Ring",
        back="Lifestream Cape",
		waist="Dynamic Belt",
		legs="Geomancy Pants +1",
		feet=MerBoots_FC}

	-- 425 Geomancy/Handbell Skill = 850, need 50 in gear to cap at 900	(18+20+17 = 55
    sets.midcast.Geomancy = {main="Idris",sub="Ammurapi Shield",range="Dunna", --18 skill
		head="Vanya Hood",neck="Melic Torque",ear1="Enchanter Earring +1",ear2="Gwati Earring", -- 20 (10+10 from Incanter)
		body="Witching Robe",hands="Geomancy Mitaines +1", --17
		back="Aurist's Cape",waist="Austerity Belt",legs="Vanya Slops",feet="Vanya Clogs"} 
		
    sets.midcast.Geomancy.Indi = {main="Idris",sub="Ammurapi Shield",range="Dunna",
		head="Vanya Hood",neck="Incanter's Torque",ear1="Mendicant's Earring",ear2="Gwati Earring",
		body="Witching Robe",hands="Geomancy Mitaines +1",
		back="Lifestream Cape",waist="Austerity Belt",legs="Bagua Pants +1",feet="Azimuth Gaiters +1"}
    
    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast.Protectra = {ring1="Sheltered Ring"}

    sets.midcast.Shellra = {ring1="Sheltered Ring"}


    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    -- Resting sets
    sets.resting = {main="Bolelabunga",sub="Genmei Shield",range="Dunna",
		head="Befouled Crown",neck="Loricate Torque +1",
        body="Jhakri Robe +2",hands="Bagua Mitaines +1",ring1="Dark Ring",ring2="Defending Ring",
        waist="Fucho-no-Obi",legs="Assiduity Pants +1",feet="Chelona Boots +1"}


    -- Idle sets

    sets.idle = {main="Bolelabunga",sub="Genmei Shield",range="Dunna",
        head="Befouled Crown",neck="Loricate Torque +1",ear1="Lugalbanda Earring",ear2="Etiolation Earring",
        body="Jhakri robe +2",hands="Bagua Mitaines +1",ring1="Gelatinous Ring +1",ring2="Defending Ring",
        back="Moonbeam Cape",waist="Fucho-no-obi",legs="Assiduity Pants +1",feet="Geomancy Sandals +1"}

    sets.idle.PDT = {main="Bolelabunga",sub="Genmei Shield",range="Dunna",
        head="Befouled Crown",neck="Loricate Torque +1",ear1="Lugalbanda Earring",ear2="Etiolation Earring",
        body="Jhakri robe +2",hands="Geomancy Mitaines +1",ring1="Gelatinous Ring +1",ring2="Defending Ring",
        back="Moonbeam Cape",waist="Fucho-no-obi",legs="Merlinic Shalwar",feet="Azimuth Gaiters +1"}

    -- .Pet sets are for when Luopan is present.
	-- 87.5% cap for pet DT. 50% innate pet DT, 25% Idris, 5% Dunna, 3% Isa Belt, 3% T Pants, 4% T Gloves
    sets.idle.Pet = {main="Bolelabunga",sub="Genmei Shield",range="Dunna",
        head="Azimuth Hood +1"
		,neck="Loricate Torque +1",
		ear1="Lugalbanda Earring",ear2="Handler's Earring",
        body="Jhakri Robe +2",
		hands="Geomancy Mitaines +1",
		ring1="Gelatinous Ring +1",ring2="Defending Ring",
        back=PetRegen,
		waist="Isa Belt",
		legs=TelchinePantsGEO,
		feet="Bagua Sandals +1"}
	
    sets.idle.PDT.Pet = {main="Bolelabunga",sub="Genmei Shield",range="Dunna",
        head="Azimuth Hood +1",
		neck="Loricate Torque +1",
		ear1="Lugalbanda Earring",ear2="Etiolation Earring",
        body="Jhakri Robe +2",
		hands="Geomancy Mitaines +1",
		ring1="Gelatinous Ring +1",ring2="Defending Ring",
        back=PetRegen,
		waist="Isa Belt",
		legs="Geomancy Pants +1",
		feet="Azimuth Gaiters +1"}

    -- .Indi sets are for when an Indi-spell is active. Change to Bagua Pants after getting
    sets.idle.Indi = set_combine(sets.idle, {legs="Assiduity Pants +1"})
    sets.idle.Pet.Indi = set_combine(sets.idle.Pet, {legs=TelchinePantsGEO})
    sets.idle.PDT.Indi = set_combine(sets.idle.PDT, {legs="Assiduity Pants +1"})
    sets.idle.PDT.Pet.Indi = set_combine(sets.idle.PDT.Pet, {legs=TelchinePantsGEO})

    sets.idle.Town = {main="Bolelabunga",sub="Genmei Shield",range="Dunna",
        head="Befouled Crown",neck="Loricate Torque +1",ear1="Lugalbanda Earring",ear2="Etiolation Earring",
        body="Councilor's Garb",hands="Bagua Mitaines +1",ring1="Gelatinous ring +1",ring2="Defending Ring",
        back="Moonbeam Cape",waist="Fucho-no-Obi",legs="Assiduity Pants +1",feet="Geomancy Sandals +1"}

    sets.idle.Weak = {main="Bolelabunga",sub="Genmei Shield",range="Dunna",
        head="Befouled Crown",neck="Loricate Torque +1",ear1="Lugalbanda Earring",ear2="Etiolation Earring",
        body="Shamash Robe",hands="Geomancy Mitaines +1",ring1="Gelatinous Ring +1",ring2="Defending Ring",
        back="Moonbeam Cape",waist="Fucho-no-Obi",legs="Assiduity Pants +1",feet="Geomancy Sandals +1"}

    -- Defense sets

    sets.defense.PDT = {main="Idris",sub="Genmei Shield",range="Dunna",
        head="Befouled Crown",neck="Loricate Torque +1",ear1="Lugalbanda Earring",ear2="Etiolation Earring",
        body="Shamash Robe",hands="Geomancy Mitaines +1",ring1="Dark Ring",ring2="Defending Ring",
        back="Moonbeam Cape",waist="Goading Belt",legs="Hagondes Pants +1",feet="Geomancy Sandals +1"}

    sets.defense.MDT = {main="Idris",sub="Genmei Shield",range="Dunna",
        head="Befouled Crown",neck="Loricate Torque +1",ear1="Lugalbanda Earring",ear2="Etiolation Earring",
        body="Shamash Robe",hands="Geomancy Mitaines +1",ring1="Dark Ring",ring2="Defending Ring",
        back="Moonbeam Cape",waist="Goading Belt",legs="Hagondes Pants +1",feet="Geomancy Sandals +1"}

    sets.Kiting = {feet="Geomancy Sandals +1"}

    sets.latent_refresh = {waist="Fucho-no-obi"}


    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {main="Idris",sub="Genmei Shield",range="Dunna",
        head="Jhakri Coronal +2",neck="Lissome Necklace",ear1="Telos Earring",ear2="Dignitary's Earring",
        body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Cacoethic Ring +1",ring2="Petrov Ring",
        back="Aurist's Cape",waist="Goading Belt",legs="Jhakri Slops +2",feet="Bagua Sandals +1"}

    --------------------------------------
    -- Custom buff sets
    --------------------------------------

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english:startswith('Indi') then
            if not classes.CustomIdleGroups:contains('Indi') then
                classes.CustomIdleGroups:append('Indi')
            end
            send_command('@timers d "'..indi_timer..'"')
            indi_timer = spell.english
            send_command('@timers c "'..indi_timer..'" '..indi_duration..' down spells/00136.png')
        elseif spell.english == 'Sleep' or spell.english == 'Sleepga' then
            send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 60 down spells/00220.png')
        elseif spell.english == 'Sleep II' or spell.english == 'Sleepga II' then
            send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 90 down spells/00220.png')
        end
    elseif not player.indi then
        classes.CustomIdleGroups:clear()
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Elemental Magic' and state.MagicBurst.value then
        equip(sets.magic_burst)
    end
	if spell.skill == 'Enhancing Magic' then
		if spellMap == 'Refresh' then
			equip(sets.midcast.Refresh)
		else
			equip(sets.midcast['Enhancing Magic'])
		end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if player.indi and not classes.CustomIdleGroups:contains('Indi')then
        classes.CustomIdleGroups:append('Indi')
        handle_equipping_gear(player.status)
    elseif classes.CustomIdleGroups:contains('Indi') and not player.indi then
        classes.CustomIdleGroups:clear()
        handle_equipping_gear(player.status)
    end
end

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

function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        elseif spell.skill == 'Geomancy' then
            if spell.english:startswith('Indi') then
                return 'Indi'
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
    classes.CustomIdleGroups:clear()
    if player.indi then
        classes.CustomIdleGroups:append('Indi')
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
    set_macro_page(1, 14)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset 075')
end