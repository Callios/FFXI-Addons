-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'MidAcc', 'FullAcc', 'DT')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'Kiting', 'PDT')

	gear.default.obi_waist = "Yamabuki-no-obi"
			
    -- Additional local binds
    send_command('bind ^` input /ja "Chain Affinity" <me>')
    send_command('bind !` input /ja "Efflux" <me>')
    send_command('bind @` input /ja "Burst Affinity" <me>')

    update_combat_form()
    select_default_macro_book(1, 6)
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind @`')
end


-- Set up gear sets.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

	--include('augmented-items.lua')
	
    sets.buff['Burst Affinity'] = {feet="Hashishin Basmak"}
    sets.buff['Chain Affinity'] = {head="Hashishin kavuk +1",feet="Assimilator's charuqs +3"}
    sets.buff.Convergence = {head="Luhlaza keffiyeh +1"}
    sets.buff.Diffusion = {feet="Luhlaza charuqs +1"}
    sets.buff.Enchainment = {body="Luhlaza Jubbah +1"}
    sets.buff.Efflux = {legs="Hashishin tayt +1",back=gear.RosCapeDEX}

    gear.BLUnuke = {name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}}
    gear.BLUSTRWS = { name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}}
    
    -- Precast Sets
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Azure Lore'] = {hands="Luhlaza Bazubands +1"}


    -- Waltz set (chr and vit)
    sets.precast.Waltz = {body="Passion jacket"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {body="Passion jacket"}

    -- Fast cast sets for spells
    
    sets.precast.FC = {ammo="Impatiens",
        head="Carmine mask +1",neck="Baetyl pendant",ear1="Enchanter earring +1",ear2="Loquacious Earring",
        body="Luhlaza jubbah +3",hands="Leyline gloves",ring1="Kishar ring",ring2="Defending Ring",
        back="Fi Follet Cape +1",waist="Witful Belt",legs="Ayanmo cosciales +2",feet="Carmine greaves +1"}
        
    sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, {body="Hashishin mintan +1"})

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {ammo="Amar cluster",
        head="Adhemar bonnet +1",neck="Caro necklace",ear1="Ishvara earring",ear2="Brutal Earring",
        body="Assim. Jubbah +3",hands="Adhemar wristbands +1",ring1="Ilabrat ring",ring2="Epaminondas's ring",
        back=gear.BLUSTRWS,waist="Sailfi Belt +1",legs=gear.HercLegsSTR,feet="Nyame Sollerets"}
    
    sets.precast.WS.Acc = {ammo="Mantoptera",
        head=gear.TaeonHeadTA,neck="Fotia gorget",ear1="Zennaroi Earring",ear2="Moonshade Earring",
        body="Assim. Jubbah +3", hands="Adhemar wristbands +1",ring1="Ilabrat ring",ring2="Ramuh ring +1",
        back=gear.BLUSTRWS,waist="Fotia belt",legs="Samnuha tights",feet="Nyame Sollerets"}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Chant du Cygne'] = {ammo="Jukukik feather",
        head="Adhemar bonnet +1",neck="Fotia gorget",ear1="Telos earring",ear2="Moonshade earring",
        body="Assim. Jubbah +3",hands="Adhemar wristbands +1",ring1="Apate ring",ring2="Epaminondas's ring",
        back=gear.BLUSTRWS,waist="Fotia belt",legs="Samnuha tights",feet="Nyame Sollerets"}
	
	sets.precast.WS['Chant du Cygne'].Acc = {ammo="Falcon eye",
        head="Carmine mask +1",neck="Fotia gorget",ear1="Zennaroi Earring",ear2="Moonshade Earring",
        body="Assim. Jubbah +3",hands=gear.HercHandsACC,ring1="Begrudging ring",ring2="Epaminondas's ring",
        back=gear.BLUSTRWS,waist="Fotia belt",legs="Carmine cuisses +1",feet="Thereoid Greaves"}
		
	sets.precast.WS['Savage Blade'] = {ammo="Amar cluster",
        head="Lilitu headpiece",neck="Caro necklace",ear1="Ishvara earring",ear2="Moonshade Earring",
        body="Assim. Jubbah +3",hands="Jhakri cuffs +2",ring1="Epaminondas's ring",ring2="Rufescent ring",
        back=gear.BLUSTRWS,waist="Sailfi Belt +1",legs="Samnuha tights",feet="Nyame Sollerets"}
		
	sets.precast.WS['Savage Blade'].Acc = {ammo="Amar cluster",
        head="Lilitu headpiece",neck="Caro Necklace",ear1="Regal earring",ear2="Moonshade Earring",
        body="Assim. Jubbah +3",hands="Jhakri cuffs +2",ring1="Epaminondas's ring",ring2="Rufescent ring",
        back=gear.BLUSTRWS,waist="Sailfi Belt +1",legs="Samnuha tights",feet="Nyame Sollerets"}

	sets.precast.WS['Expiacion'] = {ammo="Floestone",
        head="Lilitu headpiece",neck="Caro necklace",ear1="Ishvara earring",ear2="Moonshade Earring",
        body="Assim. Jubbah +3",hands="Jhakri cuffs +2",ring1="Ilabrat ring",ring2="Epaminondas's ring",
        back=gear.BLUSTRWS,waist="Prosilio belt +1",legs=gear.HercLegsSTR,feet="Nyame Sollerets"}
		
	sets.precast.WS['Expiacion'].Acc = {ammo="Mantoptera",
        head="Lilitu headpiece",neck="Caro necklace",ear1="Regal earring",ear2="Moonshade Earring",
        body="Assim. Jubbah +3",hands="Jhakri cuffs +2",ring1="Ilabrat ring",ring2="Epaminondas's ring",
        back=gear.BLUSTRWS,waist="Sailfi Belt +1",legs=gear.HercLegsSTR,feet="Nyame Sollerets"}
		
	sets.precast.WS['Requiescat'] = {ammo="Floestone",
		head="Jhakri coronal +2",neck="Fotia gorget",ear1="Cessance earring",ear2="Brutal earring",
		body="Jhakri robe +2",hands="Jhakri cuffs +2",ring1="Rufescent ring",ring2="Persis ring",
		back="Aurist's cape +1",waist="Fotia belt",legs="Jhakri slops +2",feet="Nyame Sollerets"}
	
	sets.precast.WS['Requiescat'].Acc = {ammo="Falcon eye",
		head="Jhakri coronal +2",neck="Fotia gorget",ear1="Cessance earring",ear2="Dignitary's earring",
		body="Jhakri robe +2",hands="Jhakri cuffs +2",ring1="Rufescent ring",ring2="Persis ring",
		back=gear.RosCapeSTR,waist="Fotia belt",legs="Jhakri slops +2",feet="Nyame Sollerets"}
		
    sets.precast.WS['Sanguine Blade'] = {ammo="Pemphredo tathlum",
        head="pixie hairpin +1",neck="Sanctity Necklace",ear1="Regal earring",ear2="Friomisi Earring",
        body="Amalric Doublet +1", hands="Jhakri cuffs +2", ring1="Shiva ring", ring2="Shiva ring",
        back=gear.BLUnuke,waist="Orpheus's sash",
        legs="Amalric Slops +1", feet="Amalric Nails +1"}
    
	sets.precast.WS['Flash Nova'] = {ammo="Pemphredo tathlum",
        head="Jhakri coronal +2",neck="Sanctity Necklace",ear1="Regal earring",ear2="Friomisi Earring",
        body="Assimilator jubbah +3",hands="Jhakri cuffs +2",ring1="Shiva ring +1",ring2="Shiva ring +1",
        back="Cornflower cape",waist="Orpheus's sash",legs="Amalric slops",feet=gear.HercFeetMagic}
    
    -- Midcast Sets
    sets.midcast.FastRecast = {ammo="Staunch tathlum +1",
		head="Carmine mask +1",neck="Baetyl pendant",ear1="Etiolation earring",ear2="Loquacious Earring",
        body="Luhlaza Jubbah +3",hands="Leyline gloves",ring1="Defending Ring",ring2="Jhakri ring",
        back="Cornflower cape",waist="Witful belt",legs="Ayanmo cosciales +1",feet="Carmine greaves +1"}
        
    sets.midcast['Blue Magic'] = set_combine(sets.midcast.FastRecast,{hands="Hashishin bazubands"})
	
	sets.midcast.Aquaveil = set_combine(sets.midcast.FastRecast, {
		legs="Shedir seraweels"})
    
    -- Physical Spells --
    
    sets.midcast['Blue Magic'].Physical = {ammo="Floestone",
        head="Jhakri coronal +2",neck="Caro necklace",ear1="Regal earring",ear2="Dignitary's earring",
        body="Ayanmo corazza +2",hands="Jhakri cuffs +2",ring1="Ilabrat ring",ring2="Shukuyu Ring",
        back="Cornflower Cape",waist="Grunfeld rope",legs="Ayanmo cosciales +2",feet="Nyame Sollerets"}

    sets.midcast['Blue Magic'].PhysicalAcc = {ammo="Mantoptera eye",
        head="Carmine mask +1",neck="Caro necklace",ear1="Regal earring",ear2="Dignitary's earring",
        body="Assimilator's jubbah +3",hands="Jhakri cuffs +2",ring1="Ilabrat ring",ring2="Ramuh ring +1",
        back=gear.BLUnuke,waist="Grunfeld rope",legs="Carmine cuisses +1",feet="Nyame Sollerets"}

    sets.midcast['Blue Magic'].PhysicalStr = set_combine(sets.midcast['Blue Magic'].Physical,{})
    sets.midcast['Blue Magic'].PhysicalDex = set_combine(sets.midcast['Blue Magic'].Physical,{})
    sets.midcast['Blue Magic'].PhysicalVit = set_combine(sets.midcast['Blue Magic'].Physical,{})
    sets.midcast['Blue Magic'].PhysicalAgi = set_combine(sets.midcast['Blue Magic'].Physical,{})
    sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical,{})
    sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical,{})
    sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical,{})
    sets.midcast['Blue Magic'].PhysicalHP = set_combine(sets.midcast['Blue Magic'].Physical,{})


    -- Magical Spells --
    
    sets.midcast['Blue Magic'].Magical = {ammo="Ghastly tathlum +1",
        head="Amalric coif +1",neck="Baetyl pendant",ear1="Regal Earring",ear2="Friomisi earring",
        body="Amalric doublet +1",hands="Amalric gages +1",ring1="Shiva ring",ring2="Jhakri ring",
        back=gear.BLUnuke,waist="Orpheus's sash",legs="Amalric slops +1",feet="Amalric nails +1"}

    sets.midcast['Blue Magic'].Magical.Resistant = {ammo="Ghastly tathlum +1",
		head="Amalric coif +1",neck="Sanctity Necklace",ear1="Regal Earring",ear2="Dignitary's earring",
		body="Amalric doublet +1",hands="Amalric gages +1",ring1="Stikini ring",ring2="Stikini ring",
		back=gear.BLUnuke,waist="Orpheus's sash",legs="Amalric slops +1",feet="Amalric nails +1"}
		
	sets.midcast['Tenebral Crush'] = set_combine(sets.midcast['Blue Magic'].Magical,{
		head="Pixie hairpin +1",ring2="Archon ring"})
    
    sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical,{})
    sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical)
    sets.midcast['Blue Magic'].MagicalVit = set_combine(sets.midcast['Blue Magic'].Magical,{})
    sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical)

    sets.midcast['Blue Magic'].MagicAccuracy = {ammo="Pemphredo tathlum",
        head="Carmine mask +1",neck="Sanctity necklace",ear1="Gwati earring",ear2="Dignitary's earring",
		body="Jhakri robe +2",hands="Jhakri cuffs +2",ring1="Stikini ring",ring2="Jhakri ring",
        back=gear.BLUnuke,waist="Luminary sash",legs="Jhakri slops +2",feet="Jhakri Pigaches +2"}

    -- Breath Spells --
    
    sets.midcast['Blue Magic'].Breath = {
        ear1="Lifestorm Earring",ear2="Psystorm Earring",
        body="Respite cloak",hands="Assimilator's Bazubands +1",ring1="K'ayres Ring",ring2="Meridian ring",
        back="Moonbeam cape",legs="Hashishin tayt +1",feet="Nyame Sollerets"}

    -- Other Types --
    
    sets.midcast['Blue Magic'].Stun = set_combine(sets.midcast['Blue Magic'].MagicAccuracy,
        {ammo="Honed tathlum",
		head="Carmine mask +1",neck="Sanctity necklace",ear1="Regal earring",ear2="Dignitary's earring",
		body="Assimilator's jubbah +3",hands="Jhakri cuffs +2",ring1="Stikini ring",ring2="Stikini ring",
		back="Cornflower cape",waist="Eschan stone",legs="Carmine cuisses +1",feet="Nyame Sollerets"})

    sets.midcast['Blue Magic'].SkillBasedBuff = {ammo="Mavi Tathlum",
        head="Luhlaza keffiyeh +1",neck="Incanter's torque", wasit="Witful belt",
        body="Hashishin mintan +1",hands="Rawhide gloves",ring1="Stikini Ring",ring2="Stikini ring",
        back="Cornflower Cape",legs="Hashishin tayt +1",feet="Luhlaza charuqs +1"}

    sets.midcast['Blue Magic'].Buff = {ammo="Impatiens",
        head="Carmine mask +1",neck="Baetyl pendant",ear1="Etiolation earring",ear2="Loquacious Earring",
        body="Hashishin mintan +1",hands="Hashishin Bazubands",ring1="Kishar ring",ring2="Jhakri ring",
        back="Solemnity cape",waist="Witful Belt",legs="Ayanmo cosciales +2",feet="Carmine greaves +1"}
		
	sets.midcast['Blue Magic']['White Wind'] = {
        head=gear.TelchineHeadCP,neck="Phalaina locket",ear2="Mendicant's earring",
        body="Vrikodara jupon",hands=gear.TelchineHandsCP,ring1="Kunaji ring",ring2="Meridian Ring",
        back="Moonbeam cape",waist="Chuq'aba belt",legs="Gyve Trousers",feet="Medium's sabots"}

    sets.midcast['Blue Magic'].Healing = {
        head=gear.TelchineHeadCP,neck="Phalaina locket",ear1="Regal earring",ear2="Mendicant's earring",
		body="Vrikodara jupon",hands=gear.TelchineHandsCP,ring1="Persis Ring",ring2="Rufescent ring",
        back="Tempered cape +1",waist="Gishdubar sash",legs="Gyve Trousers",feet="Medium's sabots"}
    
    sets.midcast.Protect = {ring1="Sheltered Ring"}
    sets.midcast.Protectra = {ring1="Sheltered Ring"}
    sets.midcast.Shell = {ring1="Sheltered Ring"}
    sets.midcast.Shellra = {ring1="Sheltered Ring"}
    

    
    
    -- Sets to return to when not performing an action.

    -- Gear for learning spells: +skill and AF hands.
    sets.PDT = {ammo="Staunch tathlum +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance gloves",
    legs="Malignance tights",
    feet="Aya. Gambieras +2",
    neck="Bathy Choker +1",
    waist="Flume Belt",
    ear1="Odnowa Earring",
    ear2="Odnowa Earring +1",
    ring1="Defending Ring",
    ring2="Gelatinous ring +1",
    back="Solemnity Cape",
}
    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Resting sets
    sets.resting = {ammo="Staunch tathlum +1",
        head="Rawhide mask",neck="Bathy choker +1",ear1="Infused earring",ear2="Ethereal Earring",
        body="Jhakri robe +2",hands="Serpentes Cuffs",ring1="Defending Ring",ring2="Dark Ring",
        back="Moonbeam cape",waist="Fucho-no-obi",legs="Carmine cuisses +1",feet="Nyame Sollerets"}
    
    -- Idle sets
    sets.idle = {ammo="Staunch tathlum +1",
        head="Rawhide mask",neck="Bathy choker +1",ear1="Odnowa Earring",ear2="Odnowa Earring +1",
        body="Jhakri robe +2",hands="Malignance gloves",ring1="Defending ring",ring2="Dark Ring",
        back="Solemnity cape",waist="Fucho-no-obi",legs="Carmine cuisses +1",feet="Nyame Sollerets"}

    sets.idle.PDT = {ammo="Staunch tathlum +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance gloves",
    legs="Malignance tights",
    feet="Nyame Sollerets",
    neck="Bathy Choker +1",
    waist="Flume Belt",
    ear1="Odnowa Earring",
    ear2="Odnowa Earring +1",
    ring1="Defending Ring",
    ring2="Gelatinous ring +1",
    back="Solemnity Cape",}

    sets.idle.Town = {ammo="Staunch tathlum +1",
        head="Malignance Chapeau",neck="Bathy choker +1",ear1="Infused earring",ear2="Odnowa earring +1",
        body="Jhakri robe +2",hands="Malignance gloves",ring1="Dark Ring",ring2="Defending ring",
        back="Solemnity cape",waist="Fucho-no-obi",legs="Carmine cuisses +1",feet="Nyame Sollerets"}

    sets.idle.Learning = set_combine(sets.idle, sets.Learning)

    -- Defense sets
    sets.defense.PDT =  {ammo="Staunch tathlum +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance gloves",
    legs="Malignance tights",
    feet="Nyame Sollerets",
    neck="Loricate torque +1",
    waist="Flume belt",
    ear1="Odnowa Earring",
    ear2="Odnowa Earring +1",
    ring1="Defending Ring",
    ring2="Gelatinous ring +1",
    back="Solemnity Cape",
}
    sets.defense.MDT = {ammo="Staunch Tathlum +1",
    head="Aya. Zucchetto +2",
    body="Ayanmo Corazza +2",
    hands="Aya. Manopolas +2",
    legs="Aya. Cosciales +2",
    feet="Nyame Sollerets",
    neck="Loricate torque +1",
    waist="Flume belt",
    ear1="Odnowa Earring",
    ear2="Odnowa Earring +1",
    ring1="Defending Ring",
    ring2="Minerva's ring",
    back="Solemnity Cape"
}

    sets.Kiting = {ammo="Staunch tathlum +1",
        head="Aya. Zucchetto +2",neck="Loricate torque +1",ear1="Genmei Earring",ear2="Etiolation Earring",
        body="Ayanmo corazza +2",hands="Aya. Manopolas +2",ring1="Defending Ring",ring2="Gelatinous Ring +1",
        back="Solemnity cape",waist="Flume Belt",legs="Carmine cuisses +1",feet="Aya. Gambieras +2"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged = {ammo="Ginsen",
        head="Adhemar bonnet +1",neck="Combatant's torque",ear1="Telos earring",ear2="Suppanomimi",
        body="Adhemar jacket +1",hands="Adhemar wristbands +1",ring1="Petrov ring",ring2="Epona's Ring",
        back="Lupine cape",waist="Windbuffet Belt +1",legs="Samnuha tights",
        feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}}
        }
		
	sets.engaged.MidAcc = {ammo="Ginsen",
        head="Adhemar bonnet +1",neck="Combatant's torque",ear1="Telos earring",ear2="Dignitary Earring",
        body="Adhemar jacket +1",hands="Adhemar wristbands +1",ring1="Petrov ring",ring2="Epona's Ring",
        back="Lupine cape",waist="Olseni belt",legs="Samnuha tights",
        feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}}
        }
		
    sets.engaged.FullAcc = {ammo="Ginsen",
        head="Ayanmo Zucchetto +2",neck="Combatant's torque",ear1="Telos earring",ear2="Dignitary's earring",
        body="Ayanmo Corazza +2",hands="Ayanmo Manopolas +2",ring1="Cacoethic ring +1",ring2="Ilabrat ring",
        back="Lupine cape",waist="Olseni belt",legs="Carmine cuisses +1",
        feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}}
        }

sets.engaged.DT = {ammo="Ginsen",
        head="Malignance Chapeau",neck="Combatant's torque",ear1="Telos earring",ear2="Dignitary's earring",
        body="Malignance Tabard",hands="Malignance gloves",ring1="Cacoethic ring +1",ring2="Ilabrat ring",
        back="Lupine cape",waist="Windbuffet Belt +1",legs="Malignance tights",
        feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}}
        }
	-- DW Sets
    sets.engaged.DW = {ammo="Ginsen",
        head="Adhemar bonnet +1",neck="Combatant's torque",ear1="Eabani earring",ear2="Suppanomimi",
        body="Adhemar jacket +1",hands="Adhemar wristbands +1",ring1="Petrov ring",ring2="Epona's Ring",
        back="Lupine cape",waist="Windbuffet Belt +1",legs="Samnuha tights",
        feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}}
        }
		
	sets.engaged.DW.MidAcc = {ammo="Falcon eye",
        head="Adhemar bonnet +1",neck="Combatant's torque",ear1="Telos earring",ear2="Cessance Earring",
        body="Adhemar jacket +1",hands="Adhemar wristbands +1",ring1="Petrov ring",ring2="Epona's Ring",
        back="Lupine cape",waist="Olseni belt",legs="Samnuha tights",
        feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}}
        }
		
    sets.engaged.DW.FullAcc = {ammo="Ginsen",
        head="Ayanmo Zucchetto +2",neck="Combatant's torque",ear1="Telos earring",ear2="Dignitary's earring",
        body="Ayanmo Corazza +2",hands="Ayanmo Manopolas +2",ring1="Cacoethic ring +1",ring2="Ilabrat ring",
        back="Lupine cape",waist="Olseni belt",legs="Carmine cuisses +1",
        feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}}
        }

        sets.engaged.DW.DT = {ammo="Ginsen",
        head="Malignance Chapeau",neck="Combatant's torque",ear1="Eabani Earring",ear2="Suppanomimi",
        body="Malignance Tabard",hands="Malignance gloves",ring1="Petrov Ring",ring2="Ilabrat ring",
        back="Lupine cape",waist="Windbuffet Belt +1",legs="Malignance tights",
        feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}}
        }

    sets.self_healing = {}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if unbridled_spells:contains(spell.english) and not state.Buff['Unbridled Learning'] then
        eventArgs.cancel = true
        windower.send_command('@input /ja "Unbridled Learning" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
    end
custom_aftermath_timers_precast(spell)
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Add enhancement gear for Chain Affinity, etc.
    if spell.skill == 'Blue Magic' then
        for buff,active in pairs(state.Buff) do
            if active and sets.buff[buff] then
                equip(sets.buff[buff])
            end
        end
        if spellMap == 'Healing' and spell.target.type == 'SELF' and sets.self_healing then
            equip(sets.self_healing)
        end
    end

    -- If in learning mode, keep on gear intended to help with that, regardless of action.
    if state.OffenseMode.value == 'Learning' then
        equip(sets.Learning)
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
custom_aftermath_timers_aftercast(spell)
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
        state.Buff[buff] = gain
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
-- Return custom spellMap value that can override the default spell mapping.
-- Don't return anything to allow default spell mapping to be used.
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Blue Magic' then
        for category,spell_list in pairs(blue_magic_maps) do
            if spell_list:contains(spell.english) then
                return category
            end
        end
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        set_combine(idleSet, sets.latent_refresh)
    end
    return idleSet
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_combat_form()
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    -- Check for H2H or single-wielding
    if player.equipment.sub == "Genbu's Shield" or player.equipment.sub == 'empty' then
        state.CombatForm:reset()
    else
        state.CombatForm:set('DW')
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(2, 4)
    else
        set_macro_page(2, 4)
    end
end


