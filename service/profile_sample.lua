local skynet = require "skynet"
local Core = require "skynet.snlua.c"

local function get_service_addr(target)
    local handle = tonumber(targert)
    if handle then
        return skynet.address(handle)
    else
        local lst = skynet.call(".launcher", "lua", "LIST")
        for addr, name in pairs(lst) do
            local h = tonumber("0x" .. string.sub(addr , 2))
            print("addr:", addr, "name:", name)
            if name == target then
                return h
            end
        end
    end
end

local command = {}

function command.cpu_conter(service_name)
    local addr = get_service_addr(service_name)
    if not addr then
        error(string.format("Unknown service %s", tostring(service_name)))
        return
    end

    print("addr:", addr)
    skynet.fork(function()
        Core.get_trace(addr)
        for i=1,100 do
            -- print("testtttttttttttttttt i:", i);
            local ret = Core.get_trace(addr)
            if ret then
                print("ret:", ret)
            end
            skynet.sleep(2)
        end
    end)
end

skynet.start(function()
    skynet.error("Server start")
    skynet.dispatch("lua", function(session, address, cmd, ...)
        print("xxxxxxxxxxxxx cmd:", cmd)
        local f = assert(command[cmd])
        if f then
            f(...)
        else
            error(string.format("Unknown command %s", tostring(cmd)))
        end
    end)
end)