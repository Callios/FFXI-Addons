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

render_targettarget_bar = function()
	if not initialized then return end
	local targettarget = windower.ffxi.get_mob_by_id(targettarget_id or 0)
	
	if targettarget ~= nil and targettarget_id ~= nil then
		ttbg_cap_l:show()
		ttbg_cap_r:show()
		ttbg_body:show()
		ttfg_body:show()
		tt_text:show()
	
		local i = targettarget.hpp / 100
		local new_width = math.floor(targettargetBarWidth * i)
		local old_width = ttfg_body:width()

		ttfg_body:width(0)

		local now = os.clock()
		if new_width ~= nil and new_width > 0 then
			if new_width < old_width then
				local x = old_width + math.floor(((new_width - old_width) * 0.1))
				ttfg_body:width(x)
			elseif new_width >= old_width then
				ttfg_body:width(new_width)
			end			
		end

		ttfg_body:width(new_width)
		ttbg_body:width(targettargetBarWidth) -- I still have no idea why removing this breaks the bg.

		tt_text.name = targettarget.name
		tt_text.hpp = targettarget.hpp
		tt_text.debug = debug_string
		
		--Check claim_id with player and party_id
		if targettarget.hpp == 0 then
			tt_text:color(155, 155, 155)
		elseif check_claim(targettarget.claim_id) then
			tt_text:color(255, 204, 204)
		elseif targettarget.in_party == true then
			tt_text:color(102, 255, 255)
		elseif targettarget.is_npc == false then
			tt_text:color(255, 255, 255)
		elseif targettarget.claim_id == 0 then
			tt_text:color(230, 230, 138) 
		elseif targettarget.claim_id ~= 0 then
			tt_text:color(153, 102, 255)
		end			
	else
		ttbg_cap_l:hide()
		ttbg_cap_r:hide()
		ttbg_body:hide()
		ttfg_body:hide()
		tt_text:hide()
	end

end