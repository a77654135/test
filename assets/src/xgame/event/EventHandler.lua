local class         = require "xgame.class"
local Event         = require "xgame.event.Event"
local KeyboardEvent = require "xgame.KeyboardEvent"
local TouchEvent    = require "xgame.ui.TouchEvent"

local assert = assert
local table = table

local EventHandler = class("EventHandler")

function EventHandler:ctor()
    self._count = 0
    self._listeners = {}
    self._target = nil
    self._priority = nil
end

function EventHandler:E(target, priority)
    self._target = target
    self._priority = priority
    return self
end

function EventHandler:handle(...)
    self:add_event_listener(...)
end

function EventHandler:on(...)
    self:add_event_listener(...)
end

function EventHandler:off(...)
    self:remove_event_listener(...)
end

function EventHandler:add_event_listener(type, listener, owner, priority)
    assert(self.class == EventHandler, self)
    priority = priority or self._priority 
    self._target:add_event_listener(type, listener, owner, priority)

    local count = self._count + 1
    self._count = count
    self._listeners[count] = {self._target, type, listener, owner}
    self._target = false
end

function EventHandler:remove_event_listener(type, listener, owner)
    self._target:remove_event_listener(type, listener, owner)
    for idx, v in pairs(self._listeners) do
        if v[1] == self._target and 
            v[2] == type and 
            v[3] == listener and 
            v[4] == owner then
            self._listeners[idx] = nil
        end
    end
    self._target = false
end

function EventHandler:dispatch_event(type, ...)
    self._target:dispatch_event(type, ...)
end

function EventHandler:onclick(listener, owner, button_mode)
    self._target.button_mode = button_mode ~= false
    self:add_event_listener(TouchEvent.CLICK, listener, owner)
end

function EventHandler:ontouchdown(listener, owner)
    self:add_event_listener(TouchEvent.TOUCH_DOWN, listener, owner)
end

function EventHandler:ontouchmove(listener, owner)
    self:add_event_listener(TouchEvent.TOUCH_MOVE, listener, owner)
end

function EventHandler:ontouchup(listener, owner)
    self:add_event_listener(TouchEvent.TOUCH_UP, listener, owner)
end

function EventHandler:onchange(listener, owner)
    self:add_event_listener(Event.CHANGE, listener, owner)
end

function EventHandler:oncomplete(listener, owner)
    self:add_event_listener(Event.COMPLETE, listener, owner)
end

function EventHandler:onselect(listener, owner)
    self:add_event_listener(Event.SELECT, listener, owner)
end

function EventHandler:onioerror(listener, owner)
    self:add_event_listener(Event.IOERROR, listener, owner)
end

function EventHandler:oncancel(listener, owner)
    self:add_event_listener(Event.CANCEL, listener, owner)
end

function EventHandler:onkeydown(listener, owner)
    self:add_event_listener(KeyboardEvent.KEY_DOWN, listener,  owner)
end

function EventHandler:onkeyup(listener, owner)
    self:add_event_listener(KeyboardEvent.KEY_UP, listener,  owner)
end

function EventHandler:clear()
    for idx, v in pairs(self._listeners) do
        v[1]:remove_event_listener(table.unpack(v, 2))
    end
    self._target = nil
    self._listeners = {}
end

return EventHandler
