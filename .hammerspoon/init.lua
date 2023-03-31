function focus_window_by_app_and_title(app_name, target_title, titles)
  local all_windows = hs.window.filter.new(app_name):getWindows()

  if target_title then
    for _, win in ipairs(all_windows) do
      if win:title() == target_title then
        win:focus()
        return
      end
    end
  end

  for _, win in ipairs(all_windows) do
    local title_matched = false
    for _, title in ipairs(titles) do
      if win:title() == title then
        title_matched = true
        break
      end
    end
    if not title_matched then
      win:focus()
      return
    end
  end
end

-- Usage example:
-- focus_window_by_app_and_title("Alacritty", "ranger", {"spotify_player", "another_title_to_exclude"})

-- Bind the function to CMD-5
hs.hotkey.bind({ "cmd" }, "5", function()
  -- focus_window_by_app_and_title("Alacritty", "spotify_player", { "spotify_player", "another_title_to_exclude" })
end)

function print_all_window_titles()
  local wf = hs.window.filter.new():setOverrideFilter({ currentSpace = false })
  local all_windows = wf:getWindows()

  for _, win in ipairs(all_windows) do
    local app_name = win:application():name()
    local win_title = win:title()
    local space_number = win:screen():spaces()[1] or "unknown"
    print(string.format("App: %s | Title: %s | Space: %s", app_name, win_title, space_number))
  end
end

-- Usage:
-- print_all_window_titles()
-- Usage:
-- print_all_window_titles()
hs.hotkey.bind({ "cmd" }, "0", function()
  -- print_all_window_titles()
end)
