local hideHUDElements = {

	["DarkRP_HUD"] = false,
	["DarkRP_EntityDisplay"] = false,
	["DarkRP_ZombieInfo"] = false,
	["DarkRP_LocalPlayerHUD"] = true,
	["DarkRP_Agenda"] = true,
	["CHudHealth"] = true,
	["CHudBattery"] = true
}

hook.Add("HUDShouldDraw", "HideDefaultHuds", function(name)
	if hideHUDElements[name] then return false
	end
end)


surface.CreateFont( "UniversalFont", {
	font = "HudHintTextLarge",
	size = 17,
	weight = 500,
	antialias = true
} )

surface.CreateFont( "NameSmall", {
	font = "HudHintTextLarge",
	size = 14,
	weight = 500,
	antialias = true
} )

surface.CreateFont( "JobSmall", {
	font = "HudHintTextLarge",
	size = 14,
	weight = 500,
	antialias = true
} )


surface.CreateFont( "MoneyRegular", {
	font = "HudHintTextLarge",
	size = 30,
	weight = 500,
	antialias = true
} )

surface.CreateFont( "SalaryRegular", {
	font = "HudHintTextLarge",
	size = 25,
	weight = 400,
	antialias = true
} )

surface.CreateFont( "SmallFontForHealthNumber", {
	font = "HudHintTextLarge",
	size = 15,
	weight = 400,
	antialias = true
} )



local function formatNumber(n)

	if not n then return "" end
	if n >= 1e14 then return tostring(n) end
	n = tostring(n)
	local sep = sep or ","
	local dp = string.find(n, "%.") or #n+1
	for i=dp-4, 1, -3 do
		n = n:sub(1, i) .. sep .. n:sub(i+1)
	end
	return n
end



local function DisplayNotify(msg)
    local txt = msg:ReadString()
    GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
    surface.PlaySound("buttons/lightswitch2.wav")

    MsgC(Color(255, 20, 20, 255), "[DarkRP] ", Color(200, 200, 200, 255), txt, "\n")
end
usermessage.Hook("_Notify", DisplayNotify)

if icon then icon:Remove() end


local modelIcon = {}

AccessorFunc( modelIcon, "m_fAnimSpeed",	"AnimSpeed" )
AccessorFunc( modelIcon, "Entity",			"Entity" )
AccessorFunc( modelIcon, "vCamPos",			"CamPos" )
AccessorFunc( modelIcon, "fFOV",			"FOV" )
AccessorFunc(modelIcon, "vLookatPos",		"LookAt" )
AccessorFunc( modelIcon, "aLookAngle",		"LookAng" )
AccessorFunc( modelIcon, "colAmbientLight",	"AmbientLight" )
AccessorFunc( modelIcon, "colColor",		"Color" )
AccessorFunc( modelIcon, "bAnimated",		"Animated" )

modelIcon.Entity = nil
modelIcon.DirectionalLight = {}
modelIcon.DirectionalLight = {}
modelIcon.FarZ = 4096

modelIcon:SetCamPos( Vector( 50, 50, 50 ) )
modelIcon:SetLookAt( Vector( 0, 0, 40 ) )
modelIcon:SetFOV( 70 )

modelIcon:SetAnimSpeed( 0.5 )
modelIcon:SetAnimated( false )

modelIcon:SetAmbientLight( Color( 50, 50, 50 ) )

modelIcon.DirectionalLight[ BOX_TOP ] = Color( 255, 255, 255 )
modelIcon.DirectionalLight[ BOX_FRONT ] =Color(255,255,255)

modelIcon:SetColor( Color( 255, 255, 255, 255 ) )

function modelIcon:SetModel(modelstr)

	if ( IsValid( modelIcon.Entity ) ) then
		modelIcon.Entity:Remove()
		modelIcon.Entity = nil
	end

	modelIcon.Entity = ClientsideModel( modelstr, RENDER_GROUP_OPAQUE_ENTITY )
	if ( !IsValid( modelIcon.Entity ) ) then return end

	modelIcon.Entity:SetNoDraw( true )

	local iSeq = modelIcon.Entity:LookupSequence( "walk_all" )
	if ( iSeq <= 0 ) then iSeq = modelIcon.Entity:LookupSequence( "WalkUnarmed_all" ) end
	if ( iSeq <= 0 ) then iSeq = modelIcon.Entity:LookupSequence( "walk_all_moderate" ) end

	if ( iSeq > 0 ) then modelIcon.Entity:ResetSequence( iSeq ) end
end


local function HUD()

	//  draw.RoundedBox(cornerRadius, x, ScrH() - y, w, h, Color())
	// 	surface.DrawvLine( x, y, endX, endY )

	// Main Box's 
	draw.RoundedBox( 0, 9, ScrH() - 143, 392, 134, Color( 0, 0, 0, 255 )) -- Main Border
	draw.RoundedBox( 0, 50, ScrH() - 142, 195, 80, Color( 38, 38, 38, 255 )) -- Middle Bar 
	draw.RoundedBox( 0, 10, ScrH() - 60, 390, 50, Color( 38, 38, 38, 255 )) -- Bottom Bar
	draw.RoundedBox( 0, 10, ScrH() - 142, 40, 80, Color( 54, 54, 54, 255 )) -- Top Left Bar
	draw.RoundedBox( 0, 400 - 156, ScrH() - 142, 156, 80, Color( 54, 54, 54, 255 )) -- Top Right Bar

	// Divider Between + and ! - There's two to emphasis the seperation 
	surface.SetDrawColor( 0, 0, 0, 255 ) 
	surface.DrawLine( 10, ScrH() - 102, 50, ScrH() - 102 )
	--surface.SetDrawColor( 61, 61, 61, 255 ) 
	--surface.DrawLine( 10, ScrH() - 101, 50, ScrH() - 101 )
	
	// Divider Between Bottom Bar and the top section 
	surface.SetDrawColor( 4, 4, 4, 255 ) 
	surface.DrawLine( 10, ScrH() - 62, 400, ScrH() - 62 )
	surface.SetDrawColor( 61, 61, 61, 255 ) -- 'Shadow'
	surface.DrawLine( 10, ScrH() - 61, 399, ScrH() - 61 )

	// Line on the Top to create a 'shadow' like appearance 
	surface.SetDrawColor( 84, 84, 84, 255 ) -- Top
	surface.DrawLine( 10, ScrH() - 142, 400, ScrH() - 142 )

	// Divider Between Middle Bar & Right Bar
	surface.SetDrawColor( 24, 24, 24, 255 ) -- Top
	surface.DrawLine( 400 - 156, ScrH() - 142, 400 - 156, ScrH() - 62 )
	
	// Divider Between +/! and Right Bar
	surface.SetDrawColor( 24, 24, 24, 255 ) -- Right of + and !
	surface.DrawLine( 50, ScrH() - 142, 50, ScrH() - 62 )

	
	

	--// Player Name  \\--

	surface.SetFont( "UniversalFont" ) -- Using this so we can use surface.GetTextureSize()

	local namefont

	// What we use to get the players name to draw on the HUD - We have to use LocalPlayer() instead of ply because this is not serverside
	local name = LocalPlayer():Name()

	// We use l, w because surface.GetTextSize() returns length and width. We're using this to scale the name better
	local l, w = surface.GetTextSize(name) 

	// The bit of code below is being used to we can scale the text/make it smaller until we can't do so anymore and have to .. the rest
	if l < 129 then
		namefont  = "UniversalFont"
		else
		namefont  = "NameSmall"
	end

	surface.SetFont( "NameSmall" )

	if 
	   namefont  == "NameSmall" and l <= 193 then
	   name = string.sub( LocalPlayer():Name(), 1, 16 )..".."
	--elseif
	  -- namefont  == "NameUniversal" and l <=193 then
	  -- name = string.sub( LocalPlayer():Name(), 1, 16 )..".."



	end



	
	draw.SimpleText(name, namefont, 130, ScrH() - 136, Color( 255, 255, 255, 255 ) )


 --// Job \\--

	local job = team.GetName(LocalPlayer():Team())
	local jobfont
	local le, wi = surface.GetTextSize(job)


	if le < 122 then 

		jobfont = "UniversalFont"

		else 

		jobfont = "JobSmall"

	end

	if jobfont  == "JobSmall" and l < 190 then
	   job = string.sub( team.GetName(LocalPlayer():Team()), 1, 17 )..".."
	end
	

	local teamcolor = team.GetColor(LocalPlayer():Team()) 
	draw.SimpleText(job, jobfont, 130, ScrH() - 113, teamcolor )
	--draw.SimpleText("Job: ", jobfont, 130, ScrH() - 113, Color(255,255,255,255) )
	--draw.SimpleText("Job: "..job, jobfont, 133, ScrH() - 113, Color( 255, 255, 255, 255 ) )

	--// Level \\--

	local leveltext = LocalPlayer():getDarkRPVar("level") 

	draw.SimpleText( leveltext, "UniversalFont", 168, ScrH() - 88, Color( 41, 98, 255,255 ) )
	

	draw.SimpleText( "Level: ", "UniversalFont", 130, ScrH() - 88, Color( 255, 255, 255, 255 ) )


	--// Money \\--

	surface.SetFont( "UniversalFont" )

	local moneyfont
	local money = formatNumber(LocalPlayer():getDarkRPVar("money"))
	local len, wid = surface.GetTextSize(money)
	
	moneyfont = "MoneyRegular"
	
	draw.SimpleText( "$".. money, moneyfont, 320, ScrH() - 135, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	
	--// Salary \\--


	draw.SimpleText( "Salary: $"..formatNumber(LocalPlayer():getDarkRPVar( "salary" )), "SalaryRegular", 320, ScrH() - 100, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )


	--// Health \\ --

	local health = LocalPlayer():Health()

	draw.RoundedBox(0, 20 + 60, ScrH() - 54, 302, 16, Color(0,0,0,200)) -- Box below armor
	
	if health > 0 then

	draw.RoundedBox(0, 21 + 60, ScrH() - 53, health * 3, 14, Color(255,20,0,220)) -- armor box

	end

	draw.SimpleText(health, "SmallFontForHealthNumber", 80 + 302 / 2, ScrH() - 54, Color(255,255,255,200), TEXT_ALIGN_CENTER)


	--// Armor \\ -- 


	local armor = LocalPlayer():Armor()

	draw.RoundedBox(0, 20 + 60, ScrH() - 34, 302, 16, Color(0,0,0,200)) -- Box below armor
	
	if armor > 0 then

		draw.RoundedBox(0, 21 + 60, ScrH() - 33, armor * 3, 14, Color(40,40,255,255)) -- armor box
	end

	draw.SimpleText(armor, "SmallFontForHealthNumber", 80 + 302 / 2, ScrH() - 33, Color(255,255,255,200), TEXT_ALIGN_CENTER)

	

	draw.SimpleText("Health:", "UniversalFont", 20, ScrH() - 54, Color(255,255,255,255), TEXT_ALIGN_LEFT)
	draw.SimpleText("Armor:", "UniversalFont", 20, ScrH() - 36, Color(255,255,255,255), TEXT_ALIGN_LEFT)
	

	// + and ! \\

	if LocalPlayer():Health() > 50 then

		surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
		surface.SetMaterial( Material( "materials/hud/heart.png" )  ) 
		surface.DrawTexturedRect( 14, ScrH() - 93, 30, 25 )	

		else

		surface.SetDrawColor( Color( math.sin( CurTime() * 2 ) * 255, 0, 0 ) )
		surface.SetMaterial( Material( "materials/hud/heart.png" )  ) 
		surface.DrawTexturedRect( 14, ScrH() - 93, 30, 25 )		

	end

		surface.SetDrawColor( Color(40,40,40,255)  )
		surface.SetMaterial( Material( "materials/hud/wanted.png" )  ) 
		surface.DrawTexturedRect( 13, ScrH() - 135, 35, 30 )

	if LocalPlayer():isWanted() then

		surface.SetDrawColor( Color( math.sin( CurTime() * 2 ) * 255, 0, 0 ) )
		surface.SetMaterial( Material( "materials/hud/wanted.png" )  ) 
		surface.DrawTexturedRect( 13, ScrH() - 135, 35, 30 )

		return
				

	end

// Model on HUD \\

	modelIcon:SetModel(LocalPlayer():GetModel())


	local ent = modelIcon:GetEntity()
	if ent then local headPos = pcall(function () ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Head1")) end)

		ent:SetEyeTarget(Vector(20, 00, 65)) 
		modelIcon:SetCamPos(Vector(20, 00, 65))
		if headPos then
			modelIcon:SetLookAt(ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Head1")))
		else
			modelIcon:SetCamPos(Vector(30, 10, 75))
		end
	end


	if ( !IsValid( modelIcon.Entity ) ) then return end

	local x, y = 45,ScrH() - 152

	local ang = modelIcon.aLookAngle
	if ( !ang ) then
		ang = (modelIcon.vLookatPos-modelIcon.vCamPos):Angle()
	end

	local w, h = 90, 90
	cam.Start3D( modelIcon.vCamPos, ang, modelIcon.fFOV, x, y, w, h, 5, modelIcon.FarZ )
	cam.IgnoreZ( true )

	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( modelIcon.Entity:GetPos() )
	render.ResetModelLighting( modelIcon.colAmbientLight.r/255, modelIcon.colAmbientLight.g/255, modelIcon.colAmbientLight.b/255 )
	render.SetColorModulation( modelIcon.colColor.r/255, modelIcon.colColor.g/255, modelIcon.colColor.b/255 )
	render.SetBlend( modelIcon.colColor.a/255 )

	for i=0, 6 do
		local col = modelIcon.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
		end
	end

	local rightx = 90
	local leftx = 0
	local topy = 0
	local bottomy = 90
	local x, y = 45, ScrH() - 152
	topy = math.Max( y, topy + y )
	leftx = math.Max( x, leftx + x )
	bottomy = math.Min( y + 90, bottomy + y )
	rightx = math.Min( x + 90, rightx + x )

		--render.SetScissorRect( leftx, topy, rightx, bottomy, true )
		modelIcon.Entity:DrawModel()
		render.SetScissorRect( 0, 0, 0, 0, false )

		render.SuppressEngineLighting( false )
		cam.IgnoreZ( false )
		cam.End3D()

end

hook.Add("HUDPaint", "PaintOurAuroraHUD", HUD)			


--[[ ALL MY FUCKING TEST CODE FUCK FUCK FUCK FUCK FUCK FUCK FUCK FUCK 
local HUDPlyIcon = false
local b_CameraIsOut = false
local function HUD_PlayerIcon() -- or a timer or something
	if( !HUDPlyIcon || !HUDPlyIcon:IsValid() ) then
		local mdl = vgui.Create( "DModelPanel" )
		mdl:ParentToHUD()
		mdl:SetPos( 53, ScrH() - 140 )
		mdl:SetSize(78, 78)
		mdl:SetModel( LocalPlayer():GetModel() )
		local eyepos = mdl.Entity:GetBonePosition( mdl.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
        mdl:SetCamPos( eyepos - Vector( -13, 0, 0 ) )
        mdl:SetLookAt(eyepos)
		

		local ent = mdl:GetEntity()
		local seq = ent:LookupSequence("idle_all_01")
		if( seq == -1 ) then
			seq = ent:LookupSequence( "idle01" )
		end
		if( seq != -1 ) then
			mdl:SetAnimated( true )
			ent:SetSequence( seq )
		end

		HUDPlyIcon = mdl

	end

	if( b_CameraIsOut ) then -- Camera Out
	HUDPlyIcon:SetVisible( false )
	else
		HUDPlyIcon:SetVisible( true )
	end
end

-- function mdl:LayoutEntity( Entity )  end

hook.Add("HUDPaint", "HUD_PlayerIcon", HUD_PlayerIcon)

hook.Add("OnPlayerChangedTeam", "ChangeHUDModel", function(ply)
        timer.Simple(0.2,function() if(!IsValid( ply ) || !HUDPlyIcon || !HUDPlyIcon:IsValid() ) then return end
                mdl:SetModel(ply:GetModel())
        end )
end)


local function DrawModelIcons()
	
		PlayerIcon = vgui.Create("SpawnIcon")
		PlayerIcon:ParentToHUD()
		PlayerIcon:SetPos( 55, ScrH() - 140 )
		PlayerIcon:SetSize(78, 78)
		PlayerIcon:SetToolTip("")
		PlayerIcon:SetModel(LocalPlayer():GetModel())
	
end
hook.Add("HUDPaint", "DrawModelIcons", DrawModelIcons)
]]

--[[

--concommand.Add("testpanel", function()

	timer.Simple(5, function() 
		local pnl = vgui.Create("DModelPanel")
		pnl:ParentToHUD()
		pnl:SetSize(80,80)
		pnl:SetPos(35, ScrH() - 170)
		pnl:SetModel(LocalPlayer():GetModel())
	    pnl:SetCamPos( Vector( 14, 0, 65))
	    pnl:SetLookAt( Vector( 0, 0, 66.5 ) )
		function pnl:LayoutEntity( Entity ) return end
		hook.Add("OnPlayerChangedTeam", "ChangeHUDModel", function(ply)
			pnl:SetModel(ply:GetModel())
		end)
	end)
--end)


local HUDPlyIcon
local b_CameraIsOut = false
local function HUD_PlayerIcon() -- or a timer or something
        if( !HUDPlyIcon || !HUDPlyIcon:IsValid() ) then
                local mdl = vgui.Create( "DModelPanel" )
                mdl:ParentToHUD()
                mdl:SetPos( 55, ScrH() - 140 )
                mdl:SetCamPos(Vector(14, 0, 65))
                mdl:SetLookAt(Vector(0, 0, 66.5))
                mdl:SetSize(78, 78)
                mdl:SetModel( LocalPlayer():GetModel() )
                mdl:SetAnimated( true )
                local ent = mdl:GetEntity()
                local seq = ent:LookupSequence("idle01") ------- WIP 
                ent:SetSequence( seq )
 
                HUDPlyIcon = mdl
        end
 
        if( b_CameraIsOut ) then -- Camera Out
                HUDPlyIcon:SetVisible( false )
        else
                HUDPlyIcon:SetVisible( true )
        end
end
hook.Add("HUDPaint", "HUD_PlayerIcon", HUD_PlayerIcon)
 
hook.Add("OnPlayerChangedTeam", "ChangeHUDModel", function(ply)
        timer.Simple(2,function() if(!IsValid( ply ) || !HUDPlyIcon || !HUDPlyIcon:IsValid() ) then return end
                HUDPlyIcon:SetModel(ply:GetModel())
        end )
end)
]]


			


