-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'DT')

	gear.default.obi_waist = "Luminary Sash"
	
	state.WeaponLock = M(false, 'Weapon Lock')
	send_command('bind @w gs c toggle WeaponLock')
	
    select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

	include('Gipi_augmented-items.lua')
	
    -- Precast Sets

    -- Fast cast sets for spells
    sets.precast.FC = {
		main="Sucellus",				--5
		ammo="Impatiens",				--
		head="Bunzi's Hat",				--10
		neck="Cleric's Torque +2",		--10
		ear1="Loquacious Earring",		--2
		ear2="Malignance Earring",		--4
		body="Pinga Tunic +1",			--15
		hands="Fanatic gloves",			--7
		ring1="Kishar ring",			--4
		ring2="Rahab Ring",				--2
		back=gear.AlaunusFC,			--10
		waist="Witful belt",			--3
		legs="Volte Brais",				--8
		feet="Regal pumps +1"			--8
		} --88
        
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {})
    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {})
    sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC, {legs="Ebers pantaloons +1"})
    sets.precast.FC.StatusRemoval = set_combine(sets.precast.FC['Healing Magic'], {main="Yagrush",})
    sets.precast.FC.Cure = set_combine(sets.precast.FC['Healing Magic'], {})		
	sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})		
    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.CureSolace = sets.precast.FC.Cure
    -- CureMelee spell map should default back to Healing Magic.
    
    -- Precast sets to enhance JAs
    sets.precast.JA.Benediction = {body="Piety Briault +3"}
	sets.precast.JA['Devotion'] = {
		head="Nyame Helm",neck="Bathy Choker",ear1="Odnowa earring +1",ear2="Eabani Earring",
		body="Nyame Mail",hands="Nyame Gauntlets",ring1="Meridian ring",ring2="Eihwaz ring",
		back="Moonbeam cape",waist="Oneiros belt",legs="Nyame Flanchard",feet="Nyame Sollerets"} 

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}
        
    -- Weaponskill sets
    sets.precast.WS = {ammo="Floestone",
        head="Nyame Helm",neck="Cleric's Torque +2",ear1="Telos Earring",ear2="Ishvara Earring",
        body="Nyame Mail",hands="Nyame Gauntlets",ring1="Epaminondas's Ring",ring2="Ilabrat Ring",
        back=gear.AlaunusTP,waist="Prosilio Belt +1",legs="Nyame Flanchard",feet="Nyame Sollerets"}
    
    sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS, {})
    
    -- Midcast Sets   
    sets.midcast.FastRecast = set_combine(sets.precast.FC, {ear1="Magnetic Earring",legs="Lengo pants",})
    
    -- Cure sets
    sets.midcast.Cure = {main="Queller rod",ammo="Pemphredo Tathlum",
        head="Kaykaus Mitra +1",neck="Cleric's Torque +2",ear1="Regal Earring",ear2="Malignance Earring",
        body="Ebers bliaud +1",hands="Theophany Mitts +3",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back=gear.AlaunusCURE,waist=gear.ElementalObi,legs="Ebers pantaloons +1",feet="Kaykaus Boots +1"}
	
	sets.midcast.CureSolace = set_combine(sets.midcast.Cure, {body="Ebers bliaud +1"})
	sets.midcast.CureWithLightWeather = set_combine(sets.midcast.Cure, {main="Chatoyant Staff",sub="Enki Strap",waist="Hachirin-no-obi",})
    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {body="Kaykaus Bliaut +1"})
    sets.midcast.CureMelee = set_combine(sets.midcast.Cure, {})
	sets.midcast.CureSelf = {}
		
    sets.midcast.Cursna = {main="Yagrush",
        head="Vanya Hood",
		body="Ebers bliaud +1",hands="Fanatic gloves",ring1="Haoma's Ring",ring2="Menelaus's Ring",
        back="Mending Cape",waist="Bishop's Sash",legs="Theophany Pantaloons +2",feet="Vanya clogs"}

    sets.midcast.StatusRemoval = set_combine(sets.midcast.FastRecast, {
		main="Yagrush",
		neck="Cleric's Torque +2",
		hands="Ebers Mitts +1",
		back="Mending Cape"
		})

    -- 110 total Enhancing Magic Skill; caps even without Light Arts
    sets.midcast['Enhancing Magic'] = {main="Gada",sub="Ammurapi shield",
        head="Befouled crown",neck="Incanter's torque",ear1="Magnetic Earring",ear2="Andoaa earring",
        body="Telchine chasuble",hands="Inyanga dastanas +2",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back="Fi Follet Cape +1",waist="Olympus sash",legs="Piety pantaloons +3",feet="Theophany Duckbills +3"}

	sets.midcast.EnhancingDuration = set_combine(sets.midcast['Enhancing Magic'], {
		main="Gada",
		sub="Ammurapi shield",
		head=gear.TelchineHeadDURATION,
		body=gear.TelchineBodyDURATION,
		hands=gear.TelchineHandsDURATION,
		legs=gear.TelchineLegsDURATION,
		feet="Theophany Duckbills +3",
		waist="Embla Sash",
		})
	
	sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {main="Bolelabunga",sub="Ammurapi shield",
        head="Inyanga Tiara +2",
		body="Piety Briault +3",
		hands="Ebers mitts +1",
        legs="Theophany Pantaloons +2"
		})
	
	sets.midcast['Haste'] = sets.midcast.EnhancingDuration
	sets.midcast['Flurry'] = sets.midcast.EnhancingDuration
	sets.midcast['Refresh'] = set_combine(sets.midcast.EnhancingDuration, {waist="Gishdubar sash"})
	sets.midcast['Blink'] = sets.midcast.EnhancingDuration
    sets.midcast.Storm = set_combine(sets.midcast.EnhancingDuration, {})	
		
    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
		neck="Stone gorget",
		waist="Siegel Sash",legs="Shedir seraweels"})
		
	sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {
		main="Vadose Rod",
		head="Chironic hat",
		hands="Regal Cuffs",
		legs="Shedir seraweels"})	

    sets.midcast.Auspice = set_combine(sets.midcast.EnhancingDuration, {feet="Ebers duckbills +1"})

    sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'], {main="Beneficus",
		head="Ebers Cap +1",
		body="Ebers bliaud +1",hands="Ebers mitts +1",
		legs="Piety pantaloons +3",feet="Ebers duckbills +1"})

    sets.midcast.Protectra = set_combine(sets.midcast.EnhancingDuration, {})
    sets.midcast.Shellra = set_combine(sets.midcast.EnhancingDuration, {})

	--Dark/Elemental Spells

    sets.midcast['Dark Magic'] = {main="Rubicundity", sub="Ammurapi shield",ammo="Pemphredo tathlum",
        head="Inyanga Tiara +2",neck="Erra pendant",ear1="Gwati Earring",ear2="Dignitary's earring",
        body="Inyanga jubbah +2",hands="Inyanga dastanas +2",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back=gear.AlaunusCURE,waist="Luminary sash",legs=gear.ChironicLegsMACC,feet="Ayanmo gambieras +2"}
		
    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
		head="Pixie hairpin +1",ring1="Archon ring",ring2="Evanescence ring",waist="Fucho-no-obi",})	
    
	sets.midcast.Aspir = sets.midcast.Drain
		
    sets.midcast['Elemental Magic'] = {main="Mpaca's Staff",sub="Niobid strap",ammo="Pemphredo tathlum",
        head="Bunzi's Hat",neck="Mizukage-no-kubikazari",ear1="Regal earring",ear2="Malignance Earring",
        body="Nyame Mail",hands="Nyame Gauntlets",ring1="Shiva ring +1",ring2="Freke Ring",
        back=gear.AlaunusCURE,waist=gear.ElementalObi,legs="Nyame Flanchard",feet="Nyame Sollerets"}

    -- Enfeebs Spells
	
    sets.midcast.MndEnfeebles = {main="Daybreak", sub="Ammurapi Shield",ammo="Pemphredo tathlum",
        head="Inyanga Tiara +2",neck="Erra pendant",ear1="Malignance Earring",ear2="Regal Earring",
        body="Theophany Briault +2",hands="Regal Cuffs",ring1="Stikini Ring +1",ring2="Kishar ring",
        back=gear.AlaunusCURE,waist="Luminary sash",legs=gear.ChironicLegsMACC,feet="Theophany Duckbills +3"}

    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {main="Daybreak", sub="Ammurapi Shield"})		
	sets.midcast.Dispelga = set_combine(sets.midcast.IntEnfeebles, {main="Daybreak", sub="Ammurapi Shield"})	
    sets.midcast['Divine Magic'] = set_combine(sets.midcast.MndEnfeebles, {main="Daybreak", sub="Ammurapi Shield"})	
   
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {}
    
    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = {main="Daybreak",sub="Genmei shield",ammo="Homiliary",
        head="Befouled Crown",neck="Bathy Choker +1",ear1="Infused earring",ear2="Eabani Earring",
        body="Shamash Robe",hands="Inyanga dastanas +2",ring1="Stikini Ring +1",ring2="Inyanga ring",
        back=gear.AlaunusFC,waist="Fucho-no-obi",legs="Assiduity pants +1",feet="Inyanga Crackows +2"}

    sets.idle.DT = {main="Daybreak",sub="Genmei shield",ammo="Staunch Tathlum +1",
        head="Inyanga Tiara +2",neck="Loricate torque +1",ear1="Sanare Earring",ear2="Eabani Earring",
        body="Shamash Robe",hands="Inyanga dastanas +2",ring1="Defending Ring",ring2="Inyanga ring",
        back=gear.AlaunusFC,waist="Fucho-no-obi",legs="Inyanga shalwar +2",feet="Inyanga crackows +2"}
    
    sets.idle.Weak = sets.idle.DT
    sets.Kiting = {ring1="Shneddick Ring"}
    
    -- Defense sets

    sets.defense.PDT = {main="Daybreak",sub="Genmei shield",ammo="Homiliary",
        head="Nyame Helm",neck="Warder's Charm +1",ear1="Sanare Earring",ear2="Eabani Earring",
        body="Nyame Mail",hands="Nyame Gauntlets",ring1="Defending Ring",ring2="Stikini Ring +1",
        back=gear.AlaunusFC,waist="Fucho-no-obi",legs="Nyame Flanchard",feet="Nyame Sollerets"}

    sets.defense.MDT = set_combine(sets.defense.PDT, {})	

    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Basic set for if no TP weapon is defined.
    sets.engaged = {range="Floestone",
		head="Ayanmo Zucchetto +2",neck="Combatant's Torque",ear1="Telos Earring",ear2="Suppanomimi",
		body="Ayanmo Corazza +2",hands="Bunzi's Gloves",ring1="Hetairoi Ring",ring2="Ilabrat ring",
		back=gear.AlaunusTP,waist="Goading Belt",legs="Nyame Flanchard",feet="Nyame Sollerets"}


    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Divine Caress'] = {hands="Ebers Mitts +1",back="Mending Cape"}
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

function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
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
    set_macro_page(1, 8)
end

