------------------------------------------------------------------------------------
-- https://github.com/Hammerspoon/hammerspoon/wiki/Sample-Configurations
------------------------------------------------------------------------------------
local hyper = {"ctrl", "cmd"}
local hyperHyper = {"cmd", "alt", "ctrl"}
------------------------------------------------------------------------------------
local ALMOST_FULLSCREEN_WIDTH_RATIO_SMALL = 0.8
local ALMOST_FULLSCREEN_HEIGHT_RATIO_SMALL = 0.85
local ALMOST_FULLSCREEN_WIDTH_RATIO_BIG = 0.8
local ALMOST_FULLSCREEN_HEIGHT_RATIO_BIG = 0.85
local SCREEN_BIG_WIDTH = 1600
local LAST_ALMOST_FULL_SCREEN_FRAME_ID = ""
local LAST_RIGHT_FRAME_ID = ""
local LAST_LEFT_FRAME_ID = ""
local AUDIO_INPUT_MUTED=false
------------------------------------------------------------------------------------
hs.window.animationDuration = 0
hs.window.setFrameCorrectness = true

------------------------------------------------------------------------------------
-- Toggle an application between being the frontmost app, and being hidden
function toggleApplication(_app)
    local app = hs.appfinder.appFromName(_app)
    if not app then
        hs.application.open(_app)
        return
    end
    local mainwin = app:mainWindow()
    if mainwin then
        if mainwin == hs.window.focusedWindow() then
            mainwin:application():hide()
        else
            mainwin:application():activate(true)
            mainwin:application():unhide()
            mainwin:focus()
        end
    end
end

------------------------------------------------------------------------------------
function mosaicCurrentApplication()
    local mainWin = hs.window.focusedWindow()
    -- hs.alert.show(hs.inspect(mainWin))
    local screen = mainWin:screen()
    local app = mainWin:application()
    local wins = app:allWindows()
    local winsDict = {}
    for j, win in ipairs(wins) do winsDict[win:title()]=win end
    local dimension = 1
    local count = 0
    for j, win in pairs(winsDict) do count = count + 1 end
    -- hs.alert.show(hs.inspect(count))
    if app:name() == "Finder" then count = count -1 end
    if count > 1 then dimension = math.ceil(math.sqrt(count)) end
    hs.grid.GRIDWIDTH = dimension
    hs.grid.GRIDHEIGHT = dimension
    if count == 2 then 
        hs.grid.GRIDWIDTH = 2
        hs.grid.GRIDHEIGHT = 1
    end
    hs.grid.MARGINX = 0
    hs.grid.MARGINY = 0
    local indexWidth = 0
    local indexHeight = 0
    -- for j, win in pairsByKeys(winsDict) do
    for j, win in ipairs(wins) do
        -- hs.alert.show(hs.inspect(j))
        -- win:focus()
        win:setFullScreen(false)
        win:moveToScreen(screen)
        if indexWidth >= dimension then
            indexWidth = 0
            indexHeight = indexHeight + 1
        end
        hs.grid.set(win,indexWidth..","..indexHeight.." 1x1")
        indexWidth = indexWidth + 1
    end
    -- hs.fnutils.map(wins,hs.grid.snap)
    mainWin:focus()
end

------------------------------------------------------------------------------------
function toggleAlmostFullScreen(win)
    if win:id() ~= LAST_ALMOST_FULL_SCREEN_FRAME_ID then
        LAST_ALMOST_FULL_SCREEN_FRAME_ID = win:id()
        LAST_ALMOST_FULL_SCREEN_POSITION = win:frame()
        win = win:setFullScreen(false)
        local max = win:screen():frame()
        local f = win:frame()
        if max.w >= SCREEN_BIG_WIDTH then
            f.w = max.w*ALMOST_FULLSCREEN_WIDTH_RATIO_BIG
            f.h = max.h*ALMOST_FULLSCREEN_HEIGHT_RATIO_BIG
        else
            f.w = max.w*ALMOST_FULLSCREEN_WIDTH_RATIO_SMALL
            f.h = max.h*ALMOST_FULLSCREEN_HEIGHT_RATIO_SMALL
        end
        -- win:setSize({w=f.w,h=f.h}):centerOnScreen()
        -- win::centerOnScreen()
        -- win:setFrame(f)
        win:setFrameInScreenBounds(f):centerOnScreen(win:screen(),false)
        
    else
        win:setFrame(LAST_ALMOST_FULL_SCREEN_POSITION)
        LAST_ALMOST_FULL_SCREEN_FRAME_ID = ""
    end
end

------------------------------------------------------------------------------------
function showApplicationName(win)
    hs.alert.show(win:application():name())
end

------------------------------------------------------------------------------------
function toggleLeft(win)
    if win:id() ~= LAST_LEFT_FRAME_ID then
        LAST_LEFT_FRAME_ID = win:id()
        LAST_LEFT_POSITION = win:frame()
        hs.grid.MARGINX = 0
        hs.grid.MARGINY = 0
        hs.grid.GRIDWIDTH = 2
        hs.grid.GRIDHEIGHT = 1
        win = win:setFullScreen(false)
        hs.grid.set(win,"0,0 1x1")
    else
        win:setFrame(LAST_LEFT_POSITION)
        LAST_LEFT_FRAME_ID = ""
    end
end

------------------------------------------------------------------------------------
function toggleRight(win)
    if win:id() ~= LAST_RIGHT_FRAME_ID then
        LAST_RIGHT_FRAME_ID = win:id()
        LAST_RIGHT_POSITION = win:frame()
        hs.grid.MARGINX = 0
        hs.grid.MARGINY = 0
        hs.grid.GRIDWIDTH = 2
        hs.grid.GRIDHEIGHT = 1
        win = win:setFullScreen(false)
        hs.grid.set(win,"1,0 1x1")
    else
        win:setFrame(LAST_RIGHT_POSITION)
        LAST_RIGHT_FRAME_ID = ""
    end
end

------------------------------------------------------------------------------------
function pairsByKeys (t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
    end
    return iter
end


------------------------------------------------------------------------------------
function toggleInputDevices()
    
    if AUDIO_INPUT_MUTED then
        for index, device in ipairs(hs.audiodevice.allInputDevices()) do 
            device:setInputMuted(false) 
        end
        AUDIO_INPUT_MUTED = false
        hs.alert.show("Mics Active")
        hs.notify.new({title="Mic status", informativeText="Active"})
    else
        for index, device in ipairs(hs.audiodevice.allInputDevices()) do
            device:setInputMuted(true) 
        end
        AUDIO_INPUT_MUTED = true
        hs.alert.show("Mics Muted")
        hs.notify.new({title="Mic status", informativeText="Muted"})
    end
end


------------------------------------------------------------------------------------
hs.hotkey.bind(hyper, 't', function() toggleApplication("iTerm") end)
hs.hotkey.bind(hyper, 's', function() toggleApplication("Safari") end)
hs.hotkey.bind(hyper, 'i', function() toggleApplication("IntelliJ IDEA 15") end)
hs.hotkey.bind(hyper, 'l', function() mosaicCurrentApplication() end)
hs.hotkey.bind(hyper, 'a', function() toggleAlmostFullScreen(hs.window.focusedWindow()) end)
hs.hotkey.bind(hyper, '&', function() toggleLeft(hs.window.focusedWindow()) end)
hs.hotkey.bind(hyper, 'é', function() toggleRight(hs.window.focusedWindow()) end)
hs.hotkey.bind(hyper, 'm', function() device = hs.audiodevice.defaultInputDevice() ; device:setInputMuted(not device:inputMuted()); hs.notify.new({title="Mic status", informativeText=device:inputMuted() and "muted" or "activated"}):send() end)
-- hs.hotkey.bind(hyper, 'm', function() toggleInputDevices() end)

------------------------------------------------------------------------------------
hs.hotkey.bind(hyperHyper, "r", function()
    hs.reload()
    hs.notify.new({title="Hammerspoon", informativeText="Config reloaded"}):send()
end)