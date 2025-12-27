return function(settings:{}?,plugins:{}?)
	local RTHUB = true
	local notificationColors = {
		['Red'] = Color3.fromRGB(255, 55, 55),
		['Green'] = Color3.fromRGB(55, 255, 55),
		['Blue'] = Color3.fromRGB(55, 55, 255),
	}

	local GUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/Niesil/roblox_RThub/main/Gui.lua'))() --require(game.ReplicatedStorage.GUI) 
	local UIS = game:GetService('UserInputService')
	local RS = game:GetService('RunService')

	local function randomName()
		return tostring(math.round(Random.new():NextNumber() * 1000000))
	end

	local window = GUI.CreateWindow('   RT Hub')


	local main = window.addCategory(randomName(),'Main') --MAIN==================================
	local noclip, noclipConnection
	local originalCollisionStates = {}
	main:addToggle(randomName(),'Noclip: ',function(bool)
		noclip = bool
		if noclip then
			local originalCollisionStates = {}
			for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide then
					originalCollisionStates[part] = part.CanCollide
					part.CanCollide = false
				end
			end
			noclipConnection = RS.Stepped:Connect(function(part)
				for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
					if part:IsA("BasePart") and part.CanCollide then
						if originalCollisionStates[part] == nil then
							originalCollisionStates[part] = part.CanCollide
						end
						part.CanCollide = false
					end
				end
			end)
		else
			noclipConnection:Disconnect()
			for part, originalState in pairs(originalCollisionStates) do
				if part and part.Parent then
					part.CanCollide = originalState
				end
			end
			originalCollisionStates = {}
		end
	end)

	local movement = window.addCategory(randomName(),'Movement') --MOVEMENT==================================
	local flyEnabled, flySpeed = false, 16
	local bodyVelocity, bodyGyro
	movement:addToggle(randomName(),'Fly: ',function(bool)
		flyEnabled = bool
		if bool then
			bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.Velocity = Vector3.new(0, 0, 0)
			bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
			bodyVelocity.P = 1000000
			bodyVelocity.Parent = game.Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart')
			bodyGyro = Instance.new("BodyGyro")
			bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
			bodyGyro.P = 100000
			bodyGyro.Parent = game.Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart')

			game.Players.LocalPlayer.Character:WaitForChild('Humanoid').PlatformStand = true
			local flyConnection
			flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
				if not flyEnabled or not bodyVelocity or not game.Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart') then
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

	local world = window.addCategory(randomName(),'World') --WORLD==================================
	local clockTimeConnection, fixedClockTime
	world:addLabel(randomName(),'Change clock time:')
	world:addTextBox(randomName(),'12.0','Clock time',function(text)
		local clockTime = tonumber(text)
		if clockTime then
			game.Lighting.ClockTime = clockTime
			fixedClockTime = clockTime
		end
	end)
	world:addToggle(randomName(),'Fix clock time: ',function(bool)
		if bool then
			clockTimeConnection = RS.Heartbeat:Connect(function()
				game.Lighting.ClockTime = fixedClockTime or game.Lighting.ClockTime
			end)
		else
			clockTimeConnection:Disconnect()
		end
	end)
	
	local visual = window.addCategory(randomName(),'Visual') --VISUAL==================================
	local lastAmbient, fullBrightConnection
	visual:addToggle(randomName(),'Full bright: ',function(bool)
		if bool then
			lastAmbient = game.Lighting.Ambient
			game.Lighting.Ambient = Color3.new(1, 1, 1)
			fullBrightConnection = RS.Heartbeat:Connect(function()
				if game.Lighting.Ambient ~= Color3.new(1,1,1) then
					lastAmbient = game.Lighting.Ambient
					game.Lighting.Ambient = Color3.new(1,1,1)
				end
			end)
		else
			fullBrightConnection:Disconnect()
			game.Lighting.Ambient = lastAmbient
		end
	end)
	visual:addSeparator(randomName())
	local wallHackEnabled, wallHackColor = false, Color3.fromRGB(255,255,255)
	local wallHackName = randomName()
	local wallHackConnection
	visual:addToggle(randomName(),'Wall hack: ',function(bool)
		wallHackEnabled = bool
		if bool then
			wallHackConnection = RS.Heartbeat:Connect(function()
				for _,v in game.Players:GetChildren() do
					if not v.Character:FindFirstChild(wallHackName) then
						local highLight = Instance.new('Highlight')
						highLight.Name = wallHackName
						highLight.FillTransparency = 0.8
						highLight.FillColor = wallHackColor
						highLight.OutlineColor = wallHackColor
						highLight.Parent = v.Character
					end
				end
			end)
		else
			wallHackConnection:Disconnect()
			for _,v in game.Players:GetChildren() do
				if v.Character:FindFirstChild(wallHackName) then
					v.Character[wallHackName]:Destroy()
				end
			end
		end
		game.Players.PlayerAdded:Connect(function(pl)
			if wallHackEnabled then
				if not pl.Character:FindFirstChild(wallHackName) then
					local highLight = Instance.new('Highlight')
					highLight.Name = wallHackName
					highLight.FillTransparency = 0.8
					highLight.FillColor = wallHackColor
					highLight.OutlineColor = wallHackColor
					highLight.Parent = pl.Character
				end
			end
		end)
	end)
	visual:addTextBox(randomName(),'255,255,255','Color',function(text)
		local Colors = string.split(text,',')
		if #Colors == 3 then
			local R,G,B
			for i,v in pairs(Colors) do
				if tonumber(v) then
					Colors[i] = math.clamp(tonumber(v),0,255)
				else
					return
				end
			end
			wallHackColor = Color3.fromRGB(Colors[1],Colors[2],Colors[3])
			GUI.sendNotification('Wall hack color changed',3,wallHackColor)
		end
	end)
	visual:addSeparator(randomName())
	
	local misc = window.addCategory(randomName(),'Misc') --MISC==================================	
	
	local setting = window.addCategory(randomName(),'Settings') --SETTINGS==================================
	local toggleKey = Enum.KeyCode.LeftControl
	local toggleKeyBinding = false
	local toggleKeyLabel = setting:addLabel(randomName(),'Toggle key: '..toggleKey.Name)
	setting:addButton(randomName(),'Bind key to hide/show window',function()
		toggleKeyBinding = true
		local connection = game:GetService('UserInputService').InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.Keyboard then
				toggleKey = inp.KeyCode
				toggleKeyLabel.Text = 'Toggle key: '..toggleKey.Name
				toggleKeyBinding = false
			end
		end)
		while wait() do
			if not toggleKeyBinding then
				connection:Disconnect()
				break
			end
		end
	end)
	setting:addSeparator(randomName(),5)
	setting:addButton(randomName(),'Close',function()
		window:Destroy()
		RTHUB = false
	end)


	UIS.InputBegan:Connect(function(inp)
		if inp.KeyCode == toggleKey and RTHUB then
			if not window:Toggle() then
				GUI.sendNotification('GUI is hidden, press '..toggleKey.Name..' to show it.')
			end
		end
	end)

	GUI.sendNotification('RT hub launched, welcome!')
end
