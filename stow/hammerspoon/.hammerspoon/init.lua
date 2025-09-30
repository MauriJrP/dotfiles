-- Example: Hold ctrl+alt+C for Calculator
hs.hotkey.bind({"ctrl", "alt"}, "s",
  function()
    local app = hs.application.find("Spotify")
    if not app then
      hs.application.launchOrFocus("Spotify")
    else
      app:activate()
      app:unhide()
    end
  end,
  function()
    local app = hs.application.find("Spotify")
    if app then app:hide() end
  end
)

local function bindRepeat(mods, key, action)
  local timer = nil
  hs.hotkey.bind(mods, key,
    function() timer = hs.timer.doEvery(0.05, action) end,
    function() if timer then timer:stop(); timer = nil end end
  )
end

local step = 10

-- 🔹 Move controls (ctrl+alt+cmd + arrows)
bindRepeat({"ctrl","alt","cmd"}, "Right", function()
  local win = hs.window.focusedWindow(); if not win then return end
  local f, sf = win:frame(), win:screen():frame()
  f.x = math.min(f.x + step, (sf.x + sf.w) - f.w)
  win:setFrame(f)
end)

bindRepeat({"ctrl","alt","cmd"}, "Down", function()
  local win = hs.window.focusedWindow(); if not win then return end
  local f, sf = win:frame(), win:screen():frame()
  f.y = math.min(f.y + step, (sf.y + sf.h) - f.h)
  win:setFrame(f)
end)

-- Move Left
bindRepeat({"ctrl","alt","cmd"}, "Left", function()
  local win = hs.window.focusedWindow(); if not win then return end
  local f, sf = win:frame(), win:screen():frame()
  f.x = math.max(f.x - step, sf.x)
  win:setFrame(f)
end)

-- Move Up
bindRepeat({"ctrl","alt","cmd"}, "Up", function()
  local win = hs.window.focusedWindow(); if not win then return end
  local f, sf = win:frame(), win:screen():frame()
  f.y = math.max(f.y - step, sf.y)
  win:setFrame(f)
end)

-- 🔹 Resize controls (ctrl+alt + arrows)
-- Shrink width (Left), Expand width (Right)
bindRepeat({"ctrl","alt"}, "Left", function()
  local win = hs.window.focusedWindow(); if not win then return end
  local f = win:frame()
  f.w = math.max(f.w - step, 100)
  win:setFrame(f)
end)

bindRepeat({"ctrl","alt"}, "Right", function()
  local win = hs.window.focusedWindow(); if not win then return end
  local f, sf = win:frame(), win:screen():frame()
  f.w = math.min(f.w + step, (sf.x + sf.w) - f.x)
  win:setFrame(f)
end)

-- Shrink height (Up), Expand height (Down)
bindRepeat({"ctrl","alt"}, "Up", function()
  local win = hs.window.focusedWindow(); if not win then return end
  local f = win:frame()
  f.h = math.max(f.h - step, 100)
  win:setFrame(f)
end)

bindRepeat({"ctrl","alt"}, "Down", function()
  local win = hs.window.focusedWindow(); if not win then return end
  local f, sf = win:frame(), win:screen():frame()
  f.h = math.min(f.h + step, (sf.y + sf.h) - f.y)
  win:setFrame(f)
end)

