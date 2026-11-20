-- Add, delete, replace and find surroundings, on the ; mappings kept from LazyVim.
require("mini.surround").setup({
  mappings = {
    add = ";;",
    delete = ";d",
    find = ";f",
    find_left = ";F",
    highlight = ";h",
    replace = ";r",
  },
})
