
local language = GetConVarString("the_stanley_parable_job_language")
local menu
local text
local confirmation
local made_by_text
local congratulation
local answer_false 


--THE TABLE WITH THE LETTERS--
local letter = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
------------------------------

------------------VGUI-------------
if CLIENT then
net.Receive("stanley_parable_job_vgui", function(_len)
if not LocalPlayer() then return end
local ply = LocalPlayer()

local letter_asked = net.ReadString()

----------TRADUCTION-------------
if language == "FR" then 
	menu = "Le travail de Stanley."
	text = "Entrez la lettre '"..letter_asked.."'"
	confirmation = "Confirmation"
	made_by_text = "Créé par John Oakman"
	congratulation = "Bravo!"
		if GetConVarNumber("the_stanley_parable_job_death") == 1 then
			answer_false = "Faux ! Réesayez correctement ou mourrez !"
		else 
			answer_false = "Faux! Réessayez !"
		end

elseif language == "ENG" then 
	menu = "The Stanley's job"
	text = "Enter the letter '"..letter_asked.."'"
	confirmation = "Confirmation"
	made_by_text = "Made by John Oakman"
	congratulation = "Congratulation!"
		if GetConVarNumber("the_stanley_parable_job_death") == 1 then
			answer_false = "False ! Try again or die !"
		else 
			answer_false = "False ! Try again !"
		end

else
	menu = ""
	text = ""
	confirmation = ""
	made_by_text = ""
	congratulation = ""
	answer_false = ""

end
--------------------------------
local couleur_texte = Color(255,255,255,255)

			local fenetre_principal = vgui.Create( "DFrame" );
		fenetre_principal:SetSize( 250, 120 );
		fenetre_principal:Center( );
		fenetre_principal:SetTitle(menu)
		fenetre_principal:MakePopup();
		
				local made_by = vgui.Create( "DLabel", fenetre_principal)
		made_by:SetSize(1000, 20)
		made_by:SetPos(10 ,100)
		made_by:SetColor(couleur_texte)
		made_by:SetText(made_by_text)	
		
			local text_vgui = vgui.Create( "DLabel", fenetre_principal)
		text_vgui:SetSize(1000, 20)
		text_vgui:SetPos(75 ,30)
		text_vgui:SetColor(couleur_texte)
		text_vgui:SetText(text)	
		
			local lettre_entrer = vgui.Create( "DTextEntry", fenetre_principal )
		lettre_entrer:SetPos( 10, 50 )
		lettre_entrer:SetSize( 230, 25 )
		lettre_entrer:SetText("")
		
		 local bouton_exit = vgui.Create( "DButton", fenetre_principal )
		bouton_exit:SetPos( 10, 80 )
		bouton_exit:SetText( confirmation )
		bouton_exit:SetSize( 230, 20 )
		bouton_exit.DoClick = function()
		----------------------------------
		 if lettre_entrer:GetValue() == letter_asked then fenetre_principal:Remove() 
			ply:ConCommand("the_stanley_parable_job") 
			ply:ConCommand("play garrysmod/save_load1.wav") 
				if GetConVarNumber("the_stanley_parable_job_health") == 1 then 
					net.Start("stanley_parable_add_health")
					net.SendToServer()
				end
			notification.AddLegacy( congratulation, NOTIFY_GENERIC, 5 )
					else notification.AddLegacy(answer_false, NOTIFY_ERROR, 5)
						ply:ConCommand("play ambient/alarms/klaxon1.wav")
				
					if GetConVarNumber("the_stanley_parable_job_death") == 1 then
						net.Start("stanley_parable_job_avertissement")
							
						net.SendToServer()
					else end
				
					end
 		end
		------------------------------------

	
end)
end


----MAIN FUNCTION----
if SERVER then 
	 

util.AddNetworkString("stanley_parable_job_vgui")
util.AddNetworkString("stanley_parable_job_avertissement")
util.AddNetworkString("stanley_parable_add_health")
------------------AVERTISSEMENT---------------------
net.Receive("stanley_parable_job_avertissement", function(_len, ply)
	if ply:GetNWInt("stanley_parable_avertissement") == 3 then ply:Kill() ply:SetNWInt("stanley_parable_avertissement", 0) return end
 
			if ply:GetNWInt("stanley_parable_avertissement") >= 1 then 
				ply:SetNWInt("stanley_parable_avertissement", (ply:GetNWInt("stanley_parable_avertissement")+1)) 
			else ply:SetNWInt("stanley_parable_avertissement", 1) end

			if ply:GetNWInt("stanley_parable_avertissement") == 3 then ply:Kill() ply:SetNWInt("stanley_parable_avertissement", 0) return end
		
end)
-----------------------------------------------------
net.Receive("stanley_parable_add_health", function(_len,ply)
	ply:SetHealth(ply:Health()+GetConVarNumber("the_stanley_parable_job_health_get"))
end)

	function the_stanley_parable_job(ply)	
			local random = math.random(1,26)
			local letter_asked
	
		for k,v in ipairs(letter) do
			if random == k then letter_asked = v end
		end
		
	net.Start("stanley_parable_job_vgui")
		net.WriteString(letter_asked)
	net.Send(ply)
	
		
	end

end

local configcvar = {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}
concommand.Add("the_stanley_parable_job", the_stanley_parable_job)
CreateConVar("the_stanley_parable_job_health", 1, configcvar, "When you enter the good letter, you win 1HP (0/1).")
CreateConVar("the_stanley_parable_job_language", "ENG", configcvar , "Change the language of 'The Stanley Parable Job' addon (ENG, FR) (You will need to reboot).")
CreateConVar("the_stanley_parable_job_death", 1, configcvar, "Kill the guy when he fail 3 times (0/1).")
CreateConVar("the_stanley_parable_job_health_get", 1, configcvar, "Change the Health you get when you win.")