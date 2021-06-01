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
    state.Buff.Hasso = buffactive.Hasso or false
    state.Buff.Seigan = buffactive.Seigan or false
    state.Buff.Sekkanoki = buffactive.Sekkanoki or false
    state.Buff.Sengikori = buffactive.Sengikori or false
    state.Buff['Meikyo Shisui'] = buffactive['Meikyo Shisui'] or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'PDT', 'Hybrid', 'Hybrid2', 'Ejin', 'MEAV','MEAVFEET')
    state.HybridMode:options('Normal', 'PDT', 'Reraise')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
    state.PhysicalDefenseMode:options('PDT', 'Reraise')

    update_combat_form()
    
    -- Additional local binds
    send_command('bind ^` input /ja "Hasso" <me>')
    send_command('bind !` input /ja "Seigan" <me>')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !-')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
   -- include('yer_augmented-items.lua')
	
	CapeSTP = { name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
	CapeWSD = { name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Damage taken-5%',}}
    CapeSNAP = { name="Smertrios's Mantle", augments={'"Snapshot"+10',}}
    CapeRNG = { name="Smertrios's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Store TP"+10',}}
    CapeRNGWS = { name="Smertrios's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}}
	
    -- Precast Sets
    -- Precast sets to enhance JAs
    sets.precast.JA.Meditate = {head="Wakido Kabuto +1",hands="Sakonji Kote", back=CapeSTP} --yer orginal
    sets.precast.JA['Warding Circle'] = {head="Wakido Kabuto +1"}
    sets.precast.JA['Blade Bash'] = {hands="Sakonji Kote"}
	sets.precast.JA['Provoke'] = {
		ammo="Iron Gobbet",
		head="Loess Barbuta",
		neck="Unmoving Collar",
		body="Emet Harness +1",
		hands="Macabre Gauntlets +1",
		ring1="Petrov Ring",
		back="Agema Cape",
		legs="Zoar Subligar +1"
		}
	
	
    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Yaoyotl Helm",
        body="Otronif Harness +1",hands="Buremte Gloves",ring1="Spiral Ring",
        back="Iximulew Cape",waist="Caudata Belt",legs="Karieyh Brayettes +1",feet="Otronif Boots +1"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {ammo="Knobkierrie",
        head="Mpaca's Cap",
		neck="Samurai's Nodowa +2",
		ear1="Ishvara Earring",ear2="Moonshade Earring",
        body="Sakonji Domaru +3",
		hands="Valorous mitts",
		ring1="Niqmaddu Ring",ring2="Regal Ring",
        back=CapeWSD,
		waist="Fotia Belt",
		legs="Wakido haidate +3",
		feet="Valorous Greaves"
		}
    
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {back="Letalis Mantle"})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Tachi: Fudo'] = set_combine(sets.precast.WS, 
		{ammo="Knobkierrie",
        head="Mpaca's Cap",
		neck="Samurai's Nodowa +2",
		ear1="Thrud Earring",ear2="Moonshade Earring",
        body="Sakonji Domaru +3",
		hands="Valorous mitts",
		ring1="Niqmaddu Ring",ring2="Regal Ring",
        back=CapeWSD,
		waist="Sailfi Belt +1",
		legs="Wakido haidate +3",
		feet="Valorous Greaves"
		})
		
    sets.precast.WS['Tachi: Fudo'].Acc = set_combine(sets.precast.WS.Acc, {
		
		})
		
    sets.precast.WS['Tachi: Fudo'].Mod = set_combine(sets.precast.WS['Tachi: Fudo'], {waist="Fotia Belt"})

    sets.precast.WS['Tachi: Shoha'] = set_combine(sets.precast.WS, {ammo="Knobkierrie",
        head="Mpaca's Cap",
		neck="Samurai's Nodowa +2",
		ear1="Thrud Earring",ear2="Moonshade Earring",
        body="Sakonji Domaru +3",
		hands="Valorous mitts",
		ring1="Niqmaddu Ring",ring2="Regal Ring",
        back=CapeWSD,
		waist="Fotia Belt",
		legs="Wakido haidate +3",
		feet="Valorous Greaves"
		})
    
	sets.precast.WS['Tachi: Shoha'].Acc = set_combine(sets.precast.WS.Acc, {
		
		})
    
	sets.precast.WS['Tachi: Shoha'].Mod = set_combine(sets.precast.WS['Tachi: Shoha'], {waist="Fotia Belt"})

 sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {ammo="Knobkierrie",
        head="Mpaca's Cap",
        neck="Samurai's Nodowa +2",
        ear1="Thrud Earring",ear2="Moonshade Earring",
        body="Sakonji Domaru +3",
        hands="Valorous mitts",
        ring1="Niqmaddu Ring",ring2="Regal Ring",
        back=CapeWSD,
        waist="Fotia Belt",
        legs="Wakido haidate +3",
        feet="Valorous Greaves"
        })
    
    sets.precast.WS['Impulse Drive'].Acc = set_combine(sets.precast.WS.Acc, {
        
        })
    
    sets.precast.WS['Impulse Drive'].Mod = set_combine(sets.precast.WS['Impulse Drive'], {waist="Fotia Belt"})

 sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS, {ammo="Knobkierrie",
        head="Mpaca's Cap",
        neck="Samurai's Nodowa +2",
        ear1="Thrud Earring",ear2="Moonshade Earring",
        body="Sakonji Domaru +3",
        hands="Valorous mitts",
        ring1="Niqmaddu Ring",ring2="Regal Ring",
        back=CapeWSD,
        waist="Fotia Belt",
        legs="Wakido haidate +3",
        feet="Valorous Greaves"
        })
    
    sets.precast.WS['Stardiver'].Acc = set_combine(sets.precast.WS.Acc, {
        
        })
    
    sets.precast.WS['Stardiver'].Mod = set_combine(sets.precast.WS['Stardiver'], {waist="Fotia Belt"})



    sets.precast.WS['Tachi: Rana'] = set_combine(sets.precast.WS, {
		ammo="Knobkierrie",
        head="Flamma Zucchetto +2",
		neck="Samurai's Nodowa +2",
		ear1="Thrud Earring",ear2="Moonshade Earring",
        body="Sakonji Domaru +3",
		hands="Founder's Gauntlets",
		ring1="Niqmaddu Ring",ring2="Regal Ring",
        back=CapeWSD,
		waist="Fotia Belt",
		legs="Wakido haidate +3",
		feet="Valorous Greaves"
		})
		
    sets.precast.WS['Tachi: Rana'].Acc = set_combine(sets.precast.WS.Acc, {
		neck="Fotia Gorget",})
    
	sets.precast.WS['Tachi: Rana'].Mod = set_combine(sets.precast.WS['Tachi: Rana'], {waist="Fotia Belt"})

    sets.precast.WS['Tachi: Kasha'] = set_combine(sets.precast.WS, {neck="Fotia Gorget",waist="Fotia Belt"})

    sets.precast.WS['Tachi: Gekko'] = set_combine(sets.precast.WS, {neck="Fotia Gorget",waist="Fotia Belt"})

    sets.precast.WS['Tachi: Yukikaze'] = set_combine(sets.precast.WS, {neck="Fotia Gorget",waist="Fotia Belt"})

    sets.precast.WS['Tachi: Ageha'] = set_combine(sets.precast.WS, {
		ammo="Knobkierrie",
        head="Flamma Zucchetto +2",
        body="Flamma Korazin +2",
        hands="Valorous mitts",
        legs="Wakido haidate +3",			
        feet="Valorous Greaves",
        neck="Samurai's Nodowa +2",
        waist="Fotia Belt",
        back=CapeWSD,
        left_ear="Gwati Earring",
        right_ear="Dignitary's Earring",
        left_ring="Regal Ring",
        right_ring="Flamma Ring",
		})

    sets.precast.WS['Tachi: Jinpu'] = set_combine(sets.precast.WS, {neck="Samurai's Nodowa +2",waist="Fotia Belt"})
	
	sets.precast.WS['Apex Arrow'] = {ranged="Yoichinoyumi",ammo="Yoichi's Arrow",
        head="Kendatsuba jinpachi +1",neck="Samurai's Nodowa +2",ear1="Thrud earring",ear2="Moonshade Earring",
        body="Kendatsuba Samue +1",hands="Kobo Kote",ring1="Regal Ring",ring2="Ilabrat ring",
        back=CapeRNGWS,waist="Fotia Belt",legs="Wakido haidate +3",feet="Kendatsuba Sune-Ate +1"}

sets.precast.WS['Namas Arrow'] = {ranged="Yoichinoyumi",ammo="Yoichi's Arrow",
        head="Kendatsuba jinpachi +1",neck="Samurai's Nodowa +2",ear1="Thrud earring",ear2="Moonshade Earring",
        body="Kendatsuba Samue +1",hands="Kobo Kote",ring1="Regal Ring",ring2="Ilabrat ring",
        back=CapeRNGWS,waist="Fotia Belt",legs="Wakido haidate +3",feet="Kendatsuba Sune-Ate +1"}

 sets.precast.RA = {
        head="Kendatsuba jinpachi +1",           
        body="Kendatsuba samue +1",             
        hands="Kobo Kote",
        ring2="Regal Ring",
        ring1="Haverton ring",
        back=CapeSNAP,
        neck="Sanctity Necklace",       
        waist="Yemaya Belt",          
        legs="Wakido haidate +3",           
        feet="Kendatsuba Sune-Ate +1"    
        } 
    -- Midcast Sets
    sets.midcast.FastRecast = {
        head="Valorous Mask",
        body="Kubira Meikogai",hands="Leyline Gloves",ear1="Loquacious earring",ear2="Enchanter earring +1",
        legs=ValPantsSTP,feet="Amm Greaves",neck="Baetyl Pendant"}

	-- Ranged gear
	sets.midcast.RA = {
		head="Kendatsuba Kabuto +1",neck="Sanctity Necklace",ear1="Telos earring",ear2="Enervating Earring",
		body="Kendatsuba samue +1",hands="Kobo Kote",ring1="Haverton ring",ring2="Regal Ring",
		back=CapeRNG,waist="Yemaya Belt",legs="Wakido haidate +3",feet="Kendatsuba Sune-Ate +1"}
    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {neck="Sanctity Necklace",ring1="Sheltered Ring",ring2="Paguroidea Ring"}
    

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle.Town = {ammo="Staunch Tathlum +1",
        head="Valorous Mask",neck="Bathy Choker +1",ear1="Infused Earring",ear2="Etiolation Earring",
        body="Wakido Domaru +3",hands="Wakido Kote +3",ring1="Gelatinous ring +1",ring2="Defending Ring",
        back="Moonbeam Cape",waist="Flume Belt",legs="Ryuo Hakama +1",feet="Nyame Sollerets"}
    
    sets.idle.Field = {ammo="Staunch Tathlum +1",
        head="Valorous Mask",neck="Loricate Torque +1",ear1="Infused Earring",ear2="Etiolation Earring",
        body="Wakido Domaru +3",hands="Wakido Kote +3",ring1="Gelatinous Ring +1",ring2="Defending Ring",
        back="Solemnity Cape",waist="Flume Belt",legs="Ryuo Hakama +1",feet="Nyame Sollerets"}

    sets.idle.Weak = {ammo="Staunch Tathlum +1",
        head="Valorous Mask",neck="Loricate Torque +1",ear1="Infused Earring",ear2="Etiolation Earring",
        body="Wakido Domaru +3",hands="Macabre Gauntlets",ring1="Gelatinous Ring +1",ring2="Defending Ring",
        back="Moonbeam Cape",waist="Flume Belt",legs="Ryuo Hakama +1",feet="Nyame Sollerets"}
    
    -- Defense sets
    sets.defense.PDT = {ammo="Staunch Tathlum +1",
        head="Flamma Zucchetto +2",neck="Loricate Torque +1",ear1="Genmei Earring",ear2="Etiolation Earring",
        body="Wakido Domaru +3",hands="Founder's Gauntlets",ring1="Gelatinous Ring +1",ring2="Defending Ring",
        back="Solemnity Cape",waist="Flume Belt",legs="Ryuo Hakama +1",feet="Amm Greaves"}

    sets.defense.Reraise = {ammo="Staunch Tathlum +1",
        head="Twilight Helm",neck="Loricate Torque +1",ear1="Infused Earring",ear2="Etiolation Earring",
        body="Twilight Mail",hands="Macabre Gauntlets +1",ring1="Dark Ring",ring2="Defending Ring",
        back="Moonbeam Cape",waist="Flume Belt",legs=ValPantsSTP,feet="Amm Greaves"}

    sets.defense.MDT = {ammo="Staunch Tathlum +1",
        head="Kendatsuba jinpachi +1",neck="Loricate Torque +1",ear1="Odnowa Earring +1",ear2="Etiolation Earring",
        body="Kendatsuba samue +1",hands="Wakido kote +3",ring1="Dark Ring",ring2="Defending Ring",
        back="Moonbeam Cape",waist="Flume Belt",legs="Kendatsuba hakama +1",feet="Kendatsuba Sune-Ate +1"}

    sets.Kiting = {feet="Danzo Sune-ate"}

    sets.Reraise = {head="Twilight Helm",body="Twilight Mail"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    -- Delay 450 GK, 57 STP for 4 hit w/ max gift/merits
    sets.engaged = {ammo="Ginsen",
        head="Flamma Zucchetto +2",
		neck="Samurai's Nodowa +2",
		ear1="Telos Earring",ear2="Dedition Earring",
        body="Kasuga domaru +1",
		hands="Wakido Kote +3",
		ring1="Niqmaddu Ring",ring2="Flamma Ring",
        back=CapeSTP,
		waist="Ioskeha Belt +1 +1",
		legs="Ryuo Hakama +1",
		feet="Ryuo Sune-Ate +1"
		}
    
	sets.engaged.Acc = {
        
    sub="Utu Grip",
    ammo="Ginsen",
    head="Flam. Zucchetto +2",
    body={ name="Tatena. Harama. +1", augments={'Path: A',}},
    hands="Wakido Kote +3",
    legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
    feet={ name="Ryuo Sune-Ate +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
    neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
    waist="Ioskeha Belt +1",
    left_ear="Telos Earring",
    right_ear="Dedition Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Chirich Ring +1",
    back=CapeSTP
    

		}
   
   sets.engaged.PDT = {ammo="Staunch Tathlum +1",
        head="Flamma Zucchetto +2",
		neck="Loricate Torque +1",
		ear1="Genmei Earring",ear2="Etiolation Earring",
        body="Wakido Domaru +3",
		hands="Wakido Kote +3",
		ring1="Gelatinous ring +1",ring2="Defending Ring",
        back=CapeSTP,
		waist="Flume Belt",
		legs="Ryuo Hakama +1",
		feet="Flamma Gambieras +2"}

    sets.engaged.Hybrid = {ammo="Staunch Tathlum +1",
        head="Kendatsuba jinpachi +1",
        neck="Loricate Torque +1",
        ear1="Genmei Earring",ear2="Etiolation Earring",
        body="Kendatsuba samue +1",
        hands="Wakido Kote +3",
        ring1="Gelatinous ring +1",ring2="Defending Ring",
        back=CapeSTP,
        waist="Flume Belt",
        legs="Kendatsuba hakama +1",
        feet="Kendatsuba Sune-Ate +1"}

        sets.engaged.Hybrid2 = {ammo="Staunch Tathlum +1",
        head="Kendatsuba jinpachi +1",
        neck="Samurai's Nodowa +2",
        ear1="Genmei Earring",ear2="Etiolation Earring",
        body="Wakido Domaru +3",
        hands="Wakido Kote +3",
        ring1="Gelatinous ring +1",ring2="Defending Ring",
        back=CapeSTP,
        waist="Flume Belt",
        legs="Kendatsuba hakama +1",
        feet="Kendatsuba Sune-Ate +1"}

        sets.engaged.MEAV = {ammo="Ginsen",
        head="Kendatsuba jinpachi +1",
        neck="Samurai's Nodowa +2",
        ear1="Telos Earring",ear2="Dedition Earring",
        body="Kendatsuba samue +1",
        hands="Wakido Kote +3",
        ring1="Niqmaddu Ring",ring2="Flamma Ring",
        back=CapeSTP,
        waist="Ioskeha Belt +1",
        legs="Kendatsuba hakama +1",
        feet="Kendatsuba Sune-Ate +1"}

        sets.engaged.MEAVFEET = {ammo="Ginsen",
        head="Kendatsuba jinpachi +1",
        neck="Samurai's Nodowa +2",
        ear1="Telos Earring",ear2="Dedition Earring",
        body="Kendatsuba samue +1",
        hands="Wakido Kote +3",
        ring1="Niqmaddu",ring2="Flamma Ring",
        back=CapeSTP,
        waist="Ioskeha Belt +1",
        legs="Kendatsuba hakama +1",
        feet="Ryuo Sune-Ate +1"}

        sets.engaged.Ejin = {ammo="Ginsen",
        head="Flamma Zucchetto +2",
        neck="Samurai's Nodowa +2",
        ear1="Brutal Earring",ear2="Dedition Earring",
        body="Kendatsuba samue +1",
        hands="Wakido Kote +3",
        ring1="Niqmaddu Ring",ring2="Flamma Ring",
        back=CapeSTP,
        waist="Ioskeha Belt +1",
        legs="Kendatsuba hakama +1",
        feet="Ryuo Sune-Ate +1"}
   
   sets.engaged.Acc.PDT = {ammo="Staunch Tathlum +1",
        head="Flamma Zucchetto +2",
		neck="Samurai's Nodowa +2",
		ear1="Telos Earring",ear2="Brutal Earring",
        body="Flamma Korazin +2",
		hands="Wakido Kote +2",
		ring1="Niqmaddu Ring",ring2="Flamma Ring",
        back=CapeSTP,
		waist="Ioskeha Belt +1",
		legs="Flamma Dirs +2",
		feet="Flamma Gambieras +2"}
    
	sets.engaged.Reraise = {ammo="Staunch Tathlum +1",
        head="Twilight Helm",neck="Loricate Torque +1",ear1="Infused Earring",ear2="Etiolation Earring",
        body="Twilight Mail",hands="Macabre Gauntlets +1",ring1="Dark Ring",ring2="Defending Ring",
        back="Moonbeam Cape",waist="Flume Belt",legs=ValPantsSTP,feet="Amm Greaves"}
    
	sets.engaged.Acc.Reraise = {ammo="Staunch Tathlum +1",
        head="Twilight Helm",neck="Loricate Torque +1",ear1="Infused Earring",ear2="Etiolation Earring",
        body="Twilight Mail",hands="Macabre Gauntlets +1",ring1="Dark Ring",ring2="Defending Ring",
        back="Moonbeam Cape",waist="Flume Belt",legs=ValPantsSTP,feet="Amm Greaves"}

    sets.buff.Sekkanoki = {hands="Unkai Kote +2"}
    sets.buff.Sengikori = {feet="Unkai Sune-Ate +2"}
    sets.buff['Meikyo Shisui'] = {feet="Sakonji Sune-Ate +1"}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then
        -- Change any GK weaponskills to polearm weaponskill if we're using a polearm.
        if player.equipment.main=='Quint Spear' or player.equipment.main=='Quint Spear' then
            if spell.english:startswith("Tachi:") then
                send_command('@input /ws "Penta Thrust" '..spell.target.raw)
                eventArgs.cancel = true
            end
        end
    end
end

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type:lower() == 'weaponskill' then
        if state.Buff.Sekkanoki then
            equip(sets.buff.Sekkanoki)
        end
        if state.Buff.Sengikori then
            equip(sets.buff.Sengikori)
        end
        if state.Buff['Meikyo Shisui'] then
            equip(sets.buff['Meikyo Shisui'])
        end
    end
end


-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Effectively lock these items in place.
    if state.HybridMode.value == 'Reraise' or
        (state.DefenseMode.value == 'Physical' and state.PhysicalDefenseMode.value == 'Reraise') then
        equip(sets.Reraise)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_combat_form()
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(1, 6)
    elseif player.sub_job == 'DNC' then
        set_macro_page(1, 6)
    elseif player.sub_job == 'THF' then
        set_macro_page(1, 6)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 6)
    else
        set_macro_page(1, 6)
    end
end

