-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'DT')

	gear.default.obi_waist = "Yamabuki-no-obi"
	
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
		head="Pinga Crown +1",			--10
		neck="Cleric's Torque +2",		--10
		ear1="Enchntr. earring +1",		--2
		ear2="Loquac. Earring",			--2
		body="Inyanga jubbah +2",		--14
		hands="Fanatic gloves",			--7
		ring1="Kishar ring",			--4
		ring2="Weather. Ring",			--5
		waist="Witful belt",			--3
		legs="Lengo pants",				--5
		feet="Regal pumps +1"			--8
		} --70
        
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {head="Umuthi Hat",legs="Doyen Pants",})

    sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC, {legs="Ebers pantaloons +1"})

    sets.precast.FC.StatusRemoval = sets.precast.FC['Healing Magic']

    sets.precast.FC.Cure = set_combine(sets.precast.FC['Healing Magic'], {main="Queller rod",sub="Genbu's shield",
		ear1="Mendicant's earring",
		legs="Doyen Pants",
		feet="Hygieia clogs +1"
		})
		
	sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})
		
    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.CureSolace = sets.precast.FC.Cure
    -- CureMelee spell map should default back to Healing Magic.
    
    -- Precast sets to enhance JAs
    sets.precast.JA.Benediction = {body="Piety Briault +1"}
	sets.precast.JA['Devotion'] = {
		head="Piety cap",neck="Cuamiz collar",ear1="Odnowa earring +1",ear2="Odnowa earring",
		body="Inyanga jubbah +2",hands="Inyanga dastanas +2",ring1="Meridian ring",ring2="Eihwaz ring",
		back="Moonbeam cape",waist="Oneiros belt",legs="Inyanga shalwar +2",feet="Ebers duckbills +1"} 

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}
    
    
    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    gear.default.weaponskill_neck = ""
    gear.default.weaponskill_waist = ""
    sets.precast.WS = {
        head="Nahtirah Hat",neck=gear.ElementalGorget,ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring1="Rajas Ring",ring2="K'ayres Ring",
        back="Refraction Cape",waist=gear.ElementalBelt,legs="Gendewitha Spats",feet="Vanya clogs"}
    
    sets.precast.WS['Flash Nova'] = {
        head="Nahtirah Hat",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring1="Weather. Ring",ring2="Freke Ring",
        back="Toro Cape",waist="Thunder Belt",legs="Gendewitha Spats",feet="Gendewitha Galoshes"}
    
    -- Midcast Sets
    
    sets.midcast.FastRecast = set_combine(sets.precast.FC, {})
    
    -- Cure sets
    sets.midcast.Cure = {main="Queller rod",ammo="Pemphredo Tathlum",
        head="Kaykaus Mitra +1",neck="Cleric's Torque +2",ear1="Mendicant's earring",ear2="Nourishing earring",
        body="Ebers bliaud +1",hands="Theophany Mitts +2",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back="Alaunus's cape",waist=gear.ElementalObi,legs="Ebers pantaloons +1",feet="Kaykaus Boots +1"}
	
	sets.midcast.CureSolace = set_combine(sets.midcast.Cure, {body="Ebers bliaud +1"})
	sets.midcast.CureWithLightWeather = set_combine(sets.midcast.Cure, {waist="Hachirin-no-obi",})
    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {body="Kaykaus Bliaut +1"})
    sets.midcast.CureMelee = set_combine(sets.midcast.Cure, {})
	sets.midcast.CureSelf = {waist="Gishdubar Sash"}
		
    sets.midcast.Cursna = {
        body="Ebers bliaud +1",hands="Fanatic gloves",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        legs="Theophany Pantaloons +2",feet="Vanya clogs"}

    sets.midcast.StatusRemoval = set_combine(sets.midcast.FastRecast, {main="Yagrush", head="Ebers Cap +1", neck="Cleric's Torque +2",})

    -- 110 total Enhancing Magic Skill; caps even without Light Arts
    sets.midcast['Enhancing Magic'] = {main="Gada",sub="Ammurapi shield",
        head="Befouled crown",neck="Incanter's torque",ear1="Andoaa earring",
        body="Telchine chasuble",hands="Dynasty mitts",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back="Fi Follet Cape +1",waist="Olympus sash",legs="Piety pantaloons +1",feet="Ebers duckbills +1"}

	sets.midcast.EnhancingDuration = set_combine(sets.midcast['Enhancing Magic'], {
		main="Gada",
		sub="Ammurapi shield",
		head=gear.TelchineHeadDURATION,
		body=gear.TelchineBodyDURATION,
		hands=gear.TelchineHandsDURATION,
		legs=gear.TelchineLegsDURATION,
		feet=gear.TelchineFeetDURATION,
		waist="Embla Sash",
		})
	
	sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {main="Bolelabunga",sub="Ammurapi shield",
        head="Inyanga Tiara +2",
		body="Piety Briault +1",hands="Ebers mitts +1",
        legs="Theophany Pantaloons +2"
		})
	
	sets.midcast['Haste'] = sets.midcast.EnhancingDuration
	sets.midcast['Flurry'] = sets.midcast.EnhancingDuration
	sets.midcast['Embrava'] = sets.midcast.EnhancingDuration
	sets.midcast['Refresh'] = set_combine(sets.midcast.EnhancingDuration, {waist="Gishdubar sash"})
	sets.midcast['Adloquium'] = sets.midcast.EnhancingDuration
	sets.midcast['Animus Augeo'] = sets.midcast.EnhancingDuration
	sets.midcast['Animus Minuo'] = sets.midcast.EnhancingDuration
	sets.midcast['Embrava'] = sets.midcast.EnhancingDuration
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
		back=gear.AlaunusFC,legs="Piety pantaloons +1",feet="Ebers duckbills +1"})

    sets.midcast.Protectra = set_combine(sets.midcast.EnhancingDuration, {ring1="Sheltered Ring"})

    sets.midcast.Shellra = set_combine(sets.midcast.EnhancingDuration, {legs="Piety pantaloons +1",ring1="Sheltered Ring"})


    sets.midcast['Divine Magic'] = {main="Grioavolr",sub="Enki strap",ammo="Pemphredo tathlum",
        head="Inyanga tiara +2",neck="Erra pendant",ear1="Gwati Earring",ear2="Dignitary's earring",
        body="Inyanga jubbah +2",hands="Inyanga dastanas +2",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back=gear.AlaunusFC,waist="Luminary sash",legs=gear.ChironicLegsMACC,feet="Ayanmo gambieras +2"}

    sets.midcast['Dark Magic'] = {main="Rubicundity", sub="Ammurapi shield",ammo="Pemphredo tathlum",
        head="Inyanga tiara +2",neck="Erra pendant",ear1="Gwati Earring",ear2="Dignitary's earring",
        body="Inyanga jubbah +2",hands="Inyanga dastanas +2",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back=gear.AlaunusFC,waist="Luminary sash",legs=gear.ChironicLegsMACC,feet="Ayanmo gambieras +2"}
		
    sets.midcast.Drain = {main="Rubicundity",sub="Ammurapi shield",ammo="Pemphredo tathlum",
        head="Pixie hairpin +1",neck="Erra pendant",ear1="Regal Earring",ear2="Barkarole earring",
        body="Inyanga jubbah +2",hands="Inyanga dastanas +2",ring1="Archon ring",ring2="Evanescence ring",
        back="Bookworm's cape",waist="Fucho-no-obi",legs=gear.ChironicLegsMACC,feet="Ayanmo gambieras +2"}

    sets.midcast.Aspir = sets.midcast.Drain
		
    sets.midcast['Elemental Magic'] = {main="Grioavolr",sub="Niobid strap",ammo="Pemphredo tathlum",
        head="Inyanga Tiara +2",neck="Mizukage-no-kubikazari",ear1="Regal earring",ear2="Friomisi earring",
        body="Witching robe",hands="Chironic gloves",ring1="Shiva ring +1",ring2="Freke Ring",
        back=gear.LughMB,waist=gear.ElementalObi,legs="Lengo pants",feet="Ayanmo Gambieras +2"}

    -- Custom spell classes
    sets.midcast.MndEnfeebles = {main="Grioavolr",sub="Enki strap",ammo="Pemphredo tathlum",
        head="Inyanga tiara +2",neck="Erra pendant",ear1="Gwati Earring",ear2="Dignitary's earring",
        body="Inyanga jubbah +2",hands="Regal Cuffs",ring1="Stikini Ring +1",ring2="Kishar ring",
        back=gear.AlaunusFC,waist="Luminary sash",legs=gear.ChironicLegsMACC,feet="Ayanmo gambieras +2"}

    sets.midcast.IntEnfeebles = {main="Grioavolr",sub="Enki strap",ammo="Pemphredo tathlum",
        head="Inyanga tiara +2",neck="Erra pendant",ear1="Gwati Earring",ear2="Dignitary's earring",
        body="Inyanga jubbah +2",hands="Regal Cuffs",ring1="Stikini Ring +1",ring2="Kishar ring",
        back=gear.AlaunusFC,waist="Luminary sash",legs=gear.ChironicLegsMACC,feet="Ayanmo gambieras +2"}
		
	sets.midcast.Dispelga = set_combine(sets.midcast.IntEnfeebles, {main="Daybreak", sub="Ammurapi Shield"})

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {}
    

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = {main="Daybreak",sub="Genmei shield",ammo="Homiliary",
        head="Befouled Crown",neck="Bathy Choker +1",ear1="Infused earring",ear2="Eabani Earring",
        body="Shamash Robe",hands="Inyanga dastanas +2",ring1="Stikini Ring +1",ring2="Inyanga ring",
        back="Moonbeam cape",waist="Fucho-no-obi",legs="Assiduity pants +1",feet="Crier's Gaiters"}

    sets.idle.DT = {main="Daybreak",sub="Genmei shield",ammo="Staunch Tathlum +1",
        head="Inyanga tiara +2",neck="Loricate torque +1",ear1="Sanare Earring",ear2="Eabani Earring",
        body="Shamash Robe",hands="Inyanga dastanas +2",ring1="Defending Ring",ring2="Inyanga ring",
        back="Moonbeam cape",waist="Fucho-no-obi",legs="Inyanga shalwar +2",feet="Inyanga crackows +2"}
    
    sets.idle.Weak = sets.idle.DT
    
    -- Defense sets

    sets.defense.PDT = {main="Terra's staff",sub="Oneiros grip",ammo="Homiliary",
        head="Inyanga tiara +2",neck="Loricate torque +1",ear1="Moonshade earring",ear2="Eabani Earring",
        body="Inyanga jubbah +2",hands="Inyanga dastanas +2",ring1="Defending Ring",ring2="Inyanga ring",
        back="Moonbeam cape",waist="Fucho-no-obi",legs="Inyanga shalwar +2",feet="Inyanga crackows +2"}

    sets.defense.MDT = {main="Terra's staff",sub="Oneiros grip",ammo="Homiliary",
        head="Inyanga tiara +2",neck="Loricate torque +1",ear1="Moonshade earring",ear2="Eabani Earring",
        body="Inyanga jubbah +2",hands="Inyanga dastanas +2",ring1="Defending Ring",ring2="Inyanga ring",
        back="Moonbeam cape",waist="Fucho-no-obi",legs="Inyanga shalwar +2",feet="Inyanga crackows +2"}

    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Basic set for if no TP weapon is defined.
    sets.engaged = {range="Floestone",
		head="Ayanmo zucchetto +2",neck="Ainia collar",ear1="Telos Earring",ear2="Cessance Earring",
		body="Ayanmo Corazza +2",hands=gear.ChironicHandsTP,ring1="Petrov ring",ring2="Ilabrat ring",
		back="Moonbeam cape",waist="Windbuffet belt +1",legs="Ayanmo cosciales +2",feet="Ayanmo gambieras +2"}


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
    set_macro_page(1, 8)
end
