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

targetBarHeight = 0
targetBarWidth = 0
targetCastBarWidth = 0
targetCastBarHeight = 0
subtargetBarHeight = 0
subtargetBarWidth = 0
targettargetBarHeight = 0
targettargetBarWidth = 0
center_screen = 0
hideKey = 70

initialized = false

local LOGIN_ZONE_PACKET = 0x0A
local ZONE_OUT_PACKET = 0x0B

visible = false
hasTarget = false
is_hidden_by_key = false
is_hidden_by_cutscene = false
is_hidden_by_macro = false
is_hidden_by_zoning = false

defaults = {}
defaults.text = {}
defaults.text.font = 'sans-serif'
defaults.text.size = 9
defaults.text.italic = true
defaults.text.bold = true
defaults.text.padding = 15
defaults.pos = {}
defaults.pos.x = 500
defaults.pos.y = 65
defaults.targetBar = {}
defaults.targetBar.width = 300
defaults.targetBar.height = 5
defaults.subTargetBar = {}
defaults.subTargetBar.width = 200
defaults.subTargetBar.height = 5
defaults.TargetTargetBar = {}
defaults.TargetTargetBar.width = 200
defaults.TargetTargetBar.height = 5
defaults.useRoundCap = true
defaults.hideKey = 70
defaults.macroBar = {}
defaults.macroBar.ctrlKey = 29
defaults.macroBar.altKey = 56
defaults.macroBar.hide = {}
defaults.macroBar.hide.enabled = true
defaults.macroBar.move = {}
defaults.macroBar.move.enabled = false
defaults.macroBar.move.height = 40

bg_cap_l_path = windower.addon_path.. 'bg_cap_l.png'
bg_cap_r_path = windower.addon_path.. 'bg_cap_r.png'
bg_body_path = windower.addon_path.. 'bg_body.png'
fg_body_path = windower.addon_path.. 'fg_body.png'
pointer_path = windower.addon_path.. 'pointer_s.png'

text_settings = {}
text_settings.pos = {}
text_settings.pos.x = center_screen
text_settings.pos.y = 50
text_settings.text = {}
text_settings.text.size = 14
text_settings.text.font = 'sans-serif'
text_settings.text.fonts = {'Arial', 'Trebuchet MS'}
text_settings.text.stroke = {}
text_settings.text.stroke.width = 2
text_settings.text.stroke.alpha = 200
text_settings.text.stroke.red = 50
text_settings.text.stroke.green = 50
text_settings.text.stroke.blue = 50
text_settings.flags = {}
text_settings.flags.italic = true
text_settings.flags.bold = true
text_settings.flags.draggable = false
text_settings.bg = {}
text_settings.bg.visible = false

stext_settings = {}
stext_settings.pos = {}
stext_settings.pos.x = center_screen
stext_settings.pos.y = 50
stext_settings.text = {}
stext_settings.text.size = 14
stext_settings.text.font = 'sans-serif'
stext_settings.text.fonts = {'Arial', 'Trebuchet MS'}
stext_settings.text.stroke = {}
stext_settings.text.stroke.width = 2
stext_settings.text.stroke.alpha = 200
stext_settings.text.stroke.red = 50
stext_settings.text.stroke.green = 50
stext_settings.text.stroke.blue = 50
stext_settings.flags = {}
stext_settings.flags.italic = true
stext_settings.flags.bold = true
stext_settings.flags.draggable = false
stext_settings.bg = {}
stext_settings.bg.visible = false


atext_settings = {}
atext_settings.pos = {}
atext_settings.pos.x = center_screen
atext_settings.pos.y = 50
atext_settings.text = {}
atext_settings.text.size = 14
atext_settings.text.font = 'sans-serif'
atext_settings.text.fonts = {'Arial', 'Trebuchet MS'}
atext_settings.text.stroke = {}
atext_settings.text.stroke.width = 2
atext_settings.text.stroke.alpha = 200
atext_settings.text.stroke.red = 50
atext_settings.text.stroke.green = 50
atext_settings.text.stroke.blue = 50
atext_settings.flags = {}
atext_settings.flags.italic = true
atext_settings.flags.bold = true
atext_settings.flags.draggable = false
atext_settings.bg = {}
atext_settings.bg.visible = false

satext_settings = {}
satext_settings.pos = {}
satext_settings.pos.x = center_screen
satext_settings.pos.y = 50
satext_settings.text = {}
satext_settings.text.size = 32
satext_settings.text.font = 'sans-serif'
satext_settings.text.fonts = {'Arial', 'Trebuchet MS'}
satext_settings.text.stroke = {}
satext_settings.text.stroke.width = 2
satext_settings.text.stroke.alpha = 200
satext_settings.text.stroke.red = 50
satext_settings.text.stroke.green = 50
satext_settings.text.stroke.blue = 50
satext_settings.flags = {}
satext_settings.flags.italic = true
satext_settings.flags.bold = true
satext_settings.flags.draggable = false
satext_settings.bg = {}
satext_settings.bg.visible = false


sadesc_settings = {}
sadesc_settings.pos = {}
sadesc_settings.pos.x = center_screen
sadesc_settings.pos.y = 50
sadesc_settings.text = {}
sadesc_settings.text.size = 32
sadesc_settings.text.font = 'sans-serif'
sadesc_settings.text.fonts = {'Arial', 'Trebuchet MS'}
sadesc_settings.text.stroke = {}
sadesc_settings.text.stroke.width = 2
sadesc_settings.text.stroke.alpha = 200
sadesc_settings.text.stroke.red = 50
sadesc_settings.text.stroke.green = 50
sadesc_settings.text.stroke.blue = 50
sadesc_settings.flags = {}
sadesc_settings.flags.italic = true
sadesc_settings.flags.bold = true
sadesc_settings.flags.draggable = false
sadesc_settings.bg = {}
sadesc_settings.bg.visible = false



pointer_settings = {}
pointer_settings.pos = {}
pointer_settings.pos.x = center_screen
pointer_settings.pos.y = 50
pointer_settings.size = {}
pointer_settings.size.width = 20
pointer_settings.size.height = 11
pointer_settings.visible = true
pointer_settings.texture = {}
pointer_settings.texture.path = pointer_path
pointer_settings.texture.fit = true
pointer_settings.draggable = false

tbg_cap_settings = {}
tbg_cap_settings.pos = {}
tbg_cap_settings.pos.x = center_screen
tbg_cap_settings.pos.y = 50
tbg_cap_settings.visible = true
tbg_cap_settings.color = {}
tbg_cap_settings.color.alpha = 255
tbg_cap_settings.color.red = 150
tbg_cap_settings.color.green = 0
tbg_cap_settings.color.blue = 0
tbg_cap_settings.size = {}
tbg_cap_settings.size.width = 1
tbg_cap_settings.size.height = targetBarHeight
tbg_cap_settings.texture = {}
tbg_cap_settings.texture.fit = true
tbg_cap_settings.repeatable = {}
tbg_cap_settings.repeatable.x = 1
tbg_cap_settings.repeatable.y = 1
tbg_cap_settings.draggable = false

tcbg_cap_settings = {}
tcbg_cap_settings.pos = {}
tcbg_cap_settings.pos.x = center_screen
tcbg_cap_settings.pos.y = 200
tcbg_cap_settings.visible = true
tcbg_cap_settings.color = {}
tcbg_cap_settings.color.alpha = 255
tcbg_cap_settings.color.red = 255
tcbg_cap_settings.color.green = 255
tcbg_cap_settings.color.blue = 255
tcbg_cap_settings.size = {}
tcbg_cap_settings.size.width = 1
tcbg_cap_settings.size.height = targetCastBarHeight
tcbg_cap_settings.texture = {}
tcbg_cap_settings.texture.fit = true
tcbg_cap_settings.repeatable = {}
tcbg_cap_settings.repeatable.x = 1
tcbg_cap_settings.repeatable.y = 1
tcbg_cap_settings.draggable = false

ttbg_cap_settings = {}
ttbg_cap_settings.pos = {}
ttbg_cap_settings.pos.x = center_screen
ttbg_cap_settings.pos.y = 50
ttbg_cap_settings.visible = true
ttbg_cap_settings.color = {}
ttbg_cap_settings.color.alpha = 255
ttbg_cap_settings.color.red = 150
ttbg_cap_settings.color.green = 0
ttbg_cap_settings.color.blue = 0
ttbg_cap_settings.size = {}
ttbg_cap_settings.size.width = 1
ttbg_cap_settings.size.height = targetBarHeight
ttbg_cap_settings.texture = {}
ttbg_cap_settings.texture.fit = true
ttbg_cap_settings.repeatable = {}
ttbg_cap_settings.repeatable.x = 1
ttbg_cap_settings.repeatable.y = 1
ttbg_cap_settings.draggable = false

stbg_cap_settings = {}
stbg_cap_settings.pos = {}
stbg_cap_settings.pos.x = center_screen
stbg_cap_settings.pos.y = 50
stbg_cap_settings.visible = true
stbg_cap_settings.color = {}
stbg_cap_settings.color.alpha = 255
stbg_cap_settings.color.red = 0
stbg_cap_settings.color.green = 51
stbg_cap_settings.color.blue = 255
stbg_cap_settings.size = {}
stbg_cap_settings.size.width = 1
stbg_cap_settings.size.height = subtargetBarHeight
stbg_cap_settings.texture = {}
stbg_cap_settings.texture.fit = true
stbg_cap_settings.repeatable = {}
stbg_cap_settings.repeatable.x = 1
stbg_cap_settings.repeatable.y = 1
stbg_cap_settings.draggable = false

tbg_body_settings = {}
tbg_body_settings.pos = {}
tbg_body_settings.pos.x = center_screen
tbg_body_settings.pos.y = 50
tbg_body_settings.visible = true
tbg_body_settings.color = {}
tbg_body_settings.color.alpha = 255
tbg_body_settings.color.red = 0
tbg_body_settings.color.green = 100
tbg_body_settings.color.blue = 166
tbg_body_settings.size = {}
tbg_body_settings.size.width = targetBarWidth
tbg_body_settings.size.height = targetBarHeight
tbg_body_settings.texture = {}
tbg_body_settings.texture.path = bg_body_path
tbg_body_settings.texture.fit = true
tbg_body_settings.repeatable = {}
tbg_body_settings.repeatable.x = 1
tbg_body_settings.repeatable.y = 1
tbg_body_settings.draggable = false


tcbg_body_settings = {}
tcbg_body_settings.pos = {}
tcbg_body_settings.pos.x = center_screen
tcbg_body_settings.pos.y = 200
tcbg_body_settings.visible = true
tcbg_body_settings.color = {}
tcbg_body_settings.color.alpha = 255
tcbg_body_settings.color.red = 0
tcbg_body_settings.color.green = 100
tcbg_body_settings.color.blue = 166
tcbg_body_settings.size = {}
tcbg_body_settings.size.width = targetCastBarWidth
tcbg_body_settings.size.height = targetCastBarHeight
tcbg_body_settings.texture = {}
tcbg_body_settings.texture.path = bg_body_path
tcbg_body_settings.texture.fit = true
tcbg_body_settings.repeatable = {}
tcbg_body_settings.repeatable.x = 1
tcbg_body_settings.repeatable.y = 1
tcbg_body_settings.draggable = false


stbg_body_settings = {}
stbg_body_settings.pos = {}
stbg_body_settings.pos.x = center_screen + 400
stbg_body_settings.pos.y = 20
stbg_body_settings.visible = true
stbg_body_settings.color = {}
stbg_body_settings.color.alpha = 255
stbg_body_settings.color.red = 0
stbg_body_settings.color.green = 51
stbg_body_settings.color.blue = 255
stbg_body_settings.size = {}
stbg_body_settings.size.width = subtargetBarWidth
stbg_body_settings.size.height = subtargetBarHeight
stbg_body_settings.texture = {}
stbg_body_settings.texture.path = bg_body_path
stbg_body_settings.texture.fit = true
stbg_body_settings.repeatable = {}
stbg_body_settings.repeatable.x = 1
stbg_body_settings.repeatable.y = 1
stbg_body_settings.draggable = false

ttbg_body_settings = {}
ttbg_body_settings.pos = {}
ttbg_body_settings.pos.x = center_screen + 400
ttbg_body_settings.pos.y = 50
ttbg_body_settings.visible = true
ttbg_body_settings.color = {}
ttbg_body_settings.color.alpha = 255
ttbg_body_settings.color.red = 0
ttbg_body_settings.color.green = 51
ttbg_body_settings.color.blue = 255
ttbg_body_settings.size = {}
ttbg_body_settings.size.width = targettargetBarWidth
ttbg_body_settings.size.height = targettargetBarHeight
ttbg_body_settings.texture = {}
ttbg_body_settings.texture.path = bg_body_path
ttbg_body_settings.texture.fit = true
ttbg_body_settings.repeatable = {}
ttbg_body_settings.repeatable.x = 1
ttbg_body_settings.repeatable.y = 1
ttbg_body_settings.draggable = false

tfgg_body_settings = {}
tfgg_body_settings.pos = {}
tfgg_body_settings.pos.x = center_screen
tfgg_body_settings.pos.y = 50
tfgg_body_settings.visible = true
tfgg_body_settings.color = {}
tfgg_body_settings.color.alpha = 200
tfgg_body_settings.color.red = 255
tfgg_body_settings.color.green = 0
tfgg_body_settings.color.blue = 0
tfgg_body_settings.size = {}
tfgg_body_settings.size.width = targetBarWidth
tfgg_body_settings.size.height = targetBarHeight
tfgg_body_settings.texture = {}
tfgg_body_settings.texture.path = fg_body_path
tfgg_body_settings.texture.fit = true
tfgg_body_settings.repeatable = {}
tfgg_body_settings.repeatable.x = 1
tfgg_body_settings.repeatable.y = 1
tfgg_body_settings.draggable = false

tcfgg_body_settings = {}
tcfgg_body_settings.pos = {}
tcfgg_body_settings.pos.x = center_screen
tcfgg_body_settings.pos.y = 50
tcfgg_body_settings.visible = true
tcfgg_body_settings.color = {}
tcfgg_body_settings.color.alpha = 200
tcfgg_body_settings.color.red = 123
tcfgg_body_settings.color.green = 189
tcfgg_body_settings.color.blue = 205
tcfgg_body_settings.size = {}
tcfgg_body_settings.size.width = targetBarWidth
tcfgg_body_settings.size.height = targetBarHeight
tcfgg_body_settings.texture = {}
tcfgg_body_settings.texture.path = fg_body_path
tcfgg_body_settings.texture.fit = true
tcfgg_body_settings.repeatable = {}
tcfgg_body_settings.repeatable.x = 1
tcfgg_body_settings.repeatable.y = 1
tcfgg_body_settings.draggable = false

tfg_body_settings = {}
tfg_body_settings.pos = {}
tfg_body_settings.pos.x = center_screen
tfg_body_settings.pos.y = 50
tfg_body_settings.visible = true
tfg_body_settings.color = {}
tfg_body_settings.color.alpha = 255
tfg_body_settings.color.red = 163
tfg_body_settings.color.green = 209
tfg_body_settings.color.blue = 245
tfg_body_settings.size = {}
tfg_body_settings.size.width = targetBarWidth
tfg_body_settings.size.height = targetBarHeight
tfg_body_settings.texture = {}
tfg_body_settings.texture.path = fg_body_path
tfg_body_settings.texture.fit = true
tfg_body_settings.repeatable = {}
tfg_body_settings.repeatable.x = 1
tfg_body_settings.repeatable.y = 1
tfg_body_settings.draggable = false


tcfg_body_settings = {}
tcfg_body_settings.pos = {}
tcfg_body_settings.pos.x = center_screen
tcfg_body_settings.pos.y = 200
tcfg_body_settings.visible = true
tcfg_body_settings.color = {}
tcfg_body_settings.color.alpha = 255
tcfg_body_settings.color.red = 163
tcfg_body_settings.color.green = 209
tcfg_body_settings.color.blue = 245
tcfg_body_settings.size = {}
tcfg_body_settings.size.width = targetBarWidth
tcfg_body_settings.size.height = targetBarHeight
tcfg_body_settings.texture = {}
tcfg_body_settings.texture.path = fg_body_path
tcfg_body_settings.texture.fit = true
tcfg_body_settings.repeatable = {}
tcfg_body_settings.repeatable.x = 1
tcfg_body_settings.repeatable.y = 1
tcfg_body_settings.draggable = false


stfg_body_settings = {}
stfg_body_settings.pos = {}
stfg_body_settings.pos.x = center_screen + 400
stfg_body_settings.pos.y = 20
stfg_body_settings.visible = true
stfg_body_settings.color = {}
stfg_body_settings.color.alpha = 255
stfg_body_settings.color.red = 0
stfg_body_settings.color.green = 102
stfg_body_settings.color.blue = 255
stfg_body_settings.size = {}
stfg_body_settings.size.width = subtargetBarWidth
stfg_body_settings.size.height = subtargetBarHeight
stfg_body_settings.texture = {}
stfg_body_settings.texture.path = fg_body_path
stfg_body_settings.texture.fit = true
stfg_body_settings.repeatable = {}
stfg_body_settings.repeatable.x = 1
stfg_body_settings.repeatable.y = 1
stfg_body_settings.draggable = false

ttfg_body_settings = {}
ttfg_body_settings.pos = {}
ttfg_body_settings.pos.x = center_screen + 400
ttfg_body_settings.pos.y = 50
ttfg_body_settings.visible = true
ttfg_body_settings.color = {}
ttfg_body_settings.color.alpha = 255
ttfg_body_settings.color.red = 0
ttfg_body_settings.color.green = 102
ttfg_body_settings.color.blue = 255
ttfg_body_settings.size = {}
ttfg_body_settings.size.width = targettargetBarWidth
ttfg_body_settings.size.height = targettargetBarHeight
ttfg_body_settings.texture = {}
ttfg_body_settings.texture.path = fg_body_path
ttfg_body_settings.texture.fit = true
ttfg_body_settings.repeatable = {}
ttfg_body_settings.repeatable.x = 1
ttfg_body_settings.repeatable.y = 1
ttfg_body_settings.draggable = false

stfgg_body_settings = {}
stfgg_body_settings.pos = {}
stfgg_body_settings.pos.x = center_screen
stfgg_body_settings.pos.y = 20
stfgg_body_settings.visible = true
stfgg_body_settings.color = {}
stfgg_body_settings.color.alpha = 255
stfgg_body_settings.color.red = 255
stfgg_body_settings.color.green = 0
stfgg_body_settings.color.blue = 0
stfgg_body_settings.size = {}
stfgg_body_settings.size.width = subtargetBarWidth
stfgg_body_settings.size.height = subtargetBarHeight
stfgg_body_settings.texture = {}
stfgg_body_settings.texture.path = fg_body_path
stfgg_body_settings.texture.fit = true
stfgg_body_settings.repeatable = {}
stfgg_body_settings.repeatable.x = 1
stfgg_body_settings.repeatable.y = 1
stfgg_body_settings.draggable = false

settings = config.load(defaults)
config.save(settings)

config.register(settings, function(settings_table)

    targetBarHeight = settings_table.targetBar.height
    targetBarWidth = settings_table.targetBar.width
	
	targetCastBarHeight = settings_table.targetcastbar.height
    targetCastBarWidth = settings_table.targetcastbar.width

    subtargetBarHeight = settings_table.subTargetBar.height
    subtargetBarWidth = settings_table.subTargetBar.width
	
    targettargetBarHeight = settings_table.targetBar.height
    targettargetBarWidth = settings_table.targetBar.width
	
    center_screen = windower.get_windower_settings().x_res / 2 - targetBarWidth / 2
    hideKey = settings_table.hideKey
	
	--target
    tbg_cap_settings.size.height = targetBarHeight
	tbg_body_settings.size.height = targetBarHeight
	tfg_body_settings.size.width = targetBarWidth
    tfg_body_settings.size.height = targetBarHeight
	tfgg_body_settings.size.width = targetBarWidth
    tfgg_body_settings.size.height = targetBarHeight
	
	--select target
    stbg_cap_settings.size.height = subtargetBarHeight
	stbg_body_settings.size.width = subtargetBarWidth
    stbg_body_settings.size.height = subtargetBarHeight
	stfg_body_settings.size.width = subtargetBarWidth
    stfg_body_settings.size.height = subtargetBarHeight
	stfgg_body_settings.size.width = subtargetBarWidth
    stfgg_body_settings.size.height = subtargetBarHeight

	--castbar
	tcbg_cap_settings.size.height = targetCastBarHeight
	tcbg_body_settings.size.width = targetCastBarWidth
    tcbg_body_settings.size.height = targetCastBarHeight
	tcfg_body_settings.size.width = targetCastBarWidth
    tcfg_body_settings.size.height = targetCastBarHeight
	tcfgg_body_settings.size.height = targetCastBarHeight
    
	--targettarget
	ttbg_cap_settings.size.height = targettargetBarHeight
    ttbg_body_settings.size.width = targettargetBarWidth
    ttbg_body_settings.size.height = targettargetBarHeight
    ttfg_body_settings.size.width = targettargetBarWidth
    ttfg_body_settings.size.height = targettargetBarHeight
	
    --Validating settings.xml values
    local nx = 0
    if settings_table.pos.x == nil or settings_table.pos.x < 0 then
        nx = center_screen
    else
        nx = settings_table.pos.x
    end
	
	---target
    tbg_cap_settings.pos.y = settings_table.pos.y
	tbg_body_settings.pos.x = nx
    tbg_body_settings.pos.y = settings_table.pos.y
	tfg_body_settings.pos.x = nx
    tfg_body_settings.pos.y = settings_table.pos.y
	tfgg_body_settings.pos.x = nx
    tfgg_body_settings.pos.y = settings_table.pos.y
	
	--target castbar
	tcbg_cap_settings.pos.y = settings_table.pos.y
	tcbg_body_settings.pos.x = nx 
    tcbg_body_settings.pos.y = settings_table.pos.y + 200
	tcfg_body_settings.pos.x = nx 
    tcfg_body_settings.pos.y = settings_table.pos.y + 200
	tcfgg_body_settings.pos.x = nx 
	tcfgg_body_settings.pos.y = settings_table.pos.y + 200
    
	--targettarget
    ttbg_cap_settings.pos.y = settings_table.pos.y
	ttbg_body_settings.pos.x = nx + targetBarWidth + 20
    ttbg_body_settings.pos.y = settings_table.pos.y
	ttfg_body_settings.pos.x = nx + targetBarWidth + 20
    ttfg_body_settings.pos.y = settings_table.pos.y
        

    pointer_settings.pos.x = nx + targetBarWidth + tbg_cap_settings.size.width
    pointer_settings.pos.y = settings_table.pos.y + (settings_table.subTargetBar.height/2) - (pointer_settings.size.height/2)

	--select target
	stbg_cap_settings.pos.y = settings_table.pos.y
    stbg_body_settings.pos.x = pointer_settings.pos.x + pointer_settings.size.width + (stbg_cap_settings.size.width)
    stfg_body_settings.pos.x = pointer_settings.pos.x + pointer_settings.size.width + (stbg_cap_settings.size.width)
    stfgg_body_settings.pos.x = pointer_settings.pos.x + pointer_settings.size.width + (stbg_cap_settings.size.width)

	
    text_settings.pos.y = settings_table.pos.y - settings_table.text.padding
    text_settings.text.font = settings_table.text.font
    text_settings.text.size = settings_table.text.size
    text_settings.flags.bold = settings_table.text.bold
    text_settings.flags.italic = settings_table.text.italic
	
	stext_settings.pos.y = settings_table.pos.y - settings_table.text.padding
    stext_settings.text.font = settings_table.text.font
    stext_settings.text.size = settings_table.text.size
    stext_settings.flags.bold = settings_table.text.bold
    stext_settings.flags.italic = settings_table.text.italic

	if settings.specialtextpos.x == 0 then
		satext_settings.pos.x = center_screen
	else
		satext_settings.pos.x = settings.specialtextpos.x
	end
	
	satext_settings.pos.y = settings_table.specialtextpos.y - settings_table.specialtext.padding
    satext_settings.text.font = settings_table.specialtext.font
    satext_settings.text.size = settings_table.specialtext.size
    satext_settings.flags.bold = settings_table.specialtext.bold
    satext_settings.flags.italic = settings_table.specialtext.italic
	
	sadesc_settings.pos.y = settings_table.specialtextpos.y - settings_table.specialtext.padding + 50
    sadesc_settings.text.font = settings_table.specialdesc.font
    sadesc_settings.text.size = settings_table.specialdesc.size
    sadesc_settings.flags.bold = settings_table.specialdesc.bold
    sadesc_settings.flags.italic = settings_table.specialdesc.italic
	
	atext_settings.pos.y = settings_table.pos.y - settings_table.abilitytext.padding + 50
    atext_settings.text.font = settings_table.abilitytext.font
    atext_settings.text.size = settings_table.abilitytext.size
    atext_settings.flags.bold = settings_table.abilitytext.bold
    atext_settings.flags.italic = settings_table.abilitytext.italic
	--btext_settings.pos.y = 0

	a_text = texts.new('${name|(Name)}', atext_settings)
	sa_text = texts.new('${name|(Name)}', satext_settings)
	sa_desc = texts.new('${desc|(Description)}', sadesc_settings)

    pointer = images.new(pointer_settings)
	
	--left
    if (settings_table.useRoundCap) then
	
      stbg_cap_settings.size.width = 2
      stbg_cap_settings.texture.path = bg_cap_l_path
	  
	  tbg_cap_settings.size.width = 2
      tbg_cap_settings.texture.path = bg_cap_l_path
	  
	  tcbg_cap_settings.size.width = 2
	  tcbg_cap_settings.texture.path = bg_cap_l_path
	  
	  ttbg_cap_settings.size.width = 2
	  ttbg_cap_settings.texture.path = bg_cap_l_path
    else
      
	  tbg_cap_settings.texture.path = bg_cap_path
	  
	  tcbg_cap_settings.texture.path = bg_cap_path
	  
	  stbg_cap_settings.texture.path = bg_cap_path
    end
	
	stbg_cap_l = images.new(stbg_cap_settings)
    tbg_cap_l = images.new(tbg_cap_settings)
	tcbg_cap_l = images.new(tcbg_cap_settings)
	ttbg_cap_l = images.new(ttbg_cap_settings)
 
	
	--rights
	if (settings_table.useRoundCap) then
	
      stbg_cap_settings.size.width = 2
      stbg_cap_settings.texture.path = bg_cap_r_path
	  
	  tbg_cap_settings.size.width = 2
	  tbg_cap_settings.texture.path = bg_cap_r_path
	  
	  tcbg_cap_settings.size.width = 2
	  tcbg_cap_settings.texture.path = bg_cap_r_path
	  
	  ttbg_cap_settings.size.width = 2
	  ttbg_cap_settings.texture.path = bg_cap_r_path
    else
      
	  tbg_cap_settings.texture.path = bg_cap_path
	  
	  tcbg_cap_settings.texture.path = bg_cap_path
	  
	  stbg_cap_settings.texture.path = bg_cap_path
	  
	  ttbg_cap_settings.texture.path = bg_cap_path
    end
	
    tbg_cap_r = images.new(tbg_cap_settings)
	tcbg_cap_r = images.new(tcbg_cap_settings)
	stbg_cap_r = images.new(stbg_cap_settings)
	ttbg_cap_r = images.new(ttbg_cap_settings)
	
    tbg_body = images.new(tbg_body_settings)

    tfgg_body = images.new(tfgg_body_settings)
    tfg_body = images.new(tfg_body_settings)
	t_text = texts.new('${name|(Name)} - HP: ${hpp|(100)}%', text_settings)
	
	tcbg_body = images.new(tcbg_body_settings)
	tcfg_body = images.new(tcfg_body_settings)
	tcfgg_body = images.new(tcfgg_body_settings)
	
    stbg_body = images.new(stbg_body_settings)
    stfgg_body = images.new(stfgg_body_settings)
    stfg_body = images.new(stfg_body_settings)
    st_text = texts.new('${name|(Name)}', stext_settings)

    ttbg_body = images.new(ttbg_body_settings)
    ttfg_body = images.new(ttfg_body_settings)
    tt_text = texts.new('  ${name|(Name)} - HP: ${hpp|(100)}% ${debug|}', text_settings)

	shift_y(0)
	
	initialized = true
end)

check_claim = function(claim_id, player_id)
    if player_id == claim_id then
        return true
    else
        for i = 1, 5, 1 do
            member = windower.ffxi.get_mob_by_target('p'..i)
            if member == nil then
                -- do nothing
            elseif member.id == claim_id then
                return true
            end
        end
    end
    return false
end

target_change = function(index)
    if index == 0 then
        visible = false
        hasTarget = false
    else
        visible = true
        hasTarget = true
	end
end

shift_y = function(quantity)

	--select target
	pointer:pos_y(settings.pos.y + (settings.subTargetBar.height/2) - (pointer_settings.size.height/2) + quantity - 40)
	stbg_cap_l:pos_y(settings.pos.y + quantity - 40)
    stbg_cap_r:pos_y(settings.pos.y + quantity - 40)
	stfgg_body:pos_y(settings.pos.y + quantity - 40)
	stfg_body:pos_y(settings.pos.y + quantity - 40)
	stbg_body:pos_y(settings.pos.y + quantity - 40)
	st_text:pos_y(settings.pos.y - settings.text.padding + quantity - 20)

	--target
    tbg_cap_l:pos_y(settings.pos.y + quantity)
    tbg_cap_r:pos_y(settings.pos.y + quantity)
    tbg_body:pos_y(settings.pos.y + quantity)
    tfg_body:pos_y(settings.pos.y + quantity)
    tfgg_body:pos_y(settings.pos.y + quantity)
	t_text:pos_y(settings.pos.y - settings.text.padding + quantity + 20)
	
	--targetcastbar
	tcbg_body:pos_y(atext_settings.pos.y + 30)
	tcfg_body:pos_y(atext_settings.pos.y + 30)
	tcfgg_body:pos_y(atext_settings.pos.y + 30)
	tcbg_cap_l:pos_y(atext_settings.pos.y + 30)
    tcbg_cap_r:pos_y(atext_settings.pos.y + 30)
    
	--targettarget
	ttbg_cap_l:pos_y(settings.pos.y + quantity)
    ttbg_cap_r:pos_y(settings.pos.y + quantity)
    ttfg_body:pos_y(settings.pos.y + quantity)
    ttbg_body:pos_y(settings.pos.y + quantity)
	tt_text:pos_y(settings.pos.y - settings.text.padding + quantity + 20)
	
    set_xPos()
end

set_xPos = function()
	--target
    tbg_cap_l:pos_x(tbg_body:pos_x() - tbg_cap_settings.size.width)
    tbg_cap_r:pos_x(tbg_body:pos_x() + targetBarWidth)
	t_text:pos_x(tfg_body:pos_x())
	
	--target castbar
	tcbg_cap_l:pos_x(tcbg_body:pos_x() - tcbg_cap_settings.size.width)
    tcbg_cap_r:pos_x(tcbg_body:pos_x() + targetCastBarWidth)
	tcbg_body:pos_x(tbg_body:pos_x())
	tcfg_body:pos_x(tfg_body:pos_x())
	tcfgg_body:pos_x(tfgg_body:pos_x())
	
	--ability 
	a_text:pos_x(tfg_body:pos_x())
	if settings.specialtextpos.x == 0 then
		sa_text:pos_x(center_screen)
	else
		sa_text:pos_x(settings.specialtextpos.x)
	end
	
	--targetarget
	ttfg_body:pos_x(tfg_body:pos_x() + targetBarWidth + 20)
    ttbg_body:pos_x(tbg_body:pos_x() + targetBarWidth + 20)
	ttbg_cap_l:pos_x(ttbg_body:pos_x() - ttbg_cap_settings.size.width)
    ttbg_cap_r:pos_x(ttbg_body:pos_x() + targettargetBarWidth)
	tt_text:pos_x(tfg_body:pos_x() + targetBarWidth + 15)	
	
	--selecttarget
	stbg_cap_l:pos_x(stbg_body:pos_x() - stbg_cap_settings.size.width)
    stbg_cap_r:pos_x(stbg_body:pos_x() + subtargetBarWidth)
	st_text:pos_x(stfg_body:pos_x())
end

windower.register_event('status change', function(new_status_id)
    if (new_status_id == 4)  and (hasTarget == true) and (is_hidden_by_key == false) and (is_hidden_by_macro == false) then
        visible = false
        is_hidden_by_cutscene = true
    elseif new_status_id ~= 4 then
        is_hidden_by_cutscene = false
    end
end)

windower.register_event('incoming chunk',function(id,org,_modi,_is_injected,_is_blocked)
    if (id == LOGIN_ZONE_PACKET) then
        is_hidden_by_zoning = false
        visible = true
    elseif (id == ZONE_OUT_PACKET) then
        is_hidden_by_zoning = true
        visible = false
    end
end)

windower.register_event('keyboard', function(dik, flags, blocked)
  if not is_hidden_by_zoning then
    if (dik == hideKey) and (flags == true) and (hasTarget == true) and (visible == true) and (is_hidden_by_cutscene == false) then
      visible = false
      is_hidden_by_key = true
    elseif (dik == hideKey) and (flags == true) and (hasTarget == true) and (visible == false) and (is_hidden_by_cutscene == false) then
      is_hidden_by_key = false
      visible = true
    end

    if (dik == settings.macroBar.ctrlKey and flags) or (dik == settings.macroBar.altKey and flags) then
        if (settings.macroBar.hide.enabled) then
            visible = false
            is_hidden_by_macro = true
        elseif (settings.macroBar.move.enabled) then
            shift_y(settings.macroBar.move.height)
        end
    elseif (dik == settings.macroBar.ctrlKey and flags == false) or (dik == settings.macroBar.altKey and flags == false) then
        if (settings.macroBar.hide.enabled and is_hidden_by_key == false) then
            visible = true
            is_hidden_by_macro = false
        elseif (settings.macroBar.move.enabled) then
            shift_y(0)
        end
    end
  end
end)
