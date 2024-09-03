
-- only run if conform is available:
if not pcall(require, "conform") then
  return
end

require("conform").formatters.black = {
  prepend_args = { "-l", "80" },
}

