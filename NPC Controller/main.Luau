--1. rules: it is forbidden to change the credit name, this script was created by @im_patrick you will be charged dcma for changing the credit
--2. rules: changing the code using AI and claiming it as your own is not allowed

-- Prevent multiple instances and cleanup old ones
if _G.patricknpcpanel then 
    warn("Script already running! Cleaning up old instance...")
    if _G.oldgui then
        _G.oldgui:Destroy()
    end
    if _G.oldconnections then
        for _, connection in pairs(_G.oldconnections) do
            if connection then
                connection:Disconnect()
            end
        end
    end
end

_G.patricknpcpanel = true
_G.oldconnections = {}

local github = "https://github.com/Git-art-byte/NPC-Controller-v2/tree/main/NPC%20Controller"
local load = loadstring(game:HttpGet(github .. "/module.Luau"))()

saved = loadstring(game:HttpGet(github .. "/table.luau"))()

local save = saved or {}

local g2l = load.G2L
local new = load.create()

-- Store GUI reference for cleanup
_G.oldgui = g2l

local lighting = game:GetService("Lighting")
local tweenservice = game:GetService("TweenService")
local rs = game:GetService("RunService")
local ws = game:GetService("Workspace")
local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local mouse = lp:GetMouse()

local fast = TweenInfo.new(.5, Enum.EasingStyle.Exponential)
local medium = TweenInfo.new(.67)
local slow = TweenInfo.new(.8)

local rad = 150
local currentnpc

local highlight = Instance.new("Highlight")
highlight.Parent = lp
highlight.FillTransparency = 1
highlight.OutlineTransparency = 1

local light = function(adornee, color)
	task.spawn(function()
		highlight.Adornee = adornee
		highlight.OutlineColor = color
		tweenservice:Create(highlight, medium, {OutlineTransparency  = 0}):Play()
		task.wait(.5)
		tweenservice:Create(highlight, medium, {OutlineTransparency  = 1}):Play()
	end)	
end

local isnpc = function(ins)
	local humanoid = ins:FindFirstChildOfClass("Humanoid")
	local player = plrs:GetPlayerFromCharacter(ins)

	if humanoid and not player then
		return ins 
	end

	return nil
end

-- Add partowner function
function partowner(part)
	return part.ReceiveAge == 0
end

new:mainbutton(save["1"].title, save["1"].des, function()
	if currentnpc then
		local part = currentnpc:FindFirstChild("HumanoidRootPart")
		if part and partowner(part) then
			local hum = currentnpc:FindFirstChildOfClass("Humanoid")
			if hum then
				hum:ChangeState(save["1"].val)
				print("NPC killed via button!")
			end
		else
			light(currentnpc, Color3.fromRGB(255, 0, 0))
		end
	end
end)

new:mainbutton(save["2"].title, save["2"].des, function()
	if currentnpc then
		local part = currentnpc:FindFirstChild("HumanoidRootPart")
		if part and partowner(part) then
			if lp and lp.Character then
				local char = lp.Character
				currentnpc:PivotTo(char:GetPivot())
			end
		else
			light(currentnpc, Color3.fromRGB(255, 0, 0))
		end
	end
end)

new:mainbutton(save["3"].title, save["3"].des, function()
	if currentnpc then
		local part = currentnpc:FindFirstChild("HumanoidRootPart")
		if part then
			if lp and lp.Character then
				local char = lp.Character
				char:PivotTo(currentnpc:GetPivot())
			end
		else
			light(currentnpc, Color3.fromRGB(255, 0, 0))
		end
	end
end)

local chr, cons
new:maintoggle(save["4"].title, save["4"].des, function(a)
	if a then
		if currentnpc then
			local part = currentnpc:FindFirstChild("HumanoidRootPart")
			if part and partowner(part) then
				if lp and lp.Character then
					chr = lp.Character
					lp.Character = currentnpc
					ws.CurrentCamera.CameraSubject = currentnpc:FindFirstChild("HumanoidRootPart")
					local move = 0.01
					cons = rs.PreSimulation:Connect(function()
						local hum = lp.Character:FindFirstChildOfClass("Humanoid")
						if lp.Character and hum then
							hum.RootPart.CFrame += Vector3.new(0,move,0)
							move = -move
						else
							if cons then
								cons:Disconnect()
								cons = nil
							end
						end
					end)
					table.insert(_G.oldconnections, cons)
				end
			else
				light(currentnpc, Color3.fromRGB(255, 0, 0))
			end
		end
	else
		if chr then
			lp.Character = chr
			ws.CurrentCamera.CameraSubject = chr.Humanoid
			chr = nil
			if cons then
				cons:Disconnect()
				cons = nil
			end
		end
	end
end)

-- Changed punish npc from button to toggle
local punishcon, originalNPCPosition
new:maintoggle(save["5"].title, save["5"].des, function(a)
	if a then
		if currentnpc then
			local part = currentnpc:FindFirstChild("HumanoidRootPart")
			if part and partowner(part) then
				-- Store original position before punishing
				originalNPCPosition = currentnpc:GetPivot()
				
				-- Teleport to space once and keep them there
				currentnpc:PivotTo(CFrame.new(0, 1000, 0))
				
				-- Keep them in space (prevent them from falling back)
				punishcon = rs.Stepped:Connect(function()
					if currentnpc and currentnpc:FindFirstChild("HumanoidRootPart") then
						local hrp = currentnpc:FindFirstChild("HumanoidRootPart")
						if hrp and partowner(hrp) then
							-- Only teleport back to space if they've moved from punishment position
							if hrp.Position.Y < 999 then
								currentnpc:PivotTo(CFrame.new(0, 1000, 0))
							end
						else
							light(currentnpc, Color3.fromRGB(255, 0, 0))
							if punishcon then
								punishcon:Disconnect()
								punishcon = nil
							end
						end
					else
						if punishcon then
							punishcon:Disconnect()
							punishcon = nil
						end
					end
				end)
				table.insert(_G.oldconnections, punishcon)
				light(currentnpc, Color3.fromRGB(255, 165, 0))
			else
				light(currentnpc, Color3.fromRGB(255, 0, 0))
			end
		end
	else
		-- Stop punishing and restore original position
		if punishcon then
			punishcon:Disconnect()
			punishcon = nil
		end
		if currentnpc and originalNPCPosition then
			local part = currentnpc:FindFirstChild("HumanoidRootPart")
			if part and partowner(part) then
				-- Restore NPC to original position
				currentnpc:PivotTo(originalNPCPosition)
				light(currentnpc, Color3.fromRGB(0, 255, 0))
			else
				light(currentnpc, Color3.fromRGB(255, 0, 0))
			end
			originalNPCPosition = nil
		end
	end
end)

new:mainbutton(save["6"].title, save["6"].des, function()
	if currentnpc then
		local part = currentnpc:FindFirstChild("HumanoidRootPart")
		if part and partowner(part) then
			local hum = currentnpc:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.Sit = not hum.Sit
			end
		else
			light(currentnpc, Color3.fromRGB(255, 0, 0))
		end
	end
end)

new:mainbutton(save["7"].title, save["7"].des, function()
	if currentnpc then
		local part = currentnpc:FindFirstChild("HumanoidRootPart")
		if part and partowner(part) then
			local hum = currentnpc:FindFirstChildOfClass("Humanoid")
			if hum then
				hum:ChangeState(save["7"].val)
			end
		else
			light(currentnpc, Color3.fromRGB(255, 0, 0))
		end
	end
end)

local con, follownpc
follownpc = new:maintoggle(save["8"].title, save["8"].des, function(a)
	if a then
		con = rs.RenderStepped:Connect(function()
			if currentnpc then
				local part = currentnpc:FindFirstChild("HumanoidRootPart")
				if part and partowner(part) then
					local hum = currentnpc:FindFirstChildOfClass("Humanoid")
					if hum then
						local hrp=lp.Character:FindFirstChild("HumanoidRootPart")
						if hrp then
							hum:MoveTo(hrp.Position + Vector3.new(-4,0,0))
						end
					end
				else
					light(currentnpc, Color3.fromRGB(255, 0, 0))
					if con then
						follownpc:swich(false)
						con:Disconnect()
						con = nil
					end
				end
			else
				if con then
					follownpc:swich(false)
					con:Disconnect()
					con = nil
				end
			end
		end)
		table.insert(_G.oldconnections, con)
	else
		if con then
			con:Disconnect()
			con = nil
		end
	end
end)

local con1
new:extratoggle(save["9"].title, function(a)
	if a then
		con1 = rs.Stepped:Connect(function()
			local hrp1 = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			if not hrp1 then return end

			local nbp = ws:GetPartBoundsInRadius(hrp1.Position, 13)
			for _, part in pairs(nbp) do
				local model = part:FindFirstAncestorOfClass("Model")
				if model and isnpc(model) then
					local npc = model
					local hrp = npc:FindFirstChild("HumanoidRootPart")
					if hrp and partowner(hrp) and not hrp.Anchored and npc ~= lp.Character then
						local hum = npc:FindFirstChildOfClass("Humanoid")
						if hum then
							hum:ChangeState(save["9"].val)
						end
					end
				end
			end
		end)
		table.insert(_G.oldconnections, con1)
	else
		if con1 then
			con1:Disconnect()
			con1 = nil
		end
	end
end)

local con2
new:extratoggle(save["10"].title, function(a)
	if a then
		con2 = rs.Stepped:Connect(function()
			local hrp1 = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			if not hrp1 then return end

			local nbp = ws:GetPartBoundsInRadius(hrp1.Position, 13)
			for _, part in pairs(nbp) do
				local model = part:FindFirstAncestorOfClass("Model")
				if model and isnpc(model) then
					local npc = model
					local hrp = npc:FindFirstChild("HumanoidRootPart")
					if hrp and partowner(hrp) and not hrp.Anchored and npc ~= lp.Character then
						local hum = npc:FindFirstChildOfClass("Humanoid")
						if hum then
							hum:ChangeState(save["10"].val)
						end
					end
				end
			end
		end)
		table.insert(_G.oldconnections, con2)
	else
		if con2 then
			con2:Disconnect()
			con2 = nil
		end
	end
end)

-- View NPC Toggle
local originalCameraSubject, viewnpc
viewnpc = new:maintoggle(save["11"].title, save["11"].des, function(a)
	if a then
		if currentnpc then
			local part = currentnpc:FindFirstChild("HumanoidRootPart")
			if part then
				originalCameraSubject = ws.CurrentCamera.CameraSubject
				ws.CurrentCamera.CameraSubject = part
				light(currentnpc, Color3.fromRGB(0, 255, 255))
			else
				light(currentnpc, Color3.fromRGB(255, 0, 0))
				viewnpc:swich(false)
			end
		else
			viewnpc:swich(false)
		end
	else
		if originalCameraSubject then
			ws.CurrentCamera.CameraSubject = originalCameraSubject
			originalCameraSubject = nil
		else
			if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
				ws.CurrentCamera.CameraSubject = lp.Character:FindFirstChildOfClass("Humanoid")
			end
		end
	end
end)

-- Freeze NPC Toggle
local freezenpc
freezenpc = new:maintoggle(save["12"].title, save["12"].des, function(a)
	if a then
		if currentnpc then
			local part = currentnpc:FindFirstChild("HumanoidRootPart")
			if part and partowner(part) then
				part.Anchored = true
				light(currentnpc, Color3.fromRGB(135, 206, 235))
			else
				light(currentnpc, Color3.fromRGB(255, 0, 0))
				freezenpc:swich(false)
			end
		else
			freezenpc:swich(false)
		end
	else
		if currentnpc then
			local part = currentnpc:FindFirstChild("HumanoidRootPart")
			if part and partowner(part) then
				part.Anchored = false
				light(currentnpc, Color3.fromRGB(0, 255, 0))
			else
				light(currentnpc, Color3.fromRGB(255, 0, 0))
			end
		end
	end
end)

-- Freeze aura any npc
local con3
new:extratoggle(save["13"].title, function(a)
	if a then
		con3 = rs.Stepped:Connect(function()
			local hrp1 = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			if not hrp1 then return end

			local nbp = ws:GetPartBoundsInRadius(hrp1.Position, 13)
			for _, part in pairs(nbp) do
				local model = part:FindFirstAncestorOfClass("Model")
				if model and isnpc(model) then
					local npc = model
					local hrp = npc:FindFirstChild("HumanoidRootPart")
					if hrp and partowner(hrp) and not hrp.Anchored and npc ~= lp.Character then
						hrp.Anchored = true
					end
				end
			end
		end)
		table.insert(_G.oldconnections, con3)
	else
		if con3 then
			con3:Disconnect()
			con3 = nil
		end
	end
end)

-- Punish aura any npc
local con4
new:extratoggle(save["14"].title, function(a)
	if a then
		con4 = rs.Stepped:Connect(function()
			local hrp1 = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			if not hrp1 then return end

			local nbp = ws:GetPartBoundsInRadius(hrp1.Position, 13)
			for _, part in pairs(nbp) do
				local model = part:FindFirstAncestorOfClass("Model")
				if model and isnpc(model) then
					local npc = model
					local hrp = npc:FindFirstChild("HumanoidRootPart")
					if hrp and partowner(hrp) and not hrp.Anchored and npc ~= lp.Character then
						npc:PivotTo(CFrame.new(0, 1000, 0))
					end
				end
			end
		end)
		table.insert(_G.oldconnections, con4)
	else
		if con4 then
			con4:Disconnect()
			con4 = nil
		end
	end
end)

-- Bring aura any npc
local con5
new:extratoggle(save["15"].title, function(a)
	if a then
		con5 = rs.Stepped:Connect(function()
			local hrp1 = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			if not hrp1 then return end

			local nbp = ws:GetPartBoundsInRadius(hrp1.Position, 13)
			for _, part in pairs(nbp) do
				local model = part:FindFirstAncestorOfClass("Model")
				if model and isnpc(model) then
					local npc = model
					local hrp = npc:FindFirstChild("HumanoidRootPart")
					if hrp and partowner(hrp) and not hrp.Anchored and npc ~= lp.Character then
						if lp and lp.Character then
							local char = lp.Character
							npc:PivotTo(char:GetPivot())
						end
					end
				end
			end
		end)
		table.insert(_G.oldconnections, con5)
	else
		if con5 then
			con5:Disconnect()
			con5 = nil
		end
	end
end)

-- Mouse click to select NPC
local mouseConnection = mouse.Button1Down:Connect(function()
	if clicknpc and mouse.Target and mouse.Target.Parent:FindFirstChild("HumanoidRootPart") then
		if mouse.Target.Parent:FindFirstChild("HumanoidRootPart").Anchored == false then
			if not plrs:GetPlayerFromCharacter(mouse.Target.Parent) then
				if partowner(mouse.Target.Parent:FindFirstChild("HumanoidRootPart")) then
					currentnpc = mouse.Target.Parent
					light(currentnpc, Color3.fromRGB(0, 255, 0))
					print("NPC selected:", currentnpc.Name)
				else
					light(mouse.Target.Parent, Color3.fromRGB(255, 0, 0))
					print("NPC not network owned")
				end
			end
		else
			light(mouse.Target.Parent, Color3.fromRGB(255, 0, 0))
			print("NPC is anchored")
		end
	end
end)
table.insert(_G.oldconnections, mouseConnection)

-- Simulation radius connection
local simConnection = rs.RenderStepped:Connect(function()
	if sethiddenproperty then
		sethiddenproperty(lp,"SimulationRadius",rad)
	else
		lp.SimulationRadius=rad
	end
end)
table.insert(_G.oldconnections, simConnection)

print("NPC Script loaded successfully!")
return g2l, require
