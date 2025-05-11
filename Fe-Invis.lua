-- FE Invisible by YetAnotherDumbBoi/Error-Cezar
-- Inspired from BitingTheDust version ; https://v3rmillion.net/member.php?action=profile&uid=1628149
local Global = getgenv and getgenv() or _G
local First = true
local Restart = true
local SoundService = game:GetService("SoundService")
local StoredCF
local SafeZone
if Global.SafeZone ~= nil then
	if type(Global.SafeZone) ~= "userdata" then return error("CFrame must be a userdata (CFrame.new(X, X, X)") end
	SafeZone = Global.SafeZone
else
	SafeZone = CFrame.new(0,-300,0)       
end

local ScriptStart = true
local Reset = false
local DeleteOnDeath = {}
local Activate
local Noclip
if Global.Key == nil then
	Activate = "F"
else
	Activate = tostring(Global.Key)     
end

if Global.Noclip == nil then
	Noclip = false
else
	Noclip = Global.Noclip        
end

if type(Noclip) ~= "boolean" then return error("Noclip value isn't a boolean") end

function notify(Message)
	game:GetService("StarterGui"):SetCore("SendNotification", { 
		Title = "FE Invisible";
		Text = Message;
		Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://7046168694"
	SoundService:PlayLocalSound(sound)
end

if Global.Running then
	return notify("Script is already running")
else
	Global.Running = true
end

local IsInvisible = false
local WasInvisible = false
local Died = false
local LP = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
repeat wait() until LP.Character
repeat wait() until LP.Character:FindFirstChild("Humanoid")
local RealChar = LP.Character or LP.CharacterAdded:Wait()
RealChar.Archivable = true
local FakeChar = RealChar:Clone()
FakeChar:WaitForChild("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
FakeChar.Parent = game:GetService("Workspace")

for _, child in pairs(FakeChar:GetDescendants()) do
	if child:IsA("BasePart") and child.CanCollide == true then
		child.CanCollide = false
	end
end

FakeChar:SetPrimaryPartCFrame(SafeZone * CFrame.new(0, 5, 0))

local Part
Part = Instance.new("Part", workspace)
Part.Anchored = true
Part.Size = Vector3.new(200, 1, 200)
Part.CFrame = SafeZone
Part.CanCollide = true


for i, v in pairs(FakeChar:GetDescendants()) do
	if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
		v.Transparency = 0.7
	end
end

for i, v in pairs(RealChar:GetChildren()) do
	if v:IsA("LocalScript") then
		local clone = v:Clone()
		clone.Disabled = true
		clone.Parent = FakeChar
	end
end

function StopScript()
	if ScriptStart == false then return end
	if Died == false then
		if Restart == true then
			notify("The character used died!\nStopping...")
		else
			notify("Script successfuly ended !")
		end
		Part:Destroy()
		if IsInvisible and RealChar:FindFirstChild("HumanoidRootPart") then
			Visible() 
			WasInvisible = true
		end
		
		if IsInvisible == false and LP.Character:WaitForChild("Humanoid").Health == 0 then
			WasInvisible = true
		end
		if not RealChar:FindFirstChild("Humanoid") then
			Reset = true
			print("a")
		end
		
		game:GetService("Workspace").CurrentCamera.CameraSubject = RealChar:WaitForChild("Humanoid")

		if FakeChar then
			FakeChar:Destroy()
		end

		if WasInvisible then
			local char = LP.Character
			if char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid"):ChangeState(15) end
			char:ClearAllChildren()
			local newChar = Instance.new("Model")
			newChar.Parent = workspace
			LP.Character = newChar
			wait()
			LP.Character = char
			newChar:Destroy()
			for _,v in pairs(DeleteOnDeath) do
				v:Destroy()
			end
			
		else
			for _,v in pairs(DeleteOnDeath) do
				v.ResetOnSpawn = true
			end
		end
		Global.Running = false
		ScriptStart = false
		if Restart == true then
		loadstring(game:HttpGet('https://raw.githubusercontent.com/Error-Cezar/Roblox-Scripts/main/FE-Invisible.lua'))()
		end
		
			LP.CharacterAdded:Connect(function()
				if Reset == false then return end
			loadstring(game:HttpGet('https://raw.githubusercontent.com/Error-Cezar/Roblox-Scripts/main/FE-Invisible.lua'))()
		end)
		
	end
end

RealChar:WaitForChild("Humanoid").Died:Connect(function()
	StopScript()
end)


FakeChar:WaitForChild("Humanoid").Died:Connect(function()
	StopScript()
end)

function Invisible()
	StoredCF = RealChar:GetPrimaryPartCFrame()
	
if First == true then
		First = false
		for _,v in pairs(LP:WaitForChild("PlayerGui"):GetChildren()) do 
		if v:IsA("ScreenGui") then
			if v.ResetOnSpawn == true then
				v.ResetOnSpawn = false
				table.insert(DeleteOnDeath, v)
			end
		end
	end
	end
	
	if Noclip == true then
	for _, child in pairs(FakeChar:GetDescendants()) do
		if child:IsA("BasePart") and child.CanCollide == true then
			child.CanCollide = false
		end
		end
	end
	FakeChar:SetPrimaryPartCFrame(StoredCF)
	FakeChar:WaitForChild("HumanoidRootPart").Anchored = false
	LP.Character = FakeChar
	game:GetService("Workspace").CurrentCamera.CameraSubject = FakeChar:WaitForChild("Humanoid")
		for _, child in pairs(RealChar:GetDescendants()) do
			if child:IsA("BasePart") and child.CanCollide == true then
				child.CanCollide = false
			end
		end

	RealChar:SetPrimaryPartCFrame(SafeZone * CFrame.new(0, 5, 0))
	--	RealChar:WaitForChild("HumanoidRootPart").Anchored = true
	RealChar:WaitForChild("Humanoid"):UnequipTools()

	for i, v in pairs(FakeChar:GetChildren()) do
		if v:IsA("LocalScript") then
			v.Disabled = false
		end
	end
end

function Visible()
	StoredCF = FakeChar:GetPrimaryPartCFrame()
	for _, child in pairs(RealChar:GetDescendants()) do
		if child:IsA("BasePart") and child.CanCollide == true then
			child.CanCollide = true
		end
	end
	RealChar:WaitForChild("HumanoidRootPart").Anchored = false
	RealChar:SetPrimaryPartCFrame(StoredCF)
	LP.Character = RealChar
	FakeChar:WaitForChild("Humanoid"):UnequipTools()
	game:GetService("Workspace").CurrentCamera.CameraSubject = RealChar:WaitForChild("Humanoid")
	for _, child in pairs(FakeChar:GetDescendants()) do
		if child:IsA("BasePart") and child.CanCollide == true then
			child.CanCollide = false
		end
	end
	FakeChar:SetPrimaryPartCFrame(SafeZone * CFrame.new(0, 5, 0))
		FakeChar:WaitForChild("HumanoidRootPart").Anchored = true
	for i, v in pairs(FakeChar:GetChildren()) do
		if v:IsA("LocalScript") then
			v.Disabled = true
		end
	end
end


UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if ScriptStart == false then return end
	if gameProcessed then return end
	if input.KeyCode.Name:lower() ~= Activate:lower() then return end
	if IsInvisible == false then
		Invisible()
		IsInvisible = true
	else
		Visible()
		IsInvisible = false
	end
end)

LP.Chatted:Connect(function(msg)
	print(ScriptStart)
	if ScriptStart == false then return end
	msg = msg:lower()
	if msg == "/e stop" then
		Restart = false
		StopScript()
	end
	
	if msg == "/e cmds" then
		Global.Header = "Commands avaiable"
		Global.Message = "/e cmds -- Show this gui \n /e stop -- Stop the script \n /e noclip -- turn on/off noclip"
		print("e")
		loadstring(game:HttpGet('https://raw.githubusercontent.com/Error-Cezar/Roblox-Scripts/main/Notif.lua'))()

	end
	
	if msg == "/e noclip" then
		Noclip = not Noclip
		notify("Noclip set to "..tostring(Noclip))
	end
end)
