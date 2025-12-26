return function()

local GUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/Niesil/roblox_RThub/main/Gui.lua'))
local UIS = game:GetService('UserInputService')
local RS = game:GetService('RunService')

local function randomName()
	return tostring(math.round(Random.new():NextNumber() * 1000000))
end

local window = GUI.CreateWindow('   RT Hub')


local main = window.addCategory(randomName(),'Main')
local noclip, noclipConnection
main:addToggle(randomName(),'Noclip: ',function(bool)
	noclip = bool
	if noclip then
		for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide then
				part.CanCollide = false
			end
		end
		noclipConnection = RS.Stepped:Connect(function(part)
			for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide then
					part.CanCollide = false
				end
			end
		end)
	else
		noclipConnection:Disconnect()
		if game.Players.LocalPlayer.Character then
			for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end
	end
end)

local movement = window.addCategory(randomName(),'Movement')
local fly, flySpeed = false, 16
local bodyVelocity, bodyGyro
movement:addToggle(randomName(),'Fly: ',function(bool)
	fly = bool
	if fly then
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
		bodyVelocity.P = 1000000
		bodyVelocity.Parent = game.Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart')
		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
		bodyGyro.P = 1000000
		bodyGyro.Parent = game.Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart')

		game.Players.LocalPlayer.Character:WaitForChild('Humanoid').PlatformStand = true
		local flyConnection
		flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
			if not fly or not bodyVelocity or not game.Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart') then
				flyConnection:Disconnect()
				return
			end
			bodyGyro.CFrame = workspace.CurrentCamera.CoordinateFrame
			
			local camera = workspace.CurrentCamera
			local lookVector = camera.CFrame.LookVector
			local rightVector = camera.CFrame.RightVector

			local direction = Vector3.new(0, 0, 0)
			if UIS:IsKeyDown(Enum.KeyCode.W) then
				direction = direction + lookVector
			end
			if UIS:IsKeyDown(Enum.KeyCode.S) then
				direction = direction - lookVector
			end
			if UIS:IsKeyDown(Enum.KeyCode.A) then
				direction = direction - rightVector
			end
			if UIS:IsKeyDown(Enum.KeyCode.D) then
				direction = direction + rightVector
			end
			if UIS:IsKeyDown(Enum.KeyCode.Space) then
				direction = direction + Vector3.new(0, 1, 0)
			end
			if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
				direction = direction + Vector3.new(0, -1, 0)
			end
			if direction.Magnitude > 0 then
				local moveDirection = direction.Unit
				bodyVelocity.Velocity = moveDirection * flySpeed
			else
				bodyVelocity.Velocity = Vector3.new(0, 0, 0)
			end
		end)

	else
		if bodyVelocity then
			bodyVelocity:Destroy()
			bodyVelocity = nil
		end
		if bodyGyro then
			bodyGyro:Destroy()
			bodyGyro = nil
		end
		if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:WaitForChild('Humanoid') then
			game.Players.LocalPlayer.Character:WaitForChild('Humanoid').PlatformStand = false
		end
	end
end)
movement:addSlider(randomName(),'Fly speed: ',1,500,function(speed)
	flySpeed = speed
end)
movement:addSeparator(randomName())
local speedHack, playerSpeed, runConnection = false, 16, nil
movement:addToggle(randomName(),'Speed hack: ',function(bool)
	speedHack = bool
	if speedHack then
		runConnection = RS.Heartbeat:Connect(function()
			game.Players.LocalPlayer.Character:WaitForChild('Humanoid').WalkSpeed = playerSpeed
		end)
	else
		runConnection:Disconnect()
		game.Players.LocalPlayer.Character:WaitForChild('Humanoid').WalkSpeed = 16
	end
end)
movement:addSlider(randomName(),'Player speed: ',1,500,function(speed)
	playerSpeed = speed
end)
movement:addSeparator(randomName())
local jumpHack, jumpHeight, jumpConnection = false, 7.2, nil
movement:addToggle(randomName(),'Jump hack: ',function(bool)
	jumpHack = bool
	if jumpHack then
		runConnection = RS.Heartbeat:Connect(function()
			game.Players.LocalPlayer.Character:WaitForChild('Humanoid').JumpHeight = jumpHeight
		end)
	else
		runConnection:Disconnect()
		game.Players.LocalPlayer.Character:WaitForChild('Humanoid').JumpHeight = 7.2
	end
end)
movement:addSlider(randomName(),'Jump height: ',1,200,function(height)
	jumpHeight = height
end)
movement:addSeparator(randomName())
local teleportKey, teleportBinding = nil, false
local teleportLabel = movement:addLabel(randomName(),'Teleport key: ')
movement:addButton(randomName(),'Bind teleport key',function()
	teleportBinding = true
	local teleportConnection = UIS.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.Keyboard then
			teleportKey = inp.KeyCode
			teleportLabel.Text = 'Teleport key: '..tostring(teleportKey.Name)
			teleportBinding = false
		end
	end)
	while wait() do
		if not teleportBinding then
			teleportConnection:Disconnect()
			break
		end
	end
end)
UIS.InputBegan:Connect(function(inp)
	if inp.KeyCode == teleportKey then
		local target = game.Players.LocalPlayer:GetMouse().Target
		if target then
			game.Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart').CFrame = game.Players.LocalPlayer:GetMouse().Hit
		end
	end
end)
movement:addSeparator(randomName())


local world = window.addCategory(randomName(),'World')

local players = window.addCategory(randomName(),'Players')

local visual = window.addCategory(randomName(),'Visual')

local misc = window.addCategory(randomName(),'Misc')

local setting = window.addCategory(randomName(),'Settings')
setting:addButton(randomName(),'Close',function()
	window:Destroy()
end)


UIS.InputBegan:Connect(function(inp)
	if inp.KeyCode == Enum.KeyCode.LeftControl then
		if not window:Toggle() then
			GUI.sendNotification('GUI is hidden, press LeftCtrl to show it.')
		end
	end
end)

GUI.sendNotification('RT hub launched, welcome!')

end
