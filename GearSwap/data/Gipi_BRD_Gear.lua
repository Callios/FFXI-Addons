-- Original: Motenten / Modified: Arislan

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Mode
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ CTRL+F11 ]        Cycle Casting Modes
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+` ]          Cycle SongMode
--
--  Songs:      [ ALT+` ]           Chocobo Mazurka
--              [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  Weapons:    [ CTRL+W ]          Toggles Weapon Lock
--
--  WS:         [ CTRL+Numpad7 ]    Mordant Rime
--              [ CTRL+Numpad4 ]    Evisceration
--              [ CTRL+Numpad5 ]    Rudra's Storm
--              [ CTRL+Numpad1 ]    Aeolian Edge
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:
    
    SongMode may take one of three values: None, Placeholder, FullLength
    
    You can set these via the standard 'set' and 'cycle' self-commands.  EG:
    gs c cycle SongMode
    gs c set SongMode Placeholder
    
    The Placeholder state will equip the bonus song instrument and ensure non-duration gear is equipped.
    The FullLength state will simply equip the bonus song instrument on top of standard gear.
    
    
    Simple macro to cast a placeholder Daurdabla song:
    /console gs c set SongMode Placeholder
    /ma "Shining Fantasia" <me>
    
    To use a Terpander rather than Daurdabla, set the info.ExtraSongInstrument variable to
    'Terpander', and info.ExtraSongs to 1.
--]]

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
    res = require 'resources'
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.SongMode = M{['description']='Song Mode', 'None', 'Placeholder'}

    state.Buff['Pianissimo'] = buffactive['pianissimo'] or false

    lockstyleset = 1
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'DT')

    state.LullabyMode = M{['description']='Lullaby Instrument', 'Horn', 'Harp'}

    state.Carol = M{['description']='Carol', 
        'Fire Carol', 'Fire Carol II', 'Ice Carol', 'Ice Carol II', 'Wind Carol', 'Wind Carol II',
        'Earth Carol', 'Earth Carol II', 'Lightning Carol', 'Lightning Carol II', 'Water Carol', 'Water Carol II',
        'Light Carol', 'Light Carol II', 'Dark Carol', 'Dark Carol II',
        }

    state.Threnody = M{['description']='Threnody',
        'Fire Threnody II', 'Ice Threnody II', 'Wind Threnody II', 'Earth Threnody II',
        'Ltng. Threnody II', 'Water Threnody II', 'Light Threnody II', 'Dark Threnody II',
        }

    state.Etude = M{['description']='Etude', 'Sinewy Etude', 'Herculean Etude', 'Learned Etude', 'Sage Etude',
        'Quick Etude', 'Swift Etude', 'Vivacious Etude', 'Vital Etude', 'Dextrous Etude', 'Uncanny Etude',
        'Spirited Etude', 'Logical Etude', 'Enchanting Etude', 'Bewitching Etude'}

    state.WeaponLock = M(false, 'Weapon Lock')
    state.CP = M(false, "Capacity Points Mode")

    -- Additional local binds

    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        send_command('lua l gearinfo')
    end
   
    -- Adjust this if using the Terpander (new +song instrument)
    info.ExtraSongInstrument = 'Daurdabla'
    -- How many extra songs we can keep from Daurdabla/Terpander
    info.ExtraSongs = 2
    
    send_command('bind ^` gs c cycle SongMode')
    send_command('bind !` input /ma "Chocobo Mazurka" <me>')

	--[[
	send_command('bind ^backspace gs c cycle SongTier')
    send_command('bind ^insert gs c cycleback Etude')
    send_command('bind ^delete gs c cycle Etude')
    send_command('bind ^home gs c cycleback Carol')
    send_command('bind ^end gs c cycle Carol')
    send_command('bind ^pageup gs c cycleback Threnody')
    send_command('bind ^pagedown gs c cycle Threnody')
	--]]
	
    send_command('bind @w gs c toggle WeaponLock')
    send_command('bind @c gs c toggle CP')


    select_default_macro_book()
    set_lockstyle()

    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind !p')
	
	--[[
    send_command('unbind ^backspace')
    send_command('unbind !insert')
    send_command('unbind !delete')
    send_command('unbind ^insert')
    send_command('unbind ^delete')
    send_command('unbind ^home')
    send_command('unbind ^end')
    send_command('unbind ^pageup')
    send_command('unbind ^pagedown')
	--]]
	
    send_command('unbind @w')
    send_command('unbind @c')

    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        send_command('lua u gearinfo')
    end
end


-- Define sets and vars used by this job file.
function init_gear_sets()

		include('Gipi_augmented-items.lua')

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Fast cast sets for spells
	sets.precast.FC = {
		main="Malevolence",				--5
		head="Bunzi's Hat",				--10
		neck="Orunmila's torque",		--5
		ear1="Enchntr. earring +1",		--2
		ear2="Loquac. Earring",			--2
		body="Inyanga jubbah +2",		--14
		hands="Leyline gloves",			--7
		ring1="Kishar ring",			--4
		ring2="Rahab ring",				--2
		back=gear.IntarabusMACC,		--10
		waist="Witful belt",			--3
		legs="Volte Brais",				--8
		feet="Kaykaus Boots +1",		--4
		} --76
	 
	sets.precast.FC['Stoneskin'] = set_combine(sets.precast.FC, {head="Umuthi hat",})
	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {})
	sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {})	
	sets.precast.FC.Cure = set_combine(sets.precast.FC, {legs="Doyen Pants",})
	sets.precast.FC.Curaga = sets.precast.FC.Cure
	sets.precast.FC.Impact = set_combine(sets.precast.FC['Elemental Magic'], {head=empty,body="Twilight Cloak"})
	sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})
    
	sets.precast.FC.BardSong = set_combine(sets.precast.FC, {
		range="Gjallarhorn",
		body="Brioso justaucorps +3",	--15
		feet="Bihu Slippers +3",		--10
		}) 

    sets.precast.FC.SongPlaceholder = set_combine(sets.precast.FC.BardSong, {range=info.ExtraSongInstrument})
	sets.precast.FC['Honor March'] = set_combine(sets.precast.FC.BardSong, {range="Marsyas"})
    
    -- Precast sets to enhance JAs
    
    sets.precast.JA.Nightingale = {feet="Bihu Slippers +3"}
    sets.precast.JA.Troubadour = {body="Bihu Jstcorps. +3"}
    sets.precast.JA['Soul Voice'] = {legs="Bihu Cannions +1"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}
    
       
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        range="Linos",
        head="Bihu Roundlet +3",
        body="Bihu Jstcorps. +3",
        hands="Bunzi's Gloves",
        legs="Lustratio subligar +1",
        feet="Bihu Slippers +3",
        neck="Bard's Charm +2",
        ear1="Ishvara Earring",
        ear2="Moonshade Earring",
        ring1="Epaminondas's Ring",
        ring2="Ilabrat Ring",
        back=gear.IntarabusWS,
        waist="Fotia Belt",
        }
    
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
        range="Linos",
        head="Lustratio Cap +1",
        legs="Lustr. Subligar +1",
        feet="Lustra. Leggings +1",
        ear1="Mache Earring +1",
		ear2="Mache Earring +1",
        ring1="Begrudging Ring",
        back=gear.IntarabusCRIT,
        })
        
    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {ring1="Shukuyu Ring"})

    sets.precast.WS['Mordant Rime'] = set_combine(sets.precast.WS, {
        ear2="Regal Earring",
        waist="Grunfeld Rope",
        })

    sets.precast.WS['Rudra\'s Storm'] = set_combine(sets.precast.WS, {
        legs="Lustr. Subligar +1",
        feet="Lustra. Leggings +1",
        waist="Grunfeld Rope",
        })
    
	sets.precast.WS['Aeolian Edge'] = {
		ammo="Pemphredo Tathlum",
		head="Cath Palug Crown",
		neck="Sanctity Necklace",
		ear1="Regal Earring",
		ear2="Moonshade earring",
		body="Bihu Jstcorps. +3",
		hands="Nyame Gauntlets",
		ring1="Epaminondas's Ring",
		ring2="Shiva Ring +1",
		back=gear.IntarabusWS,
		waist="Refoccilation Stone",
		legs="Nyame Flanchard",
		feet=gear.ChironicHandsMATK
		}
    
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- General set for recast times.
 
	sets.midcast.FastRecast = set_combine(sets.precast.FC, {
		head="Vanya Hood",
		legs="Lengo pants",
		feet="Kaykaus Boots +1",
		ear1="Magnetic Earring",
		waist="Luminary Sash",
		back="Fi Follet Cape +1",
		})
        
    -- Gear to enhance certain classes of songs.
    sets.midcast.Ballad = {legs="Fili Rhingrave +1"}
    sets.midcast.Carol = {hands="Mousai Gages +1"}
    sets.midcast.Etude = {head="Mousai Turban"}
    sets.midcast.HonorMarch = {range="Marsyas", hands="Fili Manchettes +1"}
    sets.midcast.Lullaby = {body="Fili Hongreline +1", hands="Brioso Cuffs +3"}
    sets.midcast.Madrigal = {head="Fili Calot +1"}
    --sets.midcast.Mambo = {feet="Mousai Crackows"}
    sets.midcast.March = {hands="Fili Manchettes +1"}
    sets.midcast.Minne = {legs="Mousai Seraweels"}
    sets.midcast.Minuet = {body="Fili Hongreline +1"}
    sets.midcast.Paeon = {head="Brioso Roundlet +3"}
    --sets.midcast.Threnody = {body="Mousai Manteel"}
    sets.midcast["Sentinel's Scherzo"] = {feet="Fili Cothurnes +1"}
    sets.midcast.Mazurka = {range=info.ExtraSongInstrument}

    -- For song buffs (duration and AF3 set bonus)
    sets.midcast.SongEnhancing = {
		main="Carnwenhan",
		sub="Genmei Shield",
		range="Gjallarhorn",
		head="Fili Calot +1",
		neck="Moonbow Whistle +1",
		ear1="Sanare earring",
		ear2="Eabani earring",
		body="Fili Hongreline +1",
		hands="Fili Manchettes +1",
		ring1="Defending ring",
		ring2="Inyanga ring",
		back=gear.IntarabusIDLE,
		waist="Flume belt +1",
		legs="Inyanga Shalwar +2",
		feet="Brioso Slippers +3"
		}

    -- For song debuffs (duration primary, accuracy secondary)
    sets.midcast.SongEnfeeble = {
		main="Carnwenhan",
		sub="Ammurapi Shield",
		range="Gjallarhorn",
		head="Brioso Roundlet +3",
		neck="Moonbow Whistle +1",
		ear1="Regal earring",
		ear2="Dignitary's Earring",
		body="Fili Hongreline +1",
		hands="Inyanga Dastanas +2",
		ring1="Stikini Ring +1",
		ring2="Stikini Ring +1",
		back=gear.IntarabusMACC,
		waist="Luminary Sash",
		legs="Inyanga Shalwar +2",
		feet="Brioso Slippers +3"
		}

	-- For song defbuffs (accuracy primary, duration secondary)
    sets.midcast.SongEnfeebleAcc = set_combine(sets.midcast.SongEnfeeble, {legs="Brioso Cannions +3"})
	
	sets.midcast['Horde Lullaby II'] = set_combine(sets.midcast.SongDebuff, {range="Daurdabla"})
	sets.midcast['Horde Lullaby II'].Resistant = set_combine(sets.midcast.ResistantSongDebuff, {range="Daurdabla"})
	sets.midcast['Horde Lullaby'] = sets.midcast['Horde Lullaby II']
	sets.midcast['Horde Lullaby'].Resistant = sets.midcast['Horde Lullaby II'].Resistant
	sets.midcast['Magic Finale'] = set_combine(sets.midcast.SongDebuff, {hands="Bewegt Cuffs",legs="Fili Rhingrave +1",})
	sets.midcast['Magic Finale'].Resistant = set_combine(sets.midcast.ResistantSongDebuff, {})

    -- Placeholder song; minimize duration to make it easy to overwrite.
    sets.midcast.SongPlaceholder = {
		main="Terra's staff",
		sub="Enki Strap",
		range=info.ExtraSongInstrument,
		head="Nyame Helm",
		neck="Warder's Charm +1",
		ear1="Sanare earring",
		ear2="Eabani earring",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		ring1="Defending ring",
		ring2="Inyanga Ring",
		back=gear.IntarabusIDLE,
		waist="Flume Belt +1",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets"
		}

    -- Other general spells and classes.
    sets.midcast.Cure = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Kaykaus Mitra +1",
		neck="Incanter's torque",
		ear1="Magnetic Earring",
		ear2="Mendicant's earring",
		body="Kaykaus Bliaut +1",
		hands="Inyanga dastanas +2",
		ring1="Stikini Ring +1",
		ring2="Stikini Ring +1",
		back="Tempered cape +1",
		waist="Bishop's sash",
		legs="Kaykaus Tights +1",
		feet="Kaykaus Boots +1"
		}
        
    sets.midcast.Curaga = sets.midcast.Cure
        
    sets.midcast.StatusRemoval = {
		head="Vanya hood",
		neck="Incanter's torque",
		body="Vanya robe",
		hands="Vanya cuffs",
		ring1="Stikini Ring +1",
		ring2="Stikini Ring +1",
		back="Tempered cape +1",
		waist="Bishop's sash",
		legs="Vanya slops",
		feet="Vanya clogs"
		}
        
    sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
		ring1="Menelaus's Ring",
		ring2="Haoma's Ring",
        })
    
    sets.midcast['Enhancing Magic'] = {sub="Ammurapi Shield",
		head="Umuthi hat",neck="Incanter's torque",ear1="Andoaa earring",
		body=gear.TelchineBodyDURATION,hands="Inyanga dastanas +2",ring1="Stikini Ring +1",ring2="Stikini Ring +1",
		back="Fi Follet Cape +1",waist="Olympus sash",legs="Shedir seraweels",feet="Kaykaus Boots +1"}

	sets.midcast.EnhancingDuration = set_combine(sets.midcast['Enhancing Magic'], {
		sub="Ammurapi Shield",
		head=gear.TelchineHeadDURATION,
		body=gear.TelchineBodyDURATION,
		hands=gear.TelchineHandsDURATION,
		legs=gear.TelchineLegsDURATION,
		feet=gear.TelchineFeetDURATION,
		waist="Embla Sash",
		})
	
	sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {sub="Ammurapi Shield",
		head="Inyanga tiara +2"
		})
	
	sets.midcast['Haste'] = sets.midcast.EnhancingDuration
	sets.midcast['Flurry'] = sets.midcast.EnhancingDuration
	sets.midcast['Refresh'] = set_combine(sets.midcast.EnhancingDuration, {})
    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {})
	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
		neck="Stone gorget",legs="Shedir seraweels",waist="Siegel Sash"})
		
	sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {
		head="Chironic hat",legs="Shedir seraweels"})
		
    sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'], {ring2="Sheltered Ring"})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Shell

    sets.midcast['Enfeebling Magic'] = {
        main="Carnwenhan",
        sub="Ammurapi Shield",
        head="Brioso Roundlet +3",
        body="Brioso Justau. +3",
        hands="Inyanga dastanas +2",
        legs="Brioso Cannions +3",
        feet="Brioso Slippers +3",
        neck="Mnbw. Whistle +1",
        ear1="Regal Earring",
        ear2="Digni. Earring",
        ring1="Stikini Ring +1",
        ring2="Stikini Ring +1",
        waist="Luminary Sash",
        back=gear.IntarabusMACC,
        }

    sets.midcast.Dispelga = set_combine(sets.midcast['Enfeebling Magic'], {main="Daybreak", sub="Ammurapi Shield"})
    
    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
		main="Daybreak",
		sub="Genmei shield",
		range="Nibiru Harp",
		head="Inyanga tiara +2",
		neck="Bathy choker +1",
		ear1="Infused earring",
		ear2="Eabani Earring",
		body="Inyanga jubbah +2",
		hands="Inyanga dastanas +2",
		ring1="Stikini Ring +1",
		ring2="Inyanga Ring",
		back=gear.IntarabusIDLE,
		waist="Fucho-no-obi",
		legs="Assiduity pants +1",
		feet="Inyanga Crackows +2"
		} 

    sets.idle.DT = {
		main="Daybreak",
		sub="Genmei shield",
		range="Nibiru Harp",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Warder's Charm +1",
        ear1="Sanare Earring",
        ear2="Eabani Earring",
        ring1="Purity Ring",
        ring2="Inyanga Ring",
        back=gear.IntarabusIDLE,
        waist="Flume Belt +1",
        }

    sets.idle.Town = set_combine(sets.idle, {
        })
    
    sets.idle.Weak = sets.idle.DT
    
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = set_combine(sets.idle.DT, {})
    sets.defense.MDT = set_combine(sets.defense.PDT, {})

    sets.Kiting = {ring1="Shneddick Ring",}
    sets.latent_refresh = {waist="Fucho-no-obi"}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    sets.engaged = {
        main="Carnwenhan",
		range="Linos",
		head="Ayanmo zucchetto +2",
		neck="Bard's Charm +2",
		ear1="Telos Earring",
		ear2="Cessance earring",
		body="Ashera harness",
		hands="Bunzi's Gloves",
		ring1="Chirich Ring +1",
		ring2="Chirich Ring +1",
		back=gear.IntarabusTP,
		waist="Windbuffet Belt +1",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets"
		}

    sets.engaged.Acc = set_combine(sets.engaged, {
        ear1="Mache Earring +1",
		ear2="Mache Earring +1",
        waist="Kentarch Belt +1",
        })

    -- * DNC Subjob DW Trait: +15%
    -- * NIN Subjob DW Trait: +25%

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {
        main="Carnwenhan",
        sub="Twashtar",
		range="Linos",
		head="Ayanmo zucchetto +2",
		neck="Bard's Charm +2",
		ear1="Suppanomimi",
		ear2="Eabani earring",
		body="Ashera harness",
		hands="Bunzi's Gloves",
		ring1="Chirich Ring +1",
		ring2="Chirich Ring +1",
		back=gear.IntarabusTP,
		waist="Reiki Yotai",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets"
		}

    sets.engaged.DW.Acc = set_combine(sets.engaged.DW, {
		ear1="Mache Earring +1",
		ear2="Mache Earring +1",
        })

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = sets.engaged.DW
    sets.engaged.DW.Acc.LowHaste = sets.engaged.DW.Acc

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = sets.engaged.DW
    sets.engaged.DW.Acc.MidHaste = sets.engaged.DW.Acc

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = sets.engaged.DW
    sets.engaged.DW.Acc.HighHaste = sets.engaged.DW.Acc

    -- 45% Magic Haste (36% DW to cap)
	sets.engaged.DW.MaxHaste = sets.engaged.DW
    sets.engaged.DW.MaxHaste.Acc = sets.engaged.DW.Acc

    sets.engaged.DW.MaxHastePlus = set_combine(sets.engaged.DW.MaxHaste, {})
    sets.engaged.DW.Acc.MaxHastePlus = set_combine(sets.engaged.DW.Acc.MaxHaste, {})

    sets.engaged.Aftermath = {
		ring1="Chirich Ring +1",
		ring2="Chirich Ring +1",
        back=gear.IntarabusTP,
        }

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
        head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        ring1="Chirich Ring +1", 
        ring2="Defending Ring", 
		waist="Sailfi Belt +1",
        }

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.Acc.DT = set_combine(sets.engaged.Acc, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.DT = set_combine(sets.engaged.DW.Acc, sets.engaged.Hybrid)

    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.DT.LowHaste = set_combine(sets.engaged.DW.Acc.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.DT.MidHaste = set_combine(sets.engaged.DW.Acc.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.DT.HighHaste = set_combine(sets.engaged.DW.Acc.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.DT.MaxHaste = set_combine(sets.engaged.DW.Acc.MaxHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHastePlus = set_combine(sets.engaged.DW.MaxHastePlus, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.DT.MaxHastePlus = set_combine(sets.engaged.DW.Acc.MaxHastePlus, sets.engaged.Hybrid)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.SongDWDuration = {main="Carnwenhan"}

    sets.buff.Doom = {
        --neck="Nicander's Necklace", --20
        --ring1={name="Eshmun's Ring", bag="wardrobe3"}, --20
        --ring2={name="Eshmun's Ring", bag="wardrobe4"}, --20
        waist="Gishdubar Sash", --10
        }

    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {back="Mecisto. Mantle"}
    --sets.Reive = {neck="Ygnas's Resolve +1"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' then
        --[[ Auto-Pianissimo
        if ((spell.target.type == 'PLAYER' and not spell.target.charmed) or (spell.target.type == 'NPC' and spell.target.in_party)) and
            not state.Buff['Pianissimo'] then
            
            local spell_recasts = windower.ffxi.get_spell_recasts()
            if spell_recasts[spell.recast_id] < 2 then
                send_command('@input /ja "Pianissimo" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
                eventArgs.cancel = true
                return
            end
        end]]
        if spell.name == 'Honor March' then
            equip({range="Marsyas"})
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
    end
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' then
        -- layer general gear on first, then let default handler add song-specific gear.
        local generalClass = get_song_class(spell)
        if generalClass and sets.midcast[generalClass] then
            equip(sets.midcast[generalClass])
        end
        if spell.name == 'Honor March' then
            equip({range="Marsyas"})
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
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' then
        if state.CombatForm.current == 'DW' then
            equip(sets.SongDWDuration)
        end
		state.SongMode:reset()
	end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.english:contains('Lullaby') and not spell.interrupted then
        get_lullaby_duration(spell)
    end
end

function job_buff_change(buff,gain)

--    if buffactive['Reive Mark'] then
--        if gain then
--            equip(sets.Reive)
--            disable('neck')
--        else
--            enable('neck')
--        end
--    end

    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
            disable('ring1','ring2','waist')
        else
            enable('ring1','ring2','waist')
            handle_equipping_gear(player.status)
        end
    end

end

-- Handle notifications of general user state change.
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

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
    determine_haste_group()
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

-- Called for direct player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'etude' then
        send_command('@input /ma '..state.Etude.value..' <stpc>')
    elseif cmdParams[1]:lower() == 'carol' then
        send_command('@input /ma '..state.Carol.value..' <stpc>')
    elseif cmdParams[1]:lower() == 'threnody' then
        send_command('@input /ma '..state.Threnody.value..' <stnpc>')
    end

    gearinfo(cmdParams, eventArgs)
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Carnwenhan" then
        meleeSet = set_combine(meleeSet, sets.engaged.Aftermath)
    end

    return meleeSet
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end

    return idleSet
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    local cf_msg = ''
    if state.CombatForm.has_value then
        cf_msg = ' (' ..state.CombatForm.value.. ')'
    end

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

    local ws_msg = state.WeaponskillMode.value

    local c_msg = state.CastingMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060).. ' Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

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
            return 'SongEnfeebleAcc'
        else
            return 'SongEnfeeble'
        end
    elseif state.SongMode.value == 'Placeholder' then
        return 'SongPlaceholder'
    else
        return 'SongEnhancing'
    end
end

function get_lullaby_duration(spell)
    local self = windower.ffxi.get_player()

    local troubadour = false
    local clarioncall = false
    local soulvoice = false
    local marcato = false
 
    for i,v in pairs(self.buffs) do
        if v == 348 then troubadour = true end
        if v == 499 then clarioncall = true end
        if v == 52 then soulvoice = true end
        if v == 231 then marcato = true end
    end

    local mult = 1
    
    if player.equipment.range == 'Daurdabla' then mult = mult + 0.3 end -- change to 0.25 with 90 Daur
    if player.equipment.range == "Gjallarhorn" then mult = mult + 0.4 end -- change to 0.3 with 95 Gjall
    if player.equipment.range == "Marsyas" then mult = mult + 0.5 end

    if player.equipment.main == "Carnwenhan" then mult = mult + 0.5 end -- 0.1 for 75, 0.4 for 95, 0.5 for 99/119
    if player.equipment.main == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.main == "Kali" then mult = mult + 0.05 end
    if player.equipment.sub == "Kali" then mult = mult + 0.05 end
    if player.equipment.sub == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.neck == "Aoidos' Matinee" then mult = mult + 0.1 end
    if player.equipment.neck == "Mnbw. Whistle" then mult = mult + 0.2 end
    if player.equipment.neck == "Mnbw. Whistle +1" then mult = mult + 0.3 end
    if player.equipment.body == "Fili Hongreline +1" then mult = mult + 0.12 end
    if player.equipment.legs == "Inyanga Shalwar +1" then mult = mult + 0.15 end
    if player.equipment.legs == "Inyanga Shalwar +2" then mult = mult + 0.17 end
    if player.equipment.feet == "Brioso Slippers" then mult = mult + 0.1 end
    if player.equipment.feet == "Brioso Slippers +1" then mult = mult + 0.11 end
    if player.equipment.feet == "Brioso Slippers +2" then mult = mult + 0.13 end
    if player.equipment.feet == "Brioso Slippers +3" then mult = mult + 0.15 end
    if player.equipment.hands == 'Brioso Cuffs +1' then mult = mult + 0.1 end
    if player.equipment.hands == 'Brioso Cuffs +3' then mult = mult + 0.1 end
    if player.equipment.hands == 'Brioso Cuffs +3' then mult = mult + 0.2 end

    --JP Duration Gift
    if self.job_points.brd.jp_spent >= 1200 then
        mult = mult + 0.05
    end

    if troubadour then
        mult = mult * 2
    end

    if spell.en == "Foe Lullaby II" or spell.en == "Horde Lullaby II" then 
        base = 60
    elseif spell.en == "Foe Lullaby" or spell.en == "Horde Lullaby" then 
        base = 30
    end

    totalDuration = math.floor(mult * base)
        
    -- Job Points Buff
    totalDuration = totalDuration + self.job_points.brd.lullaby_duration
    if troubadour then 
        totalDuration = totalDuration + self.job_points.brd.lullaby_duration
        -- adding it a second time if Troubadour up
    end

    if clarioncall then
        if troubadour then 
            totalDuration = totalDuration + (self.job_points.brd.clarion_call_effect * 2 * 2)
            -- Clarion Call gives 2 seconds per Job Point upgrade.  * 2 again for Troubadour
        else
            totalDuration = totalDuration + (self.job_points.brd.clarion_call_effect * 2)
            -- Clarion Call gives 2 seconds per Job Point upgrade. 
        end
    end
    
    if marcato and not soulvoice then
        totalDuration = totalDuration + self.job_points.brd.marcato_effect
    end

    -- Create the custom timer
    if spell.english == "Foe Lullaby II" or spell.english == "Horde Lullaby II" then
        send_command('@timers c "Lullaby II ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00377.png')
    elseif spell.english == "Foe Lullaby" or spell.english == "Horde Lullaby" then
        send_command('@timers c "Lullaby ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00376.png')
    end
end

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 12 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 12 and DW_needed <= 21 then
            classes.CustomMeleeGroups:append('MaxHastePlus')
        elseif DW_needed > 21 and DW_needed <= 27 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 27 and DW_needed <= 31 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 31 and DW_needed <= 42 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 42 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(tonumber(cmdParams[2])) == 'number' then
            if tonumber(cmdParams[2]) ~= DW_needed then
            DW_needed = tonumber(cmdParams[2])
            DW = true
            end
        elseif type(cmdParams[2]) == 'string' then
            if cmdParams[2] == 'false' then
                DW_needed = 0
                DW = false
            end
        end
        if type(tonumber(cmdParams[3])) == 'number' then
            if tonumber(cmdParams[3]) ~= Haste then
                Haste = tonumber(cmdParams[3])
            end
        end
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
            end
        end
        if not midaction() then
            job_update()
        end
    end
end

windower.register_event('zone change', 
    function()
        if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
            send_command('gi ugs true')
        end
    end
)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 10)
end

function set_lockstyle()
    send_command('wait 3; input /lockstyleset 18')
end