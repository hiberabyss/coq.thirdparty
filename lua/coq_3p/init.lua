local utils = require("coq_3p.utils")

---@class Source
---@field public src string
---@field public short_name string | nil

---@param sources Source[]
return function(sources)
  COQsources = COQsources or {}
  vim.validate {
    COQsources = {COQsources, "table"},
    sources = {sources, "table"}
  }

  for _, spec in ipairs(sources) do
    local cont = function()
      local short_name = spec.short_name or string.upper(spec.src)
      vim.validate {
        src = {spec.src, "string"},
        short_name = {short_name, "string"}
      }
      local mod = "coq_3p." .. spec.src
      local factory = require(mod)
      vim.inspect {factory = {factory, "function"}}
      COQsources[utils.new_uid(COQsources)] = {
        name = short_name,
        fn = factory(spec)
      }
    end

    local go, err = pcall(cont)
    if not go then
      vim.api.nvim_err_writeln(factory)
    end
  end
end
