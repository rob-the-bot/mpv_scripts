-- Author: Robert Wong
-- Date: 2023-09-22
-- Description: Lua scripts for annotation in MPV
-- The script gets the current frame and the position of the mouse (relative to the frame size of the video)
-- and copy this information to the clipboard
-- Press `g` (lower case) to get the current frame (starts from 0)
-- Press `c` (lower case) to get the position of the mouse
require 'mp'

-- this code was taken from mpv's console.lua:
-- https://github.com/mpv-player/mpv/blob/master/player/lua/console.lua
local function detect_platform()
    local o = {}
    -- Kind of a dumb way of detecting the platform but whatever
    if mp.get_property_native('options/vo-mmcss-profile', o) ~= o then
        return 'windows'
    elseif mp.get_property_native('options/macos-force-dedicated-gpu', o) ~= o then
        return 'macos'
    elseif os.getenv('WAYLAND_DISPLAY') then
        return 'wayland'
    end
    return 'x11'
end

local platform = detect_platform()


-- this is based on mpv-copyTime:
-- https://github.com/Arieleg/mpv-copyTime/blob/master/copyTime.lua
local function get_command()
    if platform == 'x11' then return 'xclip -silent -selection clipboard -in' end
    if platform == 'wayland' then return 'wl-copy' end
    if platform == 'macos' then return 'pbcopy' end
end


-- sets the contents of the clipboard to the given string
-- from https://github.com/CogentRedTester/mpv-clipboard
local function set_clipboard(text)

    if platform == 'windows' then
        mp.commandv("run", "powershell", "set-clipboard", text);

    -- this is based on mpv-copyTime:
    -- https://github.com/Arieleg/mpv-copyTime/blob/master/copyTime.lua
    else
        local pipe = io.popen(get_command(), 'w')
        if not pipe then return msg.error('could not open unix pipe') end
        pipe:write(text)
        pipe:close()
    end
end


local function getFrame()
    local time_pos = mp.get_property_number("estimated-frame-number")
    mp.osd_message(string.format("Copied to Clipboard: %d", time_pos))
    set_clipboard(time_pos)    
end

local function getCoor()
    -- absolute mouse coordinates (subtracted by the coordinates of mpv's top left corner)
    local x, y = mp.get_mouse_pos()
    -- mpv window size
    local resX, resY = mp.get_osd_size()
    -- width and height of the input video
    local w, h = mp.get_property('width'), mp.get_property('height')

    local scale = 0
    if resX/resY > w/h then -- the height of the video will be maxed out (black bars on both sides)
        x = x - (resX - w/h*resY)/2
        scale = h/resY
    else -- black bars at the top and bottom
        -- map (resY - h)/2 to 0 and (resY + h)/2 to h
        y = y - (resY - h/w*resX)/2
        scale = w/resX
    end

    x = x*scale
    y = y*scale
    mp.osd_message(string.format("Copied to Clipboard: X%d, Y%d", x, y))
    set_clipboard(string.format("\"%d,%d\"", x, y))
end


mp.add_key_binding("g", "getFrame", getFrame)
mp.add_key_binding("c", "copyCoordinates", getCoor)
