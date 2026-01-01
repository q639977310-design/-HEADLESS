local Translations = {
    -- 功能类
    ["Visualize Bomber Explosion Radius"] = "显示bommer爆炸范围",
    ["Shows a circle around bombers showing the explosion radius."] = "在轰炸机周围显示爆炸范围的圆圈。",
    ["Target ESP"] = "目标透视",
    ["Shows the zombie its currently targeting."] = "显示当前被瞄准的僵尸。",
    ["Show Aim Position"] = "显示瞄准位置",
    ["Shows a red dot at the aim position."] = "在瞄准位置显示一个红点。",
    ["Hand Mortar Timing"] = "手持应该是手炮计时",
    ["Shows The Timer Of The Mortar Before Blowing Up."] = "显示应该是手炮爆炸前的倒计时。",
    ["Auto Shoot Delay"] = "自动射击延迟",
    ["Total time from aiming to firing (seconds). Set higher for smoother rotation."] = "从瞄准到射击的总时间（秒）。数值越高旋转越平滑。",
    ["Prediction"] = "预判",
    ["Lead time in seconds (0.20 is recommended)"] = "提前量（秒），推荐0.20",
    ["Max Target Range"] = "最大目标距离",
    ["Maximum detection range."] = "最大探测范围。",
    ["Use Fov"] = "使用视野范围",
    ["Only target zombies inside the FOV."] = "仅瞄准视野范围内的僵尸。",
    ["Mobile Fov"] = "移动视野",
    ["Fov stays in the middle (can be used in pc too)."] = "视野固定在中间（电脑端也可使用）。",
    ["Gun Mod"] = "枪械修改",
    ["Auto Reload"] = "自动换弹",
    ["Automatically reload."] = "自动重新装弹。",
    ["Shooting"] = "射击",
    ["Select Zombie Types To AutoShoot"] = "选择自动射击的僵尸类型",
    ["Choose which zombie types to target."] = "选择要瞄准的僵尸类型。",
    ["Enable Auto Shoot"] = "开启自动射击",
    ["Enable Auto Shooting for the selected zombie types."] = "为选中的僵尸类型开启自动射击。",
    ["Instant Shoot"] = "瞬发射击",
    ["Instantly shoot selected zombies (No"] = "瞬发射击选中的僵尸（无",
    ["Whitelist"] = "白名单",
    ["Won't shoot bombers if these specific players are within blast radius"] = "若指定玩家在爆炸范围内则不射击轰炸机",
    ["Shoot Near Whitelist"] = "仅向白名单附近射击",
    ["ONLY shoot bombers when these specific players are within blast radius (for Shoot Bomber Near Teammates)"] = "仅当指定玩家在爆炸范围内时射击轰炸机（对应向队友附近的轰炸机射击功能）",
    ["Don't Shoot Bomber Near Teammates"] = "不向队友附近的轰炸机射击",
    ["Won't shoot bombers within the selected studs of teammates."] = "不向队友周围指定单位内的轰炸机射击。",
    ["Shoot Bomber Near Teammates"] = "向队友附近的轰炸机射击",
    ["ONLY shoot bombers when teammates are within the selected studs (opposite of above)."] = "仅当队友在指定单位内时射击轰炸机（与上述功能相反）。",
    ["Don't Shoot Bomber Near Me"] = "不向自己附近的轰炸机射击",
    ["Won't shoot bombers within the selected studs of yourself."] = "不向自己周围指定单位内的轰炸机射击。",
    ["Bomber Safety Radius"] = "轰炸机安全距离",
    ["The Selected Studs to control avoid shooting barrels, and 2 more"] = "设置单位距离以避免射击桶类目标，及其他两项",
    ["Don't Shoot Near"] = "不向附近射击",
    ["Save Players"] = "保护玩家",
    ["Auto Save Players"] = "自动保护玩家",
    ["Shoot Zombies Grabbing The player."] = "射击抓住玩家的僵尸。",
    ["Instant Save Players"] = "立即保护玩家",
    ["Instantly shoot the zombie grabbing the player (No Animations)"] = "立即射击抓住玩家的僵尸（无动画）",
    ["Save Player Delay"] = "保护玩家延迟",
    ["Delay before shooting when saving player (seconds)"] = "保护玩家时射击前的延迟（秒）",
    ["Max Save Players Range"] = "最大保护玩家距离",
    ["Max save players distance."] = "保护玩家的最大距离。",
    ["Auto Save Whitelist"] = "自动保护白名单",
    ["Only save these players"] = "仅保护这些玩家",
    -- 分类类
    ["Gun Modifiers"] = "枪械修改器",
    ["Kill Aura"] = "杀戮光环",
    ["Classes"] = "职业",
    ["Esp"] = "透视",
    ["Players"] = "玩家",
    ["Events"] = "事件",
    ["Misc"] = "杂项",
    ["Search"] = "搜索",
    ["teammates)"] = "队友）",
    ["F"] = "（快捷键F）",
    ["Sabre"] = "军刀",
    ["Heavy"] = "重型",
    ["Guts and Blackpowder"] = "胆量与黑火药",
    ["AUTO HEAD HIT WORKING OP"] = "自动爆头 可用 超强力"
}

local function translateText(text)
    if not text or type(text) ~= "string" then return text end
    if Translations[text] then return Translations[text] end
    local translated = text
    for en, cn in pairs(Translations) do
        translated = translated:gsub(en, cn)
    end
    return translated
end

local translatedElements = {}
local originalTexts = {}

local function safeTranslateElement(element)
    if translatedElements[element] then return end
    
    pcall(function()
        if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
            local currentText = element.Text
            if currentText and currentText ~= "" then
                if not originalTexts[element] then
                    originalTexts[element] = currentText
                end
                
                local translatedText = translateText(currentText)
                if translatedText ~= currentText then
                    element.Text = translatedText
                    translatedElements[element] = true
                end
            end
        end
    end)
end

local function reTranslateAllUI()
    translatedElements = {}
    for _, gui in ipairs(game:GetService("CoreGui"):GetDescendants()) do
        safeTranslateElement(gui)
    end
    local player = game:GetService("Players").LocalPlayer
    if player and player:FindFirstChild("PlayerGui") then
        for _, gui in ipairs(player.PlayerGui:GetDescendants()) do
            safeTranslateElement(gui)
        end
    end
end

local function setupSmartListener()
    local function onTextPropertyChanged(element)
        if translatedElements[element] then
            local currentText = element.Text
            local originalText = originalTexts[element]
            
            if currentText == originalText or translateText(currentText) == currentText then
                translatedElements[element] = nil
                return
            end
            
            local translatedText = translateText(currentText)
            if translatedText ~= currentText then
                element.Text = translatedText
            end
        else
            safeTranslateElement(element)
        end
    end

    local function addSmartListener(parent)
        for _, desc in ipairs(parent:GetDescendants()) do
            safeTranslateElement(desc)
        end
        parent.DescendantAdded:Connect(function(descendant)
            task.wait(0.3)
            safeTranslateElement(descendant)
            
            if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
                descendant:GetPropertyChangedSignal("Text"):Connect(function()
                    task.wait(0.1)
                    onTextPropertyChanged(descendant)
                end)
            end
        end)
    end
    
    pcall(addSmartListener, game:GetService("CoreGui"))
    local player = game:GetService("Players").LocalPlayer
    if player and player:FindFirstChild("PlayerGui") then
        pcall(addSmartListener, player.PlayerGui)
    end
end

local function delayedInitialTranslate()
    task.wait(5)
    reTranslateAllUI()
end

task.wait(2)
setupSmartListener()
delayedInitialTranslate()

local success, err = pcall(function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Guts-and-Blackpowder-Katchi-Hub-AUTO-HEAD-HIT-WORKING-OP-55045"))()
    task.wait(1.5)
    reTranslateAllUI()
end)

if not success then
    warn("加载失败:", err)
end
