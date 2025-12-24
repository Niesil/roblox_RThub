local UIS = game:GetService('UserInputService')
local TS = game:GetService('TweenService')

local font = Enum.Font.GothamBold


local Colors = {
	['text'] = Color3.new(1,1,1),
	['Disabled'] = Color3.new(0.196078, 0.196078, 0.196078),
	['Enabled'] = Color3.new(0, 0.521569, 0.866667),
}

local Tweens = {}
Tweens.__index = Tweens

function Tweens.ToggleColor(element, bool)
	local Tween
	if bool then
		Tween = TS:Create(element, TweenInfo.new(0.3),{BackgroundColor3 = Colors.Enabled})
	else
		Tween = TS:Create(element, TweenInfo.new(0.3),{BackgroundColor3 = Colors.Disabled})
	end
	Tween:Play()
end

function Tweens.Select(element, bool)
	local corner = element.UICorner
	local TweenCorner
	if bool then
		TweenCorner = TS:Create(corner,TweenInfo.new(0.3),{CornerRadius = UDim.new(0,1)})
	else
		TweenCorner = TS:Create(corner,TweenInfo.new(0.3),{CornerRadius = UDim.new(0,6)})
	end
	TweenCorner:Play()
end


local API = setmetatable({},{})

function API.CreateWindow(Name:string,Size:UDim2?,WelcomeText:string?)
	local ScreenGUI = Instance.new("ScreenGui")
	ScreenGUI.Name = tostring(math.round(Random.new():NextNumber()*100000000))
	ScreenGUI.IgnoreGuiInset = true
	ScreenGUI.ResetOnSpawn = false
	ScreenGUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

	local Window = Instance.new('Frame')
	Window.Size = Size or UDim2.new(0, 550, 0, 450)
	Window.AnchorPoint = Vector2.new(0.5,0.5)
	Window.Position = UDim2.new(0.5,0,0.5,0)
	Window.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	Window.BorderSizePixel = 0
	Window.ClipsDescendants = true
	Window.Active = true
	local WindowCorner = Instance.new('UICorner')
	WindowCorner.CornerRadius = UDim.new(0, 8)
	WindowCorner.Parent = Window

	local Title = Instance.new('TextLabel')
	Title.Size = UDim2.new(1,0,0,40)
	Title.Text = Name
	Title.TextColor3 = Colors.text
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Font = font
	Title.TextSize = 18
	Title.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
	Title.Parent = Window
	local TitleCorner = Instance.new("UICorner")
	TitleCorner.CornerRadius = UDim.new(0, 8)
	TitleCorner.Parent = Title

	local dragging = false
	local dragStartPos, frameStartPos
	Title.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStartPos = input.Position
			frameStartPos = Window.Position
		end
	end)
	Title.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStartPos
			Window.Position = UDim2.new(
				frameStartPos.X.Scale, 
				frameStartPos.X.Offset + delta.X,
				frameStartPos.Y.Scale, 
				frameStartPos.Y.Offset + delta.Y
			)
		end
	end)

	local CategoriesFrame = Instance.new('ScrollingFrame')
	CategoriesFrame.BackgroundTransparency = 1
	CategoriesFrame.Size = UDim2.new(0,175,1,-50)
	CategoriesFrame.Position = UDim2.new(0,0,0,45)
	CategoriesFrame.ScrollBarThickness = 1
	CategoriesFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	local CategoriesList = Instance.new("UIListLayout")
	CategoriesList.Padding = UDim.new(0,8)
	CategoriesList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	CategoriesList.SortOrder = Enum.SortOrder.LayoutOrder
	CategoriesList.Parent = CategoriesFrame
	CategoriesFrame.Parent = Window

	local ContentFrame = Instance.new('ScrollingFrame')
	ContentFrame.BackgroundTransparency = 1
	ContentFrame.Size = UDim2.new(1,-180,1,-50)
	ContentFrame.Position = UDim2.new(0,175,0,45)
	ContentFrame.ScrollBarThickness = 1
	ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	local ContentList = Instance.new("UIListLayout")
	ContentList.Padding = UDim.new(0,12)
	ContentList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	ContentList.SortOrder = Enum.SortOrder.LayoutOrder
	ContentList.Parent = ContentFrame
	ContentFrame.Parent = Window
	local welcomeLabel = Instance.new('TextLabel')
	welcomeLabel.Name = 'Welcome'
	welcomeLabel.Text = WelcomeText or 'Welcome to RT hub!'
	welcomeLabel.TextColor3 = Colors.text
	welcomeLabel.Font = font
	welcomeLabel.TextSize = 25
	welcomeLabel.Size = UDim2.new(1,0,0,30)
	welcomeLabel.BackgroundTransparency = 1
	welcomeLabel.Parent = ContentFrame

	local WindowFunctions = {}

	local categories = {}
	local curentCategory = ''
	local categoriesBufferFrame = Instance.new('Frame')
	categoriesBufferFrame.Name = 'Buffer'
	categoriesBufferFrame.Visible = false
	categoriesBufferFrame.Parent = ScreenGUI

	function WindowFunctions.addCategory(Name:string, Text:string)
		if categories[Name] ~= nil then 
			error('Category already exists!') 
		end

		-- Создаем буферный фрейм для хранения элементов категории
		local categoryBufferFrame = Instance.new('Frame')
		categoryBufferFrame.Name = Name
		categoryBufferFrame.BackgroundTransparency = 1
		categoryBufferFrame.Size = UDim2.new(1, 0, 1, 0)

		-- Добавляем UIListLayout для вертикального расположения элементов
		local bufferListLayout = Instance.new('UIListLayout')
		bufferListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		bufferListLayout.Padding = UDim.new(0, 5)
		bufferListLayout.Parent = categoryBufferFrame

		categoryBufferFrame.Parent = categoriesBufferFrame

		-- Создание кнопки категории
		local categoryButton = Instance.new('TextButton')
		categoryButton.Text = Text
		categoryButton.TextColor3 = Colors.text
		categoryButton.TextSize = 14
		categoryButton.Font = font
		categoryButton.Size = UDim2.new(0.9, 0, 0, 45)
		categoryButton.BackgroundColor3 = Colors.Disabled
		categoryButton.AutoButtonColor = false
		categoryButton.Name = Name
		categoryButton.LayoutOrder = #CategoriesFrame:GetChildren()

		local categoryButtonCorner = Instance.new('UICorner')
		categoryButtonCorner.CornerRadius = UDim.new(0, 6)
		categoryButtonCorner.Parent = categoryButton

		categoryButton.MouseEnter:Connect(function() 
			Tweens.Select(categoryButton, true) 
		end)

		categoryButton.MouseLeave:Connect(function() 
			Tweens.Select(categoryButton, false) 
		end)        

		categoryButton.Parent = CategoriesFrame

		-- Таблица методов для возврата
		local categoryMethods = {}

		local function addElement(element, order)
			element.LayoutOrder = order or #categoryBufferFrame:GetChildren()
			element.Parent = categoryBufferFrame

			-- Если категория активна, показываем элемент в ContentFrame
			if curentCategory == Name then
				element.Parent = ContentFrame
			end

			return element
		end

		-- Метод для добавления кнопки
		function categoryMethods:addButton(Name:string, Text:string, Callback:()->nil)
			local button = Instance.new('TextButton')
			button.Name = Name
			button.Text = Text
			button.TextColor3 = Colors.text
			button.TextSize = 14
			button.Font = font
			button.Size = UDim2.new(1, 0, 0, 35)
			button.BackgroundColor3 = Colors.Disabled
			button.AutoButtonColor = false

			local corner = Instance.new('UICorner')
			corner.CornerRadius = UDim.new(0, 6)
			corner.Parent = button

			if Callback then
				button.MouseButton1Down:Connect(function()
					Tweens.ToggleColor(button,true)
				end)
				button.MouseButton1Up:Connect(function()
					Tweens.ToggleColor(button,false)
					Callback()
				end)
			end

			button.MouseEnter:Connect(function() Tweens.Select(button,true) end)
			button.MouseLeave:Connect(function() Tweens.Select(button,false) end)

			return addElement(button)
		end

		-- Метод для добавления текстового поля
		function categoryMethods:addTextBox(Name:string, Basic:string, Placeholder:string, Callback:(string)->nil)
			local textBox = Instance.new('TextBox')
			textBox.Name = Name
			textBox.Text = Basic or ""
			textBox.PlaceholderText = Placeholder or "..."
			textBox.TextColor3 = Colors.text
			textBox.TextSize = 14
			textBox.Font = font
			textBox.Size = UDim2.new(1, 0, 0, 35)
			textBox.BackgroundColor3 = Colors.Disabled
			textBox.ClearTextOnFocus = false

			local corner = Instance.new('UICorner')
			corner.CornerRadius = UDim.new(0, 6)
			corner.Parent = textBox

			if Callback then
				textBox.Focused:Connect(function()
					Tweens.ToggleColor(textBox,true)
				end)
				textBox.FocusLost:Connect(function(enterPressed)
					Tweens.ToggleColor(textBox,false)
					Callback(textBox.Text)
				end)
			end

			textBox.MouseEnter:Connect(function() Tweens.Select(textBox,true) end)
			textBox.MouseLeave:Connect(function() Tweens.Select(textBox,false) end)

			return addElement(textBox)
		end

		-- Метод для добавления переключателя
		function categoryMethods:addToggle(Name:string, Text:string, Callback:(boolean)->nil)
			local toggleFrame = Instance.new('Frame')
			toggleFrame.Name = Name
			toggleFrame.Size = UDim2.new(1, 0, 0, 35)
			toggleFrame.BackgroundTransparency = 1

			local label = Instance.new('TextLabel')
			label.Name = "Label"
			label.Text = Text
			label.TextColor3 = Colors.text
			label.TextSize = 14
			label.Font = font
			label.Size = UDim2.new(0.40, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = toggleFrame

			local toggleButton = Instance.new('TextButton')
			toggleButton.Name = "Toggle"
			toggleButton.Text = ""
			toggleButton.Size = UDim2.new(0.60, 0, 0, 25)
			toggleButton.Position = UDim2.new(1, 0, 0.5, 0)
			toggleButton.AnchorPoint = Vector2.new(1, 0.5)
			toggleButton.BackgroundColor3 = Colors.Disabled
			toggleButton.AutoButtonColor = false

			local corner = Instance.new('UICorner')
			corner.CornerRadius = UDim.new(0, 4)
			corner.Parent = toggleButton

			local isToggled = false

			toggleButton.MouseButton1Click:Connect(function()
				isToggled = not isToggled
				Tweens.ToggleColor(toggleButton,isToggled)
				if Callback then
					Callback(isToggled)
				end
			end)
			toggleButton.MouseEnter:Connect(function() Tweens.Select(toggleButton,true) end)
			toggleButton.MouseLeave:Connect(function() Tweens.Select(toggleButton,false) end)

			toggleButton.Parent = toggleFrame

			return addElement(toggleFrame)
		end

		-- Метод для добавления слайдера
		function categoryMethods:addSlider(Name:string, Text:string, min:number, max:number, Callback:(number)->nil)
			local sliderFrame = Instance.new('Frame')
			sliderFrame.Name = Name
			sliderFrame.Size = UDim2.new(1, 0, 0, 50)
			sliderFrame.BackgroundTransparency = 1

			local label = Instance.new('TextLabel')
			label.Name = "Label"
			label.Text = Text
			label.TextColor3 = Colors.text
			label.TextSize = 14
			label.Font = font
			label.Size = UDim2.new(1, 0, 0, 15)
			label.BackgroundTransparency = 1
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = sliderFrame

			local valueLabel = Instance.new('TextLabel')
			valueLabel.Name = "Value"
			valueLabel.Text = tostring(min)
			valueLabel.TextColor3 = Colors.text
			valueLabel.TextSize = 12
			valueLabel.Font = font
			valueLabel.Size = UDim2.new(1, 0, 0, 10)
			valueLabel.Position = UDim2.new(0, 0, 0, 0)
			valueLabel.BackgroundTransparency = 1
			valueLabel.TextXAlignment = Enum.TextXAlignment.Right
			valueLabel.Parent = sliderFrame

			local sliderBackground = Instance.new('Frame')
			sliderBackground.Name = "Background"
			sliderBackground.Size = UDim2.new(1, 0, 0, 10)
			sliderBackground.Position = UDim2.new(0, 0, 0, 25)
			sliderBackground.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
			sliderBackground.BorderSizePixel = 0

			local bgCorner = Instance.new('UICorner')
			bgCorner.CornerRadius = UDim.new(0, 5)
			bgCorner.Parent = sliderBackground

			local sliderFill = Instance.new('Frame')
			sliderFill.Name = "Fill"
			sliderFill.Size = UDim2.new(0, 0, 1, 0)
			sliderFill.BackgroundColor3 = Color3.new(0, 0.5, 1)
			sliderFill.BorderSizePixel = 0

			local fillCorner = Instance.new('UICorner')
			fillCorner.CornerRadius = UDim.new(0, 5)
			fillCorner.Parent = sliderFill

			sliderFill.Parent = sliderBackground
			sliderBackground.Parent = sliderFrame

			local isDragging = false

			local function updateSlider(input)
				if not sliderBackground then return end

				local relativeX = (input.Position.X - sliderBackground.AbsolutePosition.X) / sliderBackground.AbsoluteSize.X
				relativeX = math.clamp(relativeX, 0, 1)

				local value = min + (max - min) * relativeX
				value = math.floor(value)

				sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
				valueLabel.Text = tostring(value)

				if Callback then
					Callback(value)
				end
			end

			sliderBackground.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					isDragging = true
					updateSlider(input)
				end
			end)

			sliderBackground.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					isDragging = false
				end
			end)

			game:GetService("UserInputService").InputChanged:Connect(function(input)
				if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					updateSlider(input)
				end
			end)

			return addElement(sliderFrame)
		end

		function categoryMethods:addDropDownList(Name:string, Text:string, Options:{string}, Callback:(string)->nil)
			local dropDownFrame = Instance.new('Frame')
			dropDownFrame.Name = Name
			dropDownFrame.Size = UDim2.new(1, 0, 0, 50)
			dropDownFrame.BackgroundTransparency = 1
			dropDownFrame.ClipsDescendants = true

			-- Заголовок
			local label = Instance.new('TextLabel')
			label.Name = "Label"
			label.Text = Text
			label.TextColor3 = Colors.text
			label.TextSize = 14
			label.Font = font
			label.Size = UDim2.new(1, 0, 0, 15)
			label.BackgroundTransparency = 1
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = dropDownFrame

			-- Основная кнопка выпадающего списка
			local dropDownButton = Instance.new('TextButton')
			dropDownButton.Name = "Button"
			dropDownButton.Text = "Выберите..."
			dropDownButton.TextColor3 = Colors.text
			dropDownButton.TextSize = 14
			dropDownButton.Font = font
			dropDownButton.Size = UDim2.new(1, 0, 0, 30)
			dropDownButton.Position = UDim2.new(0, 0, 0, 20)
			dropDownButton.BackgroundColor3 = Colors.Disabled
			dropDownButton.AutoButtonColor = false
			dropDownButton.MouseEnter:Connect(function() Tweens.Select(dropDownButton,true) end)
			dropDownButton.MouseLeave:Connect(function() Tweens.Select(dropDownButton,false) end)

			-- Добавляем стрелочку для отличия от обычной кнопки
			local arrow = Instance.new('TextLabel')
			arrow.Name = "Arrow"
			arrow.Text = "▼"
			arrow.TextColor3 = Colors.text
			arrow.TextSize = 10
			arrow.Font = font
			arrow.Size = UDim2.new(0, 20, 1, 0)
			arrow.Position = UDim2.new(1, -25, 0, 0)
			arrow.BackgroundTransparency = 1
			arrow.TextXAlignment = Enum.TextXAlignment.Center
			arrow.Parent = dropDownButton

			local corner = Instance.new('UICorner')
			corner.CornerRadius = UDim.new(0, 6)
			corner.Parent = dropDownButton

			-- Фрейм для списка опций
			local listFrame = Instance.new('Frame')
			listFrame.Name = "ListFrame"
			listFrame.Size = UDim2.new(1, 0, 0, 0)
			listFrame.Position = UDim2.new(0, 0, 0, 55)
			listFrame.BackgroundTransparency = 1
			listFrame.BorderSizePixel = 0
			listFrame.Visible = false
			listFrame.ClipsDescendants = true

			local listCorner = Instance.new('UICorner')
			listCorner.CornerRadius = UDim.new(0, 6)
			listCorner.Parent = listFrame

			-- Прокручиваемый фрейм для опций
			local scrollFrame = Instance.new('ScrollingFrame')
			scrollFrame.Name = "ScrollFrame"
			scrollFrame.Size = UDim2.new(1, 0, 1, 0)
			scrollFrame.BackgroundTransparency = 1
			scrollFrame.BorderSizePixel = 0
			scrollFrame.ScrollBarThickness = 1
			scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
			scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

			local listLayout = Instance.new('UIListLayout')
			listLayout.SortOrder = Enum.SortOrder.LayoutOrder
			listLayout.Padding = UDim.new(0, 2)
			listLayout.Parent = scrollFrame

			scrollFrame.Parent = listFrame
			listFrame.Parent = dropDownFrame
			dropDownButton.Parent = dropDownFrame

			local isOpen = false
			local selectedOption = ""
			local ignoreNextOutsideClick = false -- Флаг для игнорирования клика

			-- Функция для обновления высоты списка
			local function updateListHeight()
				if #Options == 0 then return end

				local maxHeight = math.min(#Options * 30, 150) -- Максимальная высота 150, минимальная по количеству элементов
				listFrame.Size = UDim2.new(1, 0, 0, maxHeight)
			end

			-- Функция для создания кнопок опций
			local function createOptionButtons()
				for _, option in pairs(Options) do
					local optionButton = Instance.new('TextButton')
					optionButton.Name = option
					optionButton.Text = option
					optionButton.TextColor3 = Colors.text
					optionButton.TextSize = 14
					optionButton.Font = font
					optionButton.Size = UDim2.new(1, 0, 0, 28)
					optionButton.BackgroundColor3 = Colors.Disabled
					optionButton.AutoButtonColor = false

					local optionCorner = Instance.new('UICorner')
					optionCorner.CornerRadius = UDim.new(0, 4)
					optionCorner.Parent = optionButton

					optionButton.MouseButton1Down:Connect(function()
						-- Устанавливаем флаг, чтобы игнорировать следующий внешний клик
						ignoreNextOutsideClick = true
					end)

					optionButton.MouseButton1Click:Connect(function()
						selectedOption = option

						if Callback then
							task.spawn(Callback,option)                       
						end

						dropDownButton.Text = "  " .. option
						isOpen = false
						arrow.Text = "▼"
						Tweens.ToggleColor(dropDownButton, false)
						TS:Create(dropDownFrame,TweenInfo.new(0.3),{Size = UDim2.new(1, 0, 0, 50)}):Play()
						task.wait(0.3)
						listFrame.Visible = false
					end)

					optionButton.MouseEnter:Connect(function() Tweens.Select(optionButton,true) end)
					optionButton.MouseLeave:Connect(function() Tweens.Select(optionButton,false) end)

					optionButton.Parent = scrollFrame
				end
			end

			-- Создаем кнопки опций
			createOptionButtons()
			updateListHeight()

			-- Обработчик клика по основной кнопке
			dropDownButton.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				Tweens.ToggleColor(dropDownButton, isOpen)

				if isOpen then
					listFrame.Visible = true
					arrow.Text = "▲"
					-- Увеличиваем размер фрейма, чтобы вместить список
					TS:Create(dropDownFrame,TweenInfo.new(0.3),{Size = UDim2.new(1, 0, 0, 55 + listFrame.Size.Y.Offset)}):Play()
				else
					arrow.Text = "▼"
					-- Возвращаем исходный размер
					TS:Create(dropDownFrame,TweenInfo.new(0.3),{Size = UDim2.new(1, 0, 0, 50)}):Play()
					task.wait(0.3)
					listFrame.Visible = false
				end

				-- Обновляем LayoutOrder всех последующих элементов
				if curentCategory == Name then
					local CanvasSize = ContentFrame.UIListLayout.AbsoluteContentSize
					ContentFrame.CanvasSize = UDim2.new(0, 0, 0, CanvasSize.Y)
				end
			end)

			-- Закрытие списка при клике вне его области
			local function handleOutsideClick(input, gameProcessed)
				if gameProcessed then return end
				if not isOpen then return end
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

				-- Если был клик на кнопке опции, игнорируем этот клик
				if ignoreNextOutsideClick then
					ignoreNextOutsideClick = false
					return
				end

				local mousePos = game:GetService("UserInputService"):GetMouseLocation()
				local dropDownAbsolutePos = dropDownFrame.AbsolutePosition
				local dropDownAbsoluteSize = dropDownFrame.AbsoluteSize

				-- Проверяем, находится ли мышь внутри всего dropdown фрейма (включая список)
				if mousePos.X >= dropDownAbsolutePos.X and mousePos.X <= dropDownAbsolutePos.X + dropDownAbsoluteSize.X and
					mousePos.Y >= dropDownAbsolutePos.Y and mousePos.Y <= dropDownAbsolutePos.Y + dropDownAbsoluteSize.Y then
					return -- Мышь внутри dropdown, не закрываем
				end

				-- Закрываем dropdown
				isOpen = false
				arrow.Text = "▼"
				Tweens.ToggleColor(dropDownButton, false)
				TS:Create(dropDownFrame,TweenInfo.new(0.3),{Size = UDim2.new(1, 0, 0, 50)}):Play()
				task.wait(0.3)
				listFrame.Visible = false
			end

			UIS.InputBegan:Connect(handleOutsideClick)

			-- Если есть опции по умолчанию, выбираем первую
			if #Options > 0 then
				selectedOption = Options[1]
				dropDownButton.Text = "  " .. Options[1]
			end

			return addElement(dropDownFrame)
		end

		-- Метод для добавления метки
		function categoryMethods:addLabel(Name:string, Text:string)
			local label = Instance.new('TextLabel')
			label.Name = Name
			label.Text = Text
			label.TextColor3 = Colors.text
			label.TextSize = 14
			label.Font = font
			label.Size = UDim2.new(1, 0, 0, 25)
			label.BackgroundTransparency = 1
			label.TextXAlignment = Enum.TextXAlignment.Left

			return addElement(label)
		end

		-- Метод для добавления разделителя
		function categoryMethods:addSeparator(Name:string, Thickness:number?)
			local separator = Instance.new('Frame')
			separator.Name = Name
			separator.Size = UDim2.new(1, 0, 0, Thickness or 1)
			separator.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
			separator.BackgroundTransparency = 0.5

			return addElement(separator)
		end

		-- Обработчик клика по категории
		categoryButton.MouseButton1Click:Connect(function()
			if ContentFrame:FindFirstChild('Welcome') then ContentFrame:FindFirstChild('Welcome'):Destroy() end
			-- Скрываем элементы предыдущей категории
			if curentCategory then
				local prevBuffer = categoriesBufferFrame:FindFirstChild(curentCategory)
				if prevBuffer then
					for _, element in pairs(ContentFrame:GetChildren()) do
						if element:IsA("GuiObject") and element.Name ~= "UIListLayout" then
							element.Parent = prevBuffer
						end
					end
				end

				-- Убираем выделение с предыдущей кнопки
				local prevButton = CategoriesFrame:FindFirstChild(curentCategory)
				if prevButton then
					Tweens.ToggleColor(prevButton, false)
				end
			end

			-- Показываем элементы выбранной категории
			curentCategory = Name

			for _, element in pairs(categoryBufferFrame:GetChildren()) do
				if element:IsA("GuiObject") then
					element.Parent = ContentFrame
				end
			end

			-- Обновляем выделение кнопки
			Tweens.ToggleColor(categoryButton, true)

			-- Обновляем размер канваса
			local CanvasSize = ContentFrame.UIListLayout.AbsoluteContentSize
			ContentFrame.CanvasSize = UDim2.new(0, 0, 0, CanvasSize.Y)
		end)

		-- Обновляем размер канваса категорий
		local CategoriesCanvasSize = CategoriesFrame.UIListLayout.AbsoluteContentSize
		CategoriesFrame.CanvasSize = UDim2.new(0, 0, 0, CategoriesCanvasSize.Y)

		-- Если это первая категория, делаем ее активной
		if not curentCategory then
			curentCategory = Name
			Tweens.ToggleColor(categoryButton, true)
		end

		-- Сохраняем категорию в общую таблицу и возвращаем методы
		categories[Name] = categoryMethods
		return categoryMethods
	end

	function WindowFunctions:toggle()
		Window.Visible = not Window.Visible
	end

	function WindowFunctions:Destroy()
		ScreenGUI:Destroy()
	end

	Window.Parent = ScreenGUI
	WindowFunctions['window'] = Window 
	setmetatable(API, WindowFunctions)
	return WindowFunctions
end

function API.CreateEmptyWindow(Name:string,Size:UDim2?,WelcomeText:string?)
	local ScreenGUI = Instance.new("ScreenGui")
	ScreenGUI.Name = tostring(math.round(Random.new():NextNumber()*100000000))
	ScreenGUI.IgnoreGuiInset = true
	ScreenGUI.ResetOnSpawn = false
	ScreenGUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

	local Window = Instance.new('Frame')
	Window.Size = Size or UDim2.new(0, 550, 0, 450)
	Window.AnchorPoint = Vector2.new(0.5,0.5)
	Window.Position = UDim2.new(0.5,0,0.5,0)
	Window.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	Window.BorderSizePixel = 0
	Window.ClipsDescendants = true
	Window.Active = true
	local WindowCorner = Instance.new('UICorner')
	WindowCorner.CornerRadius = UDim.new(0, 8)
	WindowCorner.Parent = Window

	local Title = Instance.new('TextLabel')
	Title.Size = UDim2.new(1,0,0,40)
	Title.Text = Name
	Title.TextColor3 = Colors.text
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Font = font
	Title.TextSize = 18
	Title.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
	Title.Parent = Window
	local TitleCorner = Instance.new("UICorner")
	TitleCorner.CornerRadius = UDim.new(0, 8)
	TitleCorner.Parent = Title

	local dragging = false
	local dragStartPos, frameStartPos
	Title.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStartPos = input.Position
			frameStartPos = Window.Position
		end
	end)
	Title.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStartPos
			Window.Position = UDim2.new(
				frameStartPos.X.Scale, 
				frameStartPos.X.Offset + delta.X,
				frameStartPos.Y.Scale, 
				frameStartPos.Y.Offset + delta.Y
			)
		end
	end)

	local ContentFrame = Instance.new('ScrollingFrame')
	ContentFrame.BackgroundTransparency = 1
	ContentFrame.Size = UDim2.new(1,-5,1,-50)
	ContentFrame.Position = UDim2.new(0,0,0,45)
	ContentFrame.ScrollBarThickness = 1
	ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	local ContentList = Instance.new("UIListLayout")
	ContentList.Padding = UDim.new(0,12)
	ContentList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	ContentList.SortOrder = Enum.SortOrder.LayoutOrder
	ContentList.Parent = ContentFrame
	ContentFrame.Parent = Window
	local welcomeLabel = Instance.new('TextLabel')
	welcomeLabel.Name = 'Welcome'
	welcomeLabel.Text = WelcomeText or ''
	welcomeLabel.TextColor3 = Colors.text
	welcomeLabel.Font = font
	welcomeLabel.TextSize = 25
	welcomeLabel.Size = UDim2.new(1,0,0,30)
	welcomeLabel.BackgroundTransparency = 1
	welcomeLabel.Parent = ContentFrame

	local WindowFunctions = {}

	local function addElement(element, order)
		element.LayoutOrder = order or #ContentFrame:GetChildren()
		element.Parent = ContentFrame

		return element
	end

	-- Метод для добавления кнопки
	function WindowFunctions:addButton(Name:string, Text:string, Callback:()->nil)
		local button = Instance.new('TextButton')
		button.Name = Name
		button.Text = Text
		button.TextColor3 = Colors.text
		button.TextSize = 14
		button.Font = font
		button.Size = UDim2.new(1, 0, 0, 35)
		button.BackgroundColor3 = Colors.Disabled
		button.AutoButtonColor = false

		local corner = Instance.new('UICorner')
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = button

		if Callback then
			button.MouseButton1Down:Connect(function()
				Tweens.ToggleColor(button,true)
			end)
			button.MouseButton1Up:Connect(function()
				Tweens.ToggleColor(button,false)
				Callback()
			end)
		end

		button.MouseEnter:Connect(function() Tweens.Select(button,true) end)
		button.MouseLeave:Connect(function() Tweens.Select(button,false) end)

		return addElement(button)
	end

	-- Метод для добавления текстового поля
	function WindowFunctions:addTextBox(Name:string, Basic:string, Placeholder:string, Callback:(string)->nil)
		local textBox = Instance.new('TextBox')
		textBox.Name = Name
		textBox.Text = Basic or ""
		textBox.PlaceholderText = Placeholder or "..."
		textBox.TextColor3 = Colors.text
		textBox.TextSize = 14
		textBox.Font = font
		textBox.Size = UDim2.new(1, 0, 0, 35)
		textBox.BackgroundColor3 = Colors.Disabled
		textBox.ClearTextOnFocus = false

		local corner = Instance.new('UICorner')
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = textBox

		if Callback then
			textBox.Focused:Connect(function()
				Tweens.ToggleColor(textBox,true)
			end)
			textBox.FocusLost:Connect(function(enterPressed)
				Tweens.ToggleColor(textBox,false)
				Callback(textBox.Text)
			end)
		end

		textBox.MouseEnter:Connect(function() Tweens.Select(textBox,true) end)
		textBox.MouseLeave:Connect(function() Tweens.Select(textBox,false) end)

		return addElement(textBox)
	end

	-- Метод для добавления переключателя
	function WindowFunctions:addToggle(Name:string, Text:string, Callback:(boolean)->nil)
		local toggleFrame = Instance.new('Frame')
		toggleFrame.Name = Name
		toggleFrame.Size = UDim2.new(1, 0, 0, 35)
		toggleFrame.BackgroundTransparency = 1

		local label = Instance.new('TextLabel')
		label.Name = "Label"
		label.Text = Text
		label.TextColor3 = Colors.text
		label.TextSize = 14
		label.Font = font
		label.Size = UDim2.new(0.40, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = toggleFrame

		local toggleButton = Instance.new('TextButton')
		toggleButton.Name = "Toggle"
		toggleButton.Text = ""
		toggleButton.Size = UDim2.new(0.60, 0, 0, 25)
		toggleButton.Position = UDim2.new(1, 0, 0.5, 0)
		toggleButton.AnchorPoint = Vector2.new(1, 0.5)
		toggleButton.BackgroundColor3 = Colors.Disabled
		toggleButton.AutoButtonColor = false

		local corner = Instance.new('UICorner')
		corner.CornerRadius = UDim.new(0, 4)
		corner.Parent = toggleButton

		local isToggled = false

		toggleButton.MouseButton1Click:Connect(function()
			isToggled = not isToggled
			Tweens.ToggleColor(toggleButton,isToggled)
			if Callback then
				Callback(isToggled)
			end
		end)
		toggleButton.MouseEnter:Connect(function() Tweens.Select(toggleButton,true) end)
		toggleButton.MouseLeave:Connect(function() Tweens.Select(toggleButton,false) end)

		toggleButton.Parent = toggleFrame

		return addElement(toggleFrame)
	end

	-- Метод для добавления слайдера
	function WindowFunctions:addSlider(Name:string, Text:string, min:number, max:number, Callback:(number)->nil)
		local sliderFrame = Instance.new('Frame')
		sliderFrame.Name = Name
		sliderFrame.Size = UDim2.new(1, 0, 0, 50)
		sliderFrame.BackgroundTransparency = 1

		local label = Instance.new('TextLabel')
		label.Name = "Label"
		label.Text = Text
		label.TextColor3 = Colors.text
		label.TextSize = 14
		label.Font = font
		label.Size = UDim2.new(1, 0, 0, 15)
		label.BackgroundTransparency = 1
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = sliderFrame

		local valueLabel = Instance.new('TextLabel')
		valueLabel.Name = "Value"
		valueLabel.Text = tostring(min)
		valueLabel.TextColor3 = Colors.text
		valueLabel.TextSize = 12
		valueLabel.Font = font
		valueLabel.Size = UDim2.new(1, 0, 0, 10)
		valueLabel.Position = UDim2.new(0, 0, 0, 0)
		valueLabel.BackgroundTransparency = 1
		valueLabel.TextXAlignment = Enum.TextXAlignment.Right
		valueLabel.Parent = sliderFrame

		local sliderBackground = Instance.new('Frame')
		sliderBackground.Name = "Background"
		sliderBackground.Size = UDim2.new(1, 0, 0, 10)
		sliderBackground.Position = UDim2.new(0, 0, 0, 25)
		sliderBackground.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
		sliderBackground.BorderSizePixel = 0

		local bgCorner = Instance.new('UICorner')
		bgCorner.CornerRadius = UDim.new(0, 5)
		bgCorner.Parent = sliderBackground

		local sliderFill = Instance.new('Frame')
		sliderFill.Name = "Fill"
		sliderFill.Size = UDim2.new(0, 0, 1, 0)
		sliderFill.BackgroundColor3 = Color3.new(0, 0.5, 1)
		sliderFill.BorderSizePixel = 0

		local fillCorner = Instance.new('UICorner')
		fillCorner.CornerRadius = UDim.new(0, 5)
		fillCorner.Parent = sliderFill

		sliderFill.Parent = sliderBackground
		sliderBackground.Parent = sliderFrame

		local isDragging = false

		local function updateSlider(input)
			if not sliderBackground then return end

			local relativeX = (input.Position.X - sliderBackground.AbsolutePosition.X) / sliderBackground.AbsoluteSize.X
			relativeX = math.clamp(relativeX, 0, 1)

			local value = min + (max - min) * relativeX
			value = math.floor(value)

			sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
			valueLabel.Text = tostring(value)

			if Callback then
				Callback(value)
			end
		end

		sliderBackground.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				isDragging = true
				updateSlider(input)
			end
		end)

		sliderBackground.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				isDragging = false
			end
		end)

		game:GetService("UserInputService").InputChanged:Connect(function(input)
			if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				updateSlider(input)
			end
		end)

		return addElement(sliderFrame)
	end

	function WindowFunctions:addDropDownList(Name:string, Text:string, Options:{string}, Callback:(string)->nil)
		local dropDownFrame = Instance.new('Frame')
		dropDownFrame.Name = Name
		dropDownFrame.Size = UDim2.new(1, 0, 0, 50)
		dropDownFrame.BackgroundTransparency = 1
		dropDownFrame.ClipsDescendants = true

		local label = Instance.new('TextLabel')
		label.Name = "Label"
		label.Text = Text
		label.TextColor3 = Colors.text
		label.TextSize = 14
		label.Font = font
		label.Size = UDim2.new(1, 0, 0, 15)
		label.BackgroundTransparency = 1
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = dropDownFrame

		local dropDownButton = Instance.new('TextButton')
		dropDownButton.Name = "Button"
		dropDownButton.Text = "Выберите..."
		dropDownButton.TextColor3 = Colors.text
		dropDownButton.TextSize = 14
		dropDownButton.Font = font
		dropDownButton.Size = UDim2.new(1, 0, 0, 30)
		dropDownButton.Position = UDim2.new(0, 0, 0, 20)
		dropDownButton.BackgroundColor3 = Colors.Disabled
		dropDownButton.AutoButtonColor = false
		dropDownButton.MouseEnter:Connect(function() Tweens.Select(dropDownButton,true) end)
		dropDownButton.MouseLeave:Connect(function() Tweens.Select(dropDownButton,false) end)

		local arrow = Instance.new('TextLabel')
		arrow.Name = "Arrow"
		arrow.Text = "▼"
		arrow.TextColor3 = Colors.text
		arrow.TextSize = 10
		arrow.Font = font
		arrow.Size = UDim2.new(0, 20, 1, 0)
		arrow.Position = UDim2.new(1, -25, 0, 0)
		arrow.BackgroundTransparency = 1
		arrow.TextXAlignment = Enum.TextXAlignment.Center
		arrow.Parent = dropDownButton

		local corner = Instance.new('UICorner')
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = dropDownButton

		local listFrame = Instance.new('Frame')
		listFrame.Name = "ListFrame"
		listFrame.Size = UDim2.new(1, 0, 0, 0)
		listFrame.Position = UDim2.new(0, 0, 0, 55)
		listFrame.BackgroundTransparency = 1
		listFrame.BorderSizePixel = 0
		listFrame.Visible = false
		listFrame.ClipsDescendants = true

		local listCorner = Instance.new('UICorner')
		listCorner.CornerRadius = UDim.new(0, 6)
		listCorner.Parent = listFrame

		local scrollFrame = Instance.new('ScrollingFrame')
		scrollFrame.Name = "ScrollFrame"
		scrollFrame.Size = UDim2.new(1, 0, 1, 0)
		scrollFrame.BackgroundTransparency = 1
		scrollFrame.BorderSizePixel = 0
		scrollFrame.ScrollBarThickness = 1
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

		local listLayout = Instance.new('UIListLayout')
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
		listLayout.Padding = UDim.new(0, 2)
		listLayout.Parent = scrollFrame

		scrollFrame.Parent = listFrame
		listFrame.Parent = dropDownFrame
		dropDownButton.Parent = dropDownFrame

		local isOpen = false
		local selectedOption = ""
		local ignoreNextOutsideClick = false

		local function updateListHeight()
			if #Options == 0 then return end

			local maxHeight = math.min(#Options * 30, 150)
			listFrame.Size = UDim2.new(1, 0, 0, maxHeight)
		end

		local function createOptionButtons()
			for _, option in pairs(Options) do
				local optionButton = Instance.new('TextButton')
				optionButton.Name = option
				optionButton.Text = option
				optionButton.TextColor3 = Colors.text
				optionButton.TextSize = 14
				optionButton.Font = font
				optionButton.Size = UDim2.new(1, 0, 0, 28)
				optionButton.BackgroundColor3 = Colors.Disabled
				optionButton.AutoButtonColor = false

				local optionCorner = Instance.new('UICorner')
				optionCorner.CornerRadius = UDim.new(0, 4)
				optionCorner.Parent = optionButton

				optionButton.MouseButton1Down:Connect(function()
					ignoreNextOutsideClick = true
				end)

				optionButton.MouseButton1Click:Connect(function()
					selectedOption = option

					if Callback then
						task.spawn(Callback,option)                       
					end

					dropDownButton.Text = "  " .. option
					isOpen = false
					arrow.Text = "▼"
					Tweens.ToggleColor(dropDownButton, false)
					TS:Create(dropDownFrame,TweenInfo.new(0.3),{Size = UDim2.new(1, 0, 0, 50)}):Play()
					task.wait(0.3)
					listFrame.Visible = false
				end)

				optionButton.MouseEnter:Connect(function() Tweens.Select(optionButton,true) end)
				optionButton.MouseLeave:Connect(function() Tweens.Select(optionButton,false) end)

				optionButton.Parent = scrollFrame
			end
		end
    
		createOptionButtons()
		updateListHeight()

		dropDownButton.MouseButton1Click:Connect(function()
			isOpen = not isOpen
			Tweens.ToggleColor(dropDownButton, isOpen)

			if isOpen then
				listFrame.Visible = true
				arrow.Text = "▲"
				TS:Create(dropDownFrame,TweenInfo.new(0.3),{Size = UDim2.new(1, 0, 0, 55 + listFrame.Size.Y.Offset)}):Play()
			else
				arrow.Text = "▼"
				TS:Create(dropDownFrame,TweenInfo.new(0.3),{Size = UDim2.new(1, 0, 0, 50)}):Play()
				task.wait(0.3)
				listFrame.Visible = false
			end

			local CanvasSize = ContentFrame.UIListLayout.AbsoluteContentSize
			ContentFrame.CanvasSize = UDim2.new(0, 0, 0, CanvasSize.Y)
		end)

		local function handleOutsideClick(input, gameProcessed)
			if gameProcessed then return end
			if not isOpen then return end
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

			if ignoreNextOutsideClick then
				ignoreNextOutsideClick = false
				return
			end

			local mousePos = game:GetService("UserInputService"):GetMouseLocation()
			local dropDownAbsolutePos = dropDownFrame.AbsolutePosition
			local dropDownAbsoluteSize = dropDownFrame.AbsoluteSize

			if mousePos.X >= dropDownAbsolutePos.X and mousePos.X <= dropDownAbsolutePos.X + dropDownAbsoluteSize.X and
				mousePos.Y >= dropDownAbsolutePos.Y and mousePos.Y <= dropDownAbsolutePos.Y + dropDownAbsoluteSize.Y then
				return
			end

			isOpen = false
			arrow.Text = "▼"
			Tweens.ToggleColor(dropDownButton, false)
			TS:Create(dropDownFrame,TweenInfo.new(0.3),{Size = UDim2.new(1, 0, 0, 50)}):Play()
			task.wait(0.3)
			listFrame.Visible = false
		end

		UIS.InputBegan:Connect(handleOutsideClick)

		if #Options > 0 then
			selectedOption = Options[1]
			dropDownButton.Text = "  " .. Options[1]
		end

		return addElement(dropDownFrame)
	end

	function WindowFunctions:addLabel(Name:string, Text:string)
		local label = Instance.new('TextLabel')
		label.Name = Name
		label.Text = Text
		label.TextColor3 = Colors.text
		label.TextSize = 14
		label.Font = font
		label.Size = UDim2.new(1, 0, 0, 25)
		label.BackgroundTransparency = 1
		label.TextXAlignment = Enum.TextXAlignment.Left

		return addElement(label)
	end

	-- Метод для добавления разделителя
	function WindowFunctions:addSeparator(Name:string, Thickness:number?)
		local separator = Instance.new('Frame')
		separator.Name = Name
		separator.Size = UDim2.new(1, 0, 0, Thickness or 1)
		separator.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
		separator.BackgroundTransparency = 0.5

		return addElement(separator)
	end

	function WindowFunctions:toggle()
		Window.Visible = not Window.Visible
	end

	function WindowFunctions:Destroy()
		ScreenGUI:Destroy()
	end

	Window.Parent = ScreenGUI
	WindowFunctions['window'] = Window 
	setmetatable(API, WindowFunctions)
	return WindowFunctions
end

local notificationGUI = Instance.new('ScreenGui')
notificationGUI.Name = tostring(math.round(Random.new():NextNumber()*1000000000))
notificationGUI.IgnoreGuiInset = true
notificationGUI.ResetOnSpawn = false
notificationGUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local notifications = {}
function API.sendNotification(Text:string, Time:number?, Color:Color3?)
	task.spawn(function()
		for i,v in pairs(notifications) do
			local tween = TS:Create(v,TweenInfo.new(0.3),{Position = UDim2.new(0,10,1,(-i-1)*45-(i+1)*10)})
			tween:Play()
		end
		local notificationFrame = Instance.new('Frame')
		notificationFrame.Size = UDim2.new(0,200,0,45)
		notificationFrame.Position = UDim2.new(0,-220,1,-55)
		notificationFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
		local notificationFrameCorner = Instance.new('UICorner')
		notificationFrameCorner.CornerRadius = UDim.new(0,9)
		notificationFrameCorner.Parent = notificationFrame
		local notificationColor = Instance.new('Frame')
		notificationColor.Size = UDim2.new(0,15,1,0)
		notificationColor.BackgroundColor3 = Color or Color3.new(0, 0, 1)
		notificationColor.BorderSizePixel = 0
		notificationColor.Parent = notificationFrame
		local notificationLabel = Instance.new('TextLabel')
		notificationLabel.Size = UDim2.new(1,-15,1,0)
		notificationLabel.Position = UDim2.new(0,15,0,0)
		notificationLabel.Text = Text
		notificationLabel.TextSize = 14
		notificationLabel.TextColor3 = Color3.new(1,1,1)
		notificationLabel.Font = font
		notificationLabel.BackgroundTransparency = 1
		notificationLabel.Parent = notificationFrame
		table.insert(notifications,1,notificationFrame)
		task.wait(0.2)
		notificationFrame.Parent = notificationGUI
		local addTween = TS:Create(notificationFrame,TweenInfo.new(0.3),{Position = UDim2.new(0,10,1,-55)})
		addTween:Play()

		task.wait(Time or 3)
		table.remove(notifications,table.find(notifications,notificationFrame))

		local removeTween = TS:Create(notificationFrame,TweenInfo.new(0.3),{Position = UDim2.new(0,-220,1,notificationFrame.Position.Y.Offset)})
		removeTween:Play()
		task.wait(0.4)
		notificationFrame:Destroy()
	end)
end

return API
