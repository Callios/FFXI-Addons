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

    state.FlurryMode = M{['description']='Flurry Mode', 'Flurry I', 'Flurry II'}
    state.HasteMode = M{['description']='Haste Mode', 'Haste I', 'Haste II'}

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
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'DT', 'Refresh')

    state.WeaponLock = M(false, 'Weapon Lock')    
    state.Gun = M{['description']='Current Gun', 'Death Penalty', 'Fomalhaut', 'Ataktos'}--, 'Armageddon'
    state.CP = M(false, "Capacity Points Mode")

    gear.RAbullet = "Chrono Bullet"
    gear.WSbullet = "Chrono Bullet"
    gear.MAbullet = "Orichalc. Bullet"
    gear.QDbullet = "Animikii Bullet"
    options.ammo_warning_limit = 10

	-- adjust Flurry toggle from Flurry to Flurry 2 (windows key + F11 to cycle)
		send_command('bind @f11 gs c cycle FlurryMode')
	
    -- Additional local binds
    send_command('bind ^` input /ja "Double-up" <me>')
    send_command('bind !` input /ja "Bolter\'s Roll" <me>')
    send_command ('bind @` gs c toggle LuzafRing')

    send_command('bind ^- gs c cycleback mainqd')
    send_command('bind ^= gs c cycle mainqd')
    send_command('bind ^[ gs c toggle selectqdtarget')

    --send_command('bind @c gs c toggle CP')
    --send_command('bind @g gs c cycle Gun')
	-- Window Key + F to cycle Flurry Mode
    send_command('bind @f gs c cycle FlurryMode')
	
	-- use this to change your haste modes from haste 1 to haste 2 (Windows key + h)
    send_command('bind @h gs c cycle HasteMode')
	
    send_command('bind @w gs c toggle WeaponLock')

    --[[
	send_command('bind ^numlock input /ja "Triple Shot" <me>')

    if player.sub_job == 'WAR' then
        send_command('bind ^numpad/ input /ja "Berserk" <me>')
        send_command('bind ^numpad* input /ja "Warcry" <me>')
        send_command('bind ^numpad- input /ja "Aggressor" <me>')
    elseif player.sub_job == 'RNG' then
        send_command('bind ^numpad/ input /ja "Barrage" <me>')
        send_command('bind ^numpad* input /ja "Sharpshot" <me>')
        send_command('bind ^numpad- input /ja "Shadowbind" <me>')
    end

    send_command('bind ^numpad7 input /ws "Savage Blade" <t>')
    send_command('bind ^numpad8 input /ws "Last Stand" <t>')
    send_command('bind ^numpad4 input /ws "Leaden Salute" <t>')
    send_command('bind ^numpad6 input /ws "Wildfire" <t>')
    send_command('bind ^numpad1 input /ws "Swift Blade" <t>')


    send_command('bind numpad0 input /ra <t>')
   ]]--
   
    select_default_macro_book()
    set_lockstyle()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind @`')
    send_command('unbind ^-')
    send_command('unbind ^=')
    send_command('unbind !-')
    send_command('unbind !=')
    send_command('unbind ^[')
    send_command('unbind ^]')
    send_command('unbind ^,')
    send_command('unbind @c')
    send_command('unbind @g')
    send_command('unbind @f')
    send_command('unbind @h')
    send_command('unbind @w')
    send_command('unbind ^numlock')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad6')
    send_command('unbind ^numpad1')
    send_command('unbind numpad0')
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	--include('yer_augmented-items.lua')
	
	-- Corsair Capes
	MantleSTRWSD = { name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
	MantleAGIWSD = { name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Weapon skill damage +10%',}}
	MantleTP = { name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Store TP"+10',}} -- Callios needs to edit this when cape is done
    MantelAGI = { name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+5','"Store TP"+10',}}
    
	sets.precast.JA['Triple Shot'] = {body="Chasseur's Frac"}
    sets.precast.JA['Snake Eye'] = {legs="Lanun Culottes"}
    sets.precast.JA['Wild Card'] = {feet="Lanun Bottes"}
    sets.precast.JA['Random Deal'] = {body="Lanun Frac"}

    sets.precast.CorsairRoll = {
		head="Lanun Tricorne",
		neck="Regal Necklace",
		hands="Chasseur's Gants",
		back=MantleSTRWSD}
    
    sets.precast.CorsairRoll["Caster's Roll"] = set_combine(sets.precast.CorsairRoll, {legs="Chasseur's Culottes +1"})
    sets.precast.CorsairRoll["Courser's Roll"] = set_combine(sets.precast.CorsairRoll, {feet="Chasseur's Bottes +1"})
    sets.precast.CorsairRoll["Blitzer's Roll"] = set_combine(sets.precast.CorsairRoll, {head="Chasseur's Tricorne +1"})
    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Chasseur's Frac"})
    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Chasseur's Gants"})
    
    sets.precast.LuzafRing = set_combine(sets.precast.CorsairRoll, {ring2="Luzaf's Ring"})
    sets.precast.FoldDoubleBust = {hands="Lanun Gants"}
    
    sets.precast.CorsairShot = {head="Blood Mask",body="Samnuha Coat"}

    sets.precast.Waltz = {
		head="Mummu Bonnet +2",
        body="Passion Jacket",
        neck="Phalaina Locket",
        ring1="Asklepian Ring",
        waist="Gishdubar Sash",
		legs="Dashing Subligar"
        }

    sets.precast.Waltz['Healing Waltz'] = {}
    
    sets.precast.FC = {
        head="Carmine Mask +1",
		neck="Voltsurge Torque",
		ear1="Etiolation Earring",ear2="Loquacious Earring",
		body="Adhemar Jacket",
		hands="Leyline Gloves",
		ring1="Prolix Ring",ring2="Kishar Ring",
		waist="Witful belt",
		legs=HercPantsFC,
		feet="Carmine Greaves"
        }

	sets.precast.FC.Cure = set_combine(sets.precast.FC, {
		ear1="Mendicant's earring"
		})
		
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        body="Passion Jacket",
        neck="Magoraga Beads",
        })

    -- (10% Snapshot from JP Gifts, need 60% in gear)
    sets.precast.RA = {
        ammo=gear.RAbullet,
        head="Taeon Chapeau",			-- 10
        body="Laksamana's Frac +3",				-- 12
		hands="Carmine Finger Gauntlets +1",-- 08/11
        ring1="Haverton ring",
        back="Navarch's Mantle",		-- 06
		waist="Impulse Belt",			-- 03
		legs="Adhemar Kecks",			-- 09/10
		feet="Meghanada Jambeaux +2"	-- 10
        } --58/21 (58 + 10 gifts)

	-- need 45% snapshot in gear
    sets.precast.RA.Flurry1 = set_combine(sets.precast.RA, {
        body="Laksamana's Frac +3", --0/20
        }) --46/41 (15 flurry + 46 gear = 61 snapshot + 10 gifts)

	-- need 30% snapshot in gear
    sets.precast.RA.Flurry2 = set_combine(sets.precast.RA.Flurry1, {
        head="Chass. Tricorne",	--0/14
		waist="Impulse belt",		--0/5
		legs="Pursuer's Pants",		--0/19
        }) --32/45 (30 flurry2 + 32 gear = 62 snapshot + 10 gifts)


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        head=HercHelm_TP,
		neck="Fotia Gorget",
		ear1="Brutal Earring",ear2="Moonshade Earring",
        body="Laksamana's Frac +3",
		hands="Meghanada Gloves +3",
		ring1="Regal Ring",ring2="Epona's Ring",
        back=MantelAGI,
		waist="Fotia Belt",
		legs="Samnuha Tights",
		feet="Lanun Bottes +3"
        }

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        body="Meghanada Cuirie +2",
        })

    sets.precast.WS['Last Stand'] = {
		ammo=gear.WSbullet,
        head="Adhemar Bonnet",
		neck="Fotia Gorget",
		ear1="Moonshade earring",ear2="Ishvara Earring",
        body="Laksamana's Frac +3",
		hands="Meg. Gloves +2",
		ring1="Regal Ring",ring2="Dingir Ring",
        back=MantelAGI,
		waist="Fotia belt",
		legs="Meg. Chausses +2",
		feet="Lanun Bottes +3"
		}

    sets.precast.WS['Last Stand'].Acc = set_combine(sets.precast.WS['Last Stand'], {
        ear1="Enervating Earring",
		body="Laksamana's Frac +3"
        })

    sets.precast.WS['Wildfire'] = {
        ammo=gear.MAbullet,
		head="Meghanada Visor +2",
		neck="Sanctity Necklace",
		ear1="Friomisi Earring",ear2="Moonshade Earring",
        body="Laksamana's Frac +3",
		hands="Carmine Fin. Ga. +1",
		ring1="Regal Ring",ring2="Dingir Ring",
        back=MantleAGI,
		waist="Eschan Stone",
		legs={ name="Herculean Trousers", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Crit.hit rate+1','"Mag.Atk.Bns."+15',}},
		feet={ name="Herculean Boots", augments={'Weapon skill damage +5%','AGI+1','Rng.Acc.+2','Rng.Atk.+14',}},
        }

	sets.precast.WS['Wildfire'].Acc = set_combine(sets.precast.WS['Wildfire'], {
		legs="Mummu Kecks +2",
		})
		
    sets.precast.WS['Leaden Salute'] = {
        ammo=gear.MAbullet,
        head="Pixie Hairpin +1",
		neck="Baetyl Pendant",
		ear1="Friomisi Earring",ear2="Moonshade Earring",
        body="Lanun frac +3",
		hands="Carmine Fin. Ga. +1",
		ring1="Archon Ring",ring2="Dingir Ring",
        back=MantleAGIWSD,
		waist="Eschan Stone",
		legs={ name="Herculean Trousers", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Crit.hit rate+1','"Mag.Atk.Bns."+15',}},
		feet= "Lanun Bottes +3",
        }

	sets.precast.WS['Leaden Salute'].Acc = set_combine(sets.precast.WS['Leaden Salute'], {
		ring1="Regal Ring",
		legs="Mummu Kecks +2",
		})
		
    sets.precast.WS['Leaden Salute'].FullTP = {ear2="Novio Earring"}
        
    sets.precast.WS['Evisceration'] = {
        head="Adhemar Bonnet +1",
		neck="Fotia Gorget",
		ear1="Brutal Earring",ear2="Moonshade Earring",
        body="Laksamana's Frac +3",
		hands="Meghanada Gloves +2",
		ring1="Regal Ring",ring2="Epona's Ring",
        MantelAGI = { name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+5','"Store TP"+10',}},
		waist="Fotia Belt",
		legs="Mummu Kecks +2",
		feet= "Lanun Bottes +3",
        }

    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {
        head="Mummu Bonnet +2",
        hands="Mummu Wrists +2",
        legs="Meghanada Chausses +2",
		feet="Lanun Bottes +3",
        })

    sets.precast.WS['Savage Blade'] = {
        head="Lilitu headpiece",
		neck="Caro Necklace",
		ear1="Ishvara Earring",ear2="Moonshade Earring",
        body="Laksamana's Frac +3",
		hands="Meghanada Gloves +2",
		ring1="Rufescent Ring",ring2="Regal Ring",
        back=MantleSTRWSD,
		waist="Grunfeld rope",
		legs="Samnuha tights",
		feet= "Lanun Bottes +3",
        }
        
    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {
        ring1="Ilabrat Ring",
        waist="Grunfeld Rope"
        })

    sets.precast.WS['Swift Blade'] = set_combine(sets.precast.WS['Savage Blade'], {
        legs="Samnuha Tights",
        neck="Fotia Gorget",
        ear2="Brutal Earring",
        waist="Fotia Belt",
        })

    sets.precast.WS['Swift Blade'].Acc = set_combine(sets.precast.WS['Swift Blade'], {
        body="Meg. Cuirie +2",
		ear1="Dignitary's Earring",
        ear2="Cessance Earring",
        })

    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS['Savage Blade'], {
        head="Adhemar Bonnet +1",
		neck="Fotia Gorget",
		ear1="Cessance Earring",
		ear2="Moonshade Earring",
		body="Laksamana's Frac +3",
		hands="Meghanada Gloves +2",
		ring1="Regal Ring",ring2="Epona's ring",
		back=MantleSTRWSD,
		waist="Fotia Belt",
		legs="Meghanada Chausses +2",
		feet="Meghanada Jambeaux +2"
        }) --MND

    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'], {
        ear2="Dignitary's Earring",
        ring2="Rufescent Ring",
        })

	sets.precast.WS['Hot Shot'] = {
		ammo=gear.WSbullet,
        head=HercHelmWSD,
		neck="Fotia Gorget",
		ear1="Friomisi Earring",ear2="Moonshade Earring",
        body="Laksamana's Frac +3",
		hands="Carmine Finger Gauntlets +1",
		ring1="Regal Ring",ring2="Dingir Ring",
        back=MantleAGIWSD,
		waist="Fotia Belt",
		legs=HercPants_MAB,
		feet="Lanun Bottes +3"
		}
	
	sets.precast.WS['Hot Shot'].Acc = set_combine(sets.precast.WS['Hot Shot'], {
        ear1="Enervating Earring",
		ring2="Cacoethic Ring +1",
        legs="Meghanada Chausses +2",
		feet="Meghanada Jambeaux +2"
		})
	
	sets.precast.WS['Aeolian Edge'] = {
		gear.QDbullet,
		head=HercHelmWSD,
		neck="Sanctity Necklace",
		ear1="Friomisi Earring",ear2="Novio Earring",
		body="Laksamana's Frac +3",
		hands="Leyline Gloves",
		ring1="Regal Ring",ring2="Dingir Ring",
		back=MantleAGIWSD,
		waist="Eschan Stone",
		legs={ name="Herculean Trousers", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Crit.hit rate+1','"Mag.Atk.Bns."+15',}},
        feet={ name="Herculean Boots", augments={'Weapon skill damage +5%','AGI+1','Rng.Acc.+2','Rng.Atk.+14',}},
		}
	
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
        ear1="Roundel Earring",
        ear2="Mendi. Earring",
        ring1="Lebeche Ring",
        ring2="Ephedra Ring",
		back="Solemnity Cape",
        waist="Bishop's Sash",
        }    
	sets.midcast.Refresh = set_combine(sets.midcast.FastRecast,{
		waist="Gishdubar sash"})
		
    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    sets.midcast['Dark Magic'] = {
        ammo=gear.QDbullet,
        head="Mummu Bonnet +2",
        body="Carmine Mail",
        hands="Leyline Gloves",
        legs="Mummu Kecks +2",
        feet="Carmine Greaves",
        neck="Incanter's Torque",
        ear1="Gwati Earring",
        ear2="Dignitary's Earring",
        ring1="Archon Ring",
        ring2="Dingir Ring",
        back=MantleAGIWSD,        
        }

    sets.midcast.CorsairShot = {
        ammo=gear.QDbullet,
        range="Fomalhaut",
        head="Meghanada Visor +2",
		neck="Sanctity Necklace",
		ear1="Friomisi Earring",ear2="Novio Earring",
        body="Samnuha Coat",
		hands="Carmine Fin. Ga. +1",
		ring1="Regal Ring",ring2="Dingir Ring",
        back=MantleAGIWSD,
		waist="Eschan Stone",
		legs={ name="Herculean Trousers", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Crit.hit rate+1','"Mag.Atk.Bns."+15',}},
		feet="Nvrch. Bottes +1"
        }

    sets.midcast.CorsairShot.Acc = set_combine(sets.midcast.CorsairShot, {
        body="Mummu Jacket +2",
		hands="Mummu Wrists +2",
        back=MantleAGI,
		legs="Mummu Kecks +2",
        })

    sets.midcast.CorsairShot['Light Shot'] = set_combine(sets.midcast.CorsairShot.Acc, {
		ear1="Gwati Earring", ear2="Dignitary's Earring",
		ring2="Regal Ring",ring2="Mummu Ring",
		})
		
    sets.midcast.CorsairShot['Dark Shot'] = sets.midcast.CorsairShot['Light Shot']

    -- Ranged gear
    sets.midcast.RA = {
        ammo=gear.RAbullet,    
        head="Malignance Chapeau",
		neck="Iskur Gorget",
		ear1="Telos earring",ear2="Enervating Earring",
        body="Malignance tabard",
		hands="Malignance gloves",
		ring1="Haverton ring",ring2="Cacoethic Ring +1",
        back=MantelAGI,
		waist="Yemaya Belt",
		legs="Malignance tights",
		feet="Meghanada Jambeaux +2"
        }

    sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {
		body="Malignance tabard",
		legs="Meghanada Chausses +2"
        })

    sets.midcast.RA.Critical = set_combine(sets.midcast.RA, {
        head="Mummu Bonnet +2",
        body="Mummu Jacket +2",
        hands="Mummu Wrists +2",
        legs="Mummu Kecks +2",
        feet="Mummu Gamash. +2",
		ring2="Mummu Ring",
        waist="Kwahu Kachina Belt",
        })

    sets.midcast.RA.STP = set_combine(sets.midcast.RA, {
        body="Oshosi Vest",
        feet="Carmine Greaves",
        ear1="Dedition Earring",
		ring2="Ilabrat Ring",
        })

    sets.TripleShot = set_combine(sets.midcast.RA,{
        --head="Oshosi Mask", --4
        body="Chasseur's Frac", --6
        hands="Oshosi Gloves", -- 3
        --legs="Oshosi Trousers", --5
        --feet="Oshosi Leggings", --2
        }) --27

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {}

    sets.idle = {
        ammo=gear.RAbullet,
        head="Malignance Chapeau",
		neck="Loricate Torque +1",
		ear1="Infused Earring",ear2="Etiolation Earring",
        body="Malignance tabard",
		hands="Malignance gloves",
		ring1="Gelatinous Ring +1",ring2="Defending Ring",
        back="Solemnity cape",
		waist="Flume Belt",
		legs="Carmine Cuisses +1",
		feet="Meghanada Jambeaux +2"
        }

    sets.idle.DT = set_combine(sets.idle, {
        head="Malignance Chapeau",
		neck="Loricate Torque +1",
		ear1="Infused Earring",ear2="Etiolation Earring",
        body="Malignance tabard",
		hands="Malignance gloves",
		ring1="Dark Ring",ring2="Defending Ring",
        back="Solemnity cape",
		waist="Flume Belt",
		legs="Malignance tights",
		feet="Meghanada Jambeaux +2"
        })

    sets.idle.Town = set_combine(sets.idle, {
        head="Meghanada Visor +2",
		neck="Bathy choker +1",
		ear1="Infused Earring",ear2="Genmei Earring",
        body="Meghanada Cuirie +2",
		hands="Meghanada Gloves +2",
		ring1="Dark ring",ring2="Defending Ring",
        back="Solemnity cape",
		waist="Flume Belt",
		legs="Carmine Cuisses +1",
		feet="Meghanada Jambeaux +2"
        })

	sets.idle.Refresh = set_combine(sets.idle, {head="Rawhide Mask",body="Mekosuchinae Harness",hands=gear.HercHandsREFRESH,
		feet=gear.HercFeetREFRESH})
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

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
        --ammo=gear.RAbullet,
        head="Adhemar Bonnet +1",
		neck="Iskur Gorget",
		ear1="Telos earring",			-- 4
		ear2="Dedition Earring",				-- 5
        body="Adhemar Jacket +1",		-- 6
		hands="Floral gauntlets",		-- 5
		ring1="Ilabrat Ring",
		ring2="Epona's Ring",
        back=MantleTP,
		waist="Reiki Yotai",			-- 7
		legs="Carmine Cuisses +1",		-- 6
		feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}},				-- 9
        } -- 42% + (15% /dnc or 25% /nin) 

    sets.engaged.LowAcc = set_combine(sets.engaged, {
        neck="Combatant's Torque",
		ring2="Regal Ring",
		waist="Olseni belt"
        })

    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
        ear1="Telos Earring",ear2="Dignitary's Earring"
        })

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
       head="Malignance Chapeau",
        waist="Olseni belt",
        Neck="Combatant's Torque",
        body="Malignance tabard",
        legs="Malignance tights",
        hands="Malignance gloves",
        ring1="Cacoethic Ring +1",
        feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}},
        })

    sets.engaged.STP = set_combine(sets.engaged, {
		ammo=gear.RAbullet,
        head="Malignance Chapeau",
		neck="Combatant's Torque",
		ear1="Dedition Earring",			-- 4
		ear2="Suppanomimi",				-- 5
        body="Malignance tabard",			-- 6
		hands="Malignance gloves",		-- 5
		ring1="Mummu Ring",
		ring2="Epona's Ring",
        back=MantleTP,
		waist="Reiki Yotai",
		legs="Malignance tights",		-- 6
		feet="Mummu Gamashes +2"				-- 9
        })

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.LowHaste = {
        ammo=gear.RAbullet,
        head="Adhemar Bonnet +1",
		neck="Combatant's Torque",
		ear1="Telos Earring",			-- 4
		ear2="Suppanomimi",				-- 5
        body="Adhemar Jacket +1",		-- 6
		hands="Malignance gloves",		-- 5
		ring1="Ilabrat Ring",
		ring2="Epona's Ring",
        back=MantleTP,
		waist="Reiki Yotai",			-- 7
		legs="Carmine Cuisses +1",		-- 6
		feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}},				-- 9
        } -- 42% + (15% /dnc or 25% /nin)

    sets.engaged.LowAcc.LowHaste = set_combine(sets.engaged.LowHaste, {
        neck="Lissome Necklace",
		ring2="Regal Ring",
		waist="Reiki Yotai"
        })

    sets.engaged.MidAcc.LowHaste = set_combine(sets.engaged.LowAcc.LowHaste, {
        ear1="Cessance Earring",ear2="Dignitary's Earring"
        })

    sets.engaged.HighAcc.LowHaste = set_combine(sets.engaged.MidAcc.LowHaste, {
        head="Meghanada Visor +2",
        waist="Olseni belt",
        Neck="Combatant's Torque",
        body="Meghanada Cuirie +2",
        legs="Meghanada Jambeaux +2",
        hands="Malignance gloves",
        ring1="Cacoethic Ring +1",
        feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}},
        })

    sets.engaged.STP.LowHaste = set_combine(sets.engaged.STP, {
		
        })

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.MidHaste = {
        ammo=gear.RAbullet,
        head="Adhemar Bonnet +1",
		neck="Combatant's Torque",
		ear1="Telos Earring",			-- 4
		ear2="Suppanomimi",				-- 5
        body="Adhemar Jacket +1",		-- 6
		hands="Malignance gloves",	-- 
		ring1="Ilabrat Ring",
		ring2="Epona's Ring",
        back=MantleTP,
		waist="Reiki Yotai",			-- 7
		legs="Samnuha Tights",			-- 
		feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}},				-- 9
        } -- 31% + (15% /dnc or 25% /nin)

    sets.engaged.LowAcc.MidHaste = set_combine(sets.engaged.MidHaste, {
        neck="Combatant's Torque",
		ring2="Regal Ring",
		waist="Reiki Yotai"
        })

    sets.engaged.MidAcc.MidHaste = set_combine(sets.engaged.LowAcc.MidHaste, {
        ear1="Cessance Earring",ear2="Dignitary's Earring"
        })

    sets.engaged.HighAcc.MidHaste = set_combine(sets.engaged.MidAcc.MidHaste, {
        head="Meghanada Visor +2",
        waist="Olseni belt",
        Neck="Combatant's Torque",
        body="Meghanada Cuirie +2",
        legs="Meghanada Jambeaux +2",
        hands="Malignance gloves",
        ring1="Cacoethic Ring +1",
        feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}},
        })

    sets.engaged.STP.MidHaste = set_combine(sets.engaged.STP, {

        })

    -- 35% Magic Haste (51% DW to cap), subtract 15% for /dnc or 25% /nin
    sets.engaged.HighHaste = {
        ammo=gear.RAbullet,
        head="Adhemar Bonnet +1",
		neck="Combatant's Torque",
		ear1="Telos Earring",			-- 4
		ear2="Suppanomimi",				-- 5
        body="Adhemar Jacket +1",		-- 6
		hands="Malignance gloves",	-- 
		ring1="Ilabrat Ring",
		ring2="Epona's Ring",
        back=MantleTP,
		waist="Reiki Yotai",			-- 7
		legs="Carmine Cuisses +1",		-- 6
		feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}},				-- 9
        } -- 37% + (15% /dnc or 25% /nin)

    sets.engaged.LowAcc.HighHaste = set_combine(sets.engaged.HighHaste, {
        neck="Combatant's Torque",
		ring2="Regal Ring",
		waist="Kentarch Belt +1"
        })

    sets.engaged.MidAcc.HighHaste = set_combine(sets.engaged.LowAcc.HighHaste, {
        ear1="Cessance Earring",ear2="Dignitary's Earring"
        })

    sets.engaged.HighAcc.HighHaste = set_combine(sets.engaged.MidAcc.HighHaste, {
        head="Meghanada Visor +2",
        waist="Olseni belt",
        Neck="Combatant's Torque",
        body="Meghanada Cuirie +2",
        legs="Meghanada Jambeaux +2",
        hands="Malignance gloves",
        ring1="Cacoethic Ring +1",
        feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}},
        })

    sets.engaged.STP.HighHaste = set_combine(sets.engaged.STP, {

        })
        
    -- 47% Magic Haste (36% DW to cap)
    sets.engaged.MaxHaste = {
        ammo=gear.RAbullet,
        head="Adhemar Bonnet +1",
		neck="Combatant's Torque",
		ear1="Telos earring",		-- 
		ear2="Suppanomimi",				-- 5
        body="Adhemar Jacket +1",		-- 6
		hands="Malignance gloves",	-- 
		ring1="Ilabrat Ring",
		ring2="Epona's Ring",
        back=MantleTP,
		waist="Reiki Yotai",		-- 
		legs="Samnuha Tights",			-- 
		feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}}				-- 
        } -- 11% + (15% /dnc or 25% /nin)

    sets.engaged.LowAcc.MaxHaste = set_combine(sets.engaged.MaxHaste, {
        neck="Lissome Necklace",
		ring2="Regal Ring",
		waist="Kentarch Belt +1"
        })

    sets.engaged.MidAcc.MaxHaste = set_combine(sets.engaged.LowAcc.MaxHaste, {
        ear1="Cessance Earring",ear2="Dignitary's Earring"
        })

    sets.engaged.HighAcc.MaxHaste = set_combine(sets.engaged.MidAcc.MaxHaste, {
        head="Meghanada Visor +2",
        waist="Olseni belt",
        Neck="Combatant's Torque",
        body="Meghanada Cuirie +2",
        legs="Meghanada Jambeaux +2",
        hands="Malignance gloves",
		ring1="Cacoethic Ring +1",
		feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}},
        })

    sets.engaged.STP.MaxHaste = set_combine(sets.engaged.STP, {

        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
		head=HercHelm_DT,
        neck="Loricate Torque +1", --6/6
		body="Meghanada Cuirie +2",
		hands="Malignance gloves",
		back="Solemnity cape", 
        ring2="Defending Ring", --10/10
		legs="Mummu Kecks +2",
		feet=HercBoots_TP
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

    sets.buff.Doom = {ring1="Eshmun's Ring", ring2="Eshmun's Ring", waist="Gishdubar Sash"}

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
            if player.tp > 2500 then
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
  --[[  if state.Gun.current == 'Death Penalty' then
        equip({ranged="Death Penalty"})
    elseif state.Gun.current == 'Fomalhaut' then
        equip({ranged="Fomalhaut"})
    elseif state.Gun.current == 'Ataktos' then
        equip({ranged="Ataktos"})
--    elseif state.Gun.current == 'Armageddon' then
--        equip({ranged="Armageddon"})
    end
]]--
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
        set_macro_page(2, 3)
    else
        set_macro_page(2, 3)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset 78')
end