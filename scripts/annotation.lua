-- Author: Robert Wong
-- Date: 2021-12-02
-- Description: Lua scripts for annotation in MPV
-- The script gets the current frame and the position of the mouse (relative to the frame size of the video)
-- Press "g" (lower case) to get the current frame (starts from 0)
-- Press "c" (lower case) to get the position of the mouse
require 'mp'

local function set_clipboard(text)
    mp.commandv("run", "powershell", "set-clipboard", text);
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
