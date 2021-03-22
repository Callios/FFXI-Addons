
 -- casting mode - Win-F12
 -- Idle mode - Control - F10
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
 
    -- Load and initialize the include file.
    include('Mote-Include.lua')
 
 
end
 
-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff.Sentinel = buffactive.sentinel or false
    state.Buff.Cover = buffactive.cover or false
    state.Buff.Doom = buffactive.Doom or false

blue_magic_maps = {}
-- Spell sets
    blue_magic_maps.Enhance = S{'Cocoon','Metallic Body'}
    blue_magic_maps.Healing = S{'Pollen', 'Healing Breeze','Wild Carrot'}
    blue_magic_maps.Enmity = S{'Sheep Song', 'Blank Gaze','Sound Blast','Chaotic Eye','Grand Slam','Cursed Sphere','Awful Eye','Geist Wall','Jettatura','Soporific',}
-- BlueMagic --

end
 
-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------
 
-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Hybrid', 'AM3', 'Acc','PDT', 'MDT', 'Cleave')
    state.HybridMode:options('Normal', 'PDT', 'Reraise')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'SIRD', 'Resistant')
    state.PhysicalDefenseMode:options('PDT', 'HP', 'Reraise', 'Charm')
    state.MagicalDefenseMode:options('MDT', 'HP', 'Reraise', 'Charm')
    state.IdleMode:options('Normal', 'Refresh', 'DT')
     
    state.ExtraDefenseMode = M{['description']='Extra Defense Mode', 'None', 'MP', 'Knockback', 'MP_Knockback'}
    state.EquipShield = M(false, 'Equip Shield w/Defense')
     
    gear.Weard = { name="Weard Mantle", augments={'VIT+1','DEX+3','Enmity+2','Phalanx +5'}}
    gear.RudianosTP = { name="Rudianos's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10',}}
    gear.RudianosWS = { name="Rudianos's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%',}}
    gear.RudianosFC = { name="Rudianos's Mantle", augments={'"Fast Cast"+10',}}
    gear.RudianosEnm = { name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10',}}
    gear.Ejekamal = { name="Ejekamal Boots", augments={'Haste+2','"Snapshot"+2','"Fast Cast"+3',}}
    gear.AcroLegsFC = { name="Acro Breeches", augments={'"Fast Cast"+2'}}
    gear.SIRDFeet = { name="Odyssean Greaves", augments={'Mag. Acc.+11 "Mag.Atk.Bns."+11','"Fast Cast"+2','"Mag.Atk.Bns."+1',}}
    gear.OdyWSBODY = { name="Odyss. Chestplate", augments={'Accuracy+15','Weapon skill damage +5%','STR+9',}}
    gear.ValWSLEGS = { name="Valorous Hose", augments={'"Subtle Blow"+3','Magic Damage +3','Weapon skill damage +9%','Accuracy+17 Attack+17',}}
    gear.OdyMagWSFeet = { name="Odyssean Greaves", augments={'Mag. Acc.+15 "Mag.Atk.Bns."+15','Weapon skill damage +4%','INT+4','"Mag.Atk.Bns."+10',}}
    gear.OdyMagWSHead = { name="Odyssean Helm", augments={'Magic Damage +5','"Mag.Atk.Bns."+7','Accuracy+19 Attack+19','Mag. Acc.+18 "Mag.Atk.Bns."+18',}}
    gear.OdyMagWSLegs = { name="Odyssean Cuisses", augments={'"Fast Cast"+5','Mag. Acc.+7','"Mag.Atk.Bns."+7',}}
    gear.PhalanxBody = {name="Odyss. Chestplate", augments={'"Snapshot"+4','Mag. Acc.+17','Phalanx +3',}}
    target_distance = 5.5 -- Set Default Distance Here --
 
    update_defense_mode()
     
    send_command('bind ^f11 gs c cycle MagicalDefenseMode')
    send_command('bind !f11 gs c cycle ExtraDefenseMode')
    send_command('bind @f10 gs c toggle EquipShield')
    send_command('bind @f11 gs c toggle EquipShield')
    send_command('bind @f12 gs c cycle CastingMode')
    send_command('pld')
 
    select_default_macro_book()


end
 
function user_unload()
    send_command('unbind ^f11')
    send_command('unbind !f11')
    send_command('unbind @f10')
    send_command('unbind @f11')
    send_command('unbind @f12')
    send_command('gs enable all')
end
 
 
-- Define sets and vars used by this job file.
function init_gear_sets()
 
    --------------------------------------
    -- Precast sets
    --------------------------------------
     
    -- Fast cast sets for spells
     
    sets.precast.FC = {ammo="Impatiens",
    head="Carmine mask +1",neck="Baetyl Pendant",ear1="Etiolation Earring",ear2="Enchanter Earring +1",
    body="Reverence Surcoat +3",
    legs="Odyssean Cuisses",
    hands="Leyline Gloves",ring1="Moonbeam Ring",ring2="Kishar Ring",
    back=gear.RudianosFC,
    legs={ name="Odyssean Cuisses", augments={'"Fast Cast"+5','Mag. Acc.+7','"Mag.Atk.Bns."+7',}},
    waist="Carrier's sash",
    feet="Carmine Greaves +1",}
 
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash",legs="Odyssean Cuisses"})
    sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC['Enhancing Magic'], {legs="Odyssean Cuisses"})
    sets.precast.FC['Blue Magic'].Enhance = set_combine(sets.precast.FC['Blue Magic'])
    sets.precast.FC['Blue Magic'].Enmity = set_combine(sets.precast.FC['Blue Magic'])
    sets.precast.FC['Blue Magic'].Healing = set_combine(sets.precast.FC['Blue Magic'])
    --Enmity
 
    sets.precast.Enmity = {ammo="Paeapua",
        head="Loess Barbuta +1",neck="Unmoving Collar +1",ear2="Friomisi Earring", ear1="Cryptic Earring",
        body="Souveran cuirass +1",hands="Souveran handschuhs +1",ring1="Apeile Ring",ring2="Apeile Ring +1",
        back=gear.RudianosEnm,waist="Creed Baudrier",legs="Souveran diechlings +1",feet="Souveran schuhs +1"}
 
    -- Precast sets to enhance JAs
    sets.precast.JA['Invincible'] = set_combine(sets.precast.Enmity, {legs="Caballarius Breeches +1"})
    sets.precast.JA['Holy Circle'] = set_combine(sets.precast.Enmity, {feet="Reverence Leggings +1"})
    sets.precast.JA['Shield Bash'] = set_combine(sets.precast.Enmity, {hands="Caballarius Gauntlets +1", ear2="Knightly Earring"})
    sets.precast.JA['Sentinel'] = set_combine(sets.precast.Enmity, {feet="Caballarius Leggings +1"})
    sets.precast.JA['Rampart'] = set_combine(sets.precast.Enmity, {head="Caballarius Coronet +1"})
    sets.precast.JA['Fealty'] = set_combine(sets.precast.Enmity, {body="Caballarius Surcoat +1"})
    sets.precast.JA['Divine Emblem'] = set_combine(sets.precast.Enmity, {feet="Chevalier's Sabatons"})
    sets.precast.JA['Sepulcher'] = sets.precast.Enmity
    sets.precast.JA['Palisade'] = sets.precast.Enmity
    sets.precast.JA['Cover'] = set_combine(sets.precast.Enmity, {head="Reverence Coronet +1"})
 
    -- add mnd for Chivalry
    sets.precast.JA['Chivalry'] = {
        head="Reverence Coronet +1",ear2="Lifestorm Earring",
        body="Caballarius Surcoat +1",hands="Caballarius Gauntlets +1",ring1="Perception Ring",ring2="Solemn Ring",
        back=gear.RudianosEnm,
        legs="Caballarius Breeches +1",feet="Caballarius Leggings +1"}
     
    -- /WAR
    sets.precast.JA['Provoke'] = set_combine(sets.precast.Enmity, {})
    sets.precast.JA['Berserk'] = set_combine(sets.precast.Enmity, {})
    sets.precast.JA['Warcry'] = set_combine(sets.precast.Enmity, {})
    sets.precast.JA['Aggressor'] = set_combine(sets.precast.Enmity, {})
    sets.precast.JA['Defender'] = set_combine(sets.precast.Enmity, {})
     
    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Sulevia's Mask +2",
        body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +2",
        waist="Caudata Belt",legs="Dashing subligar",feet="Sulevia's Leggings +2"}
         
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
     
    sets.precast.Step = {ammo="Amar Cluster",
        head="Flamma Zucchetto +2",neck="Combantant's Torque",ear1="Steelflash Earring",ear2="Heartseeker Earring",
        body="Flamma Korazin +2",hands="Flamma Manopolas +2",ring1="Enlivened Ring",ring2="Patricius Ring",
        back=gear.RudianosTP,waist="Olseni Belt",legs="Flamma Dirs +2",feet="Flamma Gambieras +2"}
         
    sets.precast.Flourish1 = {ammo="Amar Cluster",
        head="Flamma Zucchetto +2",neck="Voltsurge Torque",ear1="Lifestorm Earring",ear2="Psystorm Earring",
        body="Flamma Korazin +2",hands="Flamma Manopolas +2",ring1="Perception Ring",ring2="Sangoma Ring",
        back=gear.RudianosTP,waist="Olseni Belt",legs="Flamma Dirs +2",feet="Flamma Gambieras +2"}
 
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
     
    sets.precast.WS = {ammo="Amar Cluster",
        head="Flamma Zucchetto +2",neck="Fotia Gorget",ear1="Moonshade Earring",ear2="Brutal Earring",
        body="Flamma korazin +2",hands="Sulevia's Gauntlets +2",ring1="Regal Ring",ring2="Rufescent Ring",
        back=gear.RudianosWS,waist="Fotia Belt",legs="Sulevia's Cuisses +2",feet="Sulevia's Leggings +2"}
 
    sets.precast.WS.Acc = {ammo="Amar Cluster",
        head="Flamma Zucchetto +2",neck="Fotia Gorget",ear1="Moonshade Earring",ear2="Ishvara Earring",
        body="Flamma Korazin +2",hands="Flamma Manopolas +2",ring1="Regal Ring",ring2="Rufescent Ring",
        back=gear.RudianosWS,waist="Anguinus Belt",legs="Flamma Dirs +2",feet="Flamma Gambieras +2"}
 
     
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {ring2="Solemn Ring",})
    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS.Acc, {waist="Fotia Belt"})
     
    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {hands="Flamma Manopolas +2",waist="Windbuffet Belt +2"})
    sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS.Acc, {hands="Flamma Manopolas +2"})
 
    sets.precast.WS['Sanguine Blade'] = {ammo="Amar Cluster",
        head="Pixie Hairpin +1",neck="Baetyl Pendant",ear1="Friomisi Earring",ear2="Novio Earring",
        body="Founder's breastplate",hands="Carmine finger Gauntlets +1",ring1="Shiva Ring",ring2="Shiva ring",
        back=gear.RudianosWS,waist="Fotia Belt",legs=gear.ValWSLEGS,feet=gear.OdyMagWSFeet}
     
    sets.precast.WS['Aeolian Edge'] = {ammo="Dosis Tathlum", head=gear.OdyMagWSHead, body = "Found. Breastplate",
            hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
            legs={ name="Odyssean Cuisses", augments={'"Fast Cast"+5','Mag. Acc.+7','"Mag.Atk.Bns."+7',}},
            feet={ name="Odyssean Greaves", augments={'Mag. Acc.+15 "Mag.Atk.Bns."+15','Weapon skill damage +4%','INT+4','"Mag.Atk.Bns."+10',}},
            neck="Baetyl Pendant", waist="Eschan Stone", left_ear="Friomisi Earring", right_ear="Novio Earring",
            left_ring="Shiva Ring", right_ring="Shiva Ring",
            back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10',}}
    }


    sets.precast.WS['Atonement'] = {ammo="Staunch tathlum +1",
        head="Souveran Schaller +1",neck="Fotia Gorget",ear1="Moonshade Earring",ear2="Thurd Earring",
        body="Souveran Cuirass +1",hands="Souveran handschuhs +1",ring1="Apeile Ring",ring2="Apeile ring +1",
        back=gear.RudianosEnm,waist="Fotia Belt",legs="Souveran Diechlings +1",feet="Souveran Schuhs +1"}
         
    sets.precast.WS['Savage Blade'] = {ammo="Amar Cluster",
        head="Hjarrandi Helm",neck="Fotia Gorget",ear1="Moonshade Earring",ear2="Thurd Earring",
        body=gear.OdyWSBODY,hands="Sulevia's Gauntlets +2",ring1="Rufescent Ring",ring2="Regal Ring",
        back=gear.RudianosWS,waist="Sailfi Belt +1",legs=gear.ValWSLEGS,feet="Sulevia's Leggings +2"}    
     
    sets.precast.WS['Circle Blade'] = {ammo="Amar Cluster",
        head="Sulevia's Mask",neck="Fotia Gorget",ear1="Moonshade Earring",ear2="Thurd Earring",
        body=gear.OdyWSBODY,hands="Sulevia's Gauntlets +2",ring1="Rufescent Ring",ring2="Regal Ring",
        back=gear.RudianosWS,waist="Sailfi Belt +1",legs=gear.ValWSLEGS,feet="Sulevia's Leggings +2"}
         
         
    --------------------------------------
    -- Midcast sets
    --------------------------------------
 
    sets.midcast.FastRecast = {ammo="Incantor Stone",
        head="Chevalier's Armet",neck="Baetyl Pendant",ear1="Loquac. Earring",ear2="Enchanter Earring +1",
        body="Reverence Surcoat +2",legs="Carmine Cuisses +1",hands="Buremte Gloves",ring2="Prolix Ring",
        back=gear.RudianosFC,waist="Tempus Fugit +1",feet=gear.Ejekamal}
         
    sets.midcast.Enmity = set_combine(sets.precast.Enmity, {})

    --sets.midcast.Enmity.SIRD = set_combine(sets.precast.Enmity, {head="Souveran Schaller +1", Body="Souveran cuirass +1", 
     --   hands="Souveran handschuhs +1", legs="Carmine Cuisses +1", feet="Souveran Schuhs +1", ammo="Staunch Tathlum +1",
     --   ear1="Knightly Earring", ear2="Cryptic Earring", neck="Moonbeam Necklace", ring1="Defending Ring", ring2="Moonbeam Ring",
     --   waist="Rumination sash"}
     --   )
     
    sets.midcast.SIRD = 
    {ammo="Staunch Tathlum +1", -- 11
    ear2="Knightly Earring", -- 9
    neck="Moonbeam Necklace", -- 10
    ear1="Nourishing earring +1", --1
    waist="Rumination Sash", -- 10 
    legs="Carmine Cuisses +1", -- 20 
    head="Souveran Schaller +1", -- 20
    feet=gear.SIRDFeet,} -- 20
 
    sets.midcast.Flash = set_combine(sets.midcast.Enmity, {neck="Unmoving collar +1", wasit="Tempus Fugit +1"})
    sets.midcast.Flash.SIRD = set_combine(sets.midcast.Flash, sets.midcast.SIRD)

    sets.midcast.Reprisal = { 
    ammo="Staunch Tathlum +1",
    head="Souveran Schaller +1",
    body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    hands="Souveran handschuhs +1",
    legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    feet="Souveran Schuhs +1",
    neck="Bathy Choker +1",
    waist="Creed Baudrier",
    left_ear="Odnowa Earring +1",
    right_ear="Odnowa Earring",
    ring1="Ilabrat Ring",
    ring2="Moonbeam Ring",
    back="Moonbeam Cape",

}

    sets.midcast.Phalanx = set_combine(sets.midcast.FastRecast, {hands="Souveran handschuhs +1", 
        feet="Souveran schuhs +1", body=gear.PhalanxBody, back=gear.Weard, neck="Incanter's Torque",
         ring1="Stikini Ring", ring2="Stikini Ring"})
     
    sets.midcast.Stun = set_combine(sets.midcast.Enmity, {})
    sets.midcast.Stun.SIRD = set_combine(sets.midcast.Stun, sets.midcast.SIRD)
     
    sets.midcast.Cure = {
        ear1="Mendicant's Earring",ear2="Nourishing Earring +1", body="Souveran Cuirass +1", head="Souveran Schaller +1",
        hands="Souveran handschuhs +1",ring1="Defending Ring",ring2="Moonbeam Ring", back="Moonbeam Cape", neck="Sacro Gorget",
        waist="Gishdubar Sash",legs="Souveran Diechlings +1", feet="Souveran Schuhs +1", ammo="Staunch Tathlum +1"}
    sets.midcast.Cure.SIRD = set_combine(sets.midcast.Cure, sets.midcast.SIRD)
 
    sets.midcast['Blue Magic'] = set_combine(sets.midcast.Enmity, {})
    sets.midcast['Blue Magic'].SIRD = set_combine(sets.midcast['Blue Magic'], sets.midcast.SIRD)
    sets.midcast['Blue Magic']['Wild Carrot'] = set_combine(sets.midcast.Enmity, sets.midcast.Cure)
    sets.midcast['Blue Magic']['Wild Carrot'].SIRD = set_combine(sets.midcast['Blue Magic']['Wild Carrot'], sets.midcast.SIRD)
    sets.midcast['Blue Magic']['Blank Gaze']= set_combine(sets.midcast.Enmity, {waist="Gishdubar sash"})
    --sets.midcast['Blue Magic']['Healing Breeze'] = set_combine(sets.midcast.Enmity, {waist="Gishdubar sash"})
  
    sets.midcast['Blue Magic'].Healing = set_combine(sets.midcast.Cure)
    sets.midcast['Blue Magic'].Enmity = set_combine(sets.midcast.Enmity)

 
--95 Enmity, -104% Spell Interrupt, 2,713 HP--
   -- sets.midcast.BLUEnmity = {ammo="Staunch tathlum +1",head="Souv. Schaller +1",neck="Unmoving Collar +1",
    --ear1="Halasz earring",ear2="Knightly earring",
   -- body="Reverence Surcoat +3",hands="Souv. Handsch. +1",ring1="Apeile ring +1",ring2="Apeile Ring",
   -- back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','VIT+10','Enmity+10',}},
--waist="Gishdubar sash",legs="Founder's hose",feet="Souveran Schuhs +1"}


    sets.midcast['Enhancing Magic'] = {legs="Reverence Breeches +1",waist="Rumination Sash",ring1="Stikini Ring", ring2="Stikini ring"}
    sets.midcast['Enhancing Magic'].SIRD = set_combine(sets.midcast['Enhancing Magic'], sets.midcast.SIRD)
    sets.midcast['Blue Magic'].Enhance = set_combine(sets.midcast['Enhancing Magic'])
    sets.midcast.Protect = {ring1="Sheltered Ring"}
    sets.midcast.Protect.SIRD = set_combine(sets.midcast.Protect, sets.midcast.SIRD)
    sets.midcast.Shell = {ring1="Sheltered Ring"}
    sets.midcast.Shell.SIRD = set_combine(sets.midcast.Shell, sets.midcast.SIRD)
     
    --------------------------------------
    -- Idle/resting/defense/etc sets cntr - F12
    --------------------------------------
 
    sets.Reraise = {head="Twilight Helm", body="Twilight Mail"}
     
    sets.resting = {ammo="Homiliary",
        head="Wivre Hairpin",neck="Creed Collar",
        body="Twilight Mail",ring1="Sheltered Ring",ring2="Paguroidea Ring"}
     
 
    -- Idle sets
    sets.idle = {ammo="Staunch Tathlum +1",
        head="Souveran schaller +1",neck="Bathy Choker +1",ear1="Odnowa earring +1",ear2="Infused Earring",
        body="Dagon breastplate",hands="Sulevia's Gauntlets +2",ring1="Gelatinous ring +1",ring2="Defending Ring",
        back=gear.RudianosEnm,waist="Fucho-no-obi",legs="Carmine Cuisses +1",feet="Sulevia's Leggings +2"}

        sets.idle.DT = {ammo="Staunch Tathlum +1",
        head="Souveran schaller +1",neck="Loricate Torque +1",ear1="Genmei Earring",ear2="Etiolation Earring",
        body="Souveran cuirass +1",hands="Souveran handschuhs +1",ring1="Gelatinous Ring +1",ring2="Defending Ring",
        back=gear.RudianosEnm,waist="Flume Belt",legs="Souveran Diechlings +1",feet="Souveran Schuhs +1"}
 
    sets.idle.Refresh = set_combine(sets.idle, {ammo="Homiliary",
        head="Wivre Hairpin",neck="Creed Collar",
        body="Twilight Mail",ring1="Sheltered Ring",ring2="Paguroidea Ring"})
 
    sets.idle.Town = {ammo="Staunch Tathlum +1",
        head="Souveran schaller +1",neck="Bathy Choker +1",ear1="Odnowa earring +1",ear2="Infused Earring",
        body="Dagon breastplate",hands="Souveran handschuhs +1",ring1="Gelatinous Ring +1",ring2="Defending Ring",
        back=gear.RudianosEnm,waist="Fucho-no-obi",legs="Carmine Cuisses +1",feet="Souveran Schuhs +1"}
     
    sets.idle.Weak = set_combine(sets.idle,{back=gear.RudianosEnm,legs="Sulevia's Cuisses +2"})
     
    sets.idle.Weak.Reraise = set_combine(sets.idle.Weak, sets.Reraise)
     
    sets.Kiting = {legs="Carmine Cuisses +1"}
 
    sets.latent_refresh = {waist="Fucho-no-obi"}
 
 
    --------------------------------------
    -- Defense sets
    --------------------------------------
     
    -- Extra defense sets.  Apply these on top of melee or defense sets.
    sets.Knockback = {ring1="Vocane Ring +1",back="Repulse Mantle"}
    sets.MP = {ammo="Homiliary",neck="Creed Collar",waist="Flume Belt"} --Chev. Armet +1
    sets.MP_Knockback = set_combine(sets.MP, sets.Knockback)
     
    -- If EquipShield toggle is on (Win+F10 or Win+F11), equip the weapon/shield combos here
    -- when activating or changing defense mode:
    sets.PhysicalShield = {main="Burtgang",sub="Ochain"}
    sets.MagicalShield = {main="Burtgang",sub="Aegis"}
 
    -- Basic defense sets.
         
    sets.defense.PDT = {ammo="Staunch Tathlum +1",
        head="Souveran schaller +1",neck="Loricate Torque +1",ear1="Genmei Earring",ear2="Etiolation Earring",
        body="Souveran cuirass +1",hands="Sulevia's Gauntlets +2",ring1="Gelatinous Ring +1",ring2="Defending Ring",
        back=gear.RudianosTP,waist="Flume Belt",legs="Sulevia's Cuisses +2",feet="Souveran schuhs +1"}
    sets.defense.HP = {ammo="Plumose Sachet",
        head="Souveran schaller +1",neck="Bathy Chocker +1",ear1="Odnowa earring +1",ear2="Odnowa Earring",
        body="Reverence Surcoat +2",hands="Souveran handschuhs +1",ring1="Gelatinous Ring +1",ring2="Defending Ring",
        back="Moonbeam Cape",
        waist="Creed Baudrier",legs="Souveran diechlings +1",feet="Souveran Schuhs +1"}
    sets.defense.Reraise = {ammo="Staunch Tathlum +1",
        head="Twilight Helm",neck="Twilight Torque",ear1="Oneiros Earring",ear2="Creed Earring",
        body="Twilight Mail",hands="Sulevia's Gauntlets +2",ring1="Vocane Ring +1",ring2="Defending Ring",
        back=gear.Weard,
        waist="Nierenschutz",legs="Sulevia's Cuisses +2",feet="Sulevia's Leggings +2"}
    sets.defense.Charm = {ammo="Homiliary",
        head="Sulevia's Mask +2",neck="Twilight Torque",ear1="Oneiros Earring",ear2="Creed Earring",
        body="Sulevia's Platemail +2",hands="Sulevia's Gauntlets +2",ring1="Vocane Ring +1",ring2="Defending Ring",
        back=gear.Weard,
        waist="Flume Belt",legs="Sulevia's Cuisses +2",feet="Sulevia's Leggings +2"}
    -- To cap MDT with Shell IV (52/256), need 76/256 in gear.
    -- Shellra V can provide 75/256, which would need another 53/256 in gear.
    sets.defense.MDT = {ammo="Staunch Tathlum +1",
        head="Souveran schaller +1",neck="Loricate Torque +1",ear1="Odnowa Earring +1",ear2="Etiolation earring",
        body="Souveran cuirass +1",hands="Flamma Manopolas +2",ring1="Dark Ring",ring2="Defending Ring",
        back=gear.RudianosEnm,waist="Flume Belt",legs="Souveran diechlings +1",feet="Flamma Gambieras +2"}
 
 
    --------------------------------------
    -- Engaged sets
    --------------------------------------
     
    sets.engaged = {ammo="Ginsen",
        head="Hjarrandi Helm",neck="Combatant's Torque",ear1="Cessance Earring",ear2="Brutal Earring",
        body="Dagon breastplate",hands="Sulevia's Gauntlets +2",ring1="Petrov Ring",ring2="Chirich Ring +1",
        back=gear.RudianosTP,waist="Tempus Fugit +1",legs="Sulevia's Cuisses +2",feet="Flamma Gambieras +2"}
 
 sets.engaged.Hybrid = {ammo="Staunch Tathlum +1",
        head="Hjarrandi Helm",neck="Combatant's Torque",ear1="Cessance Earring",ear2="Brutal Earring",
        body="Hjarrandi breastplate",hands="Sulevia's Gauntlets +2",ring1="Chirich Ring +1",ring2="Defending Ring",
        back=gear.RudianosTP,waist="Tempus Fugit +1",legs="Sulevia's Cuisses +2",feet="Flamma Gambieras +2"}

        sets.engaged.AM3 = {ammo="Ginsen",
        head="Hjarrandi Helm",neck="Combatant's Torque",ear1="Telos Earring",ear2="Dedition Earring",
        body="Hjarrandi breastplate",hands="Flamma Manopolas +2",ring1="Flamma Ring",ring2="Chirich Ring +1",
        back=gear.RudianosTP,waist="Tempus Fugit +1",legs="Sulevia's Cuisses +2",feet="Flamma Gambieras +2"}

    sets.engaged.Acc = {ammo="Hasty Pinion +1",
        head="Yorium Barbuta",neck="Ziel Charm",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Flamma Korazin +2",hands="Flamma Manopolas +2",ring1="Enlivened Ring",ring2="Patricius Ring",
        back=gear.RudianosTP,waist="Dynamic Belt +1",legs="Sulevia's Cuisses +2",feet="Flamma Gambieras +2"}
 
    --sets.engaged.DW = set_combine(sets.engaged, {ear1="Suppanomimi",ear2="Brutal Earring",legs="Carmine Cuisses +1"})
 
   -- sets.engaged.DW.Acc = set_combine(sets.engaged.Acc, {ear1="Dudgeon Earring",ear2="Heartseeker Earring"})
 
    sets.engaged.PDT = {ammo="Staunch Tathlum +1",
        head="Sulevia's Mask +2",neck="Loricate Torque +1",ear1="Genmei Earring",ear2="Etiolation Earring",
        body="Souveran cuirass +1",hands="Souveran handschuhs +1",ring1="Gelatinous Ring +1",ring2="Defending Ring",
        back=gear.RudianosEnm,waist="Flume Belt",legs="Souveran Diechlings +1",feet="Souveran Schuhs +1"}
    
    sets.engaged.MDT = {ammo="Staunch Tathlum +1",
        head="Sulevia's Mask +2",neck="Loricate Torque +1",ear1="Odnowa Earring +1",ear2="Etiolation earring",
        body="Souveran cuirass +1",hands="Souveran handschuhs +1",ring1="Dark Ring",ring2="Defending Ring",
        back=gear.RudianosEnm,waist="Flume Belt",legs="Souveran diechlings +1",feet="Flamma Gambieras +2"}

    sets.engaged.Acc.PDT = sets.engaged.PDT
    sets.engaged.Reraise = set_combine(sets.engaged, sets.Reraise)
    sets.engaged.Acc.Reraise = set_combine(sets.engaged.Acc, sets.Reraise)
 
 --  sets.engaged.DW.PDT = set_combine(sets.engaged.PDT, {ear1="Suppanomimi",ear2="Brutal Earring"})
    --sets.engaged.DW.Acc.PDT = set_combine(sets.engaged.PDT, {ear1="Dudgeon Earring",ear2="Heartseeker Earring"})
    --sets.engaged.DW.Reraise = set_combine(sets.engaged.DW, sets.Reraise)
   -- sets.engaged.DW.Acc.Reraise = set_combine(sets.engaged.DW.Acc, sets.Reraise)
 
 
    --------------------------------------
    -- Custom buff sets
    --------------------------------------
 
    sets.buff.Doom = {ring1="Saida Ring"}
    sets.buff.Cover = {head="Reverence Coronet +1", body="Caballarius Surcoat +1"}
 
end
 
 
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
 
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" and player.status == 'Engaged' and spell.target.distance > target_distance then -- Cancel WS If You Are Out Of Range --
       eventArgs.cancel=true
       add_to_chat(123, spell.name..' Canceled: [Out of Range]')
       return
    end
end
 
 
--function job_midcast(spell, action, spellMap, eventArgs)
    -- If DefenseMode is active, apply that gear over midcast
    -- choices.  Precast is allowed through for fast cast on
    -- spells, but we want to return to def gear before there's
    -- time for anything to hit us.
    -- Exclude Job Abilities from this restriction, as we probably want
    -- the enhanced effect of whatever item of gear applies to them,
    -- and only one item should be swapped out.
  --  if state.DefenseMode.value ~= 'None' and spell.type ~= 'JobAbility' then
    --    handle_equipping_gear(player.status)
      --  eventArgs.handled = true
    --end
--end
 
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------
 
-- Called when the player's state changes (e.g. Normal to Acc Engaged mode).
function job_state_change(field, new_value, old_value)
    classes.CustomDefenseGroups:clear()
    classes.CustomDefenseGroups:append(state.ExtraDefenseMode.current)
    if state.EquipShield.value == true then
        classes.CustomDefenseGroups:append(state.DefenseMode.current .. 'Shield')
    end
 
    classes.CustomMeleeGroups:clear()
    classes.CustomMeleeGroups:append(state.ExtraDefenseMode.current)
     
end
 
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------
 
-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_defense_mode()
end
 
-- Called when status changes (Idle to Engaged, Resting, etc.)
function job_status_change(newStatus, oldStatus, eventArgs)
    update_defense_mode()
end
 
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if world.area:contains('Adoulin') then
        idleSet = set_combine(idleSet, {body="Dagon breastplate"})
    end
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.Buff.Doom then
        idleSet = set_combine(idleSet, sets.buff.Doom)
    end
     
    return idleSet
end
 
-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.Buff.Doom then
        meleeSet = set_combine(meleeSet, sets.buff.Doom)
    end
     
    return meleeSet
end
 
function customize_defense_set(defenseSet)
    if state.ExtraDefenseMode.value ~= 'None' then
        defenseSet = set_combine(defenseSet, sets[state.ExtraDefenseMode.value])
    end
     
    if state.EquipShield.value == true then
        defenseSet = set_combine(defenseSet, sets[state.DefenseMode.current .. 'Shield'])
    end
     
    if state.Buff.Doom then
        defenseSet = set_combine(defenseSet, sets.buff.Doom)
    end
     
    return defenseSet
end
 
 
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
        msg = msg .. ', Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end
 
    if state.ExtraDefenseMode.value ~= 'None' then
        msg = msg .. ', Extra: ' .. state.ExtraDefenseMode.value
    end
     
    msg = msg .. ', Casting: ' .. state.CastingMode.value
     
    if state.EquipShield.value == true then
        msg = msg .. ', Force Equip Shield'
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
 
    add_to_chat(122, msg)
 
    eventArgs.handled = true
end
 
 
-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------
 
-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'tds' then
        local newTargetDistance = tonumber(cmdParams[2])
        if not newTargetDistance then
            add_to_chat(123, '[Invalid parameter. Example syntax: gs c tds 5.5]')
            return
        end
        if newTargetDistance > 0 then
            target_distance = newTargetDistance
            add_to_chat(122, '[Weaponskill max range set to '..newTargetDistance..' yalms.]')
        else
            add_to_chat(123, '[Invalid parameter. Example syntax: gs c tds 5.5]')
        end
    end
end
 
 -------------------
 -- BLUE SPELL MAPS FUNCTION  
------------------------
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Blue Magic' then
        for category,spell_list in pairs(blue_magic_maps) do
            if spell_list:contains(spell.english) then
                return category
            end
        end
    end
end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
 
function update_defense_mode()
    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        if player.equipment.sub and not player.equipment.sub:contains('Shield') and
           player.equipment.sub ~= 'Aegis' and player.equipment.sub ~= 'Ochain' then
            state.CombatForm:set('DW')
        else
            state.CombatForm:reset()
        end
    end
end
 
 
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(5, 1)
    elseif player.sub_job == 'DNC' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'THF' then
        set_macro_page(6, 1)
    elseif player.sub_job == 'SAM' then
        set_macro_page(7, 1)
    elseif player.sub_job == 'RNG' then
        set_macro_page(8, 1)
    elseif player.sub_job == 'PLD' then
        set_macro_page(9, 1)
    elseif player.sub_job == 'WHM' then
        set_macro_page(1, 2)
    elseif player.sub_job == 'RDM' then
        set_macro_page(1, 3)
    elseif player.sub_job == 'SCH' then
        set_macro_page(1, 4)
    elseif player.sub_job == 'BLU' then
        set_macro_page(1, 5)
    elseif player.sub_job == 'DRK' then
        set_macro_page(5, 5)
    elseif player.sub_job == 'RUN' then
        set_macro_page(1, 6)
    elseif player.sub_job == 'NIN' then
        set_macro_page(10, 1)
    else
        set_macro_page(1, 7)  --BRD
    end
end