local skynet = require "skynet"
local sprotoloader = require "sprotoloader"

local max_client = 64

skynet.start(function()
	skynet.error("Server start")
	skynet.uniqueservice("protoloader")
	if not skynet.getenv "daemon" then
		local console = skynet.newservice("console")
	end
	skynet.newservice("debug_console",8000)
	skynet.newservice("simpledb")
	local watchdog = skynet.newservice("watchdog")
	local addr,port = skynet.call(watchdog, "lua", "start", {
		port = 8888,
		maxclient = max_client,
		nodelay = true,
	})
	skynet.error("Watchdog listen on " .. addr .. ":" .. port)

	skynet.newservice("testaaa")
	skynet.newservice("testbbb")
	local profile_sample = skynet.newservice("profile_sample")
	skynet.fork(function()
		skynet.sleep(100)
		print("testaaa start")
		skynet.send(profile_sample, "lua", "cpu_conter", "snlua testaaa")
	end)
	-- skynet.exit()
end)
