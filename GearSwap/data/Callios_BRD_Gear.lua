-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.

function user_setup()
    state.OffenseMode:options('None', 'Normal', 'MidAcc', 'HighAcc')
	state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
	state.IdleMode:options('Normal', 'Kiting','Melee')
  
	brd_daggers = S{'Mandau','Twashtar','Carnwenhan','Taming Sari'}
	pick_tp_weapon()

-- Adjust this if using the Terpander (new +song instrument)
	info.ExtraSongInstrument = 'Daurdabla'

-- How many extra songs we can keep from Daurdabla/Terpander
	info.ExtraSongs = 2

-- Set this to false if you don't want to use custom timers.
	state.UseCustomTimers = M(true, 'Use Custom Timers')

state.LullabyMode = M{['description']='Lullaby Instrument', 'Horn', 'Harp'}
-- Additional local binds

	send_command('bind ^` gs c cycle set ExtraSongsMode Dummy; input /ma "Knight\'s Minne III" <me>;')
	send_command('bind ^` gs c cycle set ExtraSongsMode Dummy; input /ma "Knight\'s Minne IV" <me>;')
    send_command('bind !` input /ma "Chocobo Mazurka" <me>')

    select_default_macro_book(1, 10)
	
end
 
function init_gear_sets()

--------------------------------------
-- Start defining the sets
--------------------------------------

	--include('Gipi_augmented-items.lua')
	-- capes 
	BRD_MACC_FC = {name ="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+6','"Fast Cast"+10',}}
	BRD_MELEE = {name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}}

-- Precast Sets
 
-- Fast cast sets for spells

	sets.precast.FC = {
		main="Kali",				--7
		head="Nahtirah Hat",			--10
		neck="Baetyl Pendant",		--5
		ear1="Enchntr. earring +1",		--2
		ear2="Loquac. Earring",			--2
		body="Inyanga jubbah +2",		--14
		hands="Leyline gloves",			--7
		ring1="Kishar ring",			--4
		ring2="Rahab ring",				--2 --Need ring 12/21/18
		back=BRD_MACC_FC,		--10
		waist="Witful belt",			--3
		legs="Ayanmo cosciales +2",				--5
		feet=gear.ChironicHandsMATK		--4 -- Need FC Feet 12/21/18
		} --75
	 
	sets.precast.FC['Stoneskin'] = set_combine(sets.precast.FC, {head="Umuthi hat",legs="Doyen pants"})
	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
	sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {})
		
	sets.precast.FC.Cure = set_combine(sets.precast.FC, {
		main="Daybreak",
		ear1="Mendicant's earring",
		body="Heka's Kalasiris",
		legs="Doyen pants",
		})
		
	sets.precast.FC.Curaga = sets.precast.FC.Cure
	sets.precast.FC.Impact = set_combine(sets.precast.FC['Elemental Magic'], {head=empty,body="Twilight Cloak"})
		
	sets.precast.FC.BardSong = set_combine(sets.precast.FC, {
		range="Gjallarhorn",
		head="Fili calot",			--13
		body="Brioso justaucorps +3",	--15
		legs="Querkening brais",		--10
		feet="Bihu Slippers +3",
		back=BRD_MACC_FC,		--8
		}) --49 song reduction time
			
	sets.precast.FC['Honor March'] = set_combine(sets.precast.FC.BardSong, {range="Marsyas"})
	 
	sets.precast.FC.Daurdabla = set_combine(sets.precast.FC.BardSong, {range=info.ExtraSongInstrument})

-- Precast sets to enhance JAs

	sets.precast.JA.Nightingale = {feet="Bihu Slippers +3"}
	sets.precast.JA.Troubadour = {body="Bihu Jstcorps. +3"}
	sets.precast.JA['Soul Voice'] = {legs="Bihu cannions +1"}
	sets.precast.Waltz = {}

-- Weaponskill sets

	sets.precast.WS = {range="Linos",
		head="Ayanmo zucchetto +2",neck="Caro necklace",ear1="Ishvara earring",ear2="Moonshade earring",
		body="Bihu Jstcorps. +3",hands="Ayanmo manopolas +2",ring1="Petrov ring",ring2="Ilabrat ring",
		back=BRD_MELEE,waist="Grunfeld rope",legs="Lustratio subligar +1",feet="Lustratio leggings +1"}
		
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {})

-- Specific weaponskill sets. Uses the base set if an appropriate WSMod version isn't found.
 
	sets.precast.WS['Rudra\'s storm'] = set_combine(sets.precast.WS, {})
	sets.precast.WS['Rudra\'s storm'].Acc = set_combine(sets.precast.WS['Rudra\'s storm'], {})
	 
	sets.precast.WS['Mordant Rime'] = {range="Linos",
		head="Bihu roundlet +3",neck="Moonbow Whistle +1",ear1="Brutal earring",ear2="Regal Earring",
		body="Bihu Jstcorps. +3",hands="Bihu Cuffs +3",ring1="Petrov ring",ring2="Ilabrat ring",
		back=BRD_MELEE,waist="Grunfeld rope",legs="Lustratio subligar +1",feet="Bihu Slippers +3"}
		
	sets.precast.WS['Mordant Rime'].Acc = set_combine(sets.precast.WS['Mordant Rime'], {
		neck="Combatant's Torque",
		ear1="Telos Earring",
		})
		
	sets.precast.WS['Evisceration'] = {range="Linos",
		head="Bihu Roundlet +3",neck="Fotia gorget",ear1="Brutal earring",ear2="Moonshade earring",
		body="Bihu Jstcorps. +3",hands="Bihu Cuffs +3",ring1="Begrudging Ring",ring2="Ilabrat Ring",
		back=BRD_MELEE,waist="Fotia belt",legs="Lustratio subligar +1",feet="Bihu Slippers +3"}
		
	sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS["Evisceration"], {
		neck="Combatant's Torque",
		ear1="Telos Earring",
		})

	sets.precast.WS['Aeolian Edge'] = {ammo="Pemphredo tathlum",
		head="Chironic Hat",neck="Sanctity Necklace",ear1="Regal Earring",ear2="Moonshade earring",
		body="Bihu Jstcorps. +3",hands="Leyline Gloves",ring1="Shiva Ring",ring2="Shiva Ring",
		back=BRD_MELEE,waist="Eschan Stone",legs="Lustratio subligar +1",feet="Lustratio leggings +1"}
		
	sets.precast.WS['Aeolian Edge'].Acc = set_combine(sets.precast.WS['Aeolian Edge'], {})
	
-- Midcast Sets
 
	sets.midcast.FastRecast = {ammo="Pemphredo tathlum",
		head="Nahtirah Hat",neck="Baetyl Pendant",ear1="Enchntr. earring +1",ear2="Loquac. Earring",
		body="Inyanga jubbah +2",hands="Leyline gloves",ring1="Kishar Ring",ring2="Defending Ring",
		back=BRD_MACC_FC,waist="Luminary Sash",legs="Ayanmo cosciales +2",feet="Medium's Sabots"}

-- Gear to enhance certain classes of songs. No instruments added here since Gjallarhorn is being used.

	sets.midcast.Ballad = {legs="Fili rhingrave +1"}
	sets.midcast.Lullaby = {hands="Brioso Cuffs +2"}
	sets.midcast.Madrigal = {head="Fili calot",back=BRD_MACC_FC}
	sets.midcast.March = {hands="Fili manchettes"}
	sets.midcast.Minuet = {body="Fili hongreline +1"}
	sets.midcast.Minne = {legs="Mousai Seraweels",}
	sets.midcast.Paeon = {head="Brioso roundlet +2"}
	sets.midcast.Prelude = {back=BRD_MACC_FC}
	sets.midcast.Carol = {}
	sets.midcast["Sentinel's Scherzo"] = {feet="Fili cothurnes +1"}
	sets.midcast['Magic Finale'] = {}
	sets.midcast.Mazurka = {range=info.DaurdablaInstrument}
 
-- For song buffs (duration and AF3 set bonus)

	sets.midcast.SongEffect = {main="Carnwenhan",sub="Genmei shield",range="Gjallarhorn",
		head="Fili calot",neck="Moonbow Whistle +1",ear1="Enchntr. Earring +1",ear2="Loquacious Earring",
		body="Fili hongreline +1",hands="Fili Manchettes",ring1="Defending ring",ring2="Inyanga ring",
		back=gear.BRD_MACC_FC,waist="Flume belt",legs="Inyanga shalwar +2",feet="Brioso Slippers +3"}
		
	sets.midcast['Honor March'] = set_combine(sets.midcast.SongEffect, {range="Marsyas"})
 
-- For song defbuffs

	sets.midcast.SongDebuff = {main="Carnwenhan",sub="Ammurapi shield",range="Gjallarhorn",
		head="Brioso roundlet +2",neck="Moonbow Whistle +1",ear1="Regal earring",ear2="Dignitary's Earring",
		body="Fili hongreline +1",hands="Inyanga dastanas +2",ring1="Stikini ring",ring2="Stikini ring",
		back=BRD_MACC_FC,waist="Porous rope",legs="Inyanga shalwar +2",feet="Brioso Slippers +3"}
		
	sets.midcast.ResistantSongDebuff = {main="Carnwenhan",sub="Ammurapi shield",range="Gjallarhorn",
		head="Brioso roundlet +2",neck="Moonbow Whistle +1",ear1="Regal earring",ear2="Dignitary's Earring",
		body="Brioso justaucorps +3",hands="Inyanga dastanas +2",ring1="Stikini ring",ring2="Stikini ring",
		back=BRD_MACC_FC,waist="Porous rope",legs="Brioso cannions +3",feet="Brioso Slippers +3"}
	
	sets.midcast['Horde Lullaby II'] = set_combine(sets.midcast.SongDebuff, {range="Daurdabla"})
	sets.midcast['Horde Lullaby II'].Resistant = set_combine(sets.midcast.ResistantSongDebuff, {range="Daurdabla"})
	sets.midcast['Horde Lullaby'] = sets.midcast['Horde Lullaby II']
	sets.midcast['Horde Lullaby'].Resistant = sets.midcast['Horde Lullaby II'].Resistant
	sets.midcast['Magic Finale'] = set_combine(sets.midcast.SongDebuff, {hands="Bewegt Cuffs"})
	sets.midcast['Magic Finale'].Resistant = set_combine(sets.midcast.ResistantSongDebuff, {})
 
-- Song-specific recast reduction

	sets.midcast.SongRecast = {}
 
-- Cast spell with normal gear, except using Daurdabla instead

	sets.midcast.Daurdabla = {range=info.ExtraSongInstrument}

-- Dummy song with Daurdabla; minimize duration to make it easy to overwrite.

	sets.midcast.DaurdablaDummy = {main="Earth staff",sub="Enki Strap",range=info.ExtraSongInstrument,
		head="Inyanga tiara +2",neck="Loricate torque +1",ear1="Enchntr. Earring +1",ear2="Loquacious earring",
		body="Inyanga jubbah +2",hands="Inyanga dastanas +2",ring1="Defending ring",ring2="Gelatinous Ring +1",
		back=BRD_MACC_FC,waist="Flume Belt",legs="Inyanga shalwar +2",feet="Inyanga crackows +2"}
	
-- Other general spells and classes.

	sets.midcast.Cure = {main="Daybreak",sub="Enki Strap",ammo="Pemphredo Tathlum",
		head="Vanya hood",neck="Incanter's torque",ear1="Mendicant's earring",ear2="Novia earring",
		body="Chironic doublet",hands="Inyanga dastanas +2",ring1="Sirona's ring",ring2="Lebeche ring",
		back="Tempered cape +1",waist="Porous rope",legs="Vanya slops",feet="Vanya clogs"}

	sets.midcast.Curaga = sets.midcast.Cure
	sets.midcast.CureSelf = {waist="Gishdubar Sash",}

	--Enhancing Magic
		
	sets.midcast['Enhancing Magic'] = {sub="Ammurapi shield",
		head="Umuthi hat",neck="Incanter's torque",ear1="Andoaa earring",
		body="Telchine chasuble",hands="Telchine gloves",ring1="Stikini ring",ring2="Stikini ring",
		back="Fi Follet Cape +1",waist="Embla sash",legs="Telchine Braconi",feet="Rubeus boots"}

	sets.midcast.EnhancingDuration = set_combine(sets.midcast['Enhancing Magic'], {
		sub="Ammurapi shield",
		head=gear.TelchineHeadDURATION,
		body=gear.TelchineBodyDURATION,
		hands="Telchine gloves",
		legs="Telchine Braconi",
		feet=gear.TelchineFeetDURATION,
		})
	
	sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {sub="Ammurapi shield",
		head="Inyanga tiara +2"
		})
	
	sets.midcast['Haste'] = sets.midcast.EnhancingDuration
	sets.midcast['Flurry'] = sets.midcast.EnhancingDuration
	sets.midcast['Refresh'] = set_combine(sets.midcast.EnhancingDuration, {waist="Gishdubar sash"})
		
	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
		neck="Stone gorget",legs="Shedir seraweels",waist="Siegel Sash"})
	
	sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {
		head="Chironic hat",legs="Shedir seraweels"})

	sets.midcast.Cursna = {
		head="Vanya hood",neck="Incanter's torque",
		body="Vanya robe",hands="Vanya cuffs",ring1="Sirona's ring",
		back="Tempered cape +1",waist="Bishop's sash",legs="Vanya slops",feet="Vanya clogs"}
 
-- Sets to return to when not performing an action.
-- Resting sets

	sets.resting = {}

-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

	sets.idle = {main="Carnwenhan",sub="Genmei shield",range="Nibiru Harp",
		head="Inyanga tiara +2",neck="Bathy choker +1",ear1="Infused earring",ear2="Odnowa earring +1",
		body="Inyanga jubbah +2",hands="Inyanga dastanas +2",ring1="Defending ring",ring2="Inyanga ring",
		back="Solemnity cape",waist="Fucho-no-obi",legs="Assiduity pants +1",feet="Fili cothurnes +1"} --22
		
	sets.idle.Town = set_combine(sets.idle, {})
		
	sets.idle.Kiting = {main="Earth staff",sub="Enki Strap",range="Nibiru harp",
		head="Inyanga tiara +2",neck="Loricate torque +1",ear1="Odnowa earring",ear2="Odnowa earring +1",
		body="Inyanga jubbah +2",hands="Inyanga dastanas +2",ring1="Defending ring",ring2="Inyanga ring",
		back=BRD_MACC_FC,waist="Flume Belt",legs="Inyanga shalwar +2",feet="Inyanga crackows +2"} --52		

	sets.idle.Melee = {range="Nibiru harp",
		head="Inyanga tiara +2",neck="Loricate torque +1",ear1="Sanare earring",ear2="Eabani earring",
		body="Bihu Jstcorps. +3",hands="Inyanga dastanas +2",ring1="Defending ring",ring2="Moonbeam ring",
		back=BRD_MELEE,waist="Flume Belt",legs="Brioso cannions +3",feet="Inyanga crackows +2"} --51
		
	sets.Kiting = {feet="Fili cothurnes +1"}
	
-- Defense sets
 
	sets.defense.PDT = {range="Nibiru harp",
		head="Bihu Roundlet +3",neck="Loricate torque +1",ear1="Genmei earring",ear2="Odnowa earring +1",
		body="Bihu Jstcorps. +3",hands="Bihu Cuffs +3",ring1="Defending ring",ring2="Gelatinous ring +1",
		back="Solemnity cape",waist="Flume belt",legs="Brioso cannions +3",feet="Fili cothurnes +1"} 
	 
	sets.defense.MDT = {range="Nibiru harp",
		head="Inyanga tiara +2",neck="Warder's charm +1",ear1="Etiolation earring",ear2="Odnowa earring +1",
		body="Inyanga jubbah +2",hands="Inyanga dastanas +2",ring1="Defending ring",ring2="Dark ring",
		back="Solemnity cape",waist="Carrier's sash",legs="Brioso cannions +3",feet="Bihu Slippers +3"} 
 
 
-- Engaged sets
 
-- Variations for TP weapon and (optional) offense/defense modes. Code will fall back on previous
-- sets if more refined versions aren't defined.
-- If you create a set with both offense and defense modes, the offense mode should be first.
-- EG: sets.engaged.Dagger.Accuracy.Evasion
-- Basic set for if no TP weapon is defined.

	sets.engaged = {range="linos",
		head="Bihu roundlet +3",neck="Combatant's torque",ear1="Telos Earring",ear2="Cessance Earring",
		body="Ayanmo Corazza +2",hands="Ayanmo manopolas +2",ring1="Petrov ring",ring2="Ilabrat ring",
		back=BRD_MELEE,waist="Windbuffet belt +1",legs="Volte Tights",feet="Bihu Slippers +3"}
	 
	sets.engaged.MidAcc = {range="linos",
		head="Ayanmo zucchetto +2",neck="Combatant's torque",ear1="Telos Earring",ear2="Cessance Earring",
		body="Ayanmo Corazza +2",hands="Ayanmo manopolas +2",ring1="Cacoethic ring +1",ring2="Ilabrat ring",
		back=BRD_MELEE,waist="Olseni belt",legs="Ayanmo cosciales +2",feet="Ayanmo gambieras +2"}
	 
	sets.engaged.HighAcc = {range="linos",
		head="Ayanmo zucchetto +2",neck="Combatant's torque",ear1="Telos Earring",ear2="Dignitary's Earring",
		body="Bihu Jstcorps. +3",hands="Bihu Cuffs +3",ring1="Cacoethic ring +1",ring2="Ilabrat ring",
		back=BRD_MELEE,waist="Olseni belt",legs="Ayanmo cosciales +2",feet="Ayanmo gambieras +2"}
 
-- Sets with weapons defined.

	sets.engaged.Dagger = sets.engaged
		
	sets.engaged.Dagger.MidAcc = sets.engaged.MidAcc
		
	sets.engaged.Dagger.HighAcc = sets.engaged.HighAcc
	
-- Set if dual-wielding

	sets.engaged.DualWield = sets.engaged
		
	sets.engaged.DualWield.MidAcc = sets.engaged.MidAcc
		
	sets.engaged.DualWield.HighAcc = sets.engaged.HighAcc
	
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' then
        -- Auto-Pianissimo
        if ((spell.target.type == 'PLAYER' and not spell.target.charmed) or (spell.target.type == 'NPC' and spell.target.in_party)) and
            not state.Buff['Pianissimo'] then
            
            local spell_recasts = windower.ffxi.get_spell_recasts()
            if spell_recasts[spell.recast_id] < 2 then
                send_command('@input /ja "Pianissimo" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
                eventArgs.cancel = true
                return
            end
        end
    end
     if string.find(spell.name,'Lullaby') then
            if buffactive.Troubadour then
                equip({range="Marsyas"})
            elseif state.LullabyMode.value == 'Horn' then
                equip({range="Gjallarhorn"})
            else
                equip({range="Daurdabla"})
            end
        end
custom_aftermath_timers_precast(spell)
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' then
        if spell.type == 'BardSong' then
            -- layer general gear on first, then let default handler add song-specific gear.
            local generalClass = get_song_class(spell)
            if generalClass and sets.midcast[generalClass] then
                equip(sets.midcast[generalClass])
            end
        end
    end
end


function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' then
        if state.ExtraSongsMode.value == 'FullLength' then
            equip(sets.midcast.Daurdabla)
        end

        state.ExtraSongsMode:reset()
    end
end

-- Set eventArgs.handled to true if we don't want automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' and not spell.interrupted then
        if spell.target and spell.target.type == 'SELF' then
            adjust_timers(spell, spellMap)
        end
    end
custom_aftermath_timers_aftercast(spell)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main','sub','ammo')
        else
            enable('main','sub','ammo')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    pick_tp_weapon()
end


-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    
    return idleSet
end


-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Determine the custom class to use for the given song.
function get_song_class(spell)
    -- Can't use spell.targets:contains() because this is being pulled from resources
    if set.contains(spell.targets, 'Enemy') then
        if state.CastingMode.value == 'Resistant' then
            return 'ResistantSongDebuff'
        else
            return 'SongDebuff'
        end
    elseif state.ExtraSongsMode.value == 'Dummy' then
        return 'DaurdablaDummy'
    else
        return 'SongEffect'
    end
end


-- Function to create custom buff-remaining timers with the Timers plugin,
-- keeping only the actual valid songs rather than spamming the default
-- buff remaining timers.
function adjust_timers(spell, spellMap)
    if state.UseCustomTimers.value == false then
        return
    end
    
    local current_time = os.time()
    
    -- custom_timers contains a table of song names, with the os time when they
    -- will expire.
    
    -- Eliminate songs that have already expired from our local list.
    local temp_timer_list = {}
    for song_name,expires in pairs(custom_timers) do
        if expires < current_time then
            temp_timer_list[song_name] = true
        end
    end
    for song_name,expires in pairs(temp_timer_list) do
        custom_timers[song_name] = nil
    end
    
    local dur = calculate_duration(spell.name, spellMap)
    if custom_timers[spell.name] then
        -- Songs always overwrite themselves now, unless the new song has
        -- less duration than the old one (ie: old one was NT version, new
        -- one has less duration than what's remaining).
        
        -- If new song will outlast the one in our list, replace it.
        if custom_timers[spell.name] < (current_time + dur) then
            send_command('timers delete "'..spell.name..'"')
            custom_timers[spell.name] = current_time + dur
            send_command('timers create "'..spell.name..'" '..dur..' down')
        end
    else
        -- Figure out how many songs we can maintain.
        local maxsongs = 2
        if player.equipment.range == info.ExtraSongInstrument then
            maxsongs = maxsongs + info.ExtraSongs
        end
        if buffactive['Clarion Call'] then
            maxsongs = maxsongs + 1
        end
        -- If we have more songs active than is currently apparent, we can still overwrite
        -- them while they're active, even if not using appropriate gear bonuses (ie: Daur).
        if maxsongs < table.length(custom_timers) then
            maxsongs = table.length(custom_timers)
        end
        
        -- Create or update new song timers.
        if table.length(custom_timers) < maxsongs then
            custom_timers[spell.name] = current_time + dur
            send_command('timers create "'..spell.name..'" '..dur..' down')
        else
            local rep,repsong
            for song_name,expires in pairs(custom_timers) do
                if current_time + dur > expires then
                    if not rep or rep > expires then
                        rep = expires
                        repsong = song_name
                    end
                end
            end
            if repsong then
                custom_timers[repsong] = nil
                send_command('timers delete "'..repsong..'"')
                custom_timers[spell.name] = current_time + dur
                send_command('timers create "'..spell.name..'" '..dur..' down')
            end
        end
    end
end

-- Function to calculate the duration of a song based on the equipment used to cast it.
-- Called from adjust_timers(), which is only called on aftercast().
function calculate_duration(spellName, spellMap)
    local mult = 1
    if player.equipment.range == 'Daurdabla' then mult = mult + 0.3 end -- change to 0.25 with 90 Daur
    if player.equipment.range == "Gjallarhorn" then mult = mult + 0.4 end -- change to 0.3 with 95 Gjall
    
    if player.equipment.main == "Carnwenhan" then mult = mult + 0.1 end -- 0.1 for 75, 0.4 for 95, 0.5 for 99/119
    if player.equipment.main == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.sub == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.neck == "Aoidos' Matinee" then mult = mult + 0.1 end
    if player.equipment.body == "Aoidos' Hngrln. +2" then mult = mult + 0.1 end
    if player.equipment.legs == "Mdk. Shalwar +1" then mult = mult + 0.1 end
    if player.equipment.feet == "Brioso Slippers" then mult = mult + 0.1 end
    if player.equipment.feet == "Brioso Slippers +1" then mult = mult + 0.11 end
    
    if spellMap == 'Paeon' and player.equipment.head == "Brioso roundlet +3" then mult = mult + 0.1 end
    if spellMap == 'Madrigal' and player.equipment.head == "Aoidos' Calot +2" then mult = mult + 0.1 end
    if spellMap == 'Minuet' and player.equipment.body == "Aoidos' Hngrln. +2" then mult = mult + 0.1 end
    if spellMap == 'March' and player.equipment.hands == 'Ad. Mnchtte. +2' then mult = mult + 0.1 end
    if spellMap == 'Ballad' and player.equipment.legs == "Aoidos' Rhing. +2" then mult = mult + 0.1 end
    if spellName == "Sentinel's Scherzo" and player.equipment.feet == "Aoidos' Cothrn. +2" then mult = mult + 0.1 end
    
    if buffactive.Troubadour then
        mult = mult*2
    end
    if spellName == "Sentinel's Scherzo" then
        if buffactive['Soul Voice'] then
            mult = mult*2
        elseif buffactive['Marcato'] then
            mult = mult*1.5
        end
    end
    
    local totalDuration = math.floor(mult*120)

    return totalDuration
end


-- Examine equipment to determine what our current TP weapon is.
function pick_tp_weapon()
    if brd_daggers:contains(player.equipment.main) then
        state.CombatWeapon:set('Dagger')
        
        if S{'NIN','DNC'}:contains(player.sub_job) and brd_daggers:contains(player.equipment.sub) then
            state.CombatForm:set('DW')
        else
            state.CombatForm:reset()
        end
    else
        state.CombatWeapon:reset()
        state.CombatForm:reset()
    end
end

-- Function to reset timers.
function reset_timers()
    for i,v in pairs(custom_timers) do
        send_command('timers delete "'..i..'"')
    end
    custom_timers = {}
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 10)
end


windower.raw_register_event('zone change',reset_timers)
windower.raw_register_event('logout',reset_timers)

