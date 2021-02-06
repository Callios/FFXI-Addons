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
--	state.CombatForm = get_combat_form()
	
	state.Buff = {}
  end


-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	-- Options: Override default values
	state.OffenseMode:options('Normal', 'Acc', 'MaxAcc', 'PDT')
	--options.OffenseModes = {'Normal', 'Acc', 'Multi', 'PDT'}
	options.DefenseModes = {'Normal', 'PDT', 'Reraise'}
	state.WeaponskillMode:options('Normal', 'Acc')
	--options.WeaponskillModes = {'Normal', 'Acc', 'Att', 'Mod'}
	options.CastingModes = {'Normal'}
	options.IdleModes = {'Normal'}
	options.RestingModes = {'Normal'}
	options.PhysicalDefenseModes = {'PDT', 'Reraise'}
	options.MagicalDefenseModes = {'MDT'}

	--state.Defense.PhysicalMode = 'PDT'
	set_lockstyle()
	-- Additional local binds
	send_command('bind ^` input /ja "Hasso" <me>')
	send_command('bind !` input /ja "Seigan" <me>')

	select_default_macro_book(1, 16)
end


-- Called when this job file is unloaded (eg: job change)
function file_unload()
	if binds_on_unload then
		binds_on_unload()
	end

	send_command('unbind ^`')
	send_command('unbind !-')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Start defining the sets
	--------------------------------------
	include('yer_augmented-items.lua')
	
	BrigDEXSTP = { name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10',}}
	BrigSTRDA = { name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}}
	BrigSTRWSD = { name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
	
	-- Precast Sets
	-- Precast sets to enhance JAs
	sets.precast.JA.Angon = {ammo="Angon",hands="Pteroslaver Finger Gauntlets +3"}
	
	sets.precast.JA.Jump = {ammo="Ginsen",
		head="Flamma Zucchetto +2",neck="Anu Torque",ear1="Telos Earring",ear2="Sherida Earring",
		body=Val_Mail_Acc,hands="Flamma Manopolas +2",ring1="Niqmaddu Ring",ring2="Petrov Ring",
		back=BrigDEXSTP,waist="Ioskeha Belt +1",legs=ValPantsSTP,feet="Ostro Greaves"}
	
	sets.precast.JA['Ancient Circle'] = {legs="Vishap Brais +3"}
	
	sets.precast.JA['High Jump'] = set_combine(sets.precast.JA.Jump,{legs="Vishap Brais +3"})
	
	sets.precast.JA['Soul Jump'] = set_combine(sets.precast.JA.Jump,{})
	
	sets.precast.JA['Spirit Jump'] = set_combine(sets.precast.JA.Jump,{feet="Peltast's Schynbalds +1"})
	
	sets.precast.JA['Super Jump'] = set_combine(sets.precast.JA.Jump,{})
	
	sets.precast.JA['Spirit Link'] = {hands="Lnc. Vmbrc. +2"}
	sets.precast.JA['Call Wyvern'] = {body="Pteroslaver Mail"}
	sets.precast.JA['Deep Breathing'] = {hands="Wyrm Finger Gauntlets +2"}
	sets.precast.JA['Spirit Surge'] = {body="Pteroslaver Mail"}

	
	-- Healing Breath sets
	sets.HB = {ammo="Staunch Tathlum",
		head="Ptero. Armet +1",neck="Lancer's Torque",ear1="Anastasi Earring",ear2="Lancer's Earring",
		body="Emicho Haubert",hands="Despair Fin. Gaunt.",
		back="Updraft Mantle",waist="Glassblower's Belt",legs="Vishap Brais +3",feet="Ptero. Greaves +1"}
	sets.HB.Pre = {head="Vishap Armet +1"}
	sets.HB.Mid = {ammo="Staunch Tathlum",
		head="Ptero. Armet +1",neck="Lancer's Torque",ear1="Anastasi Earring",ear2="Lancer's Earring",
		body="Emicho Haubert",hands="Despair Fin. Gaunt.",
		back="Updraft Mantle",waist="Glassblower's Belt",legs="Vishap Brais +3",feet="Ptero. Greaves +1"}
		
	-- Waltz set (chr and vit)
	sets.precast.Waltz = {ammo="Sonia's Plectrum",
		head="Yaoyotl Helm",
		body="Mikinaak Breastplate",hands="Buremte Gloves",ring1="Spiral Ring",
		back="Letalis Mantle",legs="Cizin Breeches",feet="Karieyh Sollerets +1"}
		
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}

	sets.midcast.Breath = 
	set_combine(
		sets.midcast.FastRecast, 
		{ head="Vishap Armet +1" })
	
	-- Fast cast sets for spells
	
	sets.precast.FC = {ammo="Sapience Orb", 
		head="Carmine Mask",
		neck="Voltsurge Torque",
		ear1="Etiolation Earring",ear2="Loquac. Earring",
		body="Jumalik Mail",
		hands="Leyline Gloves",
		ring1="Prolix Ring",ring2="Weatherspoon Ring +1",
		feet="Carmine Greaves"}
    
	-- Midcast Sets
	sets.midcast.FastRecast = {
		head="Carmine Mask",
		neck="Voltsurge Torque",
		ear1="Etiolation Earring",ear2="Loquac. Earring",
		body="Jumalik Mail",
		hands="Leyline Gloves",
		ring1="Prolix Ring",ring2="Weather. Ring",
		feet="Carmine Greaves"}	
		
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {})

	sets.precast.WS = {ammo="Knobkierrie",
		head="Flamma Zucchetto +2",
		neck="Fotia Gorget",
		ear1="Brutal Earring",ear2="Ishvara Earring",
		body="Dagon Breastplate",
		hands="Sulevia's Gauntlets +2",
		ring1="Niqmaddu Ring",ring2="Regal Ring",
		back=BrigSTRDA,
		waist="Fotia Belt",
		legs="Sulevi. Cuisses +2",
		feet="Sulev. Leggings +2"}
	
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {ammo="Knobkierrie",
		head="Flamma Zucchetto +2",
		neck="Fotia Gorget",
		ear1="Cessance Earring",ear2="Telos Earring",
		body="Sulevia's Plate. +2",
		hands="Sulevia's Gauntlets +2",
		ring1="Niqmaddu Ring",ring2="Regal Ring",
		back=BrigSTRDA,
		waist="Fotia Belt",
		legs="Sulevi. Cuisses +2",
		feet="Sulev. Leggings +2"})
	
	sets.precast.WS.Killer = {
		body="Founder's Breastplate"
	}
	
	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
--[[	TEMP DISABLE W/ WSD patch for now
	sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS, {ammo="Knobkierrie",
		head="Flamma Zucchetto +2",
		neck="Fotia Gorget",
		ear1="Moonshade Earring",ear2="Sherida Earring",
		body=Val_Mail_Acc,
		hands="Sulevia's Gauntlets +2",
		ring1="Niqmaddu Ring",ring2="Regal Ring",
		back=BrigSTRDA,
		waist="Fotia Belt",
		legs="Sulevia's Cuisses +2",
		feet="Flamma Gambieras +2"})
]]--
	-- Stardiver set w/ WSD (temporarily)
	sets.precast.WS["Stardiver"] = {ammo="Knobkierrie",
		head="Flamma Zucchetto +2",
		neck="Fotia Gorget",
		ear1="Moonshade Earring",ear2="Sherida Earring",
		body="Dagon Breastplate",
		hands="Sulevia's Gauntlets +2",
		ring1="Niqmaddu Ring",ring2="Regal Ring",
		back=BrigSTRDA,
		waist="Fotia Belt",
		legs="Sulevia's Cuisses +2",
		feet="Flamma Gambieras +2"}
	
	sets.precast.WS['Stardiver'].Acc = set_combine(sets.precast.WS['Stardiver'], {
		ear1="Telos Earring",
		head="Flamma Zucchetto +2"
		
		})
	
	sets.precast.WS['Stardiver'].Mod = set_combine(sets.precast.WS['Stardiver'], {neck="Fotia Gorget",waist="Fotia Belt"})

	
	sets.precast.WS['Drakesbane'] = set_combine(sets.precast.WS, {ammo="Knobkierrie",
		head="Flamma Zucchetto +2",
		neck="Fotia Gorget",
		ear1="Brutal Earring",ear2="Sherida Earring",
		body="Dagon Breastplate",
		hands="Flamma Manopolas +2",
		ring1="Niqmaddu Ring",ring2="Regal Ring",
		back=BrigSTRDA,
		waist="Ioskeha Belt +1",
		legs="Sulevia's Cuisses +2",
		feet="Flamma Gambieras +2"})
	
	sets.precast.WS['Drakesbane'].Acc = set_combine(sets.precast.WS.Acc, {neck="Fotia Gorget",waist="Fotia Belt"})
	
	sets.precast.WS['Drakesbane'].Mod = set_combine(sets.precast.WS['Drakesbane'], {waist="Fotia Belt"})

	sets.precast.WS["Camlann's Torment"] = {ammo="Knobkierrie",
		head="Valorous Mask",
		neck="Fotia Gorget",
		ear1="Ishvara Earring",ear2="Sherida Earring",
		body="Dagon Breastplate",
		hands="Pteroslaver Finger Gauntlets +3",
		ring1="Niqmaddu Ring",ring2="Regal Ring",
		back=BrigSTRWSD,
		waist="Fotia Belt",
		legs="Vishap Brais +3",
		feet="Sulev. Leggings +2"}

	sets.precast.WS["Sonic Thrust"] = sets.precast.WS["Camlann's Torment"]
	
	sets.precast.WS["Impulse Drive"] = set_combine(sets.precast.WS["Camlann's Torment"],{
		neck="Caro Necklace",
		body="Nzingha Cuirass",
		ear2="Moonshade Earring",
		waist="Grunfeld Rope"
		})
	
	sets.precast.WS["Leg Sweep"] = {ammo="Knobkierrie",
		head="Flam. Zucchetto +2",neck="Fotia Gorget",ear1="Gwati Earring",ear2="Digni. Earring",
		body="Flamma Korazin +2",hands="Flam. Manopolas +2",ring1="Rufescent Ring",ring2="Flamma Ring",
		back=BrigDEXSTP,waist="Fotia Belt",legs="Flamma Dirs +2",feet="Flam. Gambieras +2"}
		
		
		
	-- Sets to return to when not performing an action.
	
	-- Resting sets
	sets.resting = {head="Yaoyotl Helm",neck="Wiglen Gorget",ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Ares' cuirass +1",hands="Cizin Mufflers",ring1="Sheltered Ring",ring2="Paguroidea Ring",
		back="Moonbeam Cape",waist="Goading Belt",legs="Carmine Cuisses +1",feet="Ejekamal Boots"}
	

	-- Idle sets
	sets.idle = {}

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle.Town = {ammo="Staunch Tathlum",
		head="White Rarab Cap +1",neck="Sanctity Necklace",ear1="Etiolation Earring",ear2="Infused Earring",
		body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +2",ring1="Sheltered Ring",ring2="Paguroidea Ring",
		back="Moonbeam Cape",waist="Flume Belt",legs="Carmine Cuisses +1",feet="Sulevia's Leggings +2"}
	
	sets.idle.Field = {ammo="Staunch Tathlum",
		head="Sulevia's Mask +2",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Infused Earring",
		body="Kubira Meikogai",hands="Sulevia's Gauntlets +2",ring1="Moonbeam Ring",ring2="Defending Ring",
		back="Moonbeam Cape",waist="Isa Belt",legs="Carmine Cuisses +1",feet="Amm Greaves"}

	sets.idle.Weak = {ammo="Staunch Tathlum",
		head="Sulevia's Mask +2",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Infused Earring",
		body="Kubira Meikogai",hands="Sulevia's Gauntlets +2",ring1="Dark Ring",ring2="Defending Ring",
		back="Moonbeam Cape",waist="Flume Belt",legs="Carmine Cuisses +1",feet="Amm Greaves"}
	
	-- Defense sets
	sets.defense.PDT = {ammo="Ginsen",
		head="Sulevia's Mask +2",
		neck="Loricate Torque +1",
		ear1="Cessance Earring",ear2="Sherida Earring",
		body="Sulevia's Plate. +2",
		hands="Sulev. Gauntlets +2",
		ring1="Niqmaddu Ring",ring2="Defending Ring",
		back=BrigDEXSTP,
		waist="Tempus Fugit",
		legs="Sulevi. Cuisses +2",
		feet="Sulevia's Leggings +2"}

	sets.defense.Reraise = {ammo="Staunch Tathlum",
		head="Twilight Helm",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Twilight Mail",hands="Buremte Gloves",ring1="Dark Ring",ring2="Paguroidea Ring",
		back="Letalis Mantle",waist="Goading Belt",legs="Cizin Breeches",feet="Karieyh Sollerets +1"}

	sets.defense.MDT = {ammo="Ginsen",
		head="Sulevia's Mask +2",
		neck="Loricate Torque +1",
		ear1="Cessance Earring",ear2="Sherida Earring",
		body="Sulevia's Plate. +2",
		hands="Sulev. Gauntlets +2",
		ring1="Niqmaddu Ring",ring2="Defending Ring",
		back=BrigDEXSTP,
		waist="Tempus Fugit",
		legs="Sulevi. Cuisses +2",
		feet="Sulevia's Leggings +2"}

	sets.Kiting = {legs="Blood Cuisses"}

	sets.Reraise = {head="Twilight Helm",body="Twilight Mail"}

	-- Engaged sets

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion
	
	-- Normal melee group
	sets.engaged = {ammo="Ginsen",
		head="Flam. Zucchetto +2",
		neck="Anu Torque",
		ear1="Telos Earring",ear2="Sherida Earring",
		body="Dagon Breastplate",
		hands="Flamma Manopolas +2",
		ring1="Niqmaddu Ring",ring2="Flamma Ring",
		back=BrigDEXSTP,
		waist="Ioskeha Belt +1",
		legs=ValPantsSTP,
		feet="Flamma Gambieras +2"}
		
	sets.engaged.Acc = {ammo="Ginsen",
		head="Flam. Zucchetto +2",
		neck="Shulmanu Collar",
		ear1="Telos Earring",ear2="Sherida Earring",
		body="Dagon Breastplate",
		hands="Flamma Manopolas +2",
		ring1="Niqmaddu Ring",ring2="Flamma Ring",
		back=BrigDEXSTP,
		waist="Ioskeha Belt +1",
		legs="Vishap Brais +3",
		feet="Flamma Gambieras +2"}
		
	sets.engaged.MaxAcc = {ammo="Ginsen",
		head="Flam. Zucchetto +2",
		neck="Shulmanu Collar",
		ear1="Telos Earring",ear2="Cessance Earring",
		body="Dagon Breastplate",
		hands="Flamma Manopolas +2",
		ring1="Regal Ring",ring2="Flamma Ring",
		back=BrigDEXSTP,
		waist="Ioskeha Belt +1",
		legs="Vishap Brais +3",
		feet="Flamma Gambieras +2"}
	
	sets.engaged.PDT = {ammo="Staunch Tathlum",
		head="Ynglinga Sallet",
		neck="Loricate Torque +1",
		ear1="Telos Earring",ear2="Cessance Earring",
		body="Kubira Meikogai",
		hands="Sulev. Gauntlets +2",
		ring1="Niqmaddu Ring",ring2="Defending Ring",
		back=BrigDEXSTP,
		waist="Ioskeha Belt +1",
		legs="Sulevi. Cuisses +2",
		feet="Sulevia's Leggings +2"}	
		
		
	sets.engaged.MaxAcc.PDT = {ammo="Hagneia Stone",
		head="Yaoyotl Helm",neck="Ganesha's Mala",ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Cizin Mail",hands="Cizin Mufflers",ring1="Rajas Ring",ring2="Mars's Ring",
		back="Letalis Mantle",waist="Dynamic Belt",legs="Cizin Breeches",feet="Cizin Graves"}
	sets.engaged.MaxAcc.Reraise = {ammo="Hagneia Stone",
		head="Twilight Helm",neck="Ganesha's Mala",ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Twilight Breastplate",hands="Cizin Mufflers",ring1="Rajas Ring",ring2="Mars's Ring",
		back="Letalis Mantle",waist="Dynamic Belt",legs="Cizin Breeches",feet="Ejekamal Boots"}
	sets.engaged.PDT = {ammo="Hagneia Stone",
		head="Yaoyotl Helm",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Mikinaak Breastplate",hands="Cizin Mufflers",ring1="Dark Ring",ring2="Dark Ring",
		back="Mollusca Mantle",waist="Dynamic Belt",legs="Cizin Breeches",feet="Karieyh Sollerets +1"}
	sets.engaged.Acc.PDT = {ammo="Hagneia Stone",
		head="Yaoyotl Helm",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Mikinaak Breastplate",hands="Cizin Mufflers",ring1="Dark Ring",ring2="Dark Ring",
		back="Mollusca Mantle",waist="Dynamic Belt",legs="Cizin Breeches",feet="Karieyh Sollerets +1"}
	sets.engaged.Reraise = {ammo="Hagneia Stone",
		head="Twilight Helm",neck="Torero Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Twilight Mail",hands="Cizin Mufflers",ring1="Dark Ring",ring2="Dark Ring",
		back="Letalis Mantle",waist="Dynamic Belt",legs="Cizin Breeches",feet="Karieyh Sollerets +1"}
	sets.engaged.Acc.Reraise = {ammo="Hagneia Stone",
		head="Twilight Helm",neck="Torero Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Twilight Mail",hands="Cizin Mufflers",ring1="Dark Ring",ring2="Dark Ring",
		back="Letalis Mantle",waist="Dynamic Belt",legs="Cizin Breeches",feet="Karieyh Sollerets +1"}
	
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)

end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Magic' then
	equip(sets.precast.FC)
	end
end

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.type == 'WeaponSkill' and
             buffactive['Ancient Circle'] then
                equip({body="Founder's Breastplate"})
            
	end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
		if spell.action_type == 'Magic' then
		equip(sets.midcast.FastRecast)
		if player.hpp < 51 then
			classes.CustomClass = "Breath" -- This would cause it to look for sets.midcast.Breath 
		end
	end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
	
--	if state.DefenseMode == 'Reraise' or
--		(state.Defense.Active and state.Defense.Type == 'Physical' and state.Defense.PhysicalMode == 'Reraise') then
--		equip(sets.Reraise)
--	end
end

-- Runs when a pet initiates an action.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_pet_midcast(spell, action, spellMap, eventArgs)
if spell.english:startswith('Healing Breath') or spell.english == 'Restoring Breath' then
		equip(sets.HB.Mid)
	end
end

-- Run after the default pet midcast() is done.
-- eventArgs is the same one used in job_pet_midcast, in case information needs to be persisted.
function job_pet_post_midcast(spell, action, spellMap, eventArgs)
	
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
--if state.DefenseMode == 'Reraise' or
--		(state.Defense.Active and state.Defense.Type == 'Physical' and state.Defense.PhysicalMode == 'Reraise') then
--	end
end

-- Run after the default aftercast() is done.
-- eventArgs is the same one used in job_aftercast, in case information needs to be persisted.
function job_post_aftercast(spell, action, spellMap, eventArgs)

end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_pet_aftercast(spell, action, spellMap, eventArgs)

end

-- Run after the default pet aftercast() is done.
-- eventArgs is the same one used in job_pet_aftercast, in case information needs to be persisted.
function job_pet_post_aftercast(spell, action, spellMap, eventArgs)

end


-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------

-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(status, eventArgs)

end

-- Return a customized weaponskill mode to use for weaponskill sets.
-- Don't return anything if you're not overriding the default value.
function get_custom_wsmode(spell, action, spellMap)

end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	return meleeSet
end

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_status_change(newStatus, oldStatus, eventArgs)

end

-- Called when the player's pet's status changes.
function job_pet_status_change(newStatus, oldStatus, eventArgs)

end

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)

end

function job_update(cmdParams, eventArgs)
	--state.CombatForm = get_combat_form()
end
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)

end

--function get_combat_form()
--	if areas.Adoulin:contains(world.area) and buffactive.ionis then
--		return 'Adoulin'
--	end
--end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	classes.CustomMeleeGroups:clear()
	if areas.Adoulin:contains(world.area) and buffactive.ionis then
		classes.CustomMeleeGroups:append('Adoulin')
	end
end

-- Job-specific toggles.
function job_toggle(field)

end

-- Request job-specific mode lists.
-- Return the list, and the current value for the requested field.
function job_get_mode_list(field)

end

-- Set job-specific mode values.
-- Return true if we recognize and set the requested field.
function job_set_mode(field, val)

end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)

end

-- Handle notifications of user state values being changed.
function job_state_change(stateField, newValue)

end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
function select_default_macro_book()
	set_macro_page(1, 11)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset 10')
end