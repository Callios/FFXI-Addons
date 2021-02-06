-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job. Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------
function user_setup()
	state.OffenseMode:options('Normal', 'Ailments','Hybrid', 'Melee', 'MeleeAcc')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.PhysicalDefenseMode:options('PDT')
	state.IdleMode:options('Normal','Kiting')
	select_default_macro_book()

	--Cycle runes with //gs c cycle Runes or /console gs c cycle Runes in macro
	--Use runes with //gs c rune or /console gs c rune 
	state.Runes = M{['description']='Runes',"Unda","Flabra","Sulpor","Gelus","Ignis","Tellus","Tenebrae","Lux"}

end

function init_gear_sets()
	sets.enmity = {
		ammo="Sapience Orb",
		head="Halitus helm",
		neck="Unmoving collar +1",
		ear1="Cryptic earring",
		ear2="Trux earring",
		body="Emet Harness +1",
		hands="Kurys gloves",
		ring1="Supershear ring",
		ring2="Eihwaz ring",
		back=gear.OgmaCapeTANK,
		waist="Kasiri belt",
		legs="Erilaz leg guards +1",
		feet="Ahosi leggings"
		}

--------------------------------------
-- Precast sets
--------------------------------------

	include('Gipi_augmented-items.lua')

-- Precast sets to enhance JAs
	sets.precast.JA['Vallation'] = set_combine(sets.enmity, {body="Runeist's coat +3",back=gear.OgmaCapeTANK,legs="Futhark Trousers +1"}) 
	sets.precast.JA['Valiance'] = sets.precast.JA['Vallation'] 
	sets.precast.JA['Pflug'] = set_combine(sets.enmity, {feet="Runeist bottes +1"}) 
	sets.precast.JA['Battuta'] = set_combine(sets.enmity, {head="Futhark Bandeau +1"})
	sets.precast.JA['Liement'] = set_combine(sets.enmity, {body="Futhark Coat +3"})
 	sets.precast.JA['Gambit'] = {hands="Runeist mitons +3"} 
	sets.precast.JA['Rayke'] = {feet="Futhark Bottes +1"} 
	sets.precast.JA['Elemental Sforzo'] = {body="Futhark Coat +3"} 
	sets.precast.JA['Swordplay'] = set_combine(sets.enmity, {hands="Futhark Mitons +1"}) 
	sets.precast.JA['Embolden'] = {back="Evasionist's cape"} 
	sets.precast.JA['Vivacious Pulse'] = {head="Erilaz galea +1"} 
	
	sets.precast.JA['One For All'] = {
		ammo="Falcon eye",
		head="Erilaz galea +1",
		neck="Cuamiz collar",
		ear1="Odnowa earring +1",
		ear2="Odnowa earring",
		body="Runeist's coat +3",
		hands="Runeist mitons +3",
		ring1="Meridian ring",
		ring2="Moonbeam ring",
		back="Moonbeam cape",
		waist="Oneiros belt",
		legs="Futhark trousers +1",
		feet="Runeist bottes +1"
		} 
		
	sets.precast.JA['Provoke'] = sets.enmity
	
	sets.precast.JA['Lunge'] = {
		ammo="Pemphredo tathlum",
		head=gear.HercHeadMagic,
		neck="Baetyl pendant",
		ear1="Friomisi Earring",
		ear2="Crematio Earring",
		body="Samnuha coat",
		hands="Carmine finger gauntlets +1",
		ring1="Shiva ring +1",
		ring2="Shiva ring +1",
		back="Evasionist's cape",
		waist="Eschan stone",
		legs=gear.HercLegsMagic,
		feet=gear.HercFeetMagic
		}
	
	sets.precast.JA['Swipe'] = sets.precast.JA['Lunge'] 

-- Fast cast sets for spells
	sets.precast.FC = {
		ammo="Impatiens",
		head="Carmine mask +1",
		neck="Orunmila's torque",
		ear1="Enchanter earring +1",
		ear2="Loquacious earring",	
		body="Adhemar Jacket",
		hands="Leyline gloves",
		ring1="Defending Ring",
		ring2="Gelatinous Ring +1",
		back=gear.OgmaCapeFC,
		waist="Flume Belt +1",
		legs="Ayanmo cosciales +1",
		feet="Carmine greaves +1"
		}
	
	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
		waist="Siegel Sash",
		legs="Futhark trousers +1"
		})
	
	sets.precast.FC['Utsusemi: Ichi'] = set_combine(sets.precast.FC, {neck='Magoraga beads'}) 
	sets.precast.FC['Utsusemi: Ni'] = set_combine(sets.precast.FC['Utsusemi: Ichi'], {neck='Magoraga beads'})

-- Weaponskill sets

	sets.precast.WS = {
		ammo="Knobkierrie",
		head="Lilitu headpiece",
		neck="Fotia Gorget",
		ear1="Moonshade Earring",
		ear2="Sherida Earring",
		body="Adhemar Jacket +1",
		hands="Meghanada gloves +2",
		ring1="Regal ring",
		ring2="Niqmaddu ring",
		back=gear.OgmaCapeSTR,
		waist="Fotia Belt",
		legs="Meghanada chausses +2",
		feet="Meghanada jambeaux +2"
		}
		
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {
		
		}) 
 
	sets.precast.WS['Resolution'] = {
		--ammo="Seething bomblet +1",
		ammo="Knobkierrie",
		head="Adhemar Bonnet +1",
		neck="Fotia Gorget",
		ear1="Moonshade Earring",
		ear2="Sherida Earring",
		body="Adhemar Jacket +1",
		---hands=gear.HercHandsACC,
		hands="Meghanada gloves +2",
		ring1="Regal ring",
		ring2="Niqmaddu ring",
		back=gear.OgmaCapeSTR,
		waist="Fotia Belt",
		legs="Meghanada chausses +2",
		feet=gear.HercFeetTP
		}
 
	sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS, {
		ammo="Yamarang",
		head="Meghanada visor +2",
		ear1="Telos Earring",
		ear2="Cessance Earring",
		}) 
 
	sets.precast.WS['Dimidiation'] = {
		ammo="Knobkierrie",
		head="Adhemar Bonnet +1",
		neck="Fotia Gorget",
		ear1="Moonshade Earring",
		ear2="Sherida Earring",
		body="Adhemar Jacket +1",
		hands="Meghanada gloves +2",
		ring1="Regal ring",
		ring2="Niqmaddu ring",
		back=gear.OgmaCapeDEX,
		waist="Fotia Belt",
		legs="Lustratio subligar +1",
		feet="Lustratio leggings +1",
		}
 
	sets.precast.WS['Dimidiation'].Acc = set_combine(sets.precast.WS, {
		ammo="Falcon eye",
		head="Meghanada visor +2",
		ear1="Telos Earring",
		ear2="Cessance Earring",
		}) 
		
	sets.precast.WS['Sanguine Blade'] = {
		ammo="Pemphredo tathlum",
		head=gear.HercHeadMagic,
		neck="Baetyl pendant",
		ear1="Friomisi Earring",
		ear2="Crematio Earring",
		body="Samnuha coat",
		hands="Carmine finger gauntlets +1",
		ring1="Shiva ring +1",
		ring2="Shiva ring +1",
		back="Evasionist's cape",
		waist="Eschan stone",
		legs=gear.HercLegsMagic,
		feet=gear.HercFeetMagic
		}
 
	sets.precast.WS['Herculean Slash'] = set_combine(sets.precast['Lunge'], {})
	sets.precast.WS['Herculean Slash'].Acc = set_combine(sets.precast.WS['Herculean Slash'].Normal, {})

--------------------------------------
-- Midcast sets
--------------------------------------
	sets.midcast.FastRecast = {
		ammo="Staunch tathlum",
        head="Carmine Mask +1",
		neck="Loricate torque +1",
		ear1="Odnowa earring +1",
		ear2="Odnowa earring +1",
        body="Futhark Coat +3",
		hands=gear.HercHandsDT,
		ring1="Defending Ring",
		ring2="Gelatinous Ring +1",
        back=gear.OgmaCapeTANK,
		waist="Flume belt +1",
		legs="Erilaz leg guards +1",
		feet="Turms Leggings"
		}
	
	sets.midcast['Enhancing Magic'] = set_combine(sets.midcast.FastRecast, {
		head="Erilaz galea +1",
		legs="Futhark Trousers +1"
		})
	
	sets.midcast['Temper'] = set_combine(sets.midcast['Enhancing Magic'], {
		neck="Incanter's torque",
		ear1="Andoaa earring",
		hands="Runeist mitons +3",
		ring1="Stikini ring",
		ring2="Stikini ring",
		waist="Olympus sash",
		})
	
	sets.midcast.BarElement = set_combine(sets.midcast['Temper'], {
		})
	
	sets.midcast['Phalanx'] = set_combine(sets.midcast['Temper'], {
		head="Futhark Bandeau +1",
		})
		
	sets.midcast['Stoneskin'] = set_combine(sets.midcast['Temper'], {
		neck="Stone gorget",waist="Siegel Sash"
		})
	
	sets.midcast['Regen'] = set_combine(sets.midcast['Enhancing Magic'], {head="Runeist Bandeau +1"})		
	sets.midcast['Refresh'] = set_combine(sets.midcast['Enhancing Magic'], {head="Erilaz galea +1",waist="Gishdubar Sash"})
 	sets.midcast['Flash'] = sets.enmity
 	sets.midcast['Stun'] = sets.enmity
 	sets.midcast['Poisonga'] = sets.enmity
 	sets.midcast['Foil'] = set_combine(sets.midcast['Flash'], {}) 
	sets.midcast['Blank Gaze'] = set_combine(sets.midcast['Flash'], {}) 
	sets.midcast['Geist Wall'] = set_combine(sets.midcast['Flash'], {})
	sets.midcast['Jettatura'] = set_combine(sets.midcast['Flash'], {})
	sets.midcast['Wild Carrot'] = set_combine(sets.midcast['Flash'], {}) 
	sets.midcast.Cure = set_combine(sets.midcast['Flash'], {})
	
--------------------------------------
-- Idle/resting/defense/etc sets
--------------------------------------
	sets.idle = {ammo="Homiliary",
        head="Rawhide mask",neck="Bathy choker +1",ear1="Infused earring",ear2="Ethereal Earring",
        body="Runeist's coat +3",hands=gear.HercHandsREFRESH,ring1="Sheltered Ring",ring2="Paguroidea Ring",
        back=gear.OgmaCapeTANK,waist="Fucho-no-obi",legs="Carmine cuisses +1",feet=gear.HercFeetREFRESH}

	sets.idle.Town = sets.idle
 
	sets.idle.Kiting = {
		ammo="Staunch tathlum",
        head=gear.HercHeadDT,
		neck="Loricate torque +1",
		ear1="Odnowa earring +1",
		ear2="Ethereal earring",
        body="Runeist's Coat +3",
		hands=gear.HercHandsDT,
		ring1="Defending Ring",
		ring2="Moonbeam Ring",
        back=gear.OgmaCapeTANK,
		waist="Engraved Belt",
		legs="Runeist's Trousers +3",
		feet="Erilaz greaves +1"
		}
 
	sets.defense.PDT = {
		ammo="Staunch tathlum",
        head=gear.HercHeadDT,
		neck="Loricate torque +1",
		ear1="Odnowa earring +1",
		ear2="Ethereal earring",
        body="Futhark Coat +3",
		hands=gear.HercHandsDT,
		ring1="Defending Ring",
		ring2="Gelatinous Ring +1",
        back=gear.OgmaCapeTANK,
		waist="Engraved belt",
		legs="Erilaz leg guards +1",
		feet="Turms Leggings"
		}
 
	sets.defense.MDT = {
		ammo="Staunch tathlum",
        head=gear.HercHeadDT,
		neck="Loricate torque +1",
		ear1="Odnowa earring +1",
		ear2="Ethereal earring",
        body="Runeist's coat +3",
		hands=gear.HercHandsDT,
		ring1="Defending Ring",
		ring2="Gelatinous Ring +1",
        back=gear.OgmaCapeTANK,
		waist="Engraved belt",
		legs="Erilaz leg guards +1",
		feet="Turms Leggings"
		}
 
	sets.Kiting = { --52
		ammo="Staunch tathlum",
        head=gear.HercHeadDT,
		neck="Loricate torque +1",
		ear1="Odnowa earring +1",
		ear2="Ethereal earring",
        body="Runeist's Coat +3",
		hands=gear.HercHandsDT,
		ring1="Defending Ring",
		ring2="Gelatinous Ring +1",
        back=gear.OgmaCapeTANK,
		waist="Engraved Belt",
		legs="Carmine cuisses +1",
		feet="Erilaz greaves +1"
		}

--------------------------------------
-- Engaged sets
--------------------------------------

	sets.engaged = { --5
		main="Epeolatry",
		sub="Mensch Strap +1",		
		ammo="Staunch tathlum", --2
        head=gear.HercHeadDT, --5
		neck="Loricate torque +1", --6
		ear1="Eabani Earring",
		ear2="Ethereal earring",
        body="Runeist's Coat +3",
		hands="Turms Mittens +1",
		ring1="Defending Ring", --10
		ring2="Gelatinous Ring +1", --7
        back=gear.OgmaCapeTANK, --10
		waist="Engraved belt",
		legs="Erilaz leg guards +1", --7
		feet="Turms Leggings",
		} 
 
	sets.engaged.Ailments = {			-- 5 from strap
		main="Epeolatry",
		sub="Mensch Strap +1",
		ammo="Staunch tathlum", 		-- 2
        head=gear.HercHeadDT,			-- 5
		neck="Loricate torque +1",		-- 6 
		ear1="Hearty earring",			--
		ear2="Ethereal earring",		--
        body="Runeist's Coat +3",		-- 
		hands="Turms Mittens +1",		-- 
		ring1="Defending Ring",			-- 10
		ring2="Gelatinous Ring +1",		-- 7
        back=gear.OgmaCapeTANK,			-- 10
		waist="Engraved belt",			--
		legs="Rune. Trousers +3",		-- 5
		feet="Turms Leggings"			--
		} 
		
	sets.engaged.Hybrid = { 
		ammo="Staunch tathlum",
        head="Meghanada visor +2",
		neck="Loricate torque +1",
		ear1="Telos earring",
		ear2="Sherida earring",
        body="Ashera harness",
		hands=gear.HercHandsDT,
		ring1="Defending Ring",
		ring2="Moonbeam ring",
        back=gear.OgmaCapeTP,
		waist="Ioskeha belt",
		legs="Meghanada chausses +2",
		feet=gear.HercFeetTP
		}
		 
	sets.engaged.Melee = {
		ammo="Yamarang",
		head="Adhemar Bonnet +1",
		neck="Anu Torque",
		ear1="Telos earring",
		ear2="Sherida Earring",
		body="Adhemar Jacket +1",
		hands="Adhemar Wristbands +1",
		ring1="Petrov ring",
		ring2="Epona's Ring",
		back=gear.OgmaCapeTP,
		waist="Windbuffet Belt +1",
		legs="Samnuha tights",
		feet=gear.HercFeetTP
		}
	
	sets.engaged.MeleeAcc = {
		ammo="Yamarang",
		head="Carmine mask +1",
		neck="Combatant's torque",
		ear1="Telos earring",
		ear2="Cessance Earring",
		body="Adhemar Jacket +1",
		hands="Adhemar Wristbands +1",
		ring1="Regal ring",
		ring2="Cacoethic ring +1",
		back=gear.OgmaCapeTP,
		waist="Olseni belt",
		legs="Carmine cuisses +1",
		feet=gear.HercFeetTP
		}

    --------------------------------------
    -- Vivacious Pulse sets
    --------------------------------------
 
    -- Maximize the stat listed for each set.
    sets.pulse = {}
    -- STR
    sets.pulse.Ignis = {
        neck="Incanter's torque",
		body="Ashera harness",ring1="Stikini Ring",ring2="Stikini Ring",
        back="Altruistic cape",waist="Bishop's sash",legs="	Rune. Trousers +3"}
    -- DEX
    sets.pulse.Gelus = sets.pulse.Ignis
    -- VIT
    sets.pulse.Flabra = sets.pulse.Ignis
    -- AGI
    sets.pulse.Tellus = sets.pulse.Ignis
    -- MND
    sets.pulse.Unda = sets.pulse.Ignis
    -- INT
    sets.pulse.Sulpor = sets.pulse.Ignis
    -- CHR
    sets.pulse.Lux = sets.pulse.Ignis
    -- Divine Magic skill and possibly all stats?
    sets.pulse.Tenebrae = sets.pulse.Ignis

end

--------------------------------------
-- Vivacious Pulse Sets
--------------------------------------
-- Precast sets to enhance Vivacious Pulse

function job_precast(spell, action, spellMap, eventArgs)
    if spell.english == 'Vivacious Pulse' then
        -- There's got to be a less verbose way of doing this
        if buffactive['Ignis'] then
            equip(sets.pulse.Ignis)
        elseif buffactive['Gelus'] then
            equip(sets.pulse.Gelus)
        elseif buffactive['Flabra'] then
            equip(sets.pulse.Flabra)
        elseif buffactive['Tellus'] then
            equip(sets.pulse.Tellus)
        elseif buffactive['Sulpor'] then
            equip(sets.pulse.Sulpor)
        elseif buffactive['Unda'] then
            equip(sets.pulse.Unda)
        elseif buffactive['Lux'] then
            equip(sets.pulse.Lux)
        elseif buffactive['Tenebrae'] then
            equip(sets.pulse.Tenebrae)
        end
    end
end
 

------------------------------------------------------------------
-- Action events
------------------------------------------------------------------
-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
if spell.english == 'Lunge' or spell.english == 'Swipe' then
local obi = get_obi(get_rune_obi_element())
if obi then
equip({waist=obi})
end
end
end
function job_aftercast(spell)
if not spell.interrupted then
if spell.type == 'Rune' then
update_timers(spell)
elseif spell.name == "Lunge" or spell.name == "Gambit" or spell.name == 'Rayke' then
reset_timers()
elseif spell.name == "Swipe" then
send_command(trim(1))
end
end
end
-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
-- Default macro set/book
if player.sub_job == 'BLU' then
set_macro_page(1, 5)
elseif player.sub_job == 'NIN' then
set_macro_page(1, 5)
elseif player.sub_job == 'SAM' then
set_macro_page(1, 5)
else
set_macro_page(1, 5)
end
end
function get_rune_obi_element()
weather_rune = buffactive[elements.rune_of[world.weather_element] or '']
day_rune = buffactive[elements.rune_of[world.day_element] or '']
local found_rune_element
if weather_rune and day_rune then
if weather_rune > day_rune then
found_rune_element = world.weather_element
else
found_rune_element = world.day_element
end
elseif weather_rune then
found_rune_element = world.weather_element
elseif day_rune then
found_rune_element = world.day_element
end
return found_rune_element
end
function get_obi(element)
if element and elements.obi_of[element] then
return (player.inventory[elements.obi_of[element]] or player.wardrobe[elements.obi_of[element]]) and elements.obi_of[element]
end
end
------------------------------------------------------------------
-- Timer manipulation
------------------------------------------------------------------
-- Add a new run to the custom timers, and update index values for existing timers.
function update_timers(spell)
local expires_time = os.time() + 300
local entry_index = rune_count(spell.name) + 1
local entry = {rune=spell.name, index=entry_index, expires=expires_time}
rune_timers:append(entry)
local cmd_queue = create_timer(entry).. ';wait 0.05;'
cmd_queue = cmd_queue .. trim()
add_to_chat(123,'cmd_queue='..cmd_queue)
send_command(cmd_queue)
end
-- Get the command string to create a custom timer for the provided entry.
function create_timer(entry)
local timer_name = '"Rune: ' .. entry.rune .. '-' .. tostring(entry.index) .. '"'
local duration = entry.expires - os.time()
return 'timers c ' .. timer_name .. ' ' .. tostring(duration) .. ' down'
end
-- Get the command string to delete a custom timer for the provided entry.
function delete_timer(entry)
local timer_name = '"Rune: ' .. entry.rune .. '-' .. tostring(entry.index) .. '"'
return 'timers d ' .. timer_name .. ''
end
-- Reset all timers
function reset_timers()
local cmd_queue = ''
for index,entry in pairs(rune_timers) do
cmd_queue = cmd_queue .. delete_timer(entry) .. ';wait 0.05;'
end
rune_timers:clear()
send_command(cmd_queue)
end
-- Get a count of the number of runes of a given type
function rune_count(rune)
local count = 0
local current_time = os.time()
for _,entry in pairs(rune_timers) do
if entry.rune == rune and entry.expires > current_time then
count = count + 1
end
end
return count
end
-- Remove the oldest rune(s) from the table, until we're below the max_runes limit.
-- If given a value n, remove n runes from the table.
function trim(n)
local cmd_queue = ''
local to_remove = n or (rune_timers:length() - max_runes)
while to_remove > 0 and rune_timers:length() > 0 do
local oldest
for index,entry in pairs(rune_timers) do
if oldest == nil or entry.expires < rune_timers[oldest].expires then
oldest = index
end
end
cmd_queue = cmd_queue .. prune(rune_timers[oldest].rune)
to_remove = to_remove - 1
end
return cmd_queue
end
-- Drop the index of all runes of a given type.
-- If the index drops to 0, it is removed from the table.
function prune(rune)
local cmd_queue = ''
for index,entry in pairs(rune_timers) do
if entry.rune == rune then
cmd_queue = cmd_queue .. delete_timer(entry) .. ';wait 0.05;'
entry.index = entry.index - 1
end
end
for index,entry in pairs(rune_timers) do
if entry.rune == rune then
if entry.index == 0 then
rune_timers[index] = nil
else
cmd_queue = cmd_queue .. create_timer(entry) .. ';wait 0.05;'
end
end
end
return cmd_queue
end
------------------------------------------------------------------
-- Reset events
------------------------------------------------------------------
windower.raw_register_event('zone change',reset_timers)
windower.raw_register_event('logout',reset_timers)
windower.raw_register_event('status change',function(new, old)
if gearswap.res.statuses[new].english == 'Dead' then
reset_timers()
end
end)

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'rune' then
        send_command('@input /ja '..state.Runes.value..' <me>')
    end
end
