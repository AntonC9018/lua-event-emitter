# lua-event-emitter
A lightweight event emitter for lua.

# How to use
Put the emitter.lua into your project's folder and just require it.


# Example
```lua
local Emitter = require('emitter')

local emitter = Emitter()
local listener = function(a) print(a) end
emitter:on('myevent', listener)
emitter:emit('myevent', 'I will be printed')
```

See some more examples in the file _test.lua_
