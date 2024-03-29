-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:
    gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.66
    
    Treasure hunter modes:
        None - Will never equip TH gear
        Tag - Will equip TH gear sufficient for initial contact with a mob (either melee, ranged hit, or Aeolian Edge AOE)
        SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
        Fulltime - Will keep TH gear equipped fulltime
--]]

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false
    
    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'TA', 'Hybrid', 'TAcc', 'Crit', 'Farm')
    state.HybridMode:options('Normal', 'Evasion', 'PDT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
    state.PhysicalDefenseMode:options('PDT')
    state.IdleMode:options('Normal', 'STP', 'Evasion')


    gear.default.weaponskill_neck = "Asperity Necklace"
    gear.default.weaponskill_waist = "ElementalBelt"
    gear.AugQuiahuiz = {name="Quiahuiz Trousers", augments={'Haste+2','"Snapshot"+2','STR+8'}}
    gear.WSDCape = {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}}
    gear.FCHat =  {name="Herculean Helm", augments={'"Mag.Atk.Bns."+24','"Fast Cast"+6','STR+7','Mag. Acc.+14'}}
    gear.CapeCrit = {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10'}}

    -- Additional local binds
    send_command('bind ^` input /ja "Flee" <me>')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind !- gs c cycle targetmode')

    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !-')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

    sets.TreasureHunter = {hands="Plunderer's Armlets +3", feet="Skulker's Poulaines +1"}
    sets.ExtraRegen = {head="Turms cap +1"}
    sets.Kiting = {feet="Jute boots +1"}

    sets.buff['Sneak Attack'] = {}

    sets.buff['Trick Attack'] = {}

    -- Actions we want to use to tag TH.
    sets.precast.Step = sets.TreasureHunter
    sets.precast.Flourish1 = sets.TreasureHunter
    sets.precast.JA.Provoke = sets.TreasureHunter


    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Collaborator'] = {head="Skulker's Bonnet +1"}
    sets.precast.JA['Accomplice'] = {head="Skulker's Bonnet +1"}
    sets.precast.JA['Flee'] = {feet="Pillager's Poulaines +3"}
    sets.precast.JA['Hide'] = {body="Pillager's Vest +3"}
    sets.precast.JA['Conspirator'] = {} -- {body="Skulker's Vest +1"}
    sets.precast.JA['Steal'] = {head="Plunderer's Bonnet +3",hands="Pillager's Armlets +3",legs="Pillager's Culottes +3",feet="Pillager's Poulaines +3"}
    sets.precast.JA['Despoil'] = {legs="Skulker's Culottes",feet="Skulker's Poulaines +1"}
    sets.precast.JA['Perfect Dodge'] = {hands="Plunderer's Armlets +3"}
    sets.precast.JA['Feint'] = {legs="Plunderer's Culottes +3"}
    sets.precast.JA['Mug'] = {ammo="C. Palug Stone",
        head="Mummu Bonnet +2", neck="Asn. Gorget +2", ear1="Odr Earring", ear2="Mache Earring +1",
        body="Mummu Jacket +2", hands="Mummu Wrists +2", ring1="Ilabrat Ring", ring2="Regal Ring",
        back= gear.WSDCape, waist="Chaac Belt", legs="Mummu Kecks +2", feet="Mummu Gamash. +2"}

    sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
    sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']


    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Whirlpool Mask",
        body="Pillager's Vest +3",hands="Pillager's Armlets +1",ring1="Asklepian Ring",
        back="Iximulew Cape",waist="Caudata Belt",legs="Pillager's Culottes +3",feet="Plunderer's Poulaines +3"}

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}


    -- Fast cast sets for spells
    sets.precast.FC = {ammo="Sapience orb",head = gear.FCHat,
        neck="Voltsurge torque",ear1="Etiolation earring",ear2="Loquacious Earring",
        body="Dread Jupon",hands="Leyline Gloves",ring1="Prolix Ring",
        legs="Rawhide trousers"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",body="Passion Jacket"})
    
    sets.midcast['Phalanx'] = set_combine(sets.midcast.FastRecast, {
        head={ name="Taeon Chapeau", augments={'Phalanx +3',}},neck="Incanter's Torque",left_ear="Mimir Earring",right_ear="Augment. Earring",
        body={ name="Taeon Tabard", augments={'Attack+23','"Dual Wield"+5','Phalanx +3',}},
        hands={ name="Taeon Gloves", augments={'Phalanx +3',}},left_ring="Stikini Ring +1",right_ring="Stikini Ring +1",
        waist="Olympus Sash",back="Merciful Cape",legs={ name="Taeon Tights", augments={'Accuracy+20 Attack+20','"Triple Atk."+2','Phalanx +3',}},
        feet={ name="Taeon Boots", augments={'Phalanx +3',}}})


    -- Ranged snapshot gear
    sets.precast.RA = {head="Volte tiara",hands="Mrigavyadha gloves",
    waist="Yemaya belt",legs="Volte tights",feet="Meghanada jambeaux +2"}


    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {ammo="Cath Palug stone",
        head="Pillager's Bonnet +3",neck="Fotia Gorget",ear1="Ishvara Earring",ear2="Moonshade Earring",
        body="Herculean vest",hands="Meghanada gloves +2",ring1="Regal Ring",ring2="Ilabrat Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},waist="Fotia Belt",
        legs="Plunderer's culottes +3",feet="Lustratio leggings +1"}
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {ammo="Honed Tathlum"})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {ear1="Sherida earring",hands="Adhemar wristbands +1",body="Plunderer's vest +3",legs="Meghanada chausses +2",feet="Plunderer's poulaines +3"})
    sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {})
    sets.precast.WS['Exenterator'].Mod = set_combine(sets.precast.WS['Exenterator'])
    sets.precast.WS['Exenterator'].SA = set_combine(sets.precast.WS['Exenterator'].Mod, {ammo="Yetshila +1",body="Pillager's Vest +3"})
    sets.precast.WS['Exenterator'].TA = set_combine(sets.precast.WS['Exenterator'].Mod, {ammo="Yetshila +1",body="Pillager's Vest +3"})
    sets.precast.WS['Exenterator'].SATA = set_combine(sets.precast.WS['Exenterator'].Mod, {ammo="Yetshila +1"})

    sets.precast.WS['Dancing Edge'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Dancing Edge'].Acc = set_combine(sets.precast.WS['Dancing Edge'], {})
    sets.precast.WS['Dancing Edge'].Mod = set_combine(sets.precast.WS['Dancing Edge'], {})
    sets.precast.WS['Dancing Edge'].SA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {ammo="Qirmiz Tathlum"})
    sets.precast.WS['Dancing Edge'].TA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {ammo="Qirmiz Tathlum"})
    sets.precast.WS['Dancing Edge'].SATA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {ammo="Qirmiz Tathlum"})

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {ammo = "Yetshila +1",
        head="Adhemar bonnet +1",ear1="Sherida Earring",ear2="Odr earring",
        body ="Plunderer's vest +3",hands="Mummu wrists +2",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10'}},ring2="Mummu Ring",
        legs="Pillager's culottes +3",feet="Adhemar Gamashes +1"})
    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'])
    sets.precast.WS['Evisceration'].Mod = set_combine(sets.precast.WS['Evisceration'])
    sets.precast.WS['Evisceration'].SA = set_combine(sets.precast.WS['Evisceration'].Mod, {head = "Pillager's Bonnet +3"})
    sets.precast.WS['Evisceration'].TA = set_combine(sets.precast.WS['Evisceration'].Mod, {head = "Pillager's Bonnet +3"})
    sets.precast.WS['Evisceration'].SATA = set_combine(sets.precast.WS['Evisceration'].Mod, {head = "Pillager's Bonnet +3"})

    sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {head="Pillager's Bonnet +3",neck="Assassin's gorget +2",ring2="Epaminondas's Ring",waist="Kentarch belt +1"})
    sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"], {})
    sets.precast.WS["Rudra's Storm"].Mod = set_combine(sets.precast.WS["Rudra's Storm"], {})
    sets.precast.WS["Rudra's Storm"].SA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {ammo = "Yetshila +1",body="Plunderer's vest +3"})
    sets.precast.WS["Rudra's Storm"].TA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {ammo = "Yetshila +1",body="Plunderer's vest +3"})
    sets.precast.WS["Rudra's Storm"].SATA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {ammo = "Yetshila +1",body="Plunderer's vest +3"})

    sets.precast.WS["Shark Bite"] = set_combine(sets.precast.WS, {head="Pillager's Bonnet +3",neck="Assassin's gorget +2",ring2="Epaminondas's Ring",waist="Kentarch belt +1"})
    sets.precast.WS['Shark Bite'].Acc = set_combine(sets.precast.WS['Shark Bite'], {})
    sets.precast.WS['Shark Bite'].Mod = set_combine(sets.precast.WS['Shark Bite'], {})
    sets.precast.WS['Shark Bite'].SA = set_combine(sets.precast.WS['Shark Bite'].Mod, {ammo = "Yetshila +1",body="Plunderer's vest +3"})
    sets.precast.WS['Shark Bite'].TA = set_combine(sets.precast.WS['Shark Bite'].Mod, {ammo = "Yetshila +1",body="Plunderer's vest +3"})
    sets.precast.WS['Shark Bite'].SATA = set_combine(sets.precast.WS['Shark Bite'].Mod, {ammo = "Yetshila +1",body="Plunderer's vest +3"})

    sets.precast.WS['Mandalic Stab'] = set_combine(sets.precast.WS, {head="Pillager's Bonnet +3",neck="Assassin's gorget +2",ring2="Epaminondas's Ring",waist="Kentarch belt +1"})
    sets.precast.WS['Mandalic Stab'].Acc = set_combine(sets.precast.WS['Mandalic Stab'], {})
    sets.precast.WS['Mandalic Stab'].Mod = set_combine(sets.precast.WS['Mandalic Stab'], {})
    sets.precast.WS['Mandalic Stab'].SA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {ammo = "Yetshila +1",body="Plunderer's vest +3"})
    sets.precast.WS['Mandalic Stab'].TA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {ammo = "Yetshila +1",body="Plunderer's vest +3"})
    sets.precast.WS['Mandalic Stab'].SATA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {ammo = "Yetshila +1",body="Plunderer's vest +3"})
    
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {ammo="Seething bomblet +1",neck="Caro necklace",body="Plunderer's vest +3",
                                                                    ring2="Epaminondas's Ring",waist="Kentarch belt +1"})
    sets.precast.WS['Savage Blade'].Mod = set_combine(sets.precast.WS['Savage Blade'], {})
    sets.precast.WS['Savage Blade'].SA = set_combine(sets.precast.WS['Savage Blade'].Mod, {ammo = "Yetshila +1",body="Plunderer's vest +3"})
    sets.precast.WS['Savage Blade'].TA = set_combine(sets.precast.WS['Savage Blade'].Mod, {ammo = "Yetshila +1",body="Plunderer's vest +3"})

    
    sets.precast.WS['Asuran Fists'] = set_combine(sets.precast.WS, {head="Plunderer's Bonnet +3",ear1="Sherida Earring",ear2="Dignitary's Earring",
        body="Plunderer's vest +3",hands="Meghanada gloves +2",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10'}},
        })

    sets.precast.WS['Aeolian Edge'] = {ammo="Pemphredo Tathlum",
    head={ name="Herculean Helm", augments={'"Mag.Atk.Bns."+24','"Fast Cast"+6','STR+7','Mag. Acc.+14',}},
    body={ name="Samnuha Coat", augments={'Mag. Acc.+14','"Mag.Atk.Bns."+13','"Fast Cast"+4','"Dual Wield"+3',}},
    hands={ name="Herculean Gloves", augments={'"Mag.Atk.Bns."+20','Weapon skill damage +4%','STR+13',}},
    legs={ name="Herculean Trousers", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','Weapon skill damage +4%','Mag. Acc.+15','"Mag.Atk.Bns."+1',}},
    feet="Adhemar Gamashes +1",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Friomisi Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +25',}},
    left_ring="Dingir Ring",
    right_ring="Epaminondas Ring",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}}}
    
    sets.precast.WS['Gust Slash'] = set_combine(sets.precast.WS['Aeolian Edge'])
    
    sets.precast.WS['Cyclone'] = set_combine(sets.precast.WS['Aeolian Edge'])

    sets.precast.WS['Aeolian Edge'].TH = set_combine(sets.precast.WS['Aeolian Edge'], sets.TreasureHunter)

    sets.precast.WS['Last Stand'] = {
        head="Meghanada Visor +2",neck="Fotia gorget",ear1="Enervating earring",ear2="Telos Earring",
        body="Meghanada cuirie +2",hands="Meghanada gloves +2",ring1="Regal Ring",ring2="Cacoethic Ring +1",
        waist="Fotia belt",legs="Meghanada chausses +2",feet="Meghanada jambeaux +2"}
        
    

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {ammo="Sapience orb",{ name="Herculean Helm", augments={'"Mag.Atk.Bns."+24','"Fast Cast"+6','STR+7','Mag. Acc.+14',}},
        neck="Voltsurge torque",ear1="Etiolation earring",ear2="Loquacious Earring",body="Dread Jupon",
        hands="Leyline Gloves",ring1="Prolix Ring",legs="Rawhide trousers"}

    -- Specific spells
    sets.midcast.Utsusemi = {ammo="Sapience orb",{ name="Herculean Helm", augments={'"Mag.Atk.Bns."+24','"Fast Cast"+6','STR+7','Mag. Acc.+14',}},
        neck="Voltsurge torque",ear1="Etiolation earring",ear2="Loquacious Earring",body="Samnuha coat",
        hands="Leyline Gloves",ring1="Prolix Ring",legs="Rawhide trousers"}

    -- Ranged gear
    sets.midcast.RA = {
        head="Malignance chapeau",neck="Iskur Gorget",ear1="Enervating earring",ear2="Telos Earring",
        body="Malignance tabard",hands="Malignance gloves",ring1="Regal Ring",ring2="Cacoethic Ring +1",
        back="Kayapa cape",waist="Yemaya belt",legs="Malignance tights",feet="Malignance boots"}


    sets.midcast.RA.Acc = {
        head="Meghanada Visor +2",neck="Iskur Gorget",ear1="Enervating earring",ear2="Tripudio Earring",
        body="Meghanada cuirie +2",hands="Meghanada gloves +2",ring1="Rajas Ring",ring2="Cacoethic Ring +1",
        back="Quarrel mantle",waist="Yemaya belt",legs="Meghanada chausses +2",feet="Meghanada jambeaux +1"}


    --------------------------------------
    -- Idle/resting/defense sets
    --------------------------------------

    -- Resting sets
    sets.resting = {head="Turms cap +1",neck="Wiglen Gorget",
        ring1="Sheltered Ring",ring2="Paguroidea Ring"}


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {ammo="Yamarang",
        head="Turms cap +1",neck="Loricate torque +1",ear1="Etiolation Earring",ear2="Infused Earring",
        body="Malignance tabard",hands="Malignance Gloves",ring1="Defending Ring",ring2="Sheltered Ring",
        back="Moonbeam cape",waist="Flume Belt",legs="Malignance tights",feet="Pillager's Poulaines +3"}
        
    sets.idle.Vagary = {
        head="Meghanada Visor +2",neck="Iskur Gorget",ear1="Enervating earring",ear2="Tripudio Earring",
        body="Adhemar jacket +1",hands="Meghanada gloves +2",ring1="Rajas Ring",ring2="Cacoethic Ring +1",
        back="Quarrel mantle",waist="Yemaya belt",legs="Meghanada chausses +2",feet="Meghanada jambeaux +1"}

    sets.idle.Town = {
        head="Turms cap +1",neck="Tanner's torque",
        body="Tanner's smock",hands="Tanner's gloves",ring1="Orvail Ring",
        back="Shadow Mantle",waist="Reiki Yotai",legs="Pillager's Culottes +3",feet="Pillager's Poulaines +3"}

    sets.idle.Weak = {ammo="Yamarang",
        head="Turms cap +1",neck="Bathy choker",ear1="Etiolation Earring",ear2="Infused Earring",
        body="Malignance tabard",hands="Turms mittens +1",ring1="Defending Ring",ring2="Sheltered Ring",
        back="Moonbeam cape",waist="Flume Belt",legs="Meghanada chausses +2",feet="Turms leggings +1"}
        
    sets.idle.STP = {ammo="Yamarang",
        head="Turms cap +1",neck="Ainia collar",ear1="Sherida Earring",ear2="Telos earring",
        body="Malignance tabard",hands="Malignance gloves",ring1="Rajas Ring",ring2="Ilabrat Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},waist="Patentia sash",legs="Malignance tights",feet="Malignance boots"}
        
    sets.idle.Evasion = {ammo="Yamarang",
        head="Malignance Chapeau",neck="Assassin's gorget +2",ear1="Infused Earring",ear2="Eabani Earring",
        body="Malignance tabard",hands="Turms Mittens +1",ring1="Moonlight Ring",ring2="Moonlight Ring",
        back={ name="Toutatis's Cape", augments={'AGI+20','Eva.+20 /Mag. Eva.+20','Evasion+10','"Store TP"+10','Phys. dmg. taken-10%'}},
        waist="Flume belt",legs="Malignance tights",feet="Pillager's Poulaines +3"}

    -- Defense sets

    sets.defense.Evasion = {set_combine(sets.engaged.Evasion)}

    sets.defense.PDT = {ammo="Yamarang",
        head="Malignance chapeau",neck="Assassin's gorget +2",ear1="Sherida Earring",ear2="Telos Earring",
        body="Pillager's Vest +3",hands="Adhemar Wristbands +1",ring1="Moonlight Ring",ring2="Moonlight Ring",
        back={ name="Toutatis's Cape", augments={'AGI+20','Eva.+20 /Mag. Eva.+20','Evasion+10','"Store TP"+10','Phys. dmg. taken-10%'}},waist="Reiki Yotai",legs="Pillager's Culottes +3",
        feet="Malignance boots"}

    sets.defense.MDT = {
        neck="Loricate torque +1",
        ring1="Defending Ring",ring2="Fortified Ring",
        back="Moonbeam Cape"}


    --------------------------------------
    -- Melee sets
    --------------------------------------

    -- Normal melee group
    sets.engaged = {ammo="Seething Bomblet +1",
        head="Adhemar bonnet +1",neck="Assassin's gorget +2",ear1="Sherida Earring",ear2="Suppanomimi",
        body="Adhemar jacket +1",hands="Adhemar Wristbands +1",ring1="Rajas Ring",ring2="Gere Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},waist="Reiki Yotai",legs="Pillager's Culottes +3",feet={name="Taeon boots",augments={'Accuracy+20 Attack+20','"Dual Wield"+4','Crit. hit damage +2%'}}}
    sets.engaged.Acc = {ammo="Yamarang",
        head="Pillager's Bonnet +3",neck="Loricate torque +1",ear1="Dignitary's Earring",ear2="Telos earring",
        body="Meghanada cuirie +2",hands="Adhemar Wristbands +1",ring1="Regal Ring",ring2="Gere Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},waist="Reiki Yotai",legs="Pillager's Culottes +3",feet={name="Herculean boots", augments={'Accuracy+24 Attack+24','Damage taken-2%','STR+7','Accuracy+11','Attack+15',}}}
        
    -- Mod set for trivial mobs (Skadi+1)
    sets.engaged.TA = {ammo="Ginsen",
        head="Adhemar bonnet +1",neck="Assassin's gorget +2",ear1="Sherida Earring",ear2="Telos earring",
        body="Adhemar jacket +1",hands="Adhemar Wristbands +1",ring1="Hetairoi Ring",ring2="Gere Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%'}},waist="Chiner's Belt +1",legs="Samnuha tights",feet="Plunderer's Poulaines +3"}
        
    sets.engaged.Farm = set_combine(sets.engaged.TA, {ammo = "Yetshila +1", body="Malignance Tabard", hands="Plunderer's Armlets +3", 
        back = {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10'}}, waist="Reiki Yotai", legs="Malignance tights"})
        
    sets.engaged.Hybrid = {ammo="Yamarang",
        head="Malignance chapeau",neck="Assassin's gorget +2",ear1="Sherida Earring",ear2="Telos Earring",
        body="Malignance tabard",hands="Malignance gloves",ring1="Moonlight Ring",ring2="Moonlight Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%'}},
        waist="Reiki Yotai",legs="Malignance tights",feet="Malignance boots"}
        
    sets.engaged.Tank = {ammo="Yamarang",
        head="Malignance chapeau",neck="Assassin's gorget +2",ear1="Sherida Earring",ear2="Telos Earring",
        body="Malignance tabard",hands="Turms mittens +1",ring1="Moonlight Ring",ring2="Moonlight Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%'}},
        waist="Reiki Yotai",legs="Malignance Tights",feet="Turms leggings +1"}
        
    sets.engaged.Crit = {ammo="Yetshila +1",
        head="Adhemar Bonnet +1", neck="Assassin's Gorget +2", left_ear="Sherida Earring", right_ear="Odr Earring",
        body="Plunderer's Vest +3", hands="Mummu Wrists +2", left_ring="Regal Ring", right_ring="Mummu Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},
        waist="Kentarch Belt +1", legs="Pill. Culottes +3",feet="Adhe. Gamashes +1"}
    

    -- Mod set for trivial mobs (Thaumas)
    sets.engaged.TAcc = set_combine(sets.engaged.TA, {ammo="Yamarang",
        head="Plunderer's Bonnet +3",neck="Assassin's gorget +2",ear2="Telos Earring",
        body="Pillager's vest +3", ring1="Regal Ring",ring2="Hetairoi Ring",
        waist="Reiki Yotai", legs="Pillager's Culottes +3",feet="Plunderer's Poulaines +3"})

    -- Mod set for trivial mobs (CP)   

    sets.engaged.Evasion = {ammo="Yamarang",
        head="Malignance Chapeau",neck="Assassin's gorget +2",ear1="Sherida Earring",ear2="Telos Earring",
        body="Pillager's vest +3",hands="Turms Mitts +1",ring1="Moonlight Ring",ring2="Moonlight Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%'}},
        waist="Reiki Yotai",legs="Pillager's Culottes +3",feet="Turms Leggings +1"}
    
    

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
        equip(sets.TreasureHunter)
    elseif spell.english=='Sneak Attack' or spell.english=='Trick Attack' or spell.type == 'WeaponSkill' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
    end
end

-- Run after the general midcast() set is constructed.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if state.TreasureMode.value ~= 'None' and spell.action_type == 'Ranged Attack' then
        equip(sets.TreasureHunter)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
    end
end

-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- If Feint is active, put that gear set on on top of regular gear.
    -- This includes overlaying SATA gear.
    check_buff('Feint', eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    local wsmode

    if state.Buff['Sneak Attack'] then
        wsmode = 'SA'
    end
    if state.Buff['Trick Attack'] then
        wsmode = (wsmode or '') .. 'TA'
    end

    return wsmode
end


-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)
    -- Check that ranged slot is locked, if necessary
    check_range_lock()

    -- Check for SATA when equipping gear.  If either is active, equip
    -- that gear specifically, and block equipping default gear.
    check_buff('Sneak Attack', eventArgs)
    check_buff('Trick Attack', eventArgs)
end


function customize_idle_set(idleSet)
    if player.hpp < 80 then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end

    return idleSet
end


function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end


-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    th_update(cmdParams, eventArgs)
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
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
    
    if state.Kiting.value == true then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end
    
    msg = msg .. ', TH: ' .. state.TreasureMode.value

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
end


-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end


-- Function to lock the ranged slot if we have a ranged weapon equipped.
function check_range_lock()
    if player.equipment.range ~= 'empty' then
        disable('range', 'ammo')
    else
        enable('range', 'ammo')
    end
end




-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(10, 1)
    elseif player.sub_job == 'WAR' then
        set_macro_page(9, 1)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'RNG' then
        set_macro_page(2, 1)
    elseif player.sub_job == 'RDM' then
        set_macro_page(8, 1)
    else
        set_macro_page(10, 1)
    end
end