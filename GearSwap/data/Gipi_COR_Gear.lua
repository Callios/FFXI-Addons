--------------------------------------------------------------------------------------------------------------------
-- (Original: Motenten / Modified: Arislan)
-------------------------------------------------------------------------------------------------------------------

--[[    Custom Features:

        QuickDraw Selector  Cycle through available primary and secondary shot types,
                            and trigger with a single macro
        Haste Detection     Detects current magic haste level and equips corresponding engaged set to
                            optimize delay reduction (automatic)
        Haste Mode          Toggles between Haste II and Haste I recieved, used by Haste Detection [WinKey-H]
        Capacity Pts. Mode  Capacity Points Mode Toggle [WinKey-C]
        Auto. Lockstyle     Automatically locks specified equipset on file load
--]]


-------------------------------------------------------------------------------------------------------------------

--[[

    Custom commands:
    
    gs c qd
        Uses the currently configured shot on the target, with either <t> or <stnpc> depending on setting.

    gs c qd t
        Uses the currently configured shot on the target, but forces use of <t>.
    
    
    Configuration commands:
    
    gs c cycle mainqd
        Cycles through the available steps to use as the primary shot when using one of the above commands.
        
    gs c cycle altqd
        Cycles through the available steps to use for alternating with the configured main shot.
        
    gs c toggle usealtqd
        Toggles whether or not to use an alternate shot.
        
    gs c toggle selectqdtarget
        Toggles whether or not to use <stnpc> (as opposed to <t>) when using a shot.
        
        
    gs c toggle LuzafRing -- Toggles use of Luzaf Ring on and off
    
    Offense mode is melee or ranged.  Used ranged offense mode if you are engaged
    for ranged weaponskills, but not actually meleeing.
    
    Weaponskill mode, if set to 'Normal', is handled separately for melee and ranged weaponskills.
--]]


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
    -- QuickDraw Selector
    state.Mainqd = M{['description']='Primary Shot', 'Dark Shot', 'Earth Shot', 'Water Shot', 'Wind Shot', 'Fire Shot', 'Ice Shot', 'Thunder Shot'}
    state.Altqd = M{['description']='Secondary Shot', 'Earth Shot', 'Water Shot', 'Wind Shot', 'Fire Shot', 'Ice Shot', 'Thunder Shot', 'Dark Shot'}
    state.UseAltqd = M(false, 'Use Secondary Shot')
    state.SelectqdTarget = M(false, 'Select Quick Draw Target')
    state.IgnoreTargetting = M(false, 'Ignore Targetting')

    state.FlurryMode = M{['description']='Flurry Mode', 'Flurry II', 'Flurry I'}
    state.HasteMode = M{['description']='Haste Mode', 'Haste II', 'Haste I'}

    state.Currentqd = M{['description']='Current Quick Draw', 'Main', 'Alt'}
    
    -- Whether to use Luzaf's Ring
    state.LuzafRing = M(false, "Luzaf's Ring")
    -- Whether a warning has been given for low ammo
    state.warned = M(false)
    
    define_roll_values()
    determine_haste_group()

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'LowAcc', 'MidAcc', 'HighAcc', 'STP')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc', 'Critical', 'STP')
    state.WeaponskillMode:options('Normal', 'Acc', 'TH')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'DT', 'Refresh')

    state.WeaponLock = M(false, 'Weapon Lock')    
    state.Gun = M{['description']='Current Gun', 'Death Penalty', 'Fomalhaut', 'Anarchy +2', 'Armageddon'}
    state.CP = M(false, "Capacity Points Mode")

    gear.RAbullet = "Chrono Bullet"
    gear.WSbullet = "Chrono Bullet"
    gear.MAbullet = "Living Bullet"
    gear.QDbullet = "Animikii Bullet"
	gear.ACCbullet = "Devastating Bullet"
    options.ammo_warning_limit = 10

	
	-- adjust Flurry toggle from Flurry to Flurry 2 (windows key + F11 to cycle)
		send_command('bind @f11 gs c cycle FlurryMode')
	
    -- Additional local binds
    send_command('bind @` gs c toggle LuzafRing')
    send_command('bind ^- gs c cycleback mainqd')
    send_command('bind ^= gs c cycle mainqd')
    send_command('bind ^[ gs c toggle selectqdtarget')
    send_command('bind @c gs c toggle CP')
    send_command('bind @g gs c cycle Gun')
    send_command('bind @f gs c cycle FlurryMode')
	
	-- use this to change your haste modes from haste 1 to haste 2 (Windows key + h)
    send_command('bind @h gs c cycle HasteMode')
    send_command('bind @w gs c toggle WeaponLock')

    select_default_macro_book()
    set_lockstyle()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	include('Gipi_augmented-items.lua')
	
	sets.enmity = {
		head=gear.HercHeadDT,
		neck="Unmoving collar +1",
		ear1="Cryptic earring",
		ear2="Trux earring",
		body="Emet Harness +1",
		hands="Assimilator's bazubands +3",
		ring1="Supershear ring",
		ring2="Eihwaz ring",
		back="Agema cape",
		waist="Kasiri belt",
		legs="Ayanmo cosciales +2",
		feet="Ahosi leggings"
		}
	
    sets.precast.JA['Triple Shot'] = {}
    sets.precast.JA['Snake Eye'] = {legs="Lanun Culottes +1"}
    sets.precast.JA['Wild Card'] = {feet="Lanun Bottes +3"}
    sets.precast.JA['Random Deal'] = {body="Lanun Frac +3"}
	sets.precast.JA['Animated Flourish'] = sets.enmity

    sets.precast.CorsairRoll = {
		head="Lanun Tricorne +1",
		neck="Regal Necklace",
		ear1="Infused Earring",
		ear2="Sanare Earring",
		body="Malignance Tabard",
		hands="Chasseur's Gants +1",
		ring1="Defending Ring",
		back=gear.CamMantleDA,
		waist="Flume Belt +1",
		legs="Malignance Tights",
		feet="Lanun Bottes +3",
		}
    
    sets.precast.CorsairRoll["Caster's Roll"] = set_combine(sets.precast.CorsairRoll, {legs="Chas. Culottes +1"})
    sets.precast.CorsairRoll["Courser's Roll"] = set_combine(sets.precast.CorsairRoll, {feet="Chass. Bottes +1"})
    sets.precast.CorsairRoll["Blitzer's Roll"] = set_combine(sets.precast.CorsairRoll, {head="Chass. Tricorne +1"})
    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Chasseur's Frac +1"})
    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Chasseur's Gants +1"})
    
    sets.precast.LuzafRing = set_combine(sets.precast.CorsairRoll, {ring2="Luzaf's Ring"})
    sets.precast.FoldDoubleBust = {hands="Lanun Gants +1"}
    
    sets.precast.CorsairShot = {body="Mirke Wardecors"}

    sets.precast.Waltz = {
		head="Anwig Salade",
        body="Passion Jacket",
		legs="Dashing Subligar"
        }

    sets.precast.Waltz['Healing Waltz'] = {head="Anwig salade"}
    
    sets.precast.FC = {
        head="Carmine Mask +1", --14
        body="Adhemar Jacket", --7
        hands="Leyline Gloves", --7
        legs=gear.HercLegsFC, --5
        feet="Carmine Greaves +1", --8
        neck="Orunmila's Torque", --5
        ear1="Loquacious Earring", --2
        ear2="Enchntr. Earring +1", --2
        ring1="Weather. Ring", --5
        ring2="Kishar Ring", --4
        }

	sets.precast.FC.Cure = set_combine(sets.precast.FC, {
		ear1="Mendicant's earring"
		})
		
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        body="Passion Jacket",
        neck="Magoraga Beads",
        })

    -- (10% Snapshot from JP Gifts, need 60%)
    sets.precast.RA = {
        ammo=gear.RAbullet,
        head=gear.TaeonHeadSNAP,	 --10
		neck="Comm. Charm +2",		 --4
        body="Laksa. Frac +3",		 --
		hands="Carmine Fin. Ga. +1", --8
        back=gear.CamMantleSNAP,	 --10 
		waist="Impulse Belt",		 --3
		legs="Laksamana's Trews +3", --15
		feet="Meghanada Jambeaux +2" --10
        } --60

    sets.precast.RA.Flurry1 = set_combine(sets.precast.RA, {
        head="Chass. Tricorne +1",
		legs="Adhemar Kecks +1", --10
		}) --45

    sets.precast.RA.Flurry2 = set_combine(sets.precast.RA.Flurry1, {
        waist="Yemaya Belt",
		feet="Pursuer's Gaiters",
        }) --32


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	--MELEE WS GEAR
	--Melee Physical WS
	
    sets.precast.WS = {
        head=gear.HercHeadSTR,
		neck="Fotia Gorget",
		ear1="Brutal Earring",
		ear2="Moonshade Earring",
        body="Laksamana's Frac +3",
		hands="Meghanada Gloves +2",
		ring1="Epaminondas's Ring",
		ring2="Epona's Ring",
        back=gear.CamMantleSB,
		waist="Fotia Belt",
		legs=gear.HercLegsSTR,
		feet="Lanun Bottes +3"
        }

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        body="Meghanada Cuirie +2",
        })
        
    sets.precast.WS['Evisceration'] = {
        head="Adhemar Bonnet +1",
		neck="Fotia Gorget",
		ear1="Mache Earring +1",
		ear2="Moonshade Earring",
        body="Abnoba Kaftan",
		hands="Mummu Wrists +2",
		ring1="Mummu Ring",
		ring2="Regal Ring",
        back=gear.CamMantleDA,
		waist="Fotia Belt",
		legs="Samnuha Tights",
		feet="Mummu Gamashes +2"
        }

    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {
        ear2="Mache Earring +1",
        })

    sets.precast.WS['Savage Blade'] = {
        head=gear.HercHeadSTR,
		neck="Fotia Gorget",
		ear1="Ishvara Earring",
		ear2="Moonshade Earring",
        body="Laksamana's Frac +3",
		hands="Meghanada Gloves +2",
		ring1="Epaminondas's Ring",
		ring2="Regal Ring",
        back=gear.CamMantleSB,
		waist="Sailfi Belt +1",
		legs=gear.HercLegsSTR,
		feet="Lanun Bottes +3"
        }
        
    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {
        neck="Combatant's Torque",
		ear1="Mache Earring +1",
		ear2="Mache Earring +1",
		ring1="Ilabrat Ring",
        waist="Grunfeld rope",
        })

    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS['Savage Blade'], {
        head="Adhemar Bonnet +1",
		neck="Fotia Gorget",
		ear1="Mache Earring +1",
		ear2="Moonshade Earring",
		body="Adhemar Jacket +1",
		hands="Meghanada Gloves +2",
		ring1="Ilabrat Ring",
		ring2="Regal Ring",
		back=gear.CamMantleDA,
		waist="Fotia Belt",
		legs="Meghanada Chausses +2",
		feet=gear.HercFeetTP
        }) 

    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'], {
		ear2="Mache Earring +1",
        })

	--Melee Magic WS
	
	sets.precast.WS['Aeolian Edge'] = {
		ammo=gear.MAbullet,
		head=gear.HercHeadMagic,
		neck="Baetyl Pendant",
		ear1="Friomisi Earring",
		ear2="Moonshade Earring",
		body="Lanun Frac +3",
		hands="Carmine Fin. Ga. +1",
		ring1="Dingir Ring",
		ring2="Epaminondas's Ring",
		back=gear.CamMantleMWS,
		waist="Eschan Stone",
		legs=gear.HercLegsMagic,
		feet="Lanun Bottes +3"
		}
	
	sets.precast.WS['Aeolian Edge'].TH = set_combine(sets.precast.WS['Aeolian Edge'], {
		body=gear.HercBodyTH,
		hands=gear.HercHandsTH,
	})

	--RANGED WS GEAR
	--Ranged Physical WS

    sets.precast.WS['Last Stand'] = {
		ammo=gear.WSbullet,
        head="Meghanada Visor +2",
		neck="Fotia Gorget",
		ear1="Ishvara Earring",
		ear2="Moonshade Earring",
        body="Laksamana's Frac +3",
		hands="Meghanada Gloves +2",
		ring1="Epaminondas's Ring",
		ring2="Regal Ring",
        back=gear.CamMantleRWS,
		waist="Fotia Belt",
		legs="Meghanada Chausses +2",
		feet="Lanun Bottes +3"
		}

    sets.precast.WS['Last Stand'].Acc = set_combine(sets.precast.WS['Last Stand'], {
        ammo=gear.ACCbullet,
		ear1="Telos Earring",
		ear2="Beyla Earring",
		waist="K. Kachina Belt +1",
        })

	sets.precast.WS['Split Shot'] = sets.precast.WS['Last Stand']
	sets.precast.WS['Split Shot'].Acc = sets.precast.WS['Last Stand'].Acc
	
	sets.precast.WS['Sniper Shot'] = sets.precast.WS['Last Stand']
	sets.precast.WS['Sniper Shot'].Acc = sets.precast.WS['Last Stand'].Acc
	
	sets.precast.WS['Slug Shot'] = sets.precast.WS['Last Stand']
	sets.precast.WS['Slug Shot'].Acc = sets.precast.WS['Last Stand'].Acc
	
	sets.precast.WS['Numbing Shot'] = sets.precast.WS['Last Stand']
	sets.precast.WS['Numbing Shot'].Acc = sets.precast.WS['Last Stand'].Acc
	
	sets.precast.WS['Detonator'] = sets.precast.WS['Last Stand']
	sets.precast.WS['Detonator'].Acc = sets.precast.WS['Last Stand'].Acc

	--Ranged Magic WS
	
    sets.precast.WS['Wildfire'] = {
        ammo=gear.MAbullet,
		head=gear.HercHeadMagic,
		neck="Comm. Charm +2",
		ear1="Friomisi Earring",
		ear2="Crematio Earring",
        body="Lanun Frac +3",
		hands="Carmine Fin. Ga. +1",
		ring1="Dingir Ring",
		ring2="Epaminondas's Ring",
        back=gear.CamMantleMWS,
		waist="Eschan Stone",
		legs=gear.HercLegsMagic,
		feet="Lanun Bottes +3"
        }

	sets.precast.WS['Wildfire'].Acc = set_combine(sets.precast.WS['Wildfire'], {
		ear1="Hermetic Earring",
		ring2="Regal Ring",
		legs="Laksamana's Trews +3",
		waist="K. Kachina Belt +1",
		})
		
    sets.precast.WS['Leaden Salute'] = {
        ammo=gear.MAbullet,
        head="Pixie Hairpin +1",
		neck="Comm. Charm +2",
		ear1="Friomisi Earring",
		ear2="Moonshade Earring",
        body="Lanun Frac +3",
		hands="Carmine Fin. Ga. +1",
		ring1="Archon Ring",
		ring2="Dingir Ring",
        back=gear.CamMantleMWS,
		waist="K. Kachina Belt +1",
		legs=gear.HercLegsMagic,
		feet="Lanun Bottes +3"
        }

	sets.precast.WS['Leaden Salute'].Acc = set_combine(sets.precast.WS['Leaden Salute'], {
		ear1="Hermetic Earring",
		ring2="Regal Ring",
		legs="Laksamana's Trews +3",
		})
		
    sets.precast.WS['Leaden Salute'].FullTP = {ear2="Crematio Earring"}
	
	--Ranged Hybrid WS
	
	sets.precast.WS['Hot Shot'] = {
		ammo=gear.WSbullet,
        head=gear.HercHeadMagic,
		neck="Comm. Charm +2",
		ear1="Friomisi Earring",
		ear2="Moonshade Earring",
        body="Laksamana's Frac +3",
		hands="Carmine Fin. Ga. +1",
		ring1="Epaminondas's Ring",
		ring2="Regal Ring",
        back=gear.CamMantleRWS,
		waist="K. Kachina Belt +1",
		legs=gear.HercLegsMagic,
		feet="Lanun Bottes +3"
		}
	
	sets.precast.WS['Hot Shot'].Acc = set_combine(sets.precast.WS['Hot Shot'], {
		ammo=gear.ACCbullet,
		ear1="Telos Earring",
        ear2="Enervating Earring",		
        legs="Laksamana's Trews +3",
		feet="Meghanada Jambeaux +2"
		})

	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        legs="Carmine Cuisses +1", --20
        ring1="Evanescence Ring", --5
        }

    sets.midcast.Cure = {
        neck="Incanter's Torque",
        ear2="Mendi. Earring",
        ring1="Stikini Ring +1",
        ring2="Stikini Ring +1",
        waist="Bishop's Sash",
        }  
		
	sets.midcast.Refresh = set_combine(sets.midcast.FastRecast,{
		waist="Gishdubar sash"})
		
    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    sets.midcast['Dark Magic'] = {
        ammo=gear.QDbullet,
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Carmine Greaves +1",
        neck="Sanctity Necklace",
        ear1="Telos Earring",
        ear2="Dedition Earring",
        ring1="Stikini Ring +1",
        ring2="Stikini Ring +1",        
        }

    sets.midcast.CorsairShot = {
        ammo=gear.MAbullet,
        head=gear.HercHeadMagic,
		neck="Comm. Charm +2",
		ear1="Friomisi Earring",
		ear2="Crematio Earring",
        body="Lanun Frac +3",
		hands="Carmine Fin. Ga. +1",
		ring1="Shiva Ring +1",
		ring2="Dingir Ring",
        back=gear.CamMantleMWS,
		waist="Eschan Stone",
		legs=gear.HercLegsMagic,
		feet="Lanun Bottes +3"
        }

    sets.midcast.CorsairShot.Acc = set_combine(sets.midcast.CorsairShot, {
        ammo=gear.QDbullet,
		head="Laksamana's Tricorne +3",
		ear1="Gwati Earring",
		ear2="Dignitary's Earring",
        body="Malignance Tabard",
		hands="Malignance Gloves",
		ring1="Stikini Ring +1",
		ring2="Regal Ring",
		waist="K. Kachina Belt +1",
		legs="Malignance Tights",
		feet="Laksamana's Boots +3"
        })

    sets.midcast.CorsairShot['Light Shot'] = set_combine(sets.midcast.CorsairShot.Acc, {})
    sets.midcast.CorsairShot['Dark Shot'] = sets.midcast.CorsairShot['Light Shot']

    -- Ranged gear
    sets.midcast.RA = {
        ammo=gear.RAbullet,    
        head="Malignance Chapeau",
		neck="Iskur Gorget",
		ear1="Telos Earring",
		ear2="Enervating Earring",
        body="Malignance Tabard",
		hands="Malignance Gloves",
		ring1="Ilabrat Ring",
		ring2="Dingir Ring",
        back=gear.CamMantleRACC,
		waist="Yemaya Belt",
		legs="Malignance Tights",
		feet="Oshosi Leggings +1",
        }

    sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {
		ammo=gear.ACCbullet,
		ear2="Beyla Earring",
		body="Laksamana's Frac +3",
		ring1="Cacoethic Ring +1",
		ring2="Regal Ring",
		waist="K. Kachina Belt +1",
        })

    sets.midcast.RA.Critical = set_combine(sets.midcast.RA, {
        head="Meghanada Visor +2",
		ear2="Odr Earring",
        body="Meghanada Cuirie +2",
        hands="Mummu Wrists +2",
        legs="Darraigner's Brais",
        feet="Oshosi Leggings +1",
		ring1="Begrudging Ring",
		ring2="Mummu Ring",	
		waist="K. Kachina Belt +1",
		back=gear.CamMantleRCRIT,
        })

    sets.midcast.RA.STP = set_combine(sets.midcast.RA, {

        })

    sets.TripleShot = {
        --head="Oshosi Mask", 
        body="Chasseur's Frac +1", 
        hands="Lanun Gants +3", 
		back=gear.CamMantleRACC,
        --legs="Oshosi Trousers", 
        feet="Oshosi Leggings +1", 
        } 

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {}

    sets.idle = {
        ammo=gear.RAbullet,
        head="Meghanada Visor +2",
		neck="Bathy Choker +1",
		ear1="Infused Earring",
		ear2="Sanare Earring",
        body="Meghanada Cuirie +2",
		hands="Meghanada Gloves +2",
		ring1="Chirich Ring +1",
		ring2="Meghanada Ring",
        back=gear.CamMantleDA,
		waist="Flume Belt +1",
		legs="Carmine Cuisses +1",
		feet="Meghanada Jambeaux +2"
        }

    sets.idle.DT = set_combine(sets.idle, {
        head="Malignance Chapeau",		--6
		neck="Warder's Charm +1",		
		ear1="Eabani Earring",
		ear2="Sanare Earring",
        body="Malignance Tabard",		--9
		hands="Malignance Gloves",		--5
		ring1="Defending Ring",			--10
		ring2="Purity Ring",			
        back=gear.CamMantleTP,			--10
		waist="Reiki Yotai",			
		legs="Malignance Tights",		--7
		feet=gear.HercFeetTP,			--2
        })

    sets.idle.Town = set_combine(sets.idle, {ammo=gear.RAbullet,})

	sets.idle.Refresh = set_combine(sets.idle, {
		head=gear.HercHeadREFRESH,
		body="Mekosuchinae harness",
		hands=gear.HercHandsREFRESH,
		ring1="Stikini Ring +1",
		ring2="Stikini Ring +1",
		feet=gear.HercFeetREFRESH,
		})
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = set_combine(sets.idle.DT, {
		ring2="Chirich Ring +1",
		waist="Reiki Yotai",		
		})
		
    sets.defense.MDT = set_combine(sets.defense.PDT, {
		
		})

    sets.Kiting = {legs="Carmine Cuisses +1"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- * DNC Subjob DW Trait: +15%
    -- * NIN Subjob DW Trait: +25%
    
    -- No Magic Haste (74% DW to cap)
    sets.engaged = {
        ammo=gear.RAbullet,
        head="Adhemar Bonnet +1",
		neck="Iskur Gorget",
		ear1="Eabani Earring",			-- 4
		ear2="Suppanomimi",				-- 5 
        body="Adhemar Jacket +1",  		-- 6 
		hands="Floral gauntlets",		-- 5
		ring1="Petrov Ring",			-- 
		ring2="Epona's Ring",			-- 
        back=gear.CamMantleDW,			-- 10
		waist="Reiki Yotai",		    -- 7 
		legs="Carmine Cuisses +1",		-- 6
		feet=gear.HercFeetTP			-- 
        } -- 43

    sets.engaged.LowAcc = set_combine(sets.engaged, {
        neck="Combatant's Torque",
		ear1="Telos Earring",
		ring1="Chirich Ring +1",
        })

    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
		hands="Adhemar Wristbands +1",
		ear2="Mache Earring +1",
		ring2="Chirich Ring +1",
        })

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
        head="Carmine Mask +1",
		ear1="Mache Earring +1",
        waist="Olseni belt",
		legs="Carmine Cuisses +1",
        })

    sets.engaged.STP = set_combine(sets.engaged, {
		head="Mummu Bonnet +2",
		body="Mummu Jacket +2",
		hands="Mummu Wrists +2",
		ring1="Mummu Ring",
		legs="Mummu Kecks +2",
		feet="Mummu Gamashes +2",
        })

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.LowHaste = {
        ammo=gear.RAbullet,
        head="Adhemar Bonnet +1",
		neck="Iskur Gorget",
		ear1="Eabani Earring",			-- 4
		ear2="Suppanomimi",				-- 5 
        body="Adhemar Jacket +1",  		-- 6 
		hands="Floral Gauntlets",  		-- 5
		ring1="Petrov Ring",			-- 
		ring2="Epona's Ring",			--
        back=gear.CamMantleDW,			-- 10
		waist="Reiki Yotai",			-- 7
		legs="Samnuha Tights",			-- 
		feet=gear.HercFeetTP			--
        } -- 37

    sets.engaged.LowAcc.LowHaste = set_combine(sets.engaged.LowHaste, {
        neck="Combatant's Torque",
		ear1="Telos Earring",
		ring1="Chirich Ring +1",
        })

    sets.engaged.MidAcc.LowHaste = set_combine(sets.engaged.LowAcc.LowHaste, {
		hands="Adhemar Wristbands +1",
		ear2="Mache Earring +1",
		ring2="Chirich Ring +1",
        })

    sets.engaged.HighAcc.LowHaste = set_combine(sets.engaged.MidAcc.LowHaste, {
        head="Carmine Mask +1",
		ear1="Mache Earring +1",
        waist="Olseni belt",
		legs="Carmine Cuisses +1",
        })

    sets.engaged.STP.LowHaste = set_combine(sets.engaged.LowHaste, {
		head="Mummu Bonnet +2",
		body="Mummu Jacket +2",
		hands="Mummu Wrists +2",
		ring1="Mummu Ring",
		legs="Mummu Kecks +2",
		feet="Mummu Gamashes +2",
        })

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.MidHaste = {
        ammo=gear.RAbullet,
        head="Adhemar Bonnet +1",
		neck="Iskur Gorget",
		ear1="Eabani Earring",			-- 4
		ear2="Suppanomimi",				-- 5 
        body="Adhemar Jacket +1",  		-- 6 
		hands="Adhemar Wristbands +1",	--
		ring1="Petrov Ring",			-- 
		ring2="Epona's Ring",			--
        back=gear.CamMantleDW,			-- 10
		waist="Reiki Yotai",			-- 7
		legs="Samnuha Tights",			-- 
		feet=gear.HercFeetTP			--
        } -- 32

    sets.engaged.LowAcc.MidHaste = set_combine(sets.engaged.MidHaste, {
        neck="Combatant's Torque",
		ear1="Telos Earring",
		ring1="Chirich Ring +1",
        })

    sets.engaged.MidAcc.MidHaste = set_combine(sets.engaged.LowAcc.MidHaste, {
		hands="Adhemar Wristbands +1",
		ear2="Mache Earring +1",
		ring2="Chirich Ring +1",
        })

    sets.engaged.HighAcc.MidHaste = set_combine(sets.engaged.MidAcc.MidHaste, {
        head="Carmine Mask +1",
		ear1="Mache Earring +1",
        waist="Olseni belt",
		legs="Carmine Cuisses +1",
        })

    sets.engaged.STP.MidHaste = set_combine(sets.engaged.MidHaste, {
		head="Mummu Bonnet +2",
		body="Mummu Jacket +2",
		hands="Mummu Wrists +2",
		ring1="Mummu Ring",
		legs="Mummu Kecks +2",
		feet="Mummu Gamashes +2",
        })

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.HighHaste = {
        ammo=gear.RAbullet,
        head="Adhemar Bonnet +1",
		neck="Iskur Gorget",
		ear1="Eabani Earring",			-- 4
		ear2="Suppanomimi",				-- 5 
        body="Adhemar Jacket +1",  		-- 6 
		hands="Adhemar Wristbands +1",	--
		ring1="Petrov Ring",			--
		ring2="Epona's Ring",			--
        back=gear.CamMantleDW,			-- 10
		waist="Windbuffet Belt +1",		--
		legs="Samnuha Tights",			-- 
		feet=gear.HercFeetTP			--
        } -- 25

    sets.engaged.LowAcc.HighHaste = set_combine(sets.engaged.HighHaste, {
        neck="Combatant's Torque",
		ear1="Telos Earring",
		ring1="Chirich Ring +1",
        })

    sets.engaged.MidAcc.HighHaste = set_combine(sets.engaged.LowAcc.HighHaste, {
		hands="Adhemar Wristbands +1",
		ear2="Mache Earring +1",
		ring2="Chirich Ring +1",
        })

    sets.engaged.HighAcc.HighHaste = set_combine(sets.engaged.MidAcc.HighHaste, {
        head="Carmine Mask +1",
		ear1="Mache Earring +1",
        waist="Olseni belt",
		legs="Carmine Cuisses +1",
        })

    sets.engaged.STP.HighHaste = set_combine(sets.engaged.HighHaste, {
		head="Mummu Bonnet +2",
		body="Mummu Jacket +2",
		hands="Mummu Wrists +2",
		ring1="Mummu Ring",
		legs="Mummu Kecks +2",
		feet="Mummu Gamashes +2",
        })
        
    -- 47% Magic Haste (36% DW to cap)
    sets.engaged.MaxHaste = {
        ammo=gear.RAbullet,
        head="Adhemar Bonnet +1",
		neck="Iskur Gorget",
		ear1="Telos Earring",			-- 
		ear2="Suppanomimi",				-- 5 
        body="Adhemar Jacket +1",  		-- 6 
		hands="Adhemar Wristbands +1",	--
		ring1="Petrov Ring",			--
		ring2="Epona's Ring",			--
        back=gear.CamMantleDA,			--
		waist="Windbuffet Belt +1",		-- 
		legs="Samnuha Tights",			-- 
		feet=gear.HercFeetTP			--
        } -- 11

    sets.engaged.LowAcc.MaxHaste = set_combine(sets.engaged.MaxHaste, {
        neck="Combatant's Torque",
		ear1="Telos Earring",
		ring1="Chirich Ring +1",
        })

    sets.engaged.MidAcc.MaxHaste = set_combine(sets.engaged.LowAcc.MaxHaste, {
		hands="Adhemar Wristbands +1",
		ear2="Mache Earring +1",
		ring2="Chirich Ring +1",
        })

    sets.engaged.HighAcc.MaxHaste = set_combine(sets.engaged.MidAcc.MaxHaste, {
        head="Carmine Mask +1",
		ear1="Mache Earring +1",
        waist="Olseni belt",
		legs="Carmine Cuisses +1",
        })

    sets.engaged.STP.MaxHaste = set_combine(sets.engaged.MaxHaste, {
		head="Mummu Bonnet +2",
		body="Mummu Jacket +2",
		hands="Mummu Wrists +2",
		ring1="Mummu Ring",
		legs="Mummu Kecks +2",
		feet="Mummu Gamashes +2",
        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = { 
        head="Malignance Chapeau",		--6
		body="Malignance Tabard", 		--9
        hands="Malignance Gloves", 		--5
		ring1="Defending Ring", 		--10
		ring2="Chirich Ring +1",
		back=gear.CamMantleDA,			--10
		legs="Malignance Tights", 		--7
        }
    
    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT = set_combine(sets.engaged.LowAcc, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)
    sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)

    sets.engaged.DT.LowHaste = set_combine(sets.engaged.LowHaste, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT.LowHaste = set_combine(sets.engaged.LowAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT.LowHaste = set_combine(sets.engaged.MidAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT.LowHaste = set_combine(sets.engaged.HighAcc.LowHaste, sets.engaged.Hybrid)    
    sets.engaged.STP.DT.LowHaste = set_combine(sets.engaged.STP.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DT.MidHaste = set_combine(sets.engaged.MidHaste, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT.MidHaste = set_combine(sets.engaged.LowAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT.MidHaste = set_combine(sets.engaged.MidAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT.MidHaste = set_combine(sets.engaged.HighAcc.MidHaste, sets.engaged.Hybrid)    
    sets.engaged.STP.DT.MidHaste = set_combine(sets.engaged.STP.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DT.HighHaste = set_combine(sets.engaged.HighHaste, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT.HighHaste = set_combine(sets.engaged.LowAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT.HighHaste = set_combine(sets.engaged.MidAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT.HighHaste = set_combine(sets.engaged.HighAcc.HighHaste, sets.engaged.Hybrid)    
    sets.engaged.STP.DT.HighHaste = set_combine(sets.engaged.HighHaste.STP, sets.engaged.Hybrid)

    sets.engaged.DT.MaxHaste = set_combine(sets.engaged.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT.MaxHaste = set_combine(sets.engaged.LowAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT.MaxHaste = set_combine(sets.engaged.MidAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT.MaxHaste = set_combine(sets.engaged.HighAcc.MaxHaste, sets.engaged.Hybrid)    
    sets.engaged.STP.DT.MaxHaste = set_combine(sets.engaged.STP.MaxHaste, sets.engaged.Hybrid)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Doom = {neck="Nicander's Necklace", ring2="Purity Ring", waist="Gishdubar Sash"}

    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {back="Mecisto. Mantle"}
    sets.Reive = {neck="Ygnas's Resolve +1"}

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
    end
    
    if spell.english == 'Fold' and buffactive['Bust'] == 2 then
        if sets.precast.FoldDoubleBust then
            equip(sets.precast.FoldDoubleBust)
            eventArgs.handled = true
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
            if player.tp > 2900 then
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

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'CorsairRoll' and not spell.interrupted then
        display_roll_info(spell)
    end
    if spell.english == "Light Shot" then
        send_command('@timers c "Light Shot ['..spell.target.name..']" 60 down abilities/00195.png')
    end
end

function job_buff_change(buff,gain)
    -- If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste', 'march', 'mighty guard', 'embrava', 'haste samba', 'geo-haste', 'indi-haste'}:contains(buff:lower()) then
        determine_haste_group()
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end

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
        disable('ranged')
    else
        enable('ranged')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.Gun.current == 'Death Penalty' then
        equip({ranged="Death Penalty"})
    elseif state.Gun.current == 'Fomalhaut' then
        equip({ranged="Fomalhaut"})
    elseif state.Gun.current == 'Anarchy +2' then
        equip({ranged="Anarchy +2"})
    elseif state.Gun.current == 'Armageddon' then
        equip({ranged="Armageddon"})
    end

    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
    return idleSet
end

-- Return a customized weaponskill mode to use for weaponskill sets.
-- Don't return anything if you're not overriding the default value.

function job_update(cmdParams, eventArgs)
    determine_haste_group()
end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
    if spell.type == 'CorsairShot' then
        if state.IgnoreTargetting.value == true then
            state.IgnoreTargetting:reset()
            eventArgs.handled = true
        end
        
        eventArgs.SelectNPCTargets = state.SelectqdTarget.value
    end
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    local msg = ''
    
    msg = msg .. '[ Offense/Ranged: '..state.OffenseMode.current..'/'..state.RangedMode.current .. ' ]'
    msg = msg .. '[ WS: '..state.WeaponskillMode.current .. ' ]'

    if state.DefenseMode.value ~= 'None' then
        msg = msg .. '[ Defense: ' .. state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ' ]'
    end
    
    if state.Kiting.value then
        msg = msg .. '[ Kiting Mode: ON ]'
    end

    msg = msg .. '[ ' .. state.HasteMode.value .. ' ]'

    msg = msg .. '[ *'..state.Mainqd.current

    if state.UseAltqd.value == true then
        msg = msg .. '/'..state.Altqd.current
    end
    
    msg = msg .. '* ]'
    
    add_to_chat(060, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'qd' then
        if cmdParams[2] == 't' then
            state.IgnoreTargetting:set()
        end

        local doqd = ''
        if state.UseAltqd.value == true then
            doqd = state[state.Currentqd.current..'qd'].current
            state.Currentqd:cycle()
        else
            doqd = state.Mainqd.current
        end        
        
        send_command('@input /ja "'..doqd..'" <t>')
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()

    -- Gearswap can't detect the difference between Haste I and Haste II
    -- so use winkey-H to manually set Haste spell level.

    -- Haste (buffactive[33]) - 15%
    -- Haste II (buffactive[33]) - 30%
    -- Haste Samba - 5~10%
    -- Honor March - 12~16%
    -- Victory March - 15~28%
    -- Advancing March - 10~18%
    -- Embrava - 25%
    -- Mighty Guard (buffactive[604]) - 15%
    -- Geo-Haste (buffactive[580]) - 30~40%

    classes.CustomMeleeGroups:clear()

    if state.HasteMode.value == 'Haste II' then
        if(((buffactive[33] or buffactive[580] or buffactive.embrava) and (buffactive.march or buffactive[604])) or
            (buffactive[33] and (buffactive[580] or buffactive.embrava)) or
            (buffactive.march == 2 and buffactive[604]) or buffactive.march == 3) or buffactive[580] == 2 then
            --add_to_chat(122, 'Magic Haste Level: 43%')
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif ((buffactive[33] or buffactive.march == 2 or buffactive[580]) and buffactive['haste samba']) then
            --add_to_chat(122, 'Magic Haste Level: 35%')
            classes.CustomMeleeGroups:append('HighHaste')
        elseif ((buffactive[580] or buffactive[33] or buffactive.march == 2) or
            (buffactive.march == 1 and buffactive[604])) then
            --add_to_chat(122, 'Magic Haste Level: 30%')
            classes.CustomMeleeGroups:append('MidHaste')
        elseif (buffactive.march == 1 or buffactive[604]) then
            --add_to_chat(122, 'Magic Haste Level: 15%')
            classes.CustomMeleeGroups:append('LowHaste')
        end
    else
        if (buffactive[580] and ( buffactive.march or buffactive[33] or buffactive.embrava or buffactive[604]) ) or
            (buffactive.embrava and (buffactive.march or buffactive[33] or buffactive[604])) or
            (buffactive.march == 2 and (buffactive[33] or buffactive[604])) or
            (buffactive[33] and buffactive[604] and buffactive.march ) or buffactive.march == 3 or buffactive[580] == 2 then
            --add_to_chat(122, 'Magic Haste Level: 43%')
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif ((buffactive[604] or buffactive[33]) and buffactive['haste samba'] and buffactive.march == 1) or
            (buffactive.march == 2 and buffactive['haste samba']) or
            (buffactive[580] and buffactive['haste samba'] ) then
            --add_to_chat(122, 'Magic Haste Level: 35%')
            classes.CustomMeleeGroups:append('HighHaste')
        elseif (buffactive.march == 2 ) or
            ((buffactive[33] or buffactive[604]) and buffactive.march == 1 ) or  -- MG or haste + 1 march
            (buffactive[580] ) or  -- geo haste
            (buffactive[33] and buffactive[604]) then
            --add_to_chat(122, 'Magic Haste Level: 30%')
            classes.CustomMeleeGroups:append('MidHaste')
        elseif buffactive[33] or buffactive[604] or buffactive.march == 1 then
            --add_to_chat(122, 'Magic Haste Level: 15%')
            classes.CustomMeleeGroups:append('LowHaste')
        end
    end
end

function define_roll_values()
    rolls = {
        ["Corsair's Roll"]   = {lucky=5, unlucky=9, bonus="Experience Points"},
        ["Ninja Roll"]       = {lucky=4, unlucky=8, bonus="Evasion"},
        ["Hunter's Roll"]    = {lucky=4, unlucky=8, bonus="Accuracy"},
        ["Chaos Roll"]       = {lucky=4, unlucky=8, bonus="Attack"},
        ["Magus's Roll"]     = {lucky=2, unlucky=6, bonus="Magic Defense"},
        ["Healer's Roll"]    = {lucky=3, unlucky=7, bonus="Cure Potency Received"},
        ["Drachen Roll"]      = {lucky=4, unlucky=8, bonus="Pet Magic Accuracy/Attack"},
        ["Choral Roll"]      = {lucky=2, unlucky=6, bonus="Spell Interruption Rate"},
        ["Monk's Roll"]      = {lucky=3, unlucky=7, bonus="Subtle Blow"},
        ["Beast Roll"]       = {lucky=4, unlucky=8, bonus="Pet Attack"},
        ["Samurai Roll"]     = {lucky=2, unlucky=6, bonus="Store TP"},
        ["Evoker's Roll"]    = {lucky=5, unlucky=9, bonus="Refresh"},
        ["Rogue's Roll"]     = {lucky=5, unlucky=9, bonus="Critical Hit Rate"},
        ["Warlock's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Accuracy"},
        ["Fighter's Roll"]   = {lucky=5, unlucky=9, bonus="Double Attack Rate"},
        ["Puppet Roll"]     = {lucky=3, unlucky=7, bonus="Pet Magic Attack/Accuracy"},
        ["Gallant's Roll"]   = {lucky=3, unlucky=7, bonus="Defense"},
        ["Wizard's Roll"]    = {lucky=5, unlucky=9, bonus="Magic Attack"},
        ["Dancer's Roll"]    = {lucky=3, unlucky=7, bonus="Regen"},
        ["Scholar's Roll"]   = {lucky=2, unlucky=6, bonus="Conserve MP"},
        ["Naturalist's Roll"]       = {lucky=3, unlucky=7, bonus="Enh. Magic Duration"},
        ["Runeist's Roll"]       = {lucky=4, unlucky=8, bonus="Magic Evasion"},
        ["Bolter's Roll"]    = {lucky=3, unlucky=9, bonus="Movement Speed"},
        ["Caster's Roll"]    = {lucky=2, unlucky=7, bonus="Fast Cast"},
        ["Courser's Roll"]   = {lucky=3, unlucky=9, bonus="Snapshot"},
        ["Blitzer's Roll"]   = {lucky=4, unlucky=9, bonus="Attack Delay"},
        ["Tactician's Roll"] = {lucky=5, unlucky=8, bonus="Regain"},
        ["Allies' Roll"]    = {lucky=3, unlucky=10, bonus="Skillchain Damage"},
        ["Miser's Roll"]     = {lucky=5, unlucky=7, bonus="Save TP"},
        ["Companion's Roll"] = {lucky=2, unlucky=10, bonus="Pet Regain and Regen"},
        ["Avenger's Roll"]   = {lucky=4, unlucky=8, bonus="Counter Rate"},
    }
end

function display_roll_info(spell)
    rollinfo = rolls[spell.english]
    local rollsize = (state.LuzafRing.value and 'Large') or 'Small'

    if rollinfo then
        add_to_chat(104, '[ Lucky: '..tostring(rollinfo.lucky)..' / Unlucky: '..tostring(rollinfo.unlucky)..' ] '..spell.english..': '..rollinfo.bonus..' ('..rollsize..') ')
    end
end


-- Determine whether we have sufficient ammo for the action being attempted.
function do_bullet_checks(spell, spellMap, eventArgs)
    local bullet_name
    local bullet_min_count = 1
    
    if spell.type == 'WeaponSkill' then
        if spell.skill == "Marksmanship" then
            if spell.english == 'Wildfire' or spell.english == 'Leaden Salute' then
                -- magical weaponskills
                bullet_name = gear.MAbullet
            else
                -- physical weaponskills
                bullet_name = gear.WSbullet
            end
        else
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
        if spell.type == 'CorsairShotShot' and player.equipment.ammo ~= 'empty' then
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
    if player.sub_job == 'DNC' then
        set_macro_page(1, 7)
    else
        set_macro_page(1, 7)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset 17')
end