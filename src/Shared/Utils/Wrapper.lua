local Wrapper = {}

function Wrapper.new(Object, Interface)
  local meta = setmetatable({ Object = Object, Interface = Interface or {} }, {
    __index = function (self, key, ...)
      print("self", self)
      print("key", key)
      print("pros", ...)
      if (Interface[key]) then
        return Interface[key]
      end
      local ModulePropertyFound, ModuleProperty = pcall(function()
        return Object[key]
      end)
      print("ModulePropertyFound", ModulePropertyFound)
      print("ModuleProperty", typeof(ModuleProperty))
      if ModulePropertyFound then
        if (typeof(ModuleProperty) == "RBXScriptSignal") then
          print("signal is not handled by wrapper")
          -- todo handle signal property
        end
        if (typeof(ModuleProperty) == "function") then
          return function(_, ...)
            return ModuleProperty(Object,...)
          end
        end
      end
    end,
    __newindex = function (self, key, value)
      if (Interface[key]) then
        Interface[key] = value
      end
      Object[key] = value
    end
  })
  return meta
end
return Wrapper
