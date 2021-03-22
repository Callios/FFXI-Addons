_addon.name = 'Escutcheons'
_addon.author = 'coldmix'
_addon.version = '1.0.0.0'
_addon.commands = {'escutcheons', 'ec'}

require('coroutine')
res = require('resources')
config = require('config')
packets = require('packets')
local recipes = require('recipes')
require('logger')


defaults = {}
defaults.Materials = S{'Bruised Starfruit','Scorpion Stinger','Fetich Head','Giant Fish Bones','Indigo Memosphere','Fetich Legs','Tonberry Board',"Carbuncle's Ruby",'Beryl Memosphere','Orcish Mail Scales','Soiled Letter','Fetich Arms','Demon Pen','Magicked Steel','Ancient Salt','Desert Venom','Fetich Torso','Lucky Egg','Ancient Papyrus','Rusty Key','Star Spinel','Rusty Medal','Elshimo Marble','Teal Memosphere','Shoalweed','Colorful Hair','Test Answers','White Memosphere','Exoray Mold','Bomb Coal','Frayed Arrow','Delkfutt Key'}
defaults.AutoSave = true
defaults.AutoCraft = true
defaults.Delay = 5
defaults.RecheckDelay = 18
defaults.Verbose = false
defaults.CraftEquipset = 9
defaults.DefaultEquipset = 9
defaults.Obtain = 0
defaults.Attempts = 0
defaults.Level1 = 0
defaults.Level2 = 0
defaults.Level3 = 0
defaults.SpiritImbue = 0
defaults.SpiritLost = 0
defaults.Catalyst1 = 0
defaults.Catalyst2 = 0
defaults.Catalyst3 = 0

settings = config.load(defaults)
--table.print(settings)

spheres = {}
spheres.l1 = S{"Lique. Sphere","Indur. Sphere","Deton. Sphere","Sciss. Sphere","Impac. Sphere","Rever. Sphere","Trans. Sphere","Compr. Sphere"}
spheres.l2 = S{"Fusion Sphere","Disto. Sphere","Fragm. Sphere","Gravi. Sphere"}
spheres.l3 = S{"Light Sphere","Darkn. Sphere"}

code = {}
code.materials = S{}
code.l1 = S{}
code.l2 = S{}
code.l3 = S{}
code.force_check_scheduled = false
code.previous_msg = ""
ids = T{}

for name in settings.Materials:it() do
    local search = res.items:name(name)
    local id, item = next(search, nil)
    if id then
        ids[item.en:lower()] = id 
        ids[item.enl:lower()] = id
        code.materials = code.materials + id      
    else
        log("Invalid item %s":format(name))
    end
end

for name in spheres.l1:it() do
    local search = res.items:name(name)
    local id, item = next(search, nil)
    if id then
        code.l1 = code.l1 + id      
    else
        log("Invalid item %s":format(name))
    end
end

for name in spheres.l2:it() do
    local search = res.items:name(name)
    local id, item = next(search, nil)
    if id then
        code.l2 = code.l2 + id      
    else
        log("Invalid item %s":format(name))
    end
end

for name in spheres.l3:it() do
    local search = res.items:name(name)
    local id, item = next(search, nil)
    if id then
        code.l3 = code.l3 + id      
    else
        log("Invalid item %s":format(name))
    end
end

bool_values = T{
    ['on'] = true,
    ['1'] = true,
    ['true'] = true,
    ['off'] = false,
    ['0'] = false,
    ['false'] = false,
}

inventory_id = res.bags:with('english', 'Inventory').id

function fetch_recipe_name(item_name)
    local item = item_name:lower()
    for recipe_name, recipe in pairs(recipes) do
        for i, ingredient in pairs(recipe['ingredients']) do
            if item == ingredient:lower() then
                return recipe_name
            end
        end        
    end
    return ''
end

function craft_item(id)
    local item_name = res.items[id].name
    local recipe_name = fetch_recipe_name(item_name)        
    if recipe_name:len() then
        if settings.Verbose then
            log('Crafting %s':format(recipe_name:color(258)))
        end
        if (settings.CraftEquipset > 0) then
            windower.send_command('input /equipset '..settings.CraftEquipset..'; wait 2; craft make \"'..recipe_name..'\"')
        else
            windower.send_command('craft make \"'..recipe_name..'\"')
        end
        settings.Attempts = settings.Attempts + 1            
    end                   
end

function force_check()
    code.force_check_scheduled = false
    if settings.Verbose then 
        log('checking inventory')
    end
    local player = windower.ffxi.get_player()
    if not player then
        code.force_check_scheduled = true
        coroutine.schedule(force_check, settings.Delay)
        return  
    elseif player.status > 0 then
        --print('Busy status %s':format(res.statuses[player.status].english))
        code.force_check_scheduled = true
        coroutine.schedule(force_check, 2)
        return
    end
    local items = windower.ffxi.get_items(inventory_id)
    if settings.AutoCraft then
        for index, item in pairs(items) do
            if type(item) == 'table' and code.materials:contains(item.id) then
                -- Trigger crafting
                windower.ffxi.run(false)
                windower.ffxi.turn(-math.pi/2)
                craft_item(item.id)
                if settings.Verbose then
                    log("checking back after %d secs":format(settings.RecheckDelay))
                end
                coroutine.schedule(force_check, settings.RecheckDelay)
                code.force_check_scheduled = true
                return
            end
        end
    end
    if (settings.DefaultEquipset > 0) then
        windower.send_command('input /equipset '..settings.DefaultEquipset)
    end
    if settings.AutoSave then
        config.save(settings, 'all')
    end            
end

function check(slot_index, item_id)
    if code.materials:contains(item_id) then
        local inventory = windower.ffxi.get_items(inventory_id)
        if code.materials:contains(item_id) then
            if not code.force_check_scheduled then
                log("found item : %s, crafting in %d secs":format(res.items[item_id].name:color(258), settings.Delay))
                coroutine.schedule(force_check,settings.Delay)
                code.force_check_scheduled = true
            end
        end
    end
end

windower.register_event('add item', function(bag, index, id, count)
    if bag == inventory_id then
        if settings.AutoCraft and code.materials:contains(id) then
            --log("Received %s":format(res.items[id].name:color(258)))
            log("found item : %s, crafting in %d secs":format(res.items[id].name:color(258), settings.Delay))
            settings.Obtain = settings.Obtain + 1 
            coroutine.schedule(force_check,settings.Delay)
            code.force_check_scheduled = true
        elseif code.l1:contains(id) then
            settings.Level1 = settings.Level1 + 1
            if settings.Verbose then
                log("crafted %s":format(res.items[id].name:color(258)))
            end 
        elseif code.l2:contains(id) then
            settings.Level2 = settings.Level2 + 1
            if settings.Verbose then
                log("crafted %s":format(res.items[id].name:color(258)))
            end
        elseif code.l3:contains(id) then
            settings.Level3 = settings.Level3 + 1
            if settings.Verbose then
                log("crafted %s":format(res.items[id].name:color(258)))
            end
        end                           
    end
    return false 
end)

windower.register_event('remove item', function(bag, index, id, count)
    if bag == inventory_id and settings.AutoCraft and code.materials:contains(id) then
        log("used item : %s":format(res.items[id].name:color(258))) 
    end
    return false 
end)

function Strip_Control_and_Extended_Codes( str )
    local s = ""
    for i = 1, str:len() do
        if str:byte(i) >= 32 and str:byte(i) <= 126 then
            s = s .. str:sub(i,i)
        end
    end
    return s
end

windower.register_event('incoming text',function (original)
    -- Block multiple repeated strings
    local cleantext = Strip_Control_and_Extended_Codes(original)
    if (code.previous_msg ~= cleantext) then
        if (string.find(cleantext, "imbue the item with %d+ spirit.")) then
            local count = tonumber(cleantext:match('%d+'))
            settings.SpiritImbue = settings.SpiritImbue + count
            config.save(settings, 'all')
            if settings.Verbose then
                print("Gain %d spirit, total %d spirit":format(count, settings.SpiritImbue - settings.SpiritLost)) 
            end
        elseif (string.find(cleantext, "spirit imbued has decreased by %d+")) then
            local count = tonumber(cleantext:match('%d+'))
            settings.SpiritLost = settings.SpiritLost + count
            config.save(settings, 'all')
            if settings.Verbose then
                print("Lost %d spirit, total %d spirit":format(count, settings.SpiritImbue - settings.SpiritLost)) 
            end
        elseif (string.find(cleantext, "The MC%-I%-SR%d+ will be")) then
            local cattype = tonumber(cleantext:match('%d+'))
            if (cattype == 1) then
                settings.Catalyst1 = settings.Catalyst1 + 1          
            elseif (cattype == 2) then
                settings.Catalyst2 = settings.Catalyst2 + 1
            elseif (cattype == 3) then
                settings.Catalyst3 = settings.Catalyst3 + 1
            end
            if settings.Verbose then
                print("Catalyst Type %d used":format(cattype))
            end                  
        end
    end   
    code.previous_msg = cleantext
end)

windower.register_event('load', force_check:cond(table.get-{'logged_in'} .. windower.ffxi.get_info))

function pct(val)
  val = val * 100
  local decimal = 2
  return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
end

windower.register_event('addon command', function(command1, command2, ...)
    local args = L{...}
    local global = false

    if args[1] == 'global' then
        global = true
        args:remove(1)
    end

    command1 = command1 and command1:lower() or 'help'
    command2 = command2 and command2:lower() or nil

    local name = args:concat(' ')
    if command1 == 'autocraft' then
        if command2 then
            settings.AutoCraft = bool_values[command2:lower()]
        else
            settings.AutoCraft = not settings.AutoCraft
        end

        config.save(settings)
        log('AutoCraft %s':format(settings.AutoCraft and 'enabled' or 'disabled'))

    elseif command1 == 'autosave' then
        if command2 then
            settings.AutoSave = bool_values[command2:lower()]
        else
            settings.AutoSave = not settings.AutoSave
        end

        config.save(settings)
        log('AutoSave %s':format(settings.AutoSave and 'enabled' or 'disabled'))

    elseif command1 == 'delay' then
        if not (command2 and tonumber(command2)) then
            error('Please specify a value in seconds for the new delay')
            return
        end

        settings.Delay = tonumber(command2)
        log('Delay set to %f seconds':format(settings.Delay))

    elseif command1 == 'recheck' then
        if not (command2 and tonumber(command2)) then
            error('Please specify a value in seconds for the new delay')
            return
        end

        settings.RecheckDelay = tonumber(command2)
        log('Recheck Delay set to %f seconds':format(settings.RecheckDelay))

    elseif command1 == 'verbose' then
        if command2 then
            settings.Verbose = bool_values[command2:lower()]
        else
            settings.Verbose = not settings.Verbose
        end

        config.save(settings)
        log('Verbose output %s':format(settings.Verbose and 'enabled' or 'disabled'))
        
    elseif command1 == 'craftset' then
        if not (command2 and tonumber(command2)) or (tonumber(command2) > 20) then
            error('Please specify a value in from 0 to 20')
            return
        end

        settings.CraftEquipset = tonumber(command2)
        log('Craftset set to %f':format(settings.CraftEquipset))
        
    elseif command1 == 'defaultset' then
        if not (command2 and tonumber(command2)) or (tonumber(command2) > 20) then
            error('Please specify a value in from 0 to 20')
            return
        end

        settings.DefaultEquipset = tonumber(command2)
        log('Defaultset set to %f':format(settings.DefaultEquipset))

    elseif command1 == 'save' then
        config.save(settings, 'all')
        
    elseif command1 == 'stats' then
        local success = settings.Level1 + settings.Level2 + settings.Level3
        log('Obtain - %d , Attempts - %d, Success - %d':format(settings.Obtain, settings.Attempts, success))
        if settings.Attempts > 0 then
            local fail = settings.Attempts - settings.Obtain
            local lost = settings.Obtain - success 
            log('T1 %5.2f%% (%d), T2 %5.2f%% (%d), T3 %5.2f%% (%d), Failed %5.2f%% (%d), Lost %5.2f%% (%d) ':format(pct(settings.Level1/settings.Attempts),settings.Level1, pct(settings.Level2/settings.Attempts),settings.Level2, pct(settings.Level3/settings.Attempts),settings.Level3, pct(fail/settings.Attempts), fail, pct(lost/settings.Attempts), lost))
        end
        log('Spirits - %d (Lost %d), Catalysts used %d, %d, %d':format(settings.SpiritImbue - settings.SpiritLost,settings.SpiritLost,settings.Catalyst1,settings.Catalyst2,settings.Catalyst3))
        
    elseif command1 == 'help' then
        print('%s v%s':format(_addon.name, _addon.version))
        print('    \\cs(255,255,255)autocraft [on|off]\\cr - Enables/disables (or toggles) the auto-craft setting')
        print('    \\cs(255,255,255)autosave [on|off]\\cr - Enables/disables (or toggles) the auto-save setting')
        print('    \\cs(255,255,255)verbose [on|off]\\cr - Enables/disables (or toggles) the verbose setting')
        print('    \\cs(255,255,255)delay <value>\\cr - Allows you to change the delay of crafting (default: 5)')
        print('    \\cs(255,255,255)recheck <value>\\cr - Allows you to change the delay of rechecking to trigger if fail (default: 25)')
        print('    \\cs(255,255,255)craftset <value>\\cr - Equipset for crafting, 0 to disable')
        print('    \\cs(255,255,255)defaultset <value>\\cr - Equipset outside crafting, 0 to disable')
        print('    \\cs(255,255,255)stats\\cr - Print stats')
        print('    \\cs(255,255,255)save\\cr - Save changed settings')
    end
end)

--[[
Copyright © 2014-2015, Windower
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of Windower nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Windower BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--]]
                                                                                                            