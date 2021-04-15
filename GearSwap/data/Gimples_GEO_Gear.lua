-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant','MB','MBResist', 'FullResist')
    state.IdleMode:options('Normal', 'PDT')

    gear.default.obi_waist = "Yamabuki-no-obi"

    select_default_macro_book()
end


-- Define sets and vars used by this job file.
function init_gear_sets()

	include('Gimples_augmented-items.lua')

    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA.Bolster = {body="Bagua Tunic +1"}
    sets.precast.JA['Life cycle'] = {body="Geomancy Tunic +3",back=gear.NantoGEO}
	sets.precast.JA['Full Circle'] = {head="Azimuth hood +1",hands="Bagua mitaines +1",back="Nantosuelta's cape"}
	sets.precast.JA['Radial Arcana'] = {feet="Bagua sandals +1"}

    -- Fast cast sets for spells

    sets.precast.FC = {main="Sucellus",range="Dunna",
        head=gear.MerlinHeadFC,neck="Orunmila's torque",ear1="Loquac. Earring",ear2="Etiolation Earring",
        body=gear.MerlinBodyMB,hands=gear.MerlinHandsFC,ring1="Kishar ring",ring2="Rahab Ring",
        back="Lifestream cape",waist="Witful belt",legs="Geomancy pants +1",feet=gear.MerlinFeetFC}
		
	sets.precast.FC['Stoneskin'] = set_combine(sets.precast.FC, {})
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {})
    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {ear2="Barkarole earring",hands="Bagua mitaines +1"})
    sets.precast.FC.Cure = set_combine(sets.precast.FC, {main="Serenity",
		ear2="Mendicant's earring",
		body="Heka's Kalasiris",
		back="Pahtli Cape"})
	sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.Impact = set_combine(sets.precast.FC['Elemental Magic'], {head=empty,body="Twilight Cloak"})
	
	sets.precast.Geomancy = set_combine(sets.precast.FC, {range="Dunna"})
	sets.precast.Geomancy.Indi = set_combine(sets.precast.FC, {range="Dunna"})

    
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head="Jhakri coronal +2",neck="Combatant's torque",ear1="Telos earring",ear2="Cessance earring",
        body="Jhakri robe +2",hands="Jhakri cuffs +2",ring1="Cacoethic ring +1",ring2="Rajas ring",
        back=gear.NantoGEO,waist="Eschan stone",legs="Jhakri slops +2",feet="Jhakri pigaches +2"}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Flash Nova'] = {ammo="Pemphredo tathlum",
        head=gear.MerlinHeadMB,neck="Baetyl pendant",ear1="Regal earring",ear2="Barkarole earring",
        body=gear.MerlinBodyMB,hands="Amalric gages",ring1="Mujin band",ring2="Acumen ring",
        back=gear.NantoMB,waist=gear.ElementalObi,legs=gear.MerlinLegsMB,feet=gear.MerlinFeetMB}

    sets.precast.WS['Starlight'] = {ear2="Moonshade Earring"}

    sets.precast.WS['Moonlight'] = {ear2="Moonshade Earring"}


    --------------------------------------
    -- Midcast sets
    --------------------------------------

    -- Base fast recast for spells
	
    sets.midcast.FastRecast = {main="Sucellus",sub="Ammurapi shield",range="Dunna",
        head="Vanya Hood",neck="Orunmila's torque",ear1="Loquac. Earring",ear2="Etiolation Earring",
        body="Amalric Doublet",hands=gear.MerlinHandsFC,ring1="Kishar ring",ring2="Rahab Ring",
        back="Lifestream cape",waist="Witful belt",legs="Geomancy pants +1",feet=gear.MerlinFeetFC}

	--425 Geomancy/Handbell Skill = 850, need 50 in gear to cap at 900	(18+20+15=53). Therefore, conserve MP in other slots**
	
    sets.midcast.Geomancy = {main="Idris",sub="Genbu's Shield",range="Dunna", --18 bell
		head="Vanya Hood",neck="Incanter's Torque",ear2="Gwati Earring", -- 20 neck (10+10 from Incanter)
		body="Amalric doublet",hands="Geomancy Mitaines +1", -- 15 hands
		back="Solemnity cape",legs="Vanya Slops",feet=gear.MerlinFeetFC} 
		
    sets.midcast.Geomancy.Indi = {main="Idris",sub="Genbu's Shield",range="Dunna",
		head="Vanya Hood",neck="Incanter's Torque",ear2="Gwati Earring",
		body="Amalric doublet",hands="Geomancy Mitaines +1",
		back=gear.NantoGEO,legs="Bagua Pants +1",feet="Azimuth Gaiters +1"}

	--Curing
		
    sets.midcast.Cure = {main="Serenity",sub="Enki Strap",ammo="Pemphredo Tathlum",
        head="Vanya hood",neck="Incanter's Torque",ear1="Novia earring",ear2="Mendicant's earring",
        body="Vanya robe",hands="Vanya cuffs",ring1="Sirona's ring",ring2="Lebeche ring",
        back="Solemnity cape",waist="Bishop's sash",legs="Vanya slops",feet="Vanya clogs"}
    
    sets.midcast.Curaga = sets.midcast.Cure
	
	sets.midcast.Cursna = {
        head="Vanya Hood",neck="Malison Medallion",
        body="Vanya Robe",hands="Vanya cuffs",ring1="Haoma's Ring",ring2="Haoma's Ring",
        legs="Vanya Slops",feet="Gendewitha Galoshes +1"}
	
	--Enhancements		
		
	sets.midcast['Enhancing Magic'] = {
        head="Befouled crown",neck="Colossus's Torque",ear1="Andoaa earring",
        body="Telchine chasuble",hands="Ayao's Gages",
        back="Merciful cape",waist="Olympus sash",legs="Shedir seraweels",feet="Regal pumps +1"}
			
	sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'], {
		legs="Shedir seraweels"})
	
	sets.midcast.EnhancingDuration = set_combine(sets.midcast['Enhancing Magic'], {
		main="Gada",
		sub="Ammurapi shield",
		head=gear.TelchineHeadDURATION,
		body=gear.TelchineBodyDURATION,
		hands=gear.TelchineHandsDURATION,
		legs=gear.TelchineLegsDURATION,
		feet=gear.TelchineFeetDURATION,
		})

    sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {main="Bolelabunga",sub="Ammurapi shield"})
	sets.midcast['Haste'] = sets.midcast.EnhancingDuration
	sets.midcast['Flurry'] = sets.midcast.EnhancingDuration
	sets.midcast['Refresh'] = set_combine(sets.midcast.EnhancingDuration, {waist="Gishdubar sash"})
	sets.midcast['Blink'] = sets.midcast.EnhancingDuration
    sets.midcast.Storm = sets.midcast.EnhancingDuration
	
	sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {
		main="Vadose Rod",legs="Shedir seraweels"})
		
	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
		neck="Stone gorget",legs="Shedir seraweels",waist="Siegel Sash"})

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {ring1="Sheltered Ring"})
    sets.midcast.Protectra = sets.midcast.Protect

    sets.midcast.Shell = set_combine(sets.midcast.EnhancingDuration, {ring1="Sheltered Ring"})
    sets.midcast.Shellra = sets.midcast.Shell
		
	-- Elemental Magic sets are default for handling low-tier nukes.
    sets.midcast['Elemental Magic'] = {main="Grioavolr",sub="Niobid Strap",ammo="Pemphredo tathlum",
        head=gear.MerlinHeadMB,neck="Sanctity necklace",ear1="Regal earring",ear2="Barkarole earring",
        body=gear.MerlinBodyMB,hands="Jhakri cuffs +2",ring1="Strendu ring",ring2="Acumen ring",
        back=gear.NantoMB,waist=gear.ElementalObi,legs=gear.MerlinLegsMB,feet=gear.MerlinFeetMB}
		
    sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
		sub="Enki Strap",
		})
		
	sets.midcast['Elemental Magic'].MB = set_combine(sets.midcast['Elemental Magic'], {
        neck="Mizukage-no-Kubikazari",
        hands="Amalric gages",
		ring1="Mujin band",
		})
		
	sets.midcast['Elemental Magic'].MBResist = set_combine(sets.midcast['Elemental Magic'].MB, {
        sub="Enki Strap",
		neck="Erra pendant",
        })
		
	sets.midcast['Elemental Magic'].FullResist = {main="Grioavolr",sub="Enki Strap",ammo="Pemphredo tathlum",
        head=gear.MerlinHeadMB,neck="Erra pendant",ear1="Regal earring",ear2="Barkarole earring",
        body=gear.MerlinBodyMB,hands="Jhakri cuffs +2",ring1="Mujin band",ring2="Acumen ring",
        back=gear.NantoMB,waist=gear.ElementalObi,legs=gear.MerlinLegsMB,feet=gear.MerlinFeetMB}
		

    sets.midcast.Impact = {main="Grioavolr",sub="Enki strap",ammo="Pemphredo tathlum",
        head=empty,neck="Erra pendant",ear1="Regal earring",ear2="Barkarole earring",
        body="Twilight cloak",hands="Jhakri cuffs +2",ring1="Perception ring",ring2="Etana Ring",
        back=gear.NantoMB,waist="Luminary Sash",legs="Psycloth lappas",feet="Geomancy sandals +3"}
		
	-- Custom spell classes
    sets.midcast.MndEnfeebles = {main="Grioavolr",sub="Enki strap",ammo="Pemphredo tathlum",
        head=gear.MerlinHeadMB,neck="Erra pendant",ear1="Regal earring",ear2="Dignitary's earring",
        body="Geomancy tunic +3",hands="Jhakri cuffs +2",ring1="Kishar ring",ring2="Etana Ring",
        back=gear.NantoMB,waist="Luminary Sash",legs="Psycloth lappas",feet="Geomancy sandals +3"}

    sets.midcast.IntEnfeebles = sets.midcast.MndEnfeebles

    sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles

	-- Dark Magic	
    sets.midcast['Dark Magic'] = set_combine(sets.midcast.MndEnfeebles, {main="Rubicundity",sub="Ammurapi shield",
        ring1="Archon ring",
		})

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {})

    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = {main="Grioavolr",sub="Enki strap",range="Dunna",
        head=gear.MerlinHeadMB,neck="Erra pendant",ear1="Enchanter earring +1",ear2="Loquacious earring",
        body="Geomancy tunic +3",hands="Jhakri cuffs +2",ring1="Perception ring",ring2="Sangoma Ring",
        back=gear.NantoMB,waist="Witful Belt",legs="Merlinic shalwar",feet="Geomancy sandals +3"}
		
	sets.midcast.Stun.Resistant = set_combine(sets.midcast.Stun, {main="Serenity",legs="Azimuth tights +1",
		ear2="Barkarole earring"})


    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    -- Idle sets

    sets.idle = {main="Bolelabunga",sub="Genbu's Shield",Range="Dunna",
        head="Befouled crown",neck="Bathy choker +1",ear1="Moonshade earring",ear2="Lugalbanda earring",
        body="Geomancy tunic +3",hands="Volte Gloves",ring1="Defending ring",ring2="Dark Ring",
        back=gear.NantoGEO,waist="Fucho-no-obi",legs="Assiduity pants +1",feet="Geomancy sandals +3"}

    sets.idle.PDT = {main="Terra's staff",sub="Oneiros grip",Range="Dunna",
        head="Befouled crown",neck="Loricate torque +1",ear1="Moonshade earring",ear2="Lugalbanda earring",
        body="Geomancy tunic +3",hands="Volte Gloves",ring1="Defending ring",ring2="Dark Ring",
        back=gear.NantoGEO,waist="Fucho-no-obi",legs="Assiduity pants +1",feet="Azimuth gaiters +1"}

    -- Resting sets
    sets.resting = sets.idle
		
    -- .Pet sets are for when Luopan is present.
    sets.idle.Pet = {main="Idris",sub="Genbu's Shield",range="Dunna",
		head="Azimuth Hood +1",neck="Loricate torque +1",ear1="Moonshade earring",ear2="Lugalbanda earring",
		body=gear.TelchBodyGEO,hands=gear.TelchHandsGEO,ring1="Defending ring",ring2="Dark ring",
		back=gear.NantoGEO,waist="Isa belt",legs=gear.TelchLegsGEO,feet="Bagua sandals +1"}

    sets.idle.PDT.Pet = {main="Idris",sub="Genbu's Shield",range="Dunna",
		head="Azimuth Hood +1",neck="Loricate torque +1",ear1="Sanare earring",ear2="Lugalbanda earring",
		body=gear.TelchBodyGEO,hands=gear.TelchHandsGEO,ring1="Defending ring",ring2="Dark ring",
		back=gear.NantoGEO,waist="Isa belt",legs=gear.TelchLegsGEO,feet="Bagua sandals +1"}

    -- .Indi sets are for when an Indi-spell is active.
    sets.idle.Indi = set_combine(sets.idle, {})
    sets.idle.Pet.Indi = set_combine(sets.idle.Pet, {})
    sets.idle.PDT.Indi = set_combine(sets.idle.PDT, {})
    sets.idle.PDT.Pet.Indi = set_combine(sets.idle.PDT.Pet, {})

    sets.idle.Town = sets.idle

    sets.idle.Weak = sets.idle.PDT

    -- Defense sets

    sets.defense.PDT = sets.idle.PDT

    sets.defense.MDT = sets.idle.PDT

    sets.Kiting = {}

    sets.latent_refresh = {waist="Fucho-no-obi"}


    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {main="Idris",sub="Genbu's Shield",range="Dunna",
		head="Azimuth Hood +1",neck="Loricate torque +1",ear1="Lugalbanda earring",ear2="Etiolation Earring",
		body=gear.TelchBodyGEO,hands=gear.TelchHandsGEO,ring1="Defending ring",ring2="Dark ring",
		back=gear.NantoGEO,waist="Isa belt",legs=gear.TelchLegsGEO,feet="Bagua sandals +1"}

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
    set_macro_page(4, 4)
end

