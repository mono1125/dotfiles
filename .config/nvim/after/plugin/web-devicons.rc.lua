local status, icons = pcall(require, "nvim-web-devicons")
if (not status) then return end

icons.setup {
  -- your personal icons can go here
  -- DevIcon will be appended to `name`
  override = {},
  -- globally enable default icons (default to false)
  -- will get overridden by `get_icons` option
  default = true
}
