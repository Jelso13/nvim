local M = {}

function M.get_zathura_id()
  -- Get the list of active D-Bus names
  local names = vim.fn.systemlist("dbus-send --session --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames")

  -- Search for the zathura D-Bus ID
  for _, line in ipairs(names) do
    local match = line:match('string "(.*zathura.*)"')
    if match then
      return match
    end
  end
  return nil
end

function M.open_document_with_zathura(file)
  -- Get the active window ID
  local active_window = vim.fn.system("xdotool getactivewindow"):gsub("%s+", "")

  -- Get the Zathura D-Bus ID
  local zathura_id = M.get_zathura_id()

  -- If no Zathura process is running, start it
  if not zathura_id or zathura_id == "" then
    vim.fn.system("zathura &")
    -- Wait for Zathura to start
    while true do
      vim.fn.sleep(0.1)
      zathura_id = M.get_zathura_id()
      if zathura_id and zathura_id ~= "" then
        break
      end
    end
  end

  -- Close the current document in Zathura
  vim.fn.system(string.format('dbus-send --session --dest=%s --type=method_call --print-reply /org/pwmt/zathura org.pwmt.zathura.CloseDocument', zathura_id))

  -- Open the new document in Zathura
  vim.fn.system(string.format('dbus-send --session --dest=%s --type=method_call --print-reply /org/pwmt/zathura org.pwmt.zathura.OpenDocument string:"%s" string:"" int32:1', zathura_id, file))

  -- Activate the previously active window
  vim.fn.system("xdotool windowactivate " .. active_window)
end

-- Example usage: Pass the LaTeX file to open in Zathura
-- local tex_file = "example.pdf"  -- This should be the path to your PDF or document to open
-- open_document_with_zathura(tex_file)


-- local function view_pdf()
--     local current_file = vim.fn.expand('%:p')
--     print("Current file: " .. current_file)
-- end
-- 
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "ViewPdf",
--   callback = view_pdf,
-- })

return M
