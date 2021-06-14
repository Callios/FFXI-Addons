-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    gs c toggle LuzafRing -- Toggles use of Luzaf Ring on and off
    
    Offense mode is melee or ranged.  Used ranged offense mode if you are engaged
    for ranged weaponskills, but not actually meleeing.
    
    Weaponskill mode, if set to 'Normal', is handled separately for melee and ranged weaponskills.
--]]

--- Things I need for this lua:
--- A set that equips for RAs when Triple Shot is up
--- A set that equips for RAs when a specific weapon is equipped 


-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	
	state.FlurryMode = M{['description']='Flurry Mode', 'Flurry II', 'Flurry I'}
    -- Whether to use Luzaf's Ring
    state.LuzafRing = M(false, "Luzaf's Ring")
    -- Whether a warning has been given for low ammo
    state.warned = M(false)

    define_roll_values()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Ranged', 'Melee', 'Acc')
    state.RangedMode:options('Normal', 'Acc', 'Critical')
    state.WeaponskillMode:options('Normal', 'Acc', 'Att', 'Mod')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT', 'Refresh')

    gear.RAbullet = "Chrono Bullet"
    gear.WSbullet = "Chrono Bullet"
    gear.MAbullet = "Living Bullet"
    gear.QDbullet = "Living Bullet"
	gear.Accbullet = "Devastating Bullet"
    options.ammo_warning_limit = 10
	
	-- Adjust Flurry toggle from Flurry to Flurry 2 (windows key + F11 to cycle)
	send_command('bind @f11 gs c cycle FlurryMode')

    -- Additional local binds
    send_command('bind ^` input /ja "Double-up" <me>')
    send_command('bind !` input /ja "Bolter\'s Roll" <me>')
	send_command('bind @f gs c cycle FlurryMode')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Sets

    -- Precast sets to enhance JAs
    
    sets.precast.JA['Triple Shot'] = {body="Chasseur's Frac +1"}
    sets.precast.JA['Snake Eye'] = {legs="Lanun Trews +1"}
    sets.precast.JA['Wild Card'] = {feet="Lanun Bottes +3"}
    sets.precast.JA['Random Deal'] = {body="Lanun Frac +3"}
	sets.precast.JA['Fold'] = {body="Lanun Gants +3"}

    
    sets.precast.CorsairRoll = {head="Lanun Tricorne +3",neck="Regal Necklace",hands="Chasseur's Gants +1",
	legs="Desultor Tassets",ring2="Luzaf's Ring",back="Camulus's Mantle"}
    
    sets.precast.CorsairRoll["Caster's Roll"] = set_combine(sets.precast.CorsairRoll, {legs="Chasseur's Culottes"})
    sets.precast.CorsairRoll["Courser's Roll"] = set_combine(sets.precast.CorsairRoll, {feet="Chasseur's Bottes +1"})
    sets.precast.CorsairRoll["Blitzer's Roll"] = set_combine(sets.precast.CorsairRoll, {head="Chasseur's Tricorne +1"})
    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Chasseur's Frac +1"})
    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Chasseur's Gants +1"})
    
    sets.precast.LuzafRing = {ring2="Luzaf's Ring"}
    sets.precast.FoldDoubleBust = {hands="Lanun Gants +3"}
    
    sets.precast.CorsairShot = {head="Blood Mask"}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells
    
    sets.precast.FC = {head="Carmine Mask",neck="Orunmila's Torque",body="Dread Jupon",
	ear1="Etiolation Earring",ear2="Loquacious Earring",hands="Leyline Gloves",legs="Rawhide Trousers",ring1="Kishar Ring",ring2="Lebeche Ring",
	feet="Carmine Greaves"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",body="Passion Jacket"})


    sets.precast.RA = {ammo=gear.RAbullet,
        head="Chasseur's Tricorne +1",
        body="Oshosi Vest",hands="Lanun Gants +3",
        back="Navarch's Mantle",waist="Yemaya Belt",legs="Adhemar Kecks",feet="Meghanada Jambeaux +2"}
	
	sets.precast.RA.Acc = {ammo=gear.Accbullet,
        head="Chasseur's Tricorne +1",
        body="Oshosi Vest",hands="Lanun Gants +3",
        back="Navarch's Mantle",waist="Yemaya Belt",legs="Adhemar Kecks",feet="Meghanada Jambeaux +2"}
	   
	sets.precast.RA.Flurry1 = set_combine(sets.precast.RA, {
		body="Laksamana's Frac +3",
		feet="Meghanada Jambeaux +2"
		}) --(15 Flurry + 46 Gear = 61 Snapshot + 10 Gifts)

    sets.precast.RA.Flurry2 = set_combine(sets.precast.RA, {
		body="Laksamana's Frac +3",
        hands="Carmine Finger Gauntlets +1",
		feet="Pursuer's Gaiters"
        }) --32/45 (30 Flurry2 + 33 Gear = 63 Snapshot + 10 Gifts)   


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head="Herculean Helm",neck="Fotia Gorget",ear1="Odnowa Earring +1",ear2="Ishvara Earring",
        body="Laksamana's Frac +3",hands="Meghanada Gloves +2",ring1="Regal Ring",ring2="Dingir Ring",
        back="Camulus's Mantle",waist="Fotia Belt",legs="Herculean Trousers",feet="Lanun Bottes +3"}


    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Savage Blade'] = {
        head="Lilitu Headpiece",neck="Caro Necklace",ear1="Moonshade Earring",ear2="Ishvara Earring",
        body="Laksamana's Frac +3",hands="Meghanada Gloves +2",ring1="Rufescent Ring",ring2="Regal Ring",
        back="Camulus's Mantle",waist="Sailfi Belt +1",legs="Herculean Trousers",feet="Lanun Bottes +3"}

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
        head="Adhemar Bonnet +1",neck="Fotia Gorget",ear1="Moonshade Earring",ear2="Telos Earring",
        body="Abnoba Kaftan",hands="Mummu Wrists +2",ring1="Mummu Ring",ring2="Regal Ring",
        back="Camulus's Mantle",waist="Fotia Belt",legs="Samnuha Tights",feet="Mummu Gamashes +2"})
		
	sets.precast.WS['Aeolian Edge'] = {ammo="Hauksbok Bullet",
        head="Herculean Helm",neck="Baetyl Pendant",ear1="Moonshade Earring",ear2="Friomisi Earring",
        body="Lanun Frac +3",hands="Carmine Finger Gauntlets +1",ring1="Dingir Ring",ring2="Shiva Ring +1",
        back="Camulus's Mantle",waist="Eschan Stone",legs="Herculean Trousers",feet="Lanun Bottes +3"}

    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {
        head="Adhemar Bonnet +1",neck="Fotia Gorget",ear1="Moonshade Earring",ear2="Telos Earring",
        body="Adhemar Jacket +1",hands="Meghanada Gloves +2",ring1="Rufescent Ring",ring2="Regal Ring",
        back="Camulus's Mantle",waist="Fotia Belt",legs="Meghanada Trousers +2",feet="Herculean Boots"})
	
    sets.precast.WS['Last Stand'] = set_combine(sets.precast.WS, {
        head="Lanun Tricorne +3",neck="Fotia Gorget",ear1="Moonshade Earring",ear2="Ishvara Earring",
        body="Laksamana's Frac +3",hands="Meghanada Gloves +2",
        back="Camulus's Mantle",waist="Fotia Belt",legs="Herculean Trousers",feet="Lanun Bottes +3"})

    sets.precast.WS['Last Stand'].Acc = set_combine(sets.precast.WS, {
        head="Meghanada Visor +2",neck="Fotia Gorget",ear1="Enervating Earring",ear2="Telos Earring",
        body="Meghanada Cuirie +2",hands="Meghanada Gloves +2",
        back="Camulus's Mantle",waist="Fotia Belt",legs="Meghanada Chausses +2",feet="Meghanada Jambeaux +2"})
		
	sets.precast.WS['Detonator'] = set_combine(sets.precast.WS, {
        head="Lilitu Headpiece",neck="Fotia Gorget",ear1="Odnowa Earring +1",ear2="Ishvara Earring",
        body="Laksamana's Frac +3",hands="Meghanada Gloves +2",ring2="Ilabrat Ring",
        back="Camulus's Mantle",waist="Fotia Belt",legs="Herculean Trousers",feet="Lanun Bottes +3"})

    sets.precast.WS['Detonator'].Acc = set_combine(sets.precast.WS, {
        head="Meghanada Visor +2",neck="Fotia Gorget",ear1="Enervating Earring",ear2="Telos Earring",
        body="Meghanada Cuirie +2",hands="Meghanada Gloves +2",ring2="Ilabrat Ring",
        back="Camulus's Mantle",waist="Fotia Belt",legs="Meghanada Chausses +2",feet="Meghanada Jambeaux +2"})	

	sets.precast.WS['Wildfire'] = set_combine(sets.precast.WS, {ammo=gear.MAbullet,
        head="Herculean Helm",neck="Baetyl Pendant",ear1="Crematio Earring",ear2="Friomisi Earring",
        body="Lanun Frac +3",hands="Carmine Finger Gauntlets +1",
        back="Camulus's Mantle",waist="Eschan Stone",legs="Laksamana's Trews +2",feet="Lanun Bottes +3"})

    sets.precast.WS['Wildfire'].Brew = {ammo=gear.MAbullet,
        head="Herculean Helm",neck="Baetyl Pendant",ear1="Crematio Earring",ear2="Friomisi Earring",
        body="Lanun Frac +3",hands="Carmine Finger Gauntlets +1",
        back="Camulus's Mantle",waist="Eschan Stone",legs="Laksamana's Trews +2",feet="Lanun Bottes +3"}
    
    sets.precast.WS['Leaden Salute'] = set_combine(sets.precast.WS['Wildfire'], {head="Pixie Hairpin +1",ear1="Moonshade Earring",ring1="Archon Ring"})
	
	sets.precast.WS['Leaden Salute'].FullTP = set_combine(sets.precast.WS['Wildfire'], {head="Pixie Hairpin +1",ear1="Moonshade Earring",ring1="Archon Ring"})
    
    
    -- Midcast Sets
    sets.midcast.FastRecast = {head="Carmine Mask",neck="Orunmila's Torque",
	ear1="Etiolation Earring",ear2="Loquacious Earring",hands="Leyline Gloves",body="Laksamana's Frac +3",
	ring1="Kishar Ring",ring2="Lebeche Ring",legs="Herculean Trousers",feet="Carmine Greaves"}
        
    -- Specific spells
    sets.midcast.Utsusemi = sets.midcast.FastRecast

    sets.midcast.CorsairShot = {ammo=gear.MAbullet,
        head="Herculean Helm",neck="Baetyl Pendant",ear1="Crematio Earring",ear2="Friomisi Earring",
        body="Lanun Frac +3",hands="Carmine Finger Gauntlets +1",ring1="Dingir Ring",ring2="Shiva Ring +1",
        back="Gunslinger's Cape",waist="Eschan Stone",legs="Herculean Trousers",feet="Lanun Bottes +3"}

    sets.midcast.CorsairShot.Acc = {ammo=gear.Accbullet,
        head="Laksamana's Tricorne +2",neck="Sanctity Necklace",ear1="Gwati Earring",ear2="Dignitary's Earring",
        body="Lanun Frac +3",hands="Laksamana's Gants +2",ring1="Regal Ring",ring2="Metamorph Ring +1",
        back="Gunslinger's Cape",waist="Kwahu Kachina Belt +1",legs="Malignance Tights",feet="Laksamana's Bottes +2"}

    sets.midcast.CorsairShot['Light Shot'] = {ammo=gear.Accbullet,	
        head="Laksamana's Tricorne +2",neck="Sanctity Necklace",ear1="Gwati Earring",ear2="Dignitary's Earring",
        body="Mirke Wardecors",hands="Laksamana's Gants +2",ring1="Regal Ring",ring2="Metamorph Ring +1",
        back="Gunslinger's Cape",waist="Kwahu Kachina Belt +1",legs="Malignance Tights",feet="Laksamana's Bottes +2"}

    sets.midcast.CorsairShot['Dark Shot'] = set_combine(sets.midcast.CorsairShot['Light Shot'], {ring="Archon Ring"})


    -- Ranged gear
    sets.midcast.RA = {
        head="Ikenga's Hat",neck="Iskur Gorget",ear1="Enervating Earring",ear2="Telos Earring",
        body="Ikenga's Vest",hands="Malignance Gloves",ring1="Dingir Ring",ring2="Ilabrat Ring",
        back="Camulus's Mantle",waist="Yemaya Belt",legs="Ikenga's Trousers",feet="Malignance Boots"}

    sets.midcast.RA.Acc = {
        head="Meghanada Visor +2",neck="Combatant's Torque",ear1="Enervating Earring",ear2="Telos Earring",
        body="Meghanada Cuirie +2",hands="Malignance Gloves",ring1="Cacoethic Ring",ring2="Cacoethic Ring +1",
        back="Camulus's Mantle",waist="Kwahu Kachina Belt +1",legs="Malignance Tights",feet="Malignance Boots"}
			
	sets.midcast.RA.Critical = {
        head="Meghanada Visor +2",neck="Iskur Gorget",ear1="Odr Earring",ear2="Telos Earring",
        body="Meghanada Cuirie +2",hands="Mummu Wrists +2",ring1="Mummu Ring",ring2="Ilabrat Ring",
        back="Camulus's Mantle",waist="Kwahu Kachina Belt +1",legs="Darraigner's Brais",feet="Oshosi Leggings"}

	sets.TripleShot = set_combine(sets.midcast.RA, {
		head="Oshosi Mask",
        body="Chasseur's Frac +1",hands="Lanun Gants +3",waist="Kwahu Kachina Belt +1",feet="Oshosi Leggings"
       })
       

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {head="Meghanada Visor +2",neck="Bathy Choker +1",ear1="Infused Earring",ear2="Eabani Earring",
	body="Meghanada Cuirie +2",hands="Meghanada Gloves +2",ring1="Meghanada Ring",ring2="Sheltered Ring",
	back="Scuta Cape",legs="Meghanada Chausses +2",feet="Meghanada Jambeaux +2"}
    

    -- Idle sets
    sets.idle = {
    head="Meghanada Visor +2",neck="Bathy Choker +1",ear1="Infused Earring",ear2="Hearty Earring",body="Meghanada Cuirie +2",
	hands="Meghanada Gloves +2",ring1="Meghanada Ring",ring2="Sheltered Ring",
	back="Solemnity Cape",waist="Flume Belt",legs="Meghanada Chausses +2",feet="Meghanada Jambeaux +2"}

    sets.idle.Town = {main="Naegling", sub="Tauret",range="Death Penalty",ammo="Living Bullet",
        head="Ikenga's Hat",neck="Iskur Gorget",ear1="Enervating Earring",ear2="Telos Earring",
        body="Ikenga's Vest",hands="Malignance Gloves",ring1="Regal Ring",ring2="Ilabrat Ring",
        back="Camulus's Mantle",waist="Yemaya Belt",legs="Carmine Cuisses +1",feet="Malignance Boots"}
    
    -- Defense sets
    sets.defense.PDT = {
        head="Meghanada Visor +2",neck="Loricate Torque +1",ear1="Hibernation Earring",ear2="Colossus's Earring",
        body="Meghanada Cuirie +2",hands="Malignance Gloves",ring1="Defending Ring",ring2="Gelatinous Ring +1",
        back="Shadow Mantle",waist="Flume Belt",legs="Malignance Tights",feet="Malignance Boots"}

    sets.defense.MDT = {
        head="Dampening Tam",neck="Loricate Torque +1",ear1="Odnowa Earring +1",ear2="Etiolation Earring",
        body="Meghanada Cuirie +2",hands="Malignance Gloves",ring1="Defending Ring",ring2="Shadow Ring",
        back="Solemnity Cape",waist="Flax Sash",legs="Malignance Tights",feet="Malignance Boots"}
    

    sets.Kiting = {legs="Carmine Cuisses +1"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged.Melee = {
        head="Adhemar Bonnet +1",neck="Clotharius Torque",ear1="Brutal Earring",ear2="Cessance Earring",
        body="Adhemar Jacket +1",hands="Malignance Gloves",ring1="Epona's Ring",ring2="Petrov Ring",
        back="Bleating Mantle",waist="Windbuffet Belt +1",legs="Samnuha Tights",feet="Malignance Boots"}
    
    sets.engaged.Acc = {
        head="Adhemar Bonnet +1",neck="Combatant's Torque",ear1="Dignitary's Earring",ear2="Telos Earring",
        body="Adhemar Jacket +1",hands="Malignance Gloves",ring1="Cacoethic Ring +1",ring2="Cacoethic Ring",
        back="Grounded Mantle +1",waist="Reiki Yotai",legs="Malignance Tights",feet="Malignance Boots"}

    sets.engaged.Melee.DW = {main="Naegling", sub="Tauret",
        head="Adhemar Bonnet +1",neck="Clotharius Torque",ear1="Suppanomimi",ear2="Eabani Earring",
        body="Adhemar Jacket +1",hands="Floral Gauntlets",ring1="Epona's Ring",ring2="Petrov Ring",
        back="Bleating Mantle",waist="Reiki Yotai",legs="Samnuha Tights",feet="Malignance Boots"}
    
    sets.engaged.Acc.DW = {main="Naegling", sub="Tauret",
        head="Adhemar Bonnet +1",neck="Combatant's Torque",ear1="Suppanomimi",ear2="Telos Earring",
        body="Adhemar Jacket +1",hands="Malignance Gloves",ring1="Cacoethic Ring +1",ring2="Cacoethic Ring",
        back="Grounded Mantle +1",waist="Reiki Yotai",legs="Malignance Tights",feet="Malignance Boots"}


    sets.engaged.Ranged = {
        head="Meghanada Visor +2",neck="Iskur Gorget",ear1="Enervating Earring",ear2="Telos Earring",
        body="Meghanada Cuirie +2",hands="Malignance Gloves","Cacoethic Ring +1",ring2="Cacoethic Ring",
        back="Camulus's Mantle",waist="Kwahu Kachina Belt +1",legs="Malignance Tights",feet="Malignance Boots"}
		
	--- Special Sets ---
	
	sets.Obi = {waist="Hachirin-no-Obi"}
	
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    -- Check that proper ammo is available if we're using ranged attacks or similar.
    if spell.action_type == 'Ranged Attack' or spell.type == 'WeaponSkill' or spell.type == 'CorsairShot' then
        do_bullet_checks(spell, spellMap, eventArgs)
    end

    -- gear sets
    if (spell.type == 'CorsairRoll' or spell.english == "Double-Up") and state.LuzafRing.value then
        equip(sets.precast.LuzafRing)
    elseif spell.type == 'CorsairShot' and state.CastingMode.value == 'Resistant' then
        classes.CustomClass = 'Acc'
    elseif spell.english == 'Fold' and buffactive['Bust'] == 2 then
        if sets.precast.FoldDoubleBust then
            equip(sets.precast.FoldDoubleBust)
            eventArgs.handled = true
        end
    end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'CorsairRoll' and not spell.interrupted then
        display_roll_info(spell)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Return a customized weaponskill mode to use for weaponskill sets.
-- Don't return anything if you're not overriding the default value.
function get_custom_wsmode(spell, spellMap, default_wsmode)
    if buffactive['Transcendancy'] then
        return 'Brew'
    end
end


-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    if newStatus == 'Engaged' and player.equipment.main == 'Chatoyant Staff' then
        state.OffenseMode:set('Ranged')
    end
end


-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    local msg = ''
    
    msg = msg .. 'Off.: '..state.OffenseMode.current
    msg = msg .. ', Rng.: '..state.RangedMode.current
    msg = msg .. ', WS.: '..state.WeaponskillMode.current
    msg = msg .. ', QD.: '..state.CastingMode.current

    if state.DefenseMode.value ~= 'None' then
        local defMode = state[state.DefenseMode.value ..'DefenseMode'].current
        msg = msg .. ', Defense: '..state.DefenseMode.value..' '..defMode
    end
    
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end
    
    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value then
        msg = msg .. ', Target NPCs'
    end

    msg = msg .. ', Roll Size: ' .. ((state.LuzafRing.value and 'Large') or 'Small')
    
    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function define_roll_values()
    rolls = {
        ["Corsair's Roll"]   = {lucky=5, unlucky=9, bonus="Experience Points"},
        ["Ninja Roll"]       = {lucky=4, unlucky=8, bonus="Evasion"},
        ["Hunter's Roll"]    = {lucky=4, unlucky=8, bonus="Accuracy"},
        ["Chaos Roll"]       = {lucky=4, unlucky=8, bonus="Attack"},
        ["Magus's Roll"]     = {lucky=2, unlucky=6, bonus="Magic Defense"},
        ["Healer's Roll"]    = {lucky=3, unlucky=7, bonus="Cure Potency Received"},
        ["Puppet Roll"]      = {lucky=4, unlucky=8, bonus="Pet Magic Accuracy/Attack"},
        ["Choral Roll"]      = {lucky=2, unlucky=6, bonus="Spell Interruption Rate"},
        ["Monk's Roll"]      = {lucky=3, unlucky=7, bonus="Subtle Blow"},
        ["Beast Roll"]       = {lucky=4, unlucky=8, bonus="Pet Attack"},
        ["Samurai Roll"]     = {lucky=2, unlucky=6, bonus="Store TP"},
        ["Evoker's Roll"]    = {lucky=5, unlucky=9, bonus="Refresh"},
        ["Rogue's Roll"]     = {lucky=5, unlucky=9, bonus="Critical Hit Rate"},
        ["Warlock's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Accuracy"},
        ["Fighter's Roll"]   = {lucky=5, unlucky=9, bonus="Double Attack Rate"},
        ["Drachen Roll"]     = {lucky=3, unlucky=7, bonus="Pet Accuracy"},
        ["Gallant's Roll"]   = {lucky=3, unlucky=7, bonus="Defense"},
        ["Wizard's Roll"]    = {lucky=5, unlucky=9, bonus="Magic Attack"},
        ["Dancer's Roll"]    = {lucky=3, unlucky=7, bonus="Regen"},
        ["Scholar's Roll"]   = {lucky=2, unlucky=6, bonus="Conserve MP"},
        ["Bolter's Roll"]    = {lucky=3, unlucky=9, bonus="Movement Speed"},
        ["Caster's Roll"]    = {lucky=2, unlucky=7, bonus="Fast Cast"},
        ["Courser's Roll"]   = {lucky=3, unlucky=9, bonus="Snapshot"},
        ["Blitzer's Roll"]   = {lucky=4, unlucky=9, bonus="Attack Delay"},
        ["Tactician's Roll"] = {lucky=5, unlucky=8, bonus="Regain"},
        ["Allies's Roll"]    = {lucky=3, unlucky=10, bonus="Skillchain Damage"},
        ["Miser's Roll"]     = {lucky=5, unlucky=7, bonus="Save TP"},
        ["Companion's Roll"] = {lucky=2, unlucky=10, bonus="Pet Regain and Regen"},
        ["Avenger's Roll"]   = {lucky=4, unlucky=8, bonus="Counter Rate"},
		["Runeist's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Evasion"},
		["Naturalist's Roll"]   = {lucky=3, unlucky=7, bonus="Enhancing Duration"},
    }
end

function display_roll_info(spell)
    rollinfo = rolls[spell.english]
    local rollsize = (state.LuzafRing.value and 'Large') or 'Small'

    if rollinfo then
        add_to_chat(104, spell.english..' provides a bonus to '..rollinfo.bonus..'.  Roll size: '..rollsize)
        add_to_chat(104, 'Lucky roll is '..tostring(rollinfo.lucky)..', Unlucky roll is '..tostring(rollinfo.unlucky)..'.')
    end
end

-- Gear sets for Triple Shot and Matching Day/Weather
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Ranged Attack' then
        if state.FlurryMode.value == 'Flurry II' and (buffactive[265] or buffactive[581]) then
            equip(sets.precast.RA.Flurry2)
        elseif state.FlurryMode.value == 'Flurry I' and (buffactive[265] or buffactive[581]) then
            equip(sets.precast.RA.Flurry1)
        end
    end    -- Equip obi if weather/day matches for WS/Quick Draw.
    if spell.type == 'WeaponSkill' then
        if spell.english == 'Leaden Salute' then
            if world.weather_element == 'Dark' or world.day_element == 'Dark' then
                equip(sets.Obi)
            end
            if player.TP > 2900 then
                equip(sets.precast.WS['Leaden Salute'].FullTP)
            end    
        elseif spell.english == 'Wildfire' and (world.weather_element == 'Fire' or world.day_element == 'Fire') then
            equip(sets.Obi)
        end
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Ranged Attack' and buffactive['Triple Shot'] then
        equip(sets.TripleShot)
    end
    if spell.type == 'CorsairShot' then
        if spell.english ~= "Light Shot" and spell.english ~= "Dark Shot" then
            equip(sets.Obi)
        end
    end
end


-- Determine whether we have sufficient ammo for the action being attempted.
function do_bullet_checks(spell, spellMap, eventArgs)
    local bullet_name
    local bullet_min_count = 1
    
    if spell.type == 'WeaponSkill' then
        if spell.skill == "Marksmanship" then
            if spell.element == 'None' then
                -- Physical wWeaponskills
                bullet_name = gear.WSbullet
            else
                -- Magical Weaponskills
                bullet_name = gear.MAbullet
				
			end
            -- Ignore non-ranged weaponskills
            return
        end
    elseif spell.type == 'CorsairShot' then
        bullet_name = gear.QDbullet
    elseif spell.action_type == 'Ranged Attack' then
        bullet_name = gear.RAbullet
        if buffactive['Triple Shot'] then
            bullet_min_count = 3
        end
    end
    
    local available_bullets = player.inventory[bullet_name] or player.wardrobe[bullet_name]
    
    -- If no ammo is available, give appropriate warning and end.
    if not available_bullets then
        if spell.type == 'CorsairShot' and player.equipment.ammo ~= 'empty' then
            add_to_chat(104, 'No Quick Draw ammo left.  Using what\'s currently equipped ('..player.equipment.ammo..').')
            return
        elseif spell.type == 'WeaponSkill' and player.equipment.ammo == gear.RAbullet then
            add_to_chat(104, 'No weaponskill ammo left.  Using what\'s currently equipped (standard ranged bullets: '..player.equipment.ammo..').')
            return
        else
            add_to_chat(104, 'No ammo ('..tostring(bullet_name)..') available for that action.')
            eventArgs.cancel = true
            return
        end
    end
    
    -- Don't allow shooting or weaponskilling with ammo reserved for quick draw.
    if spell.type ~= 'CorsairShot' and bullet_name == gear.QDbullet and available_bullets.count <= bullet_min_count then
        add_to_chat(104, 'No ammo will be left for Quick Draw.  Cancelling.')
        eventArgs.cancel = true
        return
    end
    
    -- Low ammo warning.
    if spell.type ~= 'CorsairShot' and state.warned.value == false
        and available_bullets.count > 1 and available_bullets.count <= options.ammo_warning_limit then
        local msg = '*****  LOW AMMO WARNING: '..bullet_name..' *****'
        --local border = string.repeat("*", #msg)
        local border = ""
        for i = 1, #msg do
            border = border .. "*"
        end
        
        add_to_chat(104, border)
        add_to_chat(104, msg)
        add_to_chat(104, border)

        state.warned:set()
    elseif available_bullets.count > options.ammo_warning_limit and state.warned then
        state.warned:reset()
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 8)
end
