myreports       = myreports or {}
myreports.data  = myreports.data or {}

if SERVER then
    include("myreports/meta/sh_message.lua")
    include("myreports/meta/sh_report.lua")
    include("myreports/sv_net.lua")
    include("myreports/sv_init.lua")

    AddCSLuaFile("myreports/meta/sh_message.lua")
    AddCSLuaFile("myreports/meta/sh_report.lua")
    AddCSLuaFile("myreports/cl_init.lua")
else
    include("myreports/meta/sh_message.lua")
    include("myreports/meta/sh_report.lua")
    include("myreports/cl_init.lua")
end
