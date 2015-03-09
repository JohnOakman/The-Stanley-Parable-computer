AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "The Stanley Computer"
ENT.Author = "John Oakman"
ENT.Contact = "John Oakman"
ENT.Purpose	= "Do the job of Stanley, like in The Stanley Parable."
ENT.Instructions	= "Press E and enter the good letter."
ENT.Category = "The Stanley Parable"
ENT.Spawnable = true
ENT.AdminSpawnable = false

local delay = 0
if SERVER then
	function ENT:Initialize()
	 
		self:SetModel( "models/props_lab/monitor01a.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
	 
			local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
	end

function ENT:Use(activator)
if not activator:IsPlayer() then return end
if delay == 1 then return end
	activator:ConCommand("the_stanley_parable_job")
	activator:ConCommand("play ambient/machines/keyboard_fast"..math.random(1,3).."_1second.wav")
	delay = 1
timer.Simple(2, function() delay = 0 end)
end

	function ENT:Think()
	end

end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		
			local Pos = self:GetPos()
			local Ang = self:GetAngles()
			local text
		if GetConVarString("the_stanley_parable_job_language") == "FR" then
			 text = "Ordinateur de Stanley"
		elseif GetConVarString("the_stanley_parable_job_language") == "ENG" then
			 text = "Stanley's Computer"
		else 
			text = ""
		end

			local width = surface.GetTextSize("Stanley")
			local TextAng = Ang
			----ROTATE THE TEXT----
			TextAng:RotateAroundAxis(TextAng:Up(), CurTime() * 180)
			---------
			
			cam.Start3D2D(Pos + Ang:Up() * 13, Ang +Angle(0,90,90), 0.3)
		draw.WordBox(2, -width, -30, text, "Default", Color(40, 0, 0, 100), Color(255,255,255,255))
			cam.End3D2D()
			
	end
	
end


