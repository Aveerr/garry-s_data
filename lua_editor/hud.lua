--[[--------------------------------
        HUD: Made by Aver
--------------------------------]]--

--[[ All? gradient material
gui/center_gradient
gui/gradient
gui/gradient_down
gui/gradient_up
vgui/gradh
vgui/gradhr
vgui/gradient-d
vgui/gradient-l
vgui/gradient-r
vgui/gradient-u
vgui/gradient_down
vgui/gradient_up
vgui/gradv
vgui/gradvr
]]--

--[[------------------------------
    HUD: settings
------------------------------]]--
local Set = {
	['x'] = ScrW()*0.20,
	['y'] = ScrH()*0.90,
	['HBW'] = 270, --[ HealthBarWidth
	['HBH'] = 25, --[ HealthBarHeight
	['HBX'] = 0, 
	['HBY'] = 0,
	['ABW'] = 270, --[ ArmorBarWidth
	['ABH'] = 10, --[ ArmorBarHeight
	['ABX'] = 0,
	['ABY'] = 30
}

local GradCol = {
	['center'] = Color(0,0,0,255),
	['right'] = Color(241, 39, 17,255),
	['left'] = Color(245, 175, 25,255)
}

local GradColLesAlph = {
	['center'] = Color(0,0,0,20),
	['right'] = Color(241, 39, 17,20),
	['left'] = Color(245, 175, 25,20)
}

local ArmGradCol = {
	['center'] = Color(0,0,0,255),
	['right'] = Color(55, 59, 68,255),
	['left'] = Color(66, 134, 244,255)
}

local AGColLesAlp = {
	['center'] = Color(0,0,0,20),
	['right'] = Color(55, 59, 68,20),
	['left'] = Color(66, 134, 244,20)
}

local hide = { 
	["CHudHealth"] = true,
	["CHudBattery"] = true
}

surface.CreateFont( "TheDefaultSettings", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if (hide[name]) then
		return false --[Hide standart HUD health and battery
	end
end )

local function colorSplit(color) --[bruh color
	return color.r,color.g,color.b,color.a;
end


--[[------------------------------
    Function: PlayerModel
------------------------------]]--
local function PlayerModel()
    --> Variables
    local camPos = Vector(14,0,62)
    local LookAT = Vector(0,0,62)
    local gradX = ScrW()*0.20 + (LocalPlayer():GetVelocity().x)/10
	local gradY = ScrH()*0.90 + (LocalPlayer():GetVelocity().z)/10

    --> Create Model
    local HudModel = vgui.Create('DModelPanel')
    function HudModel:LayoutEntity(Entity) return end
    HudModel:SetModel(LocalPlayer():GetModel())
    HudModel:SetPos(gradX-250,gradY-40)
    HudModel:SetSize(80,80)
    HudModel:SetCamPos(camPos)
    HudModel:SetLookAt(LookAT)

    concommand.Add( "killModel", function() --[Remove model from HUD
        HudModel:Remove()
        print( "model R.I.P" )
    end )
end

--[[------------------------------
    Function: PlayerModelHUD
------------------------------]]--
local function PlayerModelHUD(centerColor, rightColor, leftColor)
    --> Variables
    local gradW = 70
	local gradH = 2
	local gradX = Set.x-210 - gradW/2  
	local gradY = Set.y+41 - gradH/2 

    --> Create Model
    surface.SetDrawColor(colorSplit(centerColor) ) --[ center gradient
    surface.DrawRect( gradX, gradY, gradW, gradH )
    
    surface.SetDrawColor(colorSplit(rightColor))
    surface.SetMaterial(Material('vgui/gradient-r')) --[ gradient from right to left
    surface.DrawTexturedRect( gradX, gradY, gradW, gradH )
    
    surface.SetDrawColor(colorSplit(leftColor))
    surface.SetMaterial(Material('vgui/gradient-l')) --[ from left to right
    surface.DrawTexturedRect( gradX, gradY, gradW, gradH )
    
    draw.DrawText( LocalPlayer():GetName(), "TheDefaultSettings", gradX+35, gradY, color_white, TEXT_ALIGN_CENTER )
end


--[[------------------------------
    Function: Triangle
------------------------------]]--
local function Triangle()
	local triangle = {
		{ x = Set.x+110, y =  Set.y-80 },
		{ x = Set.x+10, y = Set.y+80 },
		{ x = Set.x+50, y = -Set.y+1600 }
	}
	surface.SetDrawColor( 255, 0, 0, 255 )
	surface.SetMaterial(Material("models/wireframe"))
	surface.DrawPoly( triangle )
end


--[[------------------------------
    Function: GradientPanel
------------------------------]]--
local function GradientPanel(gradX, gradY, gradW, gradH ,centerColor, rightColor, leftColor)
	surface.SetDrawColor(colorSplit(centerColor) ) --[ center gradient
    surface.DrawRect( gradX, gradY, gradW, gradH )
    
    surface.SetDrawColor(colorSplit(rightColor))
    surface.SetMaterial(Material('vgui/gradient-r')) --[ gradient from right to left
    surface.DrawTexturedRect( gradX, gradY, gradW, gradH )
    
    surface.SetDrawColor(colorSplit(leftColor))
    surface.SetMaterial(Material('vgui/gradient-l')) --[ from left to right
    surface.DrawTexturedRect( gradX, gradY, gradW, gradH )
end


--[[------------------------------
    Function: HealthBarBorder
------------------------------]]--
local function HealthBarBorder(x, y, w, h, color, thickness)
	local thick = thickness*2
    surface.SetDrawColor(color)
    surface.DrawOutlinedRect( x-thick/2, y-thick/2, w+thick, h+thick,thickness )
end


--[[------------------------------
    Function: HealthBar
------------------------------]]--
local function HealthBar()
    --> Variables
    local LPMaxHealth = LocalPlayer():GetMaxHealth()
    local LPHealth = LocalPlayer():Health()  
    local gradW = (Set.HBW/LPMaxHealth)*LPHealth
	local gradH = Set.HBH
	local gradX = Set.x - gradW/2 + Set.HBX
	local gradY = Set.y - gradH/2 + Set.HBY

    --> Create
    HealthBarBorder(gradX, gradY, gradW, gradH, GradCol.left, 0)
    HealthBarBorder(Set.x - Set.HBW/2 + Set.HBX, Set.y - gradH/2 + Set.HBY, Set.HBW, gradH, Color(255,255,255,100), 1)

	GradientPanel(gradX, gradY, gradW, gradH,GradCol.center,GradCol.right,GradCol.left)
	GradientPanel(Set.x - Set.HBW/2 + Set.HBX, Set.y - gradH/2 + Set.HBY, Set.HBW, gradH,GradColLesAlph.center,GradColLesAlph.right,GradColLesAlph.left)

	PlayerModelHUD(GradCol.center,GradCol.right,GradCol.left)
end


--[[------------------------------
    Function: HealthBar
------------------------------]]--
local function ArmorBar()
    --> Variables
	local MaxArmor = LocalPlayer():GetMaxArmor()
	local Armor = LocalPlayer():Armor()
	local gradW = (Set.ABW/MaxArmor)*Armor
	local gradH = Set.ABH
	local gradX = Set.x - gradW/2 + Set.ABX - MaxArmor
	local gradY = Set.y - gradH/2 + Set.ABY
	
    --> Create
    
	GradientPanel(gradX, gradY, gradW, gradH,ArmGradCol.center,ArmGradCol.right,ArmGradCol.left)
	GradientPanel(Set.x-Set.ABW/2+Set.ABX, gradY, Set.ABW, Set.ABH,AGColLesAlp.center,AGColLesAlp.right,AGColLesAlp.left)
end

local function MainHud()
    HealthBar()
    ArmorBar()
    --Triangle()
end
PlayerModel()

--[[------------------------------
    cmd: KillHUD
------------------------------]]--
concommand.Add( "killHUD", function()
    hook.Remove("HUDPaint", "mainHUD")
    hook.Remove('InitPostEntity','PlayerModel')
    print( "hud R.I.P" )
end )


hook.Add( "HUDPaint", "mainHUD", MainHud)
