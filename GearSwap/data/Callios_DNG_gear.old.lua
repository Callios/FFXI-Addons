-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'FullAcc', 'Hybrid')
    state.HybridMode:options('Normal')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.PhysicalDefenseMode:options('PDT')

    select_default_macro_book(1, 4)
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
	--include('augmented-items.lua')
	
	sets.enmity = {ammo="Staunch tathlum",
		head=gear.HercHeadDT,neck="Unmoving collar +1",ear1="Cryptic earring",ear2="Trux earring",
		body="Emet Harness +1",hands="Kurys gloves",ring1="Supershear ring",ring2="Eihwaz ring",
		back="Agema cape",waist="Kasiri belt",legs="Ayanmo cosciales +1",feet="Ahosi leggings"}
	
    -- Precast Sets
    
    -- Precast sets to enhance JAs

    sets.precast.JA['No Foot Rise'] = {body="Horos Casaque"}
    sets.precast.JA['Trance'] = {head="Horos Tiara"}
    sets.precast.JA['Provoke'] = sets.enmity

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Horos Tiara",ear1="Roundel Earring",
        body="Maxixi Casaque +1",hands="Buremte Gloves",ring1="Asklepian Ring",
        back="Toetapper Mantle",waist="Caudata Belt",legs="Nahtirah Trousers",feet="Maxixi Toe Shoes +1"}
        
    sets.precast.Waltz['Healing Waltz'] = {body="Maxixi Casaque +1"}
    sets.precast.Samba = {head="Maxixi Tiara +1",back="Senuna's mantle"}
    sets.precast.Jig = {legs="Horos Tights", feet="Maxixi Toe Shoes +1"}
    sets.precast.Step = {waist="Chaac Belt"}
    sets.precast.Step['Feather Step'] = {feet="Maculele Toeshoes"}

    sets.precast.Flourish1 = sets.enmity
    sets.precast.Flourish1['Violent Flourish'] = {ear1="Psystorm Earring",ear2="Lifestorm Earring",
        head="Dampening tam",neck="Sanctity necklace",ear2="Dignitary's earring",
		body="Horos Casaque",hands="Buremte Gloves",ring2="Sangoma Ring",
        waist="Chaac Belt",legs="Iuitl Tights",feet="Iuitl Gaiters +1"} -- magic accuracy
    sets.precast.Flourish1['Desperate Flourish'] = {ammo="Charis Feather",
        head="Whirlpool Mask",neck="Ej Necklace",ear2="Dignitary's earring",
        body="Horos Casaque",hands="Buremte Gloves",ring1="Beeline Ring",
        back="Toetapper Mantle",waist="Hurch'lan Sash",legs="Kaabnax Trousers",feet="Iuitl Gaiters +1"} -- acc gear

    sets.precast.Flourish2 = {}
    sets.precast.Flourish2['Reverse Flourish'] = {hands="Maculele Bangles",back="Toetapper mantle"}

    sets.precast.Flourish3 = {}
    sets.precast.Flourish3['Striking Flourish'] = {body="Maculele Casaque"}
    sets.precast.Flourish3['Climactic Flourish'] = {head="Maculele Tiara"}

    -- Fast cast sets for spells
    
    sets.precast.FC = {ammo="Impatiens",
		head="Herculean helm",neck="Orunmila's torque",ear1="Enchanter earring +1",ear2="Loquacious Earring",
		body="Dread jupon",hands="Leyline gloves",ring2="Lebeche ring",
		back="Swith cape"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {ammo="Falcon eye",
		head="Lilitu headpiece",neck="Caro necklace",ear1="Moonshade earring",ear2="Sherida earring",
        body="Meghanada cuirie +2",hands="Meghanada gloves +2",ring1="Regal ring",ring2="Ilabrat Ring",
        back=gear.SenCapeWS,waist="Grunfeld rope",legs="Lustratio subligar +1",feet="Lustratio leggings +1"}
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {})
    
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Exenterator'] = {ammo="Yamarang",
		head="Meghanada visor +2",neck="Fotia gorget",ear1="Telos earring",ear2="Sherida earring",
        body="Meghanada cuirie +2",hands="Meghanada gloves +2",ring1="Regal ring",ring2="Ilabrat ring",
        back=gear.SenCapeWS,waist="Fotia belt",legs="Meghanada chausses +2",feet="Meghanada jambeaux +2"}
    
	sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {})

    sets.precast.WS['Pyrrhic Kleos'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Pyrrhic Kleos'].Acc = set_combine(sets.precast.WS.Acc, {})

    sets.precast.WS['Evisceration'] = {ammo="Yetshila",
		head="Adhemar bonnet",neck="Caro necklace",ear1="Moonshade earring",ear2="Sherida earring",
        body="Meghanada cuirie +2",hands="Meghanada gloves +2",ring1="Begrudging ring",ring2="Ilabrat ring",
        back=gear.SenCapeWS,waist="Grunfeld rope",legs="Lustratio subligar +1",feet="Lustratio leggings +1"}
    
	sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {})

    sets.precast.WS["Rudra's Storm"] = { ammo="Ginsen",
    head={ name="Lilitu Headpiece", augments={'STR+10','DEX+10','Attack+15','Weapon skill damage +3%',}},
    body="Meg. Cuirie +2",
    hands="Meg. Gloves +2",
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Weapon skill damage +5%','AGI+1','Rng.Acc.+2','Rng.Atk.+14',}},
    neck="Caro Necklace",
    waist="Grunfeld Rope",
    left_ear="Ishvara Earring",
    right_ear="Brutal Earring",
    left_ring="Apate Ring",
    right_ring="Regal Ring",
    back="Lupine Cape",}
    
	sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"], {})

    sets.precast.WS['Aeolian Edge'] = {ammo="Charis Feather",
        head="Wayfarer Circlet",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Moonshade Earring",
        body="Wayfarer Robe",hands="Wayfarer Cuffs",ring1="Acumen Ring",ring2="Demon's Ring",
        back="Toro Cape",waist="Chaac Belt",legs="Shneddick Tights +1",feet="Wayfarer Clogs"}
    
    sets.precast.Skillchain = {hands="Maculele Bangles"}
    
    
    -- Midcast Sets
    
    sets.midcast.FastRecast = {
        head="Felistris Mask",ear2="Loquacious Earring",
        body="Iuitl Vest",hands="Iuitl Wristbands",
        legs="Kaabnax Trousers",feet="Iuitl Gaiters +1"}
        
    -- Specific spells
    sets.midcast.Utsusemi = {
        head="Felistris Mask",neck="Ej Necklace",ear2="Loquacious Earring",
        body="Iuitl Vest",hands="Iuitl Wristbands",ring1="Beeline Ring",
        back="Toetapper Mantle",legs="Kaabnax Trousers",feet="Iuitl Gaiters +1"}

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {head="Ocelomeh Headpiece +1",neck="Wiglen Gorget",
        ring1="Sheltered Ring",ring2="Paguroidea Ring"}
    sets.ExtraRegen = {head="Ocelomeh Headpiece +1"}
    

    -- Idle sets

    sets.idle = {ammo="Staunch tathlum",
		head="Meghanada visor +2",neck="Bathy choker +1",ear1="Infused earring",ear2="Ethereal earring",
        body="Meghanada cuirie +2",hands="Meghanada gloves +2",ring1="Sheltered Ring",ring2="Paguroidea Ring",
        back="Moonbeam cape",waist="Flume Belt +1",legs="Meghanada chausses +2",feet="Skadi's Jambeaux +1"}
		
    sets.idle.Town = {ammo="Staunch tathlum",
		head="Meghanada visor +2",neck="Bathy choker +1",ear1="Infused earring",ear2="Ethereal earring",
        body="Meghanada cuirie +2",hands="Meghanada gloves +2",ring1="Sheltered Ring",ring2="Paguroidea Ring",
        back="Moonbeam cape",waist="Flume Belt +1",legs="Meghanada chausses +2",feet="Skadi's Jambeaux +1"}
    
    -- Defense sets

    sets.defense.PDT = {ammo="Staunch tathlum",
        head="Meghanada visor +2",neck="Loricate torque +1",ear1="Odnowa earring +1",ear2="Eabani earring",
        body="Ashera harness",hands=gear.HercHandsDT,ring1="Defending ring",ring2="Moonbeam ring",
        back="Moonbeam cape",waist="Flume Belt +1",legs="Mummu kecks +2",feet="Ahosi leggings"}

    sets.defense.MDT = {ammo="Staunch tathlum",
        head="Pillager's bonnet +3",neck="Loricate torque +1",ear1="Odnowa earring +1",ear2="Eabani earring",
        body="Ashera harness",hands=gear.HercHandsDT,ring1="Defending ring",ring2="Moonbeam ring",
        back="Moonbeam cape",waist="Engraved belt",legs="Mummu kecks +2",feet="Ahosi leggings"}

    sets.Kiting = {feet="Skadi's Jambeaux +1"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged = {ammo="Ginsen",
    head={ name="Lilitu Headpiece", augments={'STR+10','DEX+10','Attack+15','Weapon skill damage +3%',}},
    body={ name="Herculean Vest", augments={'"Triple Atk."+4','DEX+10','Attack+6',}},
    hands={ name="Adhemar Wristbands", augments={'DEX+10','AGI+10','Accuracy+15',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}},
    neck="Anu Torque",
    waist="Kentarch Belt",
    left_ear="Telos Earring",
    right_ear="Digni. Earring",
    left_ring="Rajas Ring",
    right_ring="Epona's Ring",
    back="Lupine Cape",}
	
	sets.engaged.MidAcc = {ammo="Yamarang",
        head="Dampening tam",neck="Combatant's torque",ear1="Telos Earring",ear2="Sherida earring",
        body="Adhemar jacket",hands=gear.HercHandsACC,ring1="Epona's Ring",ring2="Ilabrat Ring",
        back=gear.SenCapeTP,waist="Grunfeld rope",legs="Samnuha tights",feet=gear.HercFeetTP}
	
    sets.engaged.FullAcc = {ammo="Yamarang",
        head="Dampening tam",neck="Combatant's torque",ear1="Telos Earring",ear2="Dignitary's earring",
        body="Adhemar jacket",hands=gear.HercHandsACC,ring1="Cacoethic ring +1",ring2="Regal ring",
        back=gear.SenCapeTP,waist="Olseni belt",legs="Samnuha tights",feet=gear.HercFeetTP}
		
	sets.engaged.Hybrid = {ammo="Staunch tathlum",
        head="Meghanada visor +2",neck="Loricate torque +1",ear1="Telos earring",ear2="Sherida earring",
        body="Ashera harness",hands=gear.HercHandsACC,ring1="Defending ring",ring2="Moonbeam ring",
        back="Moonbeam cape",waist="Sailfi belt +1",legs="Meghanada chausses +2",feet=gear.HercFeetTP}

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Saber Dance'] = {legs="Horos Tights"}
    sets.buff['Climactic Flourish'] = {ammo="Charis feather",head="Maculele Tiara"}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    --auto_presto(spell)
end


function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
        if state.Buff['Climactic Flourish'] then
            equip(sets.buff['Climactic Flourish'])
        end
        if state.SkillchainPending.value == true then
            equip(sets.precast.Skillchain)
        end
    end
end


-- Return true if we handled the aftercast work.  Otherwise it will fall back
-- to the general aftercast() code in Mote-Include.
function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Wild Flourish" then
            state.SkillchainPending:set()
            send_command('wait 5;gs c unset SkillchainPending')
        elseif spell.type:lower() == "weaponskill" then
            state.SkillchainPending:toggle()
            send_command('wait 6;gs c unset SkillchainPending')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
    -- If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste','march','embrava','haste samba'}:contains(buff:lower()) then
        determine_haste_group()
        handle_equipping_gear(player.status)
    elseif buff == 'Saber Dance' or buff == 'Climactic Flourish' then
        handle_equipping_gear(player.status)
    end
end


function job_status_change(new_status, old_status)
    if new_status == 'Engaged' then
        determine_haste_group()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
    determine_haste_group()
end


function customize_idle_set(idleSet)
    if player.hpp < 80 and not areas.Cities:contains(world.area) then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end
    
    return idleSet
end

function customize_melee_set(meleeSet)
    if state.DefenseMode.value ~= 'None' then
        if buffactive['saber dance'] then
            meleeSet = set_combine(meleeSet, sets.buff['Saber Dance'])
        end
        if state.Buff['Climactic Flourish'] then
            meleeSet = set_combine(meleeSet, sets.buff['Climactic Flourish'])
        end
    end
    
    return meleeSet
end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
    if spell.type == 'Step' then
        if state.IgnoreTargetting.value == true then
            state.IgnoreTargetting:reset()
            eventArgs.handled = true
        end
        
        eventArgs.SelectNPCTargets = state.SelectStepTarget.value
    end
end


-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end
    
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end

    msg = msg .. ', ['..state.MainStep.current

    if state.UseAltStep.value == true then
        msg = msg .. '/'..state.AltStep.current
    end
    
    msg = msg .. ']'

    if state.SelectStepTarget.value == true then
        steps = steps..' (Targetted)'
    end

    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'step' then
        if cmdParams[2] == 't' then
            state.IgnoreTargetting:set()
        end

        local doStep = ''
        if state.UseAltStep.value == true then
            doStep = state[state.CurrentStep.current..'Step'].current
            state.CurrentStep:cycle()
        else
            doStep = state.MainStep.current
        end        
        
        send_command('@input /ja "'..doStep..'" <t>')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    -- We have three groups of DW in gear: Charis body, Charis neck + DW earrings, and Patentia Sash.

    -- For high haste, we want to be able to drop one of the 10% groups (body, preferably).
    -- High haste buffs:
    -- 2x Marches + Haste
    -- 2x Marches + Haste Samba
    -- 1x March + Haste + Haste Samba
    -- Embrava + any other haste buff
    
    -- For max haste, we probably need to consider dropping all DW gear.
    -- Max haste buffs:
    -- Embrava + Haste/March + Haste Samba
    -- 2x March + Haste + Haste Samba

    classes.CustomMeleeGroups:clear()
    
    if buffactive.embrava and (buffactive.haste or buffactive.march) and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.march == 2 and buffactive.haste and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.embrava and (buffactive.haste or buffactive.march or buffactive['haste samba']) then
        classes.CustomMeleeGroups:append('HighHaste')
    elseif buffactive.march == 1 and buffactive.haste and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('HighHaste')
    elseif buffactive.march == 2 and (buffactive.haste or buffactive['haste samba']) then
        classes.CustomMeleeGroups:append('HighHaste')
    end
end


-- Automatically use Presto for steps when it's available and we have less than 3 finishing moves
function auto_presto(spell)
    if spell.type == 'Step' then
        local allRecasts = windower.ffxi.get_ability_recasts()
        local prestoCooldown = allRecasts[236]
        local under3FMs = not buffactive['Finishing Move 3'] and not buffactive['Finishing Move 4'] and not buffactive['Finishing Move 5']
        
        if player.main_job_level >= 77 and prestoCooldown < 1 and under3FMs then
            cast_delay(1.1)
            send_command('@input /ja "Presto" <me>')
        end
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 4)

end
