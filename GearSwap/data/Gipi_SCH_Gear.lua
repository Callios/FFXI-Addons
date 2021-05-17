-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal','Resistant','MB','MBResist','FullResist')
    state.IdleMode:options('Normal', 'PDT')

	gear.default.obi_waist = "Refoccilation Stone"
	gear.default.obi_back = gear.LughMB
	
    send_command('bind ^` input /ma Stun <t>')
	
    info.low_nukes = S{"Stone", "Water", "Aero", "Fire", "Blizzard", "Thunder"}
    info.mid_nukes = S{"Stone II", "Water II", "Aero II", "Fire II", "Blizzard II", "Thunder II",
                       "Stone III", "Water III", "Aero III", "Fire III", "Blizzard III", "Thunder III",
                       "Stone IV", "Water IV", "Aero IV", "Fire IV", "Blizzard IV", "Thunder IV",}
    info.high_nukes = S{"Stone V", "Water V", "Aero V", "Fire V", "Blizzard V", "Thunder V"}
	
    select_default_macro_book()
end

function user_unload()
    send_command('unbind ^`')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

	include('Gipi_augmented-items.lua')
	
    -- Precast Sets

    -- Precast sets to enhance JAs

    sets.precast.JA['Tabula Rasa'] = {legs="Pedagogy Pants +1"}
	sets.precast.JA['Enlightenment'] = {body="Pedagogy Gown +3"}
	sets.precast.JA['Parsimony'] = {legs="Arbatel pants +1"}


    -- Fast cast sets for spells

    sets.precast.FC = {
		main="Sucellus",				--5
		ammo="Impatiens",
        head=gear.MerlinHeadFC,			--15
		neck="Orunmila's torque",		--5
		ear1="Loquacious Earring",		--2
		ear2="Malignance Earring",		--4
        body=gear.MerlinBodyFC,			--12
		hands="Academic's bracers +3",	--9
		ring1="Rahab Ring",				--2
		ring2="Kishar Ring",			--4
        back=gear.LughFC,				--10
		waist="Witful Belt",			--3
		legs="Volte Brais",				--8
		feet=gear.MerlinFeetFC			--12
		} --88
			
	sets.precast.FC['Stoneskin'] = set_combine(sets.precast.FC, {head="Umuthi hat",legs="Doyen pants"})
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {})
    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {})
	sets.precast.FC.Cure = set_combine(sets.precast.FC, {})
	sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.Impact = set_combine(sets.precast.FC['Elemental Magic'], {head=empty,body="Twilight Cloak"})
	sets.precast.FC['Dispelga'] = set_combine(sets.precast.FC, {main="Daybreak"})

	-- Weaponskill sets
	
	sets.precast.WS = {ammo="Floestone",
        head="jhakri coronal +2",neck="Fotia gorget",ear1="Ishvara earring",ear2="Moonshade earring",
        body="Jhakri robe +2",hands="Jhakri cuffs +2",ring1="Petrov ring",ring2="Hetairoi ring",
        back="Solemnity cape",waist="Fotia belt",legs="Jhakri slops +2",feet="Jhakri pigaches +2"}
		
	sets.precast.WS['Cataclysm'] = {ammo="Pemphredo tathlum",
        head="Pixie Hairpin +1",neck="Sanctity necklace",ear1="Friomisi earring",ear2="Malignance Earring",
        body="Amalric Doublet +1",hands="Amalric gages +1",ring1="Archon Ring",ring2="Freke Ring",
        back=gear.LughMB,waist="Hachirin-no-obi",legs="Amalric Slops +1",feet="Amalric Nails +1"}
		
	sets.precast.WS['Omniscience'] = set_combine(sets.precast.WS['Cataclysm'], {waist="Hachirin-no-obi",})
	
    -- Midcast Sets

    sets.midcast.FastRecast = {main="Sucellus",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
        head=gear.MerlinHeadFC,neck="Orunmila's torque",ear1="Magnetic Earring",ear2="Loquacious Earring",
        body="Amalric Doublet +1",hands="Academic's bracers +3",ring1="Defending ring",ring2="Kishar Ring",
        back="Fi Follet Cape +1",waist="Luminary Sash",legs="Lengo pants",feet="Amalric Nails +1"}

	--Healing Magic
		
    sets.midcast.Cure = {main="Daybreak",sub="Ammurapi Shield",ammo="Impatiens",
        head="Kaykaus Mitra +1",neck="Incanter's torque",ear1="Magnetic Earring",ear2="Regal Earring",
        body="Kaykaus Bliaut +1",hands="Vanya cuffs",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back=gear.LughMACC,waist="Bishop's sash",legs="Kaykaus Tights +1",feet="Kaykaus Boots +1"}

    sets.midcast.CureWithLightWeather = set_combine(sets.midcast.Cure, {waist="Hachirin-no-obi",})

    sets.midcast.Curaga = sets.midcast.Cure
	sets.midcast.CureSelf = {waist="Gishdubar Sash",ring2="Kunaji Ring"}

    sets.midcast.Cursna = {		
		head="Vanya hood",neck="Incanter's torque",
		body="Vanya robe",hands="Vanya cuffs",ring1="Menelaus's Ring",ring2="Haoma's Ring",
		back="Tempered cape +1",waist="Bishop's sash",legs="Vanya slops",feet="Vanya clogs"}
	
	--Enhancing Magic
	
	sets.midcast['Enhancing Magic'] = {main="Gada",sub="Ammurapi Shield",ammo="Pemphredo Tathlum",
        head="Befouled crown",neck="Incanter's torque",ear1="Magnetic Earring",ear2="Andoaa earring",
        body="Pedagogy Gown +3",hands="Chironic gloves",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back="Fi Follet Cape +1",waist="Olympus sash",legs="Academic's pants +2",feet="Regal pumps +1"}	
		
    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
		neck="Stone gorget",legs="Shedir seraweels",waist="Siegel Sash"})
	
	sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'], {
		legs="Shedir seraweels"})
	
	sets.midcast.EnhancingDuration = set_combine(sets.midcast['Enhancing Magic'], {
		main="Gada",
		sub="Ammurapi Shield",
		head=gear.TelchineHeadDURATION,
		hands=gear.TelchineHandsDURATION,
		legs=gear.TelchineLegsDURATION,
		feet=gear.TelchineFeetDURATION,
		waist="Embla Sash",
		})

    sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {main="Bolelabunga",sub="Ammurapi Shield",
		head="Arbatel bonnet +1",
		hands="Arbatel Bracers +1",
		back="Bookworm's cape"})
		
	sets.midcast['Haste'] = sets.midcast.EnhancingDuration
	sets.midcast['Flurry'] = sets.midcast.EnhancingDuration
	sets.midcast['Embrava'] = sets.midcast.EnhancingDuration
	sets.midcast['Refresh'] = set_combine(sets.midcast.EnhancingDuration, {
		head="Amalric Coif +1",
		--waist="Gishdubar sash"
		})
	sets.midcast['Adloquium'] = sets.midcast.EnhancingDuration
	sets.midcast['Animus Augeo'] = sets.midcast.EnhancingDuration
	sets.midcast['Animus Minuo'] = sets.midcast.EnhancingDuration
	sets.midcast['Embrava'] = sets.midcast.EnhancingDuration
	sets.midcast['Blink'] = sets.midcast.EnhancingDuration
    sets.midcast.Storm = set_combine(sets.midcast.EnhancingDuration, {feet="Pedagogy Loafers +1"})
	
	sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {
		main="Vadose Rod",
		head="Amalric Coif +1",
		hands="Regal Cuffs",
		legs="Shedir seraweels"
		})

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {ring1="Sheltered Ring"})
    sets.midcast.Protectra = sets.midcast.Protect

    sets.midcast.Shell = set_combine(sets.midcast.EnhancingDuration, {ring1="Sheltered Ring"})
    sets.midcast.Shellra = sets.midcast.Shell


    -- Custom spell classes
    sets.midcast.MndEnfeebles = {main="Daybreak",sub="Ammurapi Shield",ammo="Pemphredo tathlum",
        head="Academic's mortarboard +3",neck="Erra pendant",ear1="Dignitary's earring",ear2="Regal earring",
        body="Academic's gown +3",hands="Regal Cuffs",ring1="Stikini Ring +1",ring2="Kishar ring",
        back=gear.LughMACC,waist="Luminary sash",legs=gear.ChironicLegsMACC,feet="Academic's Loafers +3"}
		
	sets.midcast['Distract'] = sets.midcast.MndEnfeebles
	sets.midcast['Frazzle'] = sets.midcast.MndEnfeebles
    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {back=gear.LughMB})
    sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles
	sets.midcast['Dispelga'] = set_combine(sets.midcast.MndEnfeebles, {main="Daybreak",sub="Ammurapi Shield"})

	-- Dark Element Stuff
	
    sets.midcast['Dark Magic'] = {main="Rubicundity",sub="Ammurapi Shield",ammo="Pemphredo tathlum",
        head="Academic's mortarboard +3",neck="Erra pendant",ear1="Gwati Earring",ear2="Malignance Earring",
        body="Academic's gown +3",hands="Academic's bracers +3",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back=gear.LughMB,waist="Luminary sash",legs=gear.ChironicLegsMACC,feet="Academic's Loafers +3"}

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        head="Pixie hairpin +1",
		ring1="Archon ring",ring2="Evanescence ring",
        waist="Fucho-no-obi"})

    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = {main="Rubicundity",sub="Ammurapi Shield",ammo="Pemphredo tathlum",
        head="Academic's mortarboard +3",neck="Orunmila's torque",ear1="Enchanter earring +1",ear2="Regal Earring",
        body=gear.MerlinBodyMB,hands="Academic's bracers +3",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back=gear.LughFC,waist="Witful Belt",legs="Psycloth lappas",feet="Academic's Loafers +3"}

    sets.midcast.Stun.Resistant = {main="Rubicundity",sub="Ammurapi Shield",ammo="Pemphredo tathlum",
        head="Academic's mortarboard +3",neck="Erra pendant",ear1="Dignitary's earring",ear2="Regal earring",
        body="Academic's gown +3",hands="Academic's bracers +3",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back=gear.LughMB,waist="Luminary sash",legs=gear.ChironicLegsMACC,feet="Academic's Loafers +3"}

    -- Elemental Magic
	
    sets.midcast['Elemental Magic'] = {main="Mpaca's Staff",sub="Niobid strap",ammo="Pemphredo tathlum",
        head=gear.MerlinHeadMB,neck="Sanctity necklace",ear1="Regal earring",ear2="Malignance Earring",
        body="Amalric Doublet +1",hands="Amalric Gages +1",ring1="Shiva ring +1",ring2="Freke Ring",
        back=gear.LughMB,waist=gear.ElementalObi,legs="Amalric Slops +1",feet="Amalric Nails +1"}
		
    sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
        head="Academic's mortarboard +3",
        legs=gear.MerlinLegsMB,})
		
	sets.midcast['Elemental Magic'].MB = set_combine(sets.midcast['Elemental Magic'], {
        head=gear.MerlinHeadMB,neck="Mizukage-no-Kubikazari",
		hands="Amalric Gages +1",ring1="Mujin band",
        legs=gear.MerlinLegsMB,feet=gear.MerlinFeetMB})
	
	sets.midcast['Elemental Magic'].MBResist = set_combine(sets.midcast['Elemental Magic'].MB, {
        head="Academic's mortarboard +3",
        body="Academic's gown +3",hands="Regal Cuffs",ring1="Mujin band",
		})
		
	sets.midcast['Elemental Magic'].FullResist = {main="Mpaca's Staff",sub="Enki strap",ammo="Pemphredo tathlum",
        head="Academic's mortarboard +3",neck="Erra pendant",ear1="Regal earring",ear2="Malignance Earring",
        body="Academic's gown +3",hands="Regal Cuffs",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back=gear.LughMB,waist=gear.ElementalObi,legs=gear.MerlinLegsMB,feet="Academic's Loafers +3"}
		
    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'].FullResist, {main="Maxentius",sub="Ammurapi Shield",
        head=empty,ear1="Dignitary's earring",
        body="Twilight cloak",
        back=gear.LughMB,waist="Luminary sash",legs=gear.ChironicLegsMACC,})
		
	sets.midcast['Elemental Magic'].Helix = {main="Mpaca's Staff",sub="Enki strap",ammo="Pemphredo tathlum",
        head=gear.MerlinHeadMB,neck="Mizukage-no-Kubikazari",ear1="Regal earring",ear2="Malignance Earring",
        body="Academic's gown +3",hands="Amalric Gages +1",ring1="Mujin Band",ring2="Freke Ring",
        back=gear.LughMB,waist="Refoccilation Stone",legs=gear.MerlinLegsMB,feet="Amalric Nails +1"}
		
    sets.midcast.Kaustra = {main="Mpaca's Staff",sub="Enki strap",ammo="Pemphredo tathlum",
        head="Pixie hairpin +1",neck="Sanctity necklace",ear1="Regal earring",ear2="Malignance Earring",
        body="Academic's gown +3",hands="Regal Cuffs",ring1="Archon ring",ring2="Freke Ring",
        back=gear.LughMB,waist=gear.ElementalObi,legs=gear.MerlinLegsMB,feet="Amalric Nails +1"}
		
	sets.midcast.Kaustra.Resistant = {main="Mpaca's Staff",sub="Enki strap",ammo="Pemphredo tathlum",
        head="Pixie hairpin +1",neck="Erra pendant",ear1="Regal earring",ear2="Malignance Earring",
        body="Academic's gown +3",hands="Regal Cuffs",ring1="Archon ring",ring2="Stikini Ring +1",
        back=gear.LughMB,waist="Eschan stone",legs=gear.MerlinLegsMB,feet=gear.MerlinFeetMB}


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {main="Daybreak",sub="Genmei shield",ammo="Homiliary",
        head="Befouled Crown",neck="Bathy Choker +1",ear1="Infused earring",ear2="Eabani Earring",
        body="Shamash Robe",hands="Nyame Gauntlets",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
        back=gear.LughFC,waist="Fucho-no-obi",legs="Assiduity pants +1",feet="Nyame Sollerets"}
		
	sets.idle.Weak = sets.idle
		
    sets.resting = sets.idle
		
	sets.idle.Town = set_combine(sets.idle, {})

    -- Defense sets

    sets.defense.PDT = {main="Daybreak",sub="Genmei shield",ammo="Staunch Tathlum +1",
        head="Nyame Helm",neck="Loricate torque +1",ear1="Sanare earring",ear2="Eabani Earring",
        body="Nyame Mail",hands="Nyame Gauntlets",ring1="Defending ring",ring2="Stikini Ring +1",
        back=gear.LughFC,waist="Fucho-no-obi",legs="Nyame Flanchard",feet="Academic's Loafers +3"}

    sets.defense.MDT = sets.defense.PDT

    sets.Kiting = {ring2="Shneddick Ring"}

    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {ammo="Staunch Tathlum +1",
        head="Nyame Helm",neck="Combatant's Torque",ear1="Telos Earring",ear2="Brutal earring",
        body="Nyame Mail",hands="Nyame Gauntlets",ring1="Chirich Ring +1",ring2="Chirich Ring +1",
        back=gear.LughFC,waist="Witful Belt",legs="Nyame Flanchard",feet="Nyame Sollerets"}



    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Ebullience'] = {head="Arbatel bonnet +1"}
    sets.buff['Rapture'] = {head="Arbatel bonnet +1"}
    sets.buff['Perpetuance'] = {hands="Arbatel bracers +1"}
    sets.buff['Immanence'] = {hands="Arbatel bracers +1"}
    sets.buff['Penury'] = {legs="Arbatel pants +1"}
    sets.buff['Parsimony'] = {legs="Arbatel pants +1"}
    sets.buff['Celerity'] = {feet="Pedagogy Loafers +1"}
    sets.buff['Alacrity'] = {feet="Pedagogy Loafers +1"}

    sets.buff['Klimaform'] = {feet="Arbatel loafers +1"}

    --sets.buff.FullSublimation = {head="Academic's Mortarboard",ear1="Savant's Earring",body="Pedagogy Gown"}
    --sets.buff.PDTSublimation = {head="Academic's Mortarboard",ear1="Savant's Earring"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general midcast() is done.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' then
        apply_grimoire_bonuses(spell, action, spellMap, eventArgs)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if buff == "Sublimation: Activated" then
        handle_equipping_gear(player.status)
    end
end

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
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if world.weather_element == 'Light' then
                return 'CureWithLightWeather'
            end
        elseif spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        elseif spell.skill == 'Elemental Magic' then
            if info.low_nukes:contains(spell.english) then
                return 'LowTierNuke'
            elseif info.mid_nukes:contains(spell.english) then
                return 'MidTierNuke'
            elseif info.high_nukes:contains(spell.english) then
                return 'HighTierNuke'
            end
        end
    end
end

function customize_idle_set(idleSet)
    if state.Buff['Sublimation: Activated'] then
        if state.IdleMode.value == 'Normal' then
            idleSet = set_combine(idleSet, sets.buff.FullSublimation)
        elseif state.IdleMode.value == 'PDT' then
            idleSet = set_combine(idleSet, sets.buff.PDTSublimation)
        end
    end

    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end

    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    if cmdParams[1] == 'user' and not (buffactive['light arts']      or buffactive['dark arts'] or
                       buffactive['addendum: white'] or buffactive['addendum: black']) then
        if state.IdleMode.value == 'Stun' then
            send_command('@input /ja "Dark Arts" <me>')
        else
            send_command('@input /ja "Light Arts" <me>')
        end
    end

    update_active_strategems()
    update_sublimation()
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for direct player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'scholar' then
        handle_strategems(cmdParams)
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Reset the state vars tracking strategems.
function update_active_strategems()
    state.Buff['Ebullience'] = buffactive['Ebullience'] or false
    state.Buff['Rapture'] = buffactive['Rapture'] or false
    state.Buff['Perpetuance'] = buffactive['Perpetuance'] or false
    state.Buff['Immanence'] = buffactive['Immanence'] or false
    state.Buff['Penury'] = buffactive['Penury'] or false
    state.Buff['Parsimony'] = buffactive['Parsimony'] or false
    state.Buff['Celerity'] = buffactive['Celerity'] or false
    state.Buff['Alacrity'] = buffactive['Alacrity'] or false

    state.Buff['Klimaform'] = buffactive['Klimaform'] or false
end

function update_sublimation()
    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
end

-- Equip sets appropriate to the active buffs, relative to the spell being cast.
function apply_grimoire_bonuses(spell, action, spellMap)
    if state.Buff.Perpetuance and spell.type =='WhiteMagic' and spell.skill == 'Enhancing Magic' then
        equip(sets.buff['Perpetuance'])
    end
    if state.Buff.Rapture and (spellMap == 'Cure' or spellMap == 'Curaga') then
        equip(sets.buff['Rapture'])
    end
    if spell.skill == 'Elemental Magic' and spellMap ~= 'ElementalEnfeeble' then
        if state.Buff.Ebullience and spell.english ~= 'Impact' then
            equip(sets.buff['Ebullience'])
        end
        if state.Buff.Immanence then
            equip(sets.buff['Immanence'])
        end
        if state.Buff.Klimaform and spell.element == world.weather_element then
            equip(sets.buff['Klimaform'])
        end
    end

    if state.Buff.Penury then equip(sets.buff['Penury']) end
    if state.Buff.Parsimony then equip(sets.buff['Parsimony']) end
    if state.Buff.Celerity then equip(sets.buff['Celerity']) end
    if state.Buff.Alacrity then equip(sets.buff['Alacrity']) end
end


-- General handling of strategems in an Arts-agnostic way.
-- Format: gs c scholar <strategem>
function handle_strategems(cmdParams)
    -- cmdParams[1] == 'scholar'
    -- cmdParams[2] == strategem to use

    if not cmdParams[2] then
        add_to_chat(123,'Error: No strategem command given.')
        return
    end
    local strategem = cmdParams[2]:lower()

    if strategem == 'light' then
        if buffactive['light arts'] then
            send_command('input /ja "Addendum: White" <me>')
        elseif buffactive['addendum: white'] then
            add_to_chat(122,'Error: Addendum: White is already active.')
        else
            send_command('input /ja "Light Arts" <me>')
        end
    elseif strategem == 'dark' then
        if buffactive['dark arts'] then
            send_command('input /ja "Addendum: Black" <me>')
        elseif buffactive['addendum: black'] then
            add_to_chat(122,'Error: Addendum: Black is already active.')
        else
            send_command('input /ja "Dark Arts" <me>')
        end
    elseif buffactive['light arts'] or buffactive['addendum: white'] then
        if strategem == 'cost' then
            send_command('input /ja Penury <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Celerity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Accession <me>')
        elseif strategem == 'power' then
            send_command('input /ja Rapture <me>')
        elseif strategem == 'duration' then
            send_command('input /ja Perpetuance <me>')
        elseif strategem == 'accuracy' then
            send_command('input /ja Altruism <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Tranquility <me>')
        elseif strategem == 'skillchain' then
            add_to_chat(122,'Error: Light Arts does not have a skillchain strategem.')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: White" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    elseif buffactive['dark arts']  or buffactive['addendum: black'] then
        if strategem == 'cost' then
            send_command('input /ja Parsimony <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Alacrity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Manifestation <me>')
        elseif strategem == 'power' then
            send_command('input /ja Ebullience <me>')
        elseif strategem == 'duration' then
            add_to_chat(122,'Error: Dark Arts does not have a duration strategem.')
        elseif strategem == 'accuracy' then
            send_command('input /ja Focalization <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Equanimity <me>')
        elseif strategem == 'skillchain' then
            send_command('input /ja Immanence <me>')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: Black" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    else
        add_to_chat(123,'No arts has been activated yet.')
    end
end


-- Gets the current number of available strategems based on the recast remaining
-- and the level of the sch.
function get_current_strategem_count()
    -- returns recast in seconds.
    local allRecasts = windower.ffxi.get_ability_recasts()
    local stratsRecast = allRecasts[231]

    local maxStrategems = (player.main_job_level + 10) / 20

    local fullRechargeTime = 4*60

    local currentCharges = math.floor(maxStrategems - maxStrategems * stratsRecast / fullRechargeTime)

    return currentCharges
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 9)
end
