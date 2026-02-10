-- frame_diff.lua
-- Press 'Shift+d' to toggle frame difference visualization

local filter_label = "frame-diff-view"
local diff_filter = "lavfi=[tblend=all_mode=difference128]"

mp.add_key_binding("D", "toggle-frame-diff", function()
    -- Get the current list of filters
    local current_filters = mp.get_property("vf") or ""
    
    if current_filters:find("tblend") then
        -- If active, remove it
        mp.command("vf remove @frame-diff-view")
        mp.osd_message("Frame Diff: OFF")
    else
        -- If inactive, add the difference filter with a label
        -- difference128 makes no-change = gray (128), changes = darker/lighter
        mp.command("vf add @" .. filter_label .. ":" .. diff_filter)
        mp.osd_message("Frame Diff: ON")
    end
end)
