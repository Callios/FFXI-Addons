-- Original: Motenten / Modified: Arislan
-- Haste/DW Detection Requires Gearinfo Addon

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+- ]          Chain Affinity
--              [ CTRL+= ]          Burst Affinity
--              [ CTRL+[ ]          Efflux
--              [ ALT+[ ]           Diffusion
--              [ ALT+] ]           Unbridled Learning
--              [ CTRL+Numpad/ ]    Berserk
--              [ CTRL+Numpad* ]    Warcry
--              [ CTRL+Numpad- ]    Aggressor
--
--  Spells:     [ CTRL+` ]          Blank Gaze
--              [ ALT+Q ]            Nature's Meditation/Fantod
--              [ ALT+W ]           Cocoon/Reactor Cool
--              [ ALT+E ]           Erratic Flutter
--              [ ALT+R ]           Battery Charge/Refresh
--              [ ALT+T ]           Occultation
--              [ ALT+Y ]           Barrier Tusk/Phalanx
--              [ ALT+U ]           Diamondhide/Stoneskin
--              [ ALT+P ]           Mighty Guard/Carcharian Verve
--              [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  WS:         [ CTRL+Numpad7 ]    Savage Blade
--              [ CTRL+Numpad9 ]    Chant Du Cygne
--              [ CTRL+Numpad4 ]    Requiescat
--              [ CTRL+Numpad5 ]    Expiacion
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


--------------------------------------------------------------------------------------------------------------------
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
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Chain Affinity'] = buffactive['Chain Affinity'] or false
    state.Buff.Convergence = buffactive.Convergence or false
    state.Buff.Diffusion = buffactive.Diffusion or false
    state.Buff.Efflux = buffactive.Efflux or false

    state.Buff['Unbridled Learning'] = buffactive['Unbridled Learning'] or false
    blue_magic_maps = {}

    -- Mappings for gear sets to use for various blue magic spells.
    -- While Str isn't listed for each, it's generally assumed as being at least
    -- moderately signficant, even for spells with other mods.

    -- Physical spells with no particular (or known) stat mods
    blue_magic_maps.Physical = S{'Bilgestorm'}

    -- Spells with heavy accuracy penalties, that need to prioritize accuracy first.
    blue_magic_maps.PhysicalAcc = S{'Heavy Strike'}

    -- Physical spells with Str stat mod
    blue_magic_maps.PhysicalStr = S{'Battle Dance','Bloodrake','Death Scissors','Dimensional Death',
        'Empty Thrash','Quadrastrike','Saurian Slide','Sinker Drill','Spinal Cleave','Sweeping Gouge',
        'Uppercut','Vertical Cleave'}

    -- Physical spells with Dex stat mod
    blue_magic_maps.PhysicalDex = S{'Amorphic Spikes','Asuran Claws','Barbed Crescent','Claw Cyclone',
        'Disseverment','Foot Kick','Frenetic Rip','Goblin Rush','Hysteric Barrage','Paralyzing Triad',
        'Seedspray','Sickle Slash','Smite of Rage','Terror Touch','Thrashing Assault','Vanity Dive'}

    -- Physical spells with Vit stat mod
    blue_magic_maps.PhysicalVit = S{'Body Slam','Cannonball','Delta Thrust','Glutinous Dart','Grand Slam',
        'Power Attack','Quad. Continuum','Sprout Smack','Sub-zero Smash'}

    -- Physical spells with Agi stat mod
    blue_magic_maps.PhysicalAgi = S{'Benthic Typhoon','Feather Storm','Helldive','Hydro Shot','Jet Stream',
        'Pinecone Bomb','Spiral Spin','Wild Oats'}

    -- Physical spells with Int stat mod
    blue_magic_maps.PhysicalInt = S{'Mandibular Bite','Queasyshroom'}

    -- Physical spells with Mnd stat mod
    blue_magic_maps.PhysicalMnd = S{'Ram Charge','Screwdriver','Tourbillion'}

    -- Physical spells with Chr stat mod
    blue_magic_maps.PhysicalChr = S{'Bludgeon'}

    -- Physical spells with HP stat mod
    blue_magic_maps.PhysicalHP = S{'Final Sting'}

    -- Magical spells with the typical Int mod
    blue_magic_maps.Magical = S{'Anvil Lightning','Blastbomb','Blazing Bound','Bomb Toss','Cursed Sphere',
        'Droning Whirlwind','Embalming Earth','Entomb','Firespit','Foul Waters','Ice Break','Leafstorm',
        'Maelstrom','Molting Plumage','Nectarous Deluge','Regurgitation','Rending Deluge','Scouring Spate',
        'Silent Storm','Spectral Floe','Subduction','Tem. Upheaval','Water Bomb'}

    blue_magic_maps.MagicalDark = S{'Dark Orb','Death Ray','Eyes On Me','Evryone. Grudge','Palling Salvo',
        'Tenebral Crush'}

    blue_magic_maps.MagicalLight = S{'Blinding Fulgor','Diffusion Ray','Radiant Breath','Rail Cannon',
        'Retinal Glare'}

    -- Magical spells with a primary Mnd mod
    blue_magic_maps.MagicalMnd = S{'Acrid Stream','Magic Hammer','Mind Blast'}

    -- Magical spells with a primary Chr mod
    blue_magic_maps.MagicalChr = S{'Mysterious Light'}

    -- Magical spells with a Vit stat mod (on top of Int)
    blue_magic_maps.MagicalVit = S{'Thermal Pulse'}

    -- Magical spells with a Dex stat mod (on top of Int)
    blue_magic_maps.MagicalDex = S{'Charged Whisker','Gates of Hades'}

    -- Magical spells (generally debuffs) that we want to focus on magic accuracy over damage.
    -- Add Int for damage where available, though.
    blue_magic_maps.MagicAccuracy = S{'1000 Needles','Absolute Terror','Actinic Burst','Atra. Libations',
        'Auroral Drape','Awful Eye', 'Blank Gaze','Blistering Roar','Blood Saber','Chaotic Eye',
        'Cimicine Discharge','Cold Wave','Corrosive Ooze','Demoralizing Roar','Digest','Dream Flower',
        'Enervation','Feather Tickle','Filamented Hold','Frightful Roar','Geist Wall','Hecatomb Wave',
        'Infrasonics','Jettatura','Light of Penance','Lowing','Mind Blast','Mortal Ray','MP Drainkiss',
        'Osmosis','Reaving Wind','Sandspin','Sandspray','Sheep Song','Soporific','Sound Blast',
        'Stinking Gas','Sub-zero Smash','Venom Shell','Voracious Trunk','Yawn'}

    -- Breath-based spells
    blue_magic_maps.Breath = S{'Bad Breath','Flying Hip Press','Frost Breath','Heat Breath','Hecatomb Wave',
        'Magnetite Cloud','Poison Breath','Self-Destruct','Thunder Breath','Vapor Spray','Wind Breath'}

    -- Stun spells
    blue_magic_maps.Stun = S{'Blitzstrahl','Frypan','Head Butt','Sudden Lunge','Tail slap','Temporal Shift',
        'Thunderbolt','Whirl of Rage'}

    -- Healing spells
    blue_magic_maps.Healing = S{'Healing Breeze','Magic Fruit','Plenilune Embrace','Pollen','Restoral',
        'White Wind','Wild Carrot'}

    -- Buffs that depend on blue magic skill
    blue_magic_maps.SkillBasedBuff = S{'Barrier Tusk','Diamondhide','Magic Barrier','Metallic Body',
        'Plasma Charge','Pyric Bulwark','Reactor Cool','Occultation'}

    -- Other general buffs
    blue_magic_maps.Buff = S{'Amplification','Animating Wail','Carcharian Verve','Cocoon',
        'Erratic Flutter','Exuviation','Fantod','Feather Barrier','Harden Shell','Memento Mori',
        'Nat. Meditation','Orcish Counterstance','Refueling','Regeneration','Saline Coat','Triumphant Roar',
        'Warm-Up','Winds of Promyvion','Zephyr Mantle'}

    blue_magic_maps.Refresh = S{'Battery Charge'}

    -- Spells that require Unbridled Learning to cast.
    unbridled_spells = S{'Absolute Terror','Bilgestorm','Blistering Roar','Bloodrake','Carcharian Verve','Cesspool',
        'Crashing Thunder','Cruel Joke','Droning Whirlwind','Gates of Hades','Harden Shell','Mighty Guard',
        'Polar Roar','Pyric Bulwark','Tearing Gust','Thunderbolt','Tourbillion','Uproot'}

    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    lockstyleset = 1
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'LowAcc', 'MidAcc', 'HighAcc', 'STP')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant', 'TH')
    state.PhysicalDefenseMode:options('PDT', 'MDT')
    state.IdleMode:options('Normal', 'DT')--, 'Learning')

    state.MagicBurst = M(false, 'Magic Burst')
    state.CP = M(false, "Capacity Points Mode")

	gear.default.obi_waist = "Yamabuki-no-obi"
	
    -- Additional local binds
	send_command('lua l azureSets')
    send_command('bind ^` gs c cycle treasuremode')
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
    send_command('unbind @c')

    send_command('lua u azureSets')
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	include('Gipi_augmented-items.lua')
	
    -- Precast sets to enhance JAs

    -- Enmity set
    sets.Enmity = {
		ammo="Staunch Tathlum +1",
		--head="",
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

    sets.precast.JA['Provoke'] = sets.Enmity

    sets.buff['Burst Affinity'] = {legs="Assim. Shalwar +2", feet="Hashi. Basmak +1"}
    sets.buff['Diffusion'] = {feet="Luhlaza Charuqs +1"}
    sets.buff['Efflux'] = {legs="Hashishin Tayt +1"}

    sets.precast.JA['Azure Lore'] = {hands="Luh. Bazubands +1"}
    sets.precast.JA['Chain Affinity'] = {feet="Assim. Charuqs +1"}
    sets.precast.JA['Convergence'] = {head="Luh. Keffiyeh +3"}
    --sets.precast.JA['Enchainment'] = {body="Luhlaza Jubbah +1"}

    sets.precast.FC = { --15% innate with Erratic Flutter
		ammo="Impatiens",
        head="Carmine mask +1",			--14
		neck="Orunmila's torque",		--5
		ear1="Enchanter earring +1",	--2
		ear2="Loquacious Earring",		--2
        body="Adhemar Jacket",			--7
		hands="Leyline gloves",			--8
		ring1="Defending Ring",
		ring2="Weather. Ring",			--5
        back=gear.RosCapeFC,			--10
		waist="Witful Belt",			--3
		legs="Carmine Cuisses +1",		
		feet="Carmine greaves +1"		--8
		} --64

    sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, {body="Hashishin Mintan +1"})
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
    sets.precast.FC.Cure = set_combine(sets.precast.FC, {ammo="Impatiens", ear2="Mendi. Earring"})

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {

        })


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
		ammo="Floestone",
        head=gear.HercHeadSTR,
		neck="Fotia Gorget",
		ear1="Ishvara earring",
		ear2="Moonshade Earring",
        body="Assimilator's jubbah +3",
		hands="Jhakri cuffs +2",
		ring1="Ilabrat ring",
		ring2="Shukuyu Ring",
        back=gear.RosCapeSTR,
		waist="Sailfi Belt +1",
		legs="Luhlaza Shalwar +3",
		feet=gear.HercFeetSTR
		}

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        head="Dampening Tam",
		neck="Mirage Stole +2",
		ear1="Mache Earring +1",
        ear2="Mache Earring +1",
		ring2="Ramuh Ring +1",
		waist="Grunfeld Rope",
        })

    sets.precast.WS['Chant du Cygne'] = {
		ammo="Jukukik feather",
        head="Adhemar Bonnet +1",
		neck="Mirage Stole +2",
		ear1="Odr Earring",
		ear2="Mache Earring +1",
        body=gear.HercBodyCDMG,
		hands="Adhemar Wristbands +1",
		ring1="Begrudging ring",
		ring2="Epona's ring",
        back=gear.RosCapeDEX,
		waist="Fotia belt",
		legs="Samnuha tights",
		feet=gear.HercFeetCDMG,
		}

    sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS['Chant du Cygne'], {
        ammo="Falcon eye",
		body="Adhemar Jacket +1",
		ring2="Ramuh ring +1",
		feet="Assimilator's charuqs +3"
        })

    sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Chant du Cygne']
    sets.precast.WS['Vorpal Blade'].Acc = sets.precast.WS['Chant du Cygne'].Acc

    sets.precast.WS['Savage Blade'] = {
        ammo="Floestone",
        head=gear.HercHeadSTR,
		neck="Mirage Stole +2",
		ear1="Ishvara earring",
		ear2="Moonshade Earring",
        body="Assimilator's jubbah +3",
		hands="Jhakri cuffs +2",
		ring1="Epaminondas's Ring",
		ring2="Shukuyu Ring",
        back=gear.RosCapeSTR,
		waist="Sailfi Belt +1",
		legs="Luhlaza Shalwar +3",	
		feet=gear.HercFeetMagic,
        }

    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {
        ammo="Mantoptera",
		ear1="Mache Earring +1",
		ear2="Regal Earring",
		ring2="Ilabrat Ring",
		waist="Grunfeld rope",
		feet="Assimilator's charuqs +3",
        })

    sets.precast.WS['Expiacion'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['Expiacion'].Acc = set_combine(sets.precast.WS['Savage Blade'].Acc, {})
		
    sets.precast.WS['Requiescat'] = {
		ammo="Floestone",
		head="Jhakri coronal +2",
		neck="Fotia gorget",
		ear1="Telos earring",
		ear2="Regal earring",
		body="Jhakri robe +2",
		hands="Jhakri cuffs +2",
		ring1="Ilabrat ring",
		ring2="Epona's ring",
		back=gear.RosCapeSTR,
		waist="Fotia belt",
		legs="Jhakri slops +2",
		feet="Assimilator's charuqs +3"
		}

    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'], {
        ammo="Falcon eye",
		ear1="Mache Earring +1",
		ear2="Mache Earring +1",
        })

    sets.precast.WS['True Strike'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['True Strike'].Acc = sets.precast.WS['Savage Blade'].Acc
    sets.precast.WS['Judgment'] = sets.precast.WS['True Strike']
    sets.precast.WS['Judgment'].Acc = sets.precast.WS['True Strike'].Acc
    sets.precast.WS['Black Halo'] = sets.precast.WS['True Strike']
    sets.precast.WS['Black Halo'].Acc = sets.precast.WS['True Strike'].Acc
    sets.precast.WS['Realmrazer'] = sets.precast.WS['Requiescat']
    sets.precast.WS['Realmrazer'].Acc = sets.precast.WS['Requiescat'].Acc
		
	--Magic Weaponskills
		
    sets.precast.WS['Sanguine Blade'] = {
        ammo="Pemphredo Tathlum",
        head="Pixie Hairpin +1",
        body="Amalric Doublet +1",
        hands="Jhakri Cuffs +1",
        legs="Luhlaza Shalwar +3",
        feet="Amalric Nails +1",
        neck="Fotia Gorget",
        ear1="Moonshade Earring",
        ear2="Regal Earring",
        ring1="Epaminondas's Ring",
        ring2="Archon Ring",
        back=gear.RosCapeNuke,
        waist="Eschan stone",
        }

    sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS['Sanguine Blade'], {
        head="Jhakri Coronal +2",
		ring1="Shiva Ring +1",
		ring2="Weather. Ring",
        })

	sets.precast.WS['Burning Blade'] = set_combine(sets.precast.WS['Flash Nova'], {ring2="Shiva Ring +1",})
	sets.precast.WS['Red Lotus Blade'] = set_combine(sets.precast.WS['Flash Nova'], {ring2="Shiva Ring +1",})
	sets.precast.WS['Shining Blade'] = set_combine(sets.precast.WS['Flash Nova'], {})
	sets.precast.WS['Seraph Blade'] = set_combine(sets.precast.WS['Flash Nova'], {})
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = { 
		ammo="Pemphredo Tathlum",
		head="Carmine mask +1",			--14
		neck="Orunmila's torque",		--5
		ear1="Enchanter earring +1",	--2
		ear2="Loquacious Earring",		--2
        body="Amalric Doublet +1",
		hands="Amalric Cuffs +1",		
		ring1="Defending Ring",
		ring2="Gelatinous Ring +1",
        back=gear.RosCapeFC,			--10
		waist="Luminary Sash",			
		legs="Carmine Cuisses +1",		
		feet="Amalric Nails +1",		
		} 

    sets.midcast.SpellInterrupt = {
        ammo="Impatiens", --10
		hands="Amalric Cuffs +1", --11
		legs="Carmine Cuisses +1", --20
		feet="Amalric Nails +1",  --16
        ring1="Evanescence Ring", --5
        waist="Rumination Sash", --10
        }

    sets.midcast['Blue Magic'] = set_combine(sets.midcast.FastRecast,{
		hands="Hashishin bazubands +1"
		})
		
	sets.midcast['Occultation'] = set_combine(sets.precast.FC,{
		hands="Hashishin bazubands +1"
		})

    sets.midcast['Blue Magic'].Physical = {
        ammo="Floestone",
        head="Luh. Keffiyeh +3",
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +2",
        legs="Jhakri Slops +2",
        feet="Jhakri Pigaches +2",
        neck="Mirage Stole +2",
		ear1="Telos Earring",
        ear2="Mache Earring +1",
        ring1="Shukuyu Ring",
        ring2="Ilabrat Ring",
        back=gear.RosCapeSTR,
        waist="Sailfi Belt +1",
        }

    sets.midcast['Blue Magic'].PhysicalAcc = set_combine(sets.midcast['Blue Magic'].Physical, {
        ammo="Falcon Eye",
        legs="Carmine Cuisses +1",
        feet="Assim. Charuqs +3",
		ear1="Mache Earring +1",
        back=gear.RosCapeDEX,
        waist="Grunfeld Rope",
        })

    sets.midcast['Blue Magic'].PhysicalStr = sets.midcast['Blue Magic'].Physical

    sets.midcast['Blue Magic'].PhysicalDex = set_combine(sets.midcast['Blue Magic'].Physical, {
        ammo="Falcon Eye",
        ear2="Mache Earring +1",
        ring2="Ilabrat Ring",
        back=gear.RosCapeDEX,
        })

    sets.midcast['Blue Magic'].PhysicalVit = sets.midcast['Blue Magic'].Physical

    sets.midcast['Blue Magic'].PhysicalAgi = set_combine(sets.midcast['Blue Magic'].Physical, {
        hands="Adhemar Wristbands +1",
        ring2="Ilabrat Ring",
        })

    sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical, {
        ear2="Regal Earring",
        ring1="Shiva Ring +1",
        ring2="Shiva Ring +1",
        back=gear.RosCapeNuke,
        })

    sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical, {
        ear2="Regal Earring",
        ring1="Stikini Ring +1",
        ring2="Stikini Ring +1",
        })

    sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical, {ear1="Regal Earring", ear2="Enchntr. Earring +1"})

    sets.midcast['Blue Magic'].Magical = {
        ammo="Pemphredo Tathlum",
        head=gear.HercHeadMagic,
        body="Amalric Doublet +1",
        hands="Amalric Gages +1",
        legs="Amalric Slops +1",
        feet="Amalric Nails +1",
        neck="Sanctity Necklace",
        ear1="Friomisi Earring",
        ear2="Regal Earring",
        ring1="Shiva Ring +1",
        ring2="Shiva Ring +1",
        back=gear.RosCapeNuke,
        waist=gear.ElementalObi,
        }

    sets.midcast['Blue Magic'].Magical.Resistant = set_combine(sets.midcast['Blue Magic'].Magical, {
        head="Assim. Keffiyeh +2",
        neck="Mirage Stole +2",
        ear1="Digni. Earring",
        ring1="Stikini Ring +1",
        ring2="Stikini Ring +1",
        waist="Yamabuki-no-Obi",
        })

    sets.midcast['Blue Magic'].Magical.TH = set_combine(sets.midcast['Blue Magic'].Magical, {
		body=gear.HercBodyTH,
		hands=gear.HercHandsTH,
        })

    sets.midcast['Blue Magic'].MagicalDark = set_combine(sets.midcast['Blue Magic'].Magical, {
        head="Pixie Hairpin +1",
        ring2="Archon Ring",
        })

    sets.midcast['Blue Magic'].MagicalLight = set_combine(sets.midcast['Blue Magic'].Magical, {

        })

    sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical, {
        ring1="Stikini Ring +1",
        ring2="Stikini Ring +1",
        })

    sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical, {
        ear1="Mache Earring +1",
		ear2="Mache Earring +1",
        ring1="Ramuh Ring +1",
        ring2="Ilabrat Ring",
        })

    sets.midcast['Blue Magic'].MagicalVit = set_combine(sets.midcast['Blue Magic'].Magical, {})
    sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical, {ear1="Regal Earring", ear2="Enchntr. Earring +1"})

    sets.midcast['Blue Magic'].MagicAccuracy = {
		ammo="Pemphredo tathlum",
        head="Amalric Coif +1",
		neck="Mirage Stole +2",
		ear1="Regal earring",
		ear2="Dignitary's earring",
		body="Amalric Doublet +1",
		hands="Regal Cuffs",
		ring1="Stikini Ring +1",
		ring2="Stikini Ring +1",
        back="Cornflower Cape",
		waist="Luminary sash",
		legs="Assimilator's shalwar +2",
		feet="Jhakri pigaches +2"
		}

    sets.midcast['Blue Magic'].Breath = set_combine(sets.midcast['Blue Magic'].Magical, {head="Luh. Keffiyeh +3"})

    sets.midcast['Blue Magic'].Stun = {
		ammo="Falcon eye",
		head="Malignance Chapeau",
		neck="Mirage Stole +2",
		ear1="Regal earring",
		ear2="Dignitary's earring",
		body="Jhakri Robe +2",
		hands="Malignance Gloves",
		ring1="Stikini Ring +1",
		ring2="Stikini Ring +1",
		back="Cornflower cape",
		waist="Eschan stone",
		legs="Malignance Tights",
		feet="Jhakri pigaches +2"
		}

    sets.midcast['Blue Magic'].Healing = {
        ammo="Pemphredo Tathlum",
		head="Pinga Crown +1",			--10
		neck="Incanter's Torque",		--
		ear1="Regal earring",
		ear2="Mendicant's earring",		--5
		body="Vrikodara jupon",			--13
		hands="Telchine gloves",		--10
		ring1="Stikini Ring +1",
		ring2="Stikini Ring +1",		
        back="Fi Follet Cape +1",		
		waist="Luminary Sash",
		legs="Gyve Trousers",			--10
		feet="Medium's sabots"			--12
		}

    sets.midcast['Blue Magic'].HealingSelf = set_combine(sets.midcast['Blue Magic'].Healing, {
        waist="Gishdubar Sash",				--(10)
		ring1="Kunaji Ring",				--(5)
        })

	sets.midcast['Blue Magic']['White Wind'] = {
        ammo="Pemphredo Tathlum",
		head="Pinga Crown +1",
		neck="Incanter's Torque",
		ear1="Odnowa earring +1",
		ear2="Mendicant's earring",
        body="Vrikodara jupon",
		hands="Telchine gloves",
		ring1="Kunaji ring",
		ring2="Meridian Ring",
        back="Moonbeam cape",
		waist="Gishdubar sash",
		legs="Gyve Trousers",
		feet="Medium's sabots"
		}

    sets.midcast['Blue Magic'].Buff = sets.midcast['Blue Magic']
    sets.midcast['Blue Magic'].Refresh = set_combine(sets.midcast['Blue Magic'], {head="Amalric Coif +1", waist="Gishdubar Sash",})
    
	sets.midcast['Blue Magic'].SkillBasedBuff = set_combine(sets.midcast['Blue Magic'], {
        ammo="Mavi Tathlum",			--5
        head="Luh. Keffiyeh +3",		--13
        body="Assim. Jubbah +3",		--24
        hands="Rawhide Gloves",			--10
        legs="Hashishin Tayt +1",		--23
        feet="Luhlaza Charuqs +1",		--8
        neck="Mirage Stole +2",			--20
        ring1="Stikini Ring +1",		--8
        ring2="Stikini Ring +1",		--8
        back="Cornflower Cape",			--15
		waist="Witful Belt",
        }) -- 124 (gear) + 476 (base) = 600 skill

    sets.midcast['Blue Magic']['Carcharian Verve'] = set_combine(sets.midcast['Blue Magic'].Buff, {
        head="Amalric Coif +1",
        hands="Regal Cuffs",
		legs="Shedir seraweels"
        })

    sets.midcast['Enhancing Magic'] = {
        ammo="Pemphredo Tathlum",
        head="Carmine Mask +1",
        body=gear.TelchineBodyDURATION,
        hands=gear.TelchineHandsDURATION,
        legs="Carmine Cuisses +1",
        feet=gear.TelchineFeetDURATION,
        neck="Incanter's Torque",
        ear2="Andoaa Earring",
        ring1="Stikini Ring +1",
        ring2="Stikini Ring +1",
        back="Fi Follet Cape +1",
        waist="Olympus Sash",
        }

    sets.midcast.EnhancingDuration = {
        head=gear.TelchineHeadDURATION,
        body=gear.TelchineBodyDURATION,
        hands=gear.TelchineHandsDURATION,
        legs=gear.TelchineLegsDURATION,
        feet=gear.TelchineFeetDURATION,
        }

    sets.midcast.Phalanx = set_combine(sets.midcast.EnhancingDuration, {
        body=gear.TaeonBodyLANX,
        hands=gear.TaeonHandsLANX,
        legs=gear.TaeonLegsLANX,
        feet=gear.TaeonFeetLANX,
        })
    
	sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {head="Amalric Coif +1", waist="Gishdubar Sash",})
    sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {legs="Shedir seraweels", neck="Stone Gorget", waist="Siegel Sash"})
    sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {head="Amalric Coif +1",hands="Regal Cuffs",legs="Shedir seraweels"})

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {ring1="Sheltered Ring"})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Resting sets
    sets.resting = {}

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {
		ammo="Staunch Tathlum +1",
        head=gear.HercHeadREFRESH,
		neck="Bathy choker +1",
		ear1="Infused earring",
		ear2="Sanare Earring",
        body="Shamash Robe",
		hands=gear.HercHandsREFRESH,
		ring1="Stikini Ring +1",
		ring2="Stikini Ring +1",
        back=gear.RosCapeTP,
		waist="Fucho-no-obi",
		legs="Carmine cuisses +1",
		feet=gear.HercFeetREFRESH
		}

    sets.idle.DT = {
		ammo="Staunch Tathlum +1",				--3
        head="Malignance Chapeau",				--6
		neck="Warder's Charm +1",				--
		ear1="Eabani Earring",
		ear2="Suppanomimi",
        body="Shamash Robe",					--10
		hands="Malignance Gloves",				--5
		ring1="Defending Ring",					--10
		ring2="Purity Ring",					
        back=gear.RosCapeTP,					--10
		waist="Flume Belt +1",					--4
		legs="Malignance Tights",				--7
		feet=gear.HercFeetTP					--2
		}

    sets.idle.Town = set_combine(sets.idle, {})

    sets.idle.Weak = set_combine(sets.idle, {})

    --sets.idle.Learning = set_combine(sets.idle, sets.Learning)

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = set_combine(sets.idle.DT, {
		ammo="Ginsen",
		neck="Mirage Stole +2",
		body="Malignance Tabard",
		ring2="Epona's Ring",	
		waist="Kentarch Belt +1",
		})
		
    sets.defense.MDT = set_combine(sets.idle.DT, {
		body="Malignance Tabard",
		waist="Kentarch Belt +1",
		})

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
        ammo="Ginsen",
        head="Adhemar Bonnet +1",
        body="Adhemar Jacket +1", --6
        hands="Adhemar Wristbands +1",
        legs="Samnuha Tights",
        feet=gear.HercFeetTP,
        neck="Mirage Stole +2",
        ear1="Telos Earring",
        ear2="Dedition Earring",
        ring1="Chirich Ring +1",
        ring2="Epona's Ring",
        back=gear.RosCapeTP,
        waist="Windbuffet Belt +1",
        } 

    sets.engaged.LowAcc = set_combine(sets.engaged, {
		ammo="Falcon Eye",
		ear2="Cessance Earring",
        })

    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
        waist="Kentarch Belt +1",
		ear2="Mache Earring +1",
		ring2="Chirich Ring +1",
        })

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
        head="Carmine Mask +1",
        legs="Carmine Cuisses +1",
		ear1="Mache Earring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP = set_combine(sets.engaged, {

        })

    -- Base Dual-Wield Values:
    -- * DW6: +37%
    -- * DW5: +35%
    -- * DW4: +30%
    -- * DW3: +25% (NIN Subjob)
    -- * DW2: +15% (DNC Subjob)
    -- * DW1: +10%

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {
        ammo="Ginsen",
        head="Adhemar Bonnet +1",
        body="Adhemar Jacket +1", 		--6
        hands="Adhemar Wristbands +1",
        legs="Carmine Cuisses +1", 		--6
        feet=gear.TaeonFeetDW, 			--9
        neck="Mirage Stole +2",
        ear1="Eabani Earring", 			--4
        ear2="Suppanomimi", 			--5
        ring1="Petrov Ring",
        ring2="Epona's Ring",
        back=gear.RosCapeTP,
        waist="Reiki Yotai", 			--7
        } -- 37%  

    sets.engaged.DW.LowAcc = set_combine(sets.engaged.DW, {
        ear1="Telos Earring",	
		ring1="Chirich Ring +1",
        })

    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW.LowAcc, {
        ammo="Falcon Eye",
		ear2="Mache Earring +1",
		ring2="Chirich Ring +1",
        })

    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, {
        head="Carmine Mask +1",
        ear1="Mache Earring +1",
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP = set_combine(sets.engaged.DW, {

        })

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = set_combine(sets.engaged.DW, {
        ammo="Ginsen",
        head="Adhemar Bonnet +1",
        body="Adhemar Jacket +1", 			--6
        hands="Adhemar Wristbands +1",
        legs="Carmine Cuisses +1",			--6
        feet=gear.TaeonFeetDW, 				--9
        neck="Mirage Stole +2",
        ear1="Eabani Earring", 				--4
        ear2="Suppanomimi", 				--5
        ring1="Petrov Ring",
        ring2="Epona's Ring",
        back=gear.RosCapeTP,
        waist="Reiki Yotai", 				--7
        }) -- 37%

    sets.engaged.DW.LowAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
        ear1="Telos Earring",	
		ring1="Chirich Ring +1",
		})

    sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, {
        ammo="Falcon Eye",
		ear2="Mache Earring +1",
		ring2="Chirich Ring +1",
        })

    sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, {
        head="Carmine Mask +1",
        ear1="Mache Earring +1",
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
	
        })

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = {
		ammo="Ginsen",
		head="Adhemar Bonnet +1",
		body="Adhemar Jacket +1", --6
		hands="Adhemar Wristbands +1",
		legs="Samnuha Tights",
		feet=gear.TaeonFeetDW, --9
		neck="Mirage Stole +2",
		ear1="Dedition Earring",
		ear2="Suppanomimi", --5
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back=gear.RosCapeTP,
		waist="Reiki Yotai", --7
      } -- 27%

    sets.engaged.DW.LowAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        ear1="Telos Earring",	
		ring1="Chirich Ring +1",
        })

    sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, {
        ammo="Falcon Eye",
		ear2="Mache Earring +1",
		ring2="Chirich Ring +1",
        })

    sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, {
        head="Carmine Mask +1",
        ear1="Mache Earring +1",
        waist="Olseni Belt",
		legs="Carmine Cuisses +1",
        })

    sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW.MidHaste, {

        })

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = {
        ammo="Ginsen",
        head="Adhemar Bonnet +1",
        body="Adhemar Jacket +1", --6
        hands="Adhemar Wristbands +1",
        legs="Samnuha Tights",
        feet=gear.HercFeetTP,
        neck="Mirage Stole +2",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Petrov Ring",
        ring2="Epona's Ring",
        back=gear.RosCapeTP,
        waist="Reiki Yotai", --7
        } -- 22%

    sets.engaged.DW.LowAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        ear1="Telos Earring",	
		ring1="Chirich Ring +1",
        })

    sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, {
        ammo="Falcon Eye",
		ear2="Mache Earring +1",
		ring2="Chirich Ring +1",
        })

    sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, {
        head="Carmine Mask +1",
        ear1="Mache Earring +1",
        waist="Olseni Belt",
		legs="Carmine Cuisses +1",
        })

    sets.engaged.DW.STP.HighHaste = set_combine(sets.engaged.DW.HighHaste, {

        })

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = {
        ammo="Ginsen",
        head="Adhemar Bonnet +1",
        body="Adhemar Jacket +1", --6
        hands="Adhemar Wristbands +1",
        legs="Samnuha Tights",
        feet=gear.HercFeetTP,
        neck="Mirage Stole +2",
        ear1="Dedition Earring",
        ear2="Suppanomimi",
        ring1="Petrov Ring",
        ring2="Epona's Ring",
        back=gear.RosCapeTP,
        waist="Windbuffet Belt +1",
        } -- 11%

    sets.engaged.DW.LowAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
        ear1="Telos Earring",	
		ring1="Chirich Ring +1",
        })

    sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, {
        ammo="Falcon Eye",
		ear2="Mache Earring +1",
		ring2="Chirich Ring +1",
        })

    sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {
        head="Carmine Mask +1",
        ear1="Mache Earring +1",
        waist="Olseni Belt",
		legs="Carmine Cuisses +1",
        })

    sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {

        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
		head="Malignance Chapeau",
		body="Malignance Tabard",
        hands="Malignance Gloves", 
		ring1="Defending Ring",
        ring2="Chirich Ring +1",
		back=gear.RosCapeTP,
		legs="Malignance Tights",
        }

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT = set_combine(sets.engaged.LowAcc, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)
    sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT = set_combine(sets.engaged.DW.LowAcc, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT = set_combine(sets.engaged.DW.MidAcc, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT = set_combine(sets.engaged.DW.HighAcc, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT = set_combine(sets.engaged.DW.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.LowHaste = set_combine(sets.engaged.DW.STP.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MidHaste = set_combine(sets.engaged.DW.STP.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MaxHaste = set_combine(sets.engaged.DW.STP.MaxHaste, sets.engaged.Hybrid)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.magic_burst = set_combine(sets.midcast['Blue Magic'].Magical, {
        body="Samnuha Coat", --(8)
        hands="Amalric Gages +1", --(5)
        legs="Assim. Shalwar +3", --10
        feet="Jhakri Pigaches +2", --5
        ring1="Mujin Band", --(5)
        back="Seshaw Cape", --5
        })

    sets.Kiting = {legs="Carmine Cuisses +1"}
    --sets.Learning = {hands="Assim. Bazu. +1"}
    sets.latent_refresh = {waist="Fucho-no-obi"}

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1="Purity Ring",
        --ring2={name="Eshmun's Ring", bag="wardrobe4"}, --20
        waist="Gishdubar Sash", --10
        }

    sets.CP = {back="Mecisto. Mantle"}
    sets.TreasureHunter = {head="Volte Cap", hands=gear.Herc_TH_hands, waist="Chaac Belt"}
    sets.midcast.Dia = sets.TreasureHunter
    sets.midcast.Diaga = sets.TreasureHunter
    sets.midcast.Bio = sets.TreasureHunter
    --sets.Reive = {neck="Ygnas's Resolve +1"}

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
        if spellMap == 'Healing' and spell.target.type == 'SELF' then
            equip(sets.midcast['Blue Magic'].HealingSelf)
        end
    end

    if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
        equip(sets.midcast.EnhancingDuration)
        if spellMap == 'Refresh' then
            equip(sets.midcast.Refresh)
        end
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Dream Flower" then
            send_command('@timers c "Dream Flower ['..spell.target.name..']" 90 down spells/00098.png')
        elseif spell.english == "Soporific" then
            send_command('@timers c "Sleep ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sheep Song" then
            send_command('@timers c "Sheep Song ['..spell.target.name..']" 60 down spells/00098.png')
        elseif spell.english == "Yawn" then
            send_command('@timers c "Yawn ['..spell.target.name..']" 60 down spells/00098.png')
        elseif spell.english == "Entomb" then
            send_command('@timers c "Entomb ['..spell.target.name..']" 60 down spells/00547.png')
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
    th_update(cmdParams, eventArgs)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

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
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
    --if state.IdleMode.value == 'Learning' then
    --    equip(sets.Learning)
    --    disable('hands')
    --else
    --    enable('hands')
    --end

    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
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
    if state.TreasureMode.value == 'Tag' then
        msg = msg .. ' TH: Tag |'
    end
    if state.MagicBurst.value then
        msg = ' Burst: On |'
    end
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

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 11 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 11 and DW_needed <= 21 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 21 and DW_needed <= 27 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 27 and DW_needed <= 37 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 37 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
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

function update_active_abilities()
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Efflux'] = buffactive['Efflux'] or false
    state.Buff['Diffusion'] = buffactive['Diffusion'] or false
end

-- State buff checks that will equip buff gear and mark the event as handled.
function apply_ability_bonuses(spell, action, spellMap)
    if state.Buff['Burst Affinity'] and (spellMap == 'Magical' or spellMap == 'MagicalLight' or spellMap == 'MagicalDark' or spellMap == 'Breath') then
        if state.MagicBurst.value then
            equip(sets.magic_burst)
        end
        equip(sets.buff['Burst Affinity'])
    end
    if state.Buff.Efflux and spellMap == 'Physical' then
        equip(sets.buff['Efflux'])
    end
    if state.Buff.Diffusion and (spellMap == 'Buffs' or spellMap == 'BlueSkill') then
        equip(sets.buff['Diffusion'])
    end

    if state.Buff['Burst Affinity'] then equip (sets.buff['Burst Affinity']) end
    if state.Buff['Efflux'] then equip (sets.buff['Efflux']) end
    if state.Buff['Diffusion'] then equip (sets.buff['Diffusion']) end
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

windower.register_event('zone change', 
    function()
        send_command('gi ugs true')
    end
)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
        set_macro_page(1, 6)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end