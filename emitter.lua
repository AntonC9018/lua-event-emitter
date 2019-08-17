-- I'm just gonna write my own library for events
-- I'm sick of fixing other people's bugs
local Emitter = {}

setmetatable(Emitter, {
    __call = function (_) return Emitter:new() end
})

local pfx_once = '_once_'

function Emitter:new()
    local obj = {}
    self.__index = self
    setmetatable(obj, self)
    obj:construct()

    return obj
end

function Emitter:construct()

    -- first it will have a table of events
    self.events = {}

    -- each of those events is going to be a string
    -- and the value will be the array of listeners
    -- anything else?
end


function Emitter:on(event, listener)

    if self.events[event] then
        table.insert(self.events[event], listener)

    else
        self.events[event] = { listener }
    end

end


function Emitter:emit(event, ...)

    if self.events[event] then
        for i = 1, #self.events[event] do
            self.events[event][i](...)
        end
    end

    local once_event = pfx_once..event

    if self.events[once_event] then
        for i = 1, #self.events[once_event] do
            self.events[once_event][i](...)
        end
        self.events[once_event] = nil
    end

end


function Emitter:removeListener(event, listener)

    if self.events[event] then

        for i = 1, # self.events[event] do
            if self.events[event][i] == listener then
                table.remove(self.events[event], i)
                return true
            end
        end

    end

    return false

end



function Emitter:once(event, listener)

    self:on(pfx_once..event, listener)

end


function Emitter:untilTrue(event, listener, finally)

    local function wrapper(...)
        local args = listener(...)
        if args then
            self:removeListener(event, wrapper)
            if finally then finally(args, ...) end
        end
    end

    self:on(event, wrapper)

end


function Emitter:removeAllListeners(event)
    self.events[event] = nil
    self.events[pfx_once..event] = nil
end


return Emitter