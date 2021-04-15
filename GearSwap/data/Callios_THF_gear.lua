-- Setup vars that are user-dependent. Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal','Hybrid','LowAcc', 'MidAcc', 'FullAcc')
    state.HybridMode:options('Normal', 'Evasion', 'PDT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.PhysicalDefenseMode:options('PDT', 'MDT')
    state.IdleMode:options('Normal')
     
	gear.default.obi_waist = "Eschan stone"
	 
    -- Additional local binds
    
    select_default_macro_book(2, 2)
end
     
function init_gear_sets()

    --------------------------------------
    -- Start defining the sets
    --------------------------------------
	THFCape = {}
    THFCape.TP      = {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+5','"Store TP"+10',}}
    THFCape.DEXWS = {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}}
    gear.HercFeetFC = { name="Herculean Boots", augments={'"Mag.Atk.Bns."+12','"Fast Cast"+6','Mag. Acc.+1',}}
    gear.HercLegsFC = {name="Herculean Trousers", augments={'"Fast Cast"+5','MND+5',}}
    gear.HercHeadFC = { name="Herculean Helm", augments={'"Fast Cast"+3','INT+4','Mag. Acc.+3','"Mag.Atk.Bns."+6',}}
	--include('augmented-items.lua')
	
    sets.TreasureHunter = {hands="Plunderer's Armlets +1", waist="Chaac belt", feet="Skulker's poulaines"}
	
    -- Precast Sets
    -- Precast sets to enhance JAs
    sets.precast.JA['Collaborator'] = {head="Skulker's bonnet"}
    sets.precast.JA['Accomplice'] = {head="Skulker's bonnet"}
    sets.precast.JA['Flee'] = {feet="Pillager's Poulaines +1"}
    sets.precast.JA['Hide'] = {body="Pillager's Vest +1"}
    sets.precast.JA['Conspirator'] = {body="Skulker's vest"}
    sets.precast.JA['Steal'] = {head="Assassin's Bonnet +2",hands="Pillager's armlets +1",feet="Pillager's Poulaines +1"}
    sets.precast.JA['Despoil'] = {legs="Raider's Culottes +2",feet="Raider's Poulaines +2"}
    sets.precast.JA['Perfect Dodge'] = {hands="Plunderer's Armlets +1"}
    sets.precast.JA['Feint'] = {legs="Plunderer's culottes"}
    sets.precast.JA["Assassin's Charge"] = {feet="Plun. Poulaines +1"}
     
    sets.precast.JA['Sneak Attack'] = {}
     
    sets.precast.JA['Trick Attack'] = {}
     
     
    -- Waltz set (chr and vit)
    sets.precast.Waltz = {body="Passion jacket"}
	
    -- Dont need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
	
    -- Fast cast sets for spells
    sets.precast.FC = {ammo="Staunch tathlum +1",
		head=gear.HercHeadFC,neck="Orunmila's torque",ear1="Enchanter earring +1",ear2="Loquacious Earring",
		body="Adhemar jacket",ring1="Rahab Ring",ring2="Lebeche ring", neck="Baetyl Pendant", hands="Leyline gloves", legs=gear.HercLegsFC,
		back="Swith cape",waist="Tempus Fugit +1", feet=gear.HercFeetFC}
     
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {body="Passion jacket",neck="Magoraga Beads"})
     
    -- Ranged snapshot gear
    sets.precast.RangedAttack = {
		head="Aurore beret +1",
		ring1="Haverton ring",
		legs="Nahtirah trousers",feet="Meghanada jambeaux +2"}
	
    -- Weaponskill sets
	
    -- Default set for any weaponskill that isnt any more specifically defined	
    sets.precast.WS = {ammo="Falcon eye",
		head="Lilitu headpiece",neck="Caro necklace",ear1="Sherida earring",ear2="Moonshade earring",
        body="Plunderer's vest +3",hands="Meghanada gloves +2",ring1="Regal",ring2="Ilabrat ring",
        back=THFCape.DEXWS,waist="Grunfeld rope",legs="Lustratio subligar +1",feet="Lustratio leggings +1"}
		
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {})
     
    -- Specific weaponskill sets. Uses the base set if an appropriate WSMod version isnt found.
    sets.precast.WS['Evisceration'] = {ammo="Yetshila",
		head="Adhemar bonnet +1",neck="Fotia gorget",ear1="Sherida earring",ear2="Moonshade earring",
        body="Plunderer's vest +3",hands="Meghanada gloves +2",ring1="Regal ring",ring2="Ilabrat ring",
        back=THFCape.DEXWS,waist="Fotia belt",legs="Lustratio subligar +1",feet="Lustratio leggings +1"}
		
    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {ammo="Falcon eye"})
    sets.precast.WS['Evisceration'].SA = set_combine(sets.precast.WS['Evisceration'].Mod, {ammo="Yetshila"})
    sets.precast.WS['Evisceration'].TA = set_combine(sets.precast.WS['Evisceration'].Mod, {ammo="Yetshila"})
    sets.precast.WS['Evisceration'].SATA = set_combine(sets.precast.WS['Evisceration'].Mod, {ammo="Yetshila"})
     
	 
	sets.precast.WS['Exenterator'] = {ammo="Yamarang",
		head="Meghanada visor +2",neck="Fotia gorget",ear1="Sherida earring",ear2="Moonshade earring",
        body="Plunderer's vest +3",hands="Meghanada gloves +2",ring1="Dingir ring",ring2="Ilabrat ring",
        back=THFCape.DEXWS,waist="Fotia belt",legs="Meghanada chausses +2",feet="Meghanada jambeaux +2"}
		
    sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {ammo="Falcon eye"})
    sets.precast.WS['Exenterator'].SA = set_combine(sets.precast.WS['Exenterator'].Mod, {ammo="Falcon eye"})
    sets.precast.WS['Exenterator'].TA = set_combine(sets.precast.WS['Exenterator'].Mod, {ammo="Falcon eye"})
    sets.precast.WS['Exenterator'].SATA = set_combine(sets.precast.WS['Exenterator'].Mod, {ammo="Falcon eye"})
	
	 
    sets.precast.WS["Rudra's Storm"] = { ammo="Yamarang",
    head={ name="Lilitu Headpiece", augments={'STR+10','DEX+10','Attack+15','Weapon skill damage +3%',}},
    body="Plunderer's vest +3",
    hands="Meg. Gloves +2",
    legs="Lustratio subligar +1",feet="Lustratio leggings +1",
    neck="Caro Necklace",
    waist="Grunfeld Rope",
    left_ear="Ishvara Earring",
    right_ear="Moonshade Earring",
    left_ring="Ilabrat Ring",
    right_ring="Regal Ring",
    back= THFCape.DEXWS,}
		
    sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"], {head="Meghanada visor +2"})
    sets.precast.WS["Rudra's Storm"].SA = set_combine(sets.precast.WS["Rudra's Storm"], {head="Lilitu headpiece",ammo="Yetshila"})
    sets.precast.WS["Rudra's Storm"].TA = set_combine(sets.precast.WS["Rudra's Storm"], {head="Lilitu headpiece",ammo="Yetshila"})
    sets.precast.WS["Rudra's Storm"].SATA = set_combine(sets.precast.WS["Rudra's Storm"], {head="Lilitu headpiece",ammo="Yetshila"})
	
	
	sets.precast.WS["Mandalic Stab"] = sets.precast.WS["Rudra's Storm"]
		
    sets.precast.WS["Mandalic Stab"].Acc = set_combine(sets.precast.WS["Rudra's Storm"], {})
    sets.precast.WS["Mandalic Stab"].SA = set_combine(sets.precast.WS["Rudra's Storm"], {ammo="Yetshila"})
    sets.precast.WS["Mandalic Stab"].TA = set_combine(sets.precast.WS["Rudra's Storm"], {ammo="Yetshila"})
    sets.precast.WS["Mandalic Stab"].SATA = set_combine(sets.precast.WS["Rudra's Storm"], {ammo="Yetshila"})
	
	
    sets.precast.WS['Mercy Stroke'] = {
		head="Lilitu headpiece",neck="Caro necklace",ear1="Sherida earring",ear2="Moonshade earring",
        body="Plunderer's vest +3",hands="Meghanada gloves +2",ring1="Ramuh ring +1",ring2="Ilabrat Ring",
        back=gear.ToutCapeWS,waist="Grunfeld rope",legs="Lustratio subligar +1",feet="Lustratio leggings +1"}
		
    sets.precast.WS['Mercy Stroke'].Acc = set_combine(sets.precast.WS['Mercy Stroke'], {})
    sets.precast.WS['Mercy Stroke'].SA = set_combine(sets.precast.WS['Mercy Stroke'].Mod, {ammo="Yetshila"})
    sets.precast.WS['Mercy Stroke'].TA = set_combine(sets.precast.WS['Mercy Stroke'].Mod, {ammo="Yetshila"})
    sets.precast.WS['Mercy Stroke'].SATA = set_combine(sets.precast.WS['Mercy Stroke'].Mod, {ammo="Yetshila"})
    
	
	sets.precast.WS['Aeolian Edge'] = {
		head="Lilitu headpiece",
        neck="Baetyl pendant",
        ear1="Friomisi earring",
        ear2="Moonshade earring",
		body="Samnuha coat",
        hands="Leyline gloves",
        ring1="Regal Ring",
        ring2="Dingir ring",
		waist="Eschan stone",
        legs={ name="Herculean Trousers", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Crit.hit rate+1','"Mag.Atk.Bns."+15',}},
        feet={ name="Herculean Boots", augments={'Weapon skill damage +5%','AGI+1','Rng.Acc.+2','Rng.Atk.+14',}},
    }
		
    -- Midcast Sets
    sets.midcast.FastRecast = {ammo="Staunch tathlum",
		head=gear.HercHeadDT,neck="Orunmila's torque",ear1="Dignitary's earring",ear2="Zennaroi Earring",
        body="Dread jupon",hands="Leyline gloves",ring1="Defending ring",ring2="Patricius ring",
        back="Moonbeam cape",waist="Flume Belt +1",legs="Mummu kecks +1",feet=gear.HercFeetDT}
		
    -- Specific spells
    sets.midcast.Utsusemi = {ammo="Staunch tathlum",
		head=gear.HercHeadDT,neck="Loricate torque +1",ear1="Dignitary's earring",ear2="Zennaroi Earring",
        body="Ashera harness",hands="Leyline gloves",ring1="Defending ring",ring2="Moonbeam ring",
        back="Moonbeam cape",waist="Flume Belt +1",legs="Mummu kecks +1",feet=gear.HercFeetDT}
     
    -- Ranged gear -- acc + TH
    sets.midcast.RangedAttack = {
		head="Meghanada visor +2",neck="Marked gorget",ear1="Telos Earring",ear2="Enervating earring",
        body="Ashera harness",hands="Meghanada gloves +2",ring1="Cacoethic ring",ring2="Haverton ring",
        waist="Eschan stone",legs="Pursuer's pants",feet="Meghanada jambeaux +2"}
     
    sets.midcast.RangedAttack.TH = {
		head="Meghanada visor +2",neck="Marked gorget",ear1="Telos Earring",ear2="Enervating earring",
        body="Ashera harness",hands="Plunderer armlets +1",ring1="Cacoethic ring",ring2="Haverton ring",
		back="Libeccio Mantle",waist="Aquiline Belt",legs="Manibozho brais",feet="Shulker's poulaines"}
     
    sets.midcast.RangedAttack.Acc = {
		head="Meghanada visor +2",neck="Marked gorget",ear1="Telos Earring",ear2="Enervating earring",
        body="Ashera harness",hands="Meghanada gloves +2",ring1="Cacoethic ring",ring2="Haverton ring",
        waist="Eschan stone",legs="Pursuer's pants",feet="Meghanada jambeaux +2"}
		
    -- Sets to return to when not performing an action.
	
    -- Resting sets
    sets.resting = {}
     
    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
     
    sets.idle = {ammo="Staunch tathlum +1",
		head="Meghanada visor +2",neck="Bathy choker +1",ear1="Infused earring",ear2="Odnowa earring +1",
        body="Meg. Cuirie +2",hands="Meghanada gloves +2",ring1="Defending ring",ring2="Dark ring",
        back="Solemnity cape",waist="Flume Belt",legs="Meghanada chausses +2",feet="Jute boots +1"}
		
    sets.idle.Town = {ammo="Staunch tathlum +1",
		head="Meghanada visor +2",neck="Bathy choker +1",ear1="Infused earring",ear2="Odnowa earring +1",
        body="Meg. Cuirie +2",hands="Meghanada gloves +2",ring1="Defending ring",ring2="Dark ring",
        back="Solemnity cape",waist="Flume Belt",legs="Meghanada chausses +2",feet="Jute boots +1"}
	
    -- Defense sets
    sets.defense.PDT = {ammo="Staunch tathlum +1",
        head="Malignance Chapeau",neck="Loricate torque +1",ear1="Odnowa earring +1",ear2="Genmei Earring",
        body="Malignance Tabard",hands="Malignance gloves",ring1="Defending ring",ring2="Gelationus ring +1",
        back="Solemnity cape",waist="Reiki yotai",legs="Malignance tights",feet="Jute boots +1"}

    sets.defense.MDT = {ammo="Staunch tathlum +1",
        head="Malignance Chapeau",neck="Loricate torque +1",ear1="Odnowa earring +1",ear2="Odnowa earring",
        body="Malignance Tabard",hands="Malignance gloves",ring1="Defending ring",ring2="Moonbeam ring",
        back="Solemnity cape",waist="Reiki yotai",legs="Malignance tights",feet="Jute boots +1"}
		
    sets.Kiting = {feet="Jute boots +1"}
     
    -- Engaged sets
     
    -- Variations for TP weapon and (optional) offense/defense modes. Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    -- Normal melee group
	
    sets.engaged = {ammo="Yamarang",
    head="Adhemar Bonnet +1",
   -- head="Skulker's bonnet +1",
    body= "Plunderer's vest +3",
    hands="Adhemar Wristbands +1",
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}},
    neck="Anu Torque",
    waist="Reiki yotai",
    left_ear="Telos Earring",
    right_ear="Sherida Earring",
    ring1="Ilabrat Ring",
    ring2="Epona's Ring",
    back= THFCape.TP,}

    sets.engaged.Hybrid = {ammo="Yamarang",
    head="Malignance Chapeau",
   -- head="Skulker's bonnet +1",
    body= "Malignance Tabard",
    hands="Malignance gloves",
    legs="Malignance Tights",
    feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}},
    neck="Anu Torque",
    waist="Reiki yotai",
    left_ear="Eabani Earring",
    right_ear="Dedition Earring",
    ring1="Ilabrat Ring",
    ring2="Epona's Ring",
    back= THFCape.TP,}
	
	sets.engaged.LowAcc = {ammo="Yamarang",
        head="Adhemar Bonnet +1",neck="Combatant's torque",ear1="Telos Earring",ear2="Sherida earring",
        body="Adhemar jacket +1",hands=gear.HercHandsACC,ring1="Petrov Ring",ring2="Epona's Ring",
        back= THFCape.TP,waist="Grunfeld rope",legs="Samnuha tights",feet=gear.HercFeetTP}
	
	sets.engaged.MidAcc = {ammo="Yamarang",
        head="Skulker's bonnet +1",
        neck="Combatant's torque",
        ear1="Telos Earring",
        ear2="Sherida earring",
        body="Adhemar jacket +1",
        hands="Adhemar Wristbands +1",
        ring1="Petrov Ring",
        ring2="Epona's Ring",
        back= THFCape.TP,
        waist="Olseni belt",
        legs="Meg. Chausses +2",
        feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}},
    }
	
    sets.engaged.FullAcc = {ammo="Yamarang",
        head="Meghanada visor +2",
        neck="Combatant's torque",
        ear1="Telos Earring",
        ear2="Dignitary's earring",
        body="Adhemar jacket +1",
        hands="Meghanada gloves +2",
        ring1="Regal ring",
        ring2="Cacoethic ring +1",
        back= THFCape.TP,
        waist="Olseni belt",
        legs="Meg. Chausses +2",
        feet={ name="Herculean Boots", augments={'Accuracy+14 Attack+14','"Triple Atk."+3','Accuracy+15',}},
    }
    	 
    end
     
    -- Called when this job file is unloaded (eg: job change)
    function user_unload()
    
    end