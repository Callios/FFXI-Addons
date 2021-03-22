--[[
Copyright © 2015, Mike McKee
All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of enemybar nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Mike McKee BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--]]

_addon.name = 'enemybar'
_addon.author = 'mmckee'
_addon.version = '1.0.2'
_addon.language = 'English'

config = require('config')
images = require('images')
texts = require('texts')
require('gui_settings')
require('targetBar')
require('subtargetBar')
require('targettargetBar')
res = require('resources')

player_id = 0
targettarget_id = nil
debug_string = ''

target_action_id = nil
target_action_time = nil
target_action_type = nil
actor_name = nil

windower.register_event('load', function()
    if windower.ffxi.get_info().logged_in then
        player_id = windower.ffxi.get_player().id
    end
end)


--action we are interested in
actionWhitelist = {
	[7] = true,
	[8] = true,
	[4] = true,
	[6] = true,
 }
windower.register_event('action',function (act)
	if not initialized then return end

	local actor = windower.ffxi.get_mob_by_id(act.actor_id)	
	local valid_target = act.valid_target
	local self = windower.ffxi.get_player()
	local targets = act.targets
	local primarytarget = windower.ffxi.get_mob_by_id(targets[1].id)
	local playertarget = nil
	
	if self.target_index then
		playertarget = windower.ffxi.get_mob_by_index(self.target_index)
	else
		targettarget_id = nil;
		return
	end
	
	if playertarget.id ~= act.actor_id then return end -- not interesiting
	
	if actor and playertarget then 
		--windower.add_to_chat(55,"PRIMARY TARGET: "..primarytarget.name)
		targettarget_id = targets[1].id
	else
		--windower.add_to_chat(55,"NO TARGETTARGET")
		targettarget_id = nil;
	
	end
	if actionWhitelist[act.category] and act.targets[1] and act.targets[1].actions[1] and actor.name then
		target_action_id = act.targets[1].actions[1]["param"];
		target_action_time = os.clock()
		target_action_param = act["param"]
		actor_name = actor.name
		target_action_type = act.category
		--windower.add_to_chat(55,target_action_id)
		--windower.add_to_chat(55,actor_name)
		--windower.add_to_chat(55,target_action_type)
		--windower.add_to_chat(55,target_action_param)
	end
end)


windower.register_event('prerender', function(...)
    -- This is a super cheap fix, but it works.
	if not initialized then return end
	if target_action_time ~= nil then
		elapsed_time = os.clock() - target_action_time
		--print(elapsed_time)
		if elapsed_time > 2 and target_action_type and target_action_type ~= 8 then
			--windower.add_to_chat(55,"RESETTING "..elapsed_time.." "..target_action_type)
			target_action_id = nil
			target_action_type = nil
			target_action_time = nil
			actor_name = nil
			target_action_param = nil
		end
	end
end)


windower.register_event('prerender', render_target_bar)
windower.register_event('prerender', render_subtarget_bar)
windower.register_event('prerender', render_targettarget_bar)
windower.register_event('target change', target_change)


function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

windower.register_event('logout', function(...)
    -- This is a super cheap fix, but it works.
    windower.send_command("input //lua r enemybar");
end)
