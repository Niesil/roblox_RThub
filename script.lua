local GUI = require(loadstring(game.HttpService:GetAsync('https://raw.githubusercontent.com/Niesil/roblox_RThub/main/Gui.lua')))
local UIS = game:GetService('UserInputService')

local function randomName()
	return tostring(math.round(Random.new():NextNumber() * 1000000))
end

local window = GUI.CreateWindow('   RT Hub')


local main = window.addCategory(randomName(),'Main')

local movement = window.addCategory(randomName(),'Movement')

local players = window.addCategory(randomName(),'Players')

local visual = window.addCategory(randomName(),'Visual')

local misc = window.addCategory(randomName(),'Misc')

local settings = window.addCategory(randomName(),'Settings')
