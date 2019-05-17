-- This is a Cheat Engine script that prevents Croc 2 from
-- resetting when you touch lava three times consecutively.

-- Determine game version from the process' main module size
local VER = ({[0x23A000] = "US", [0x242000] = "EU"})[getModuleSize(process)]
if not VER then
  print("Unknown game version")
  return
end

local ADDR_SCRIPT_FUNCS = ({US = 0x4AF340, EU = 0x4B0390})[VER]
local ADDR_SCRIPT_FUNC_012 = readInteger(ADDR_SCRIPT_FUNCS + 12 * 4)
local ADDR_BREAK = ADDR_SCRIPT_FUNC_012 + 0x22

function debugger_onBreakpoint()
    if (EIP == ADDR_BREAK) then
        local obj = readInteger(ESP + 4)
        -- Ignore objects other than the Croc object
        local CROC_OBJ_NAME = "WalkingCroc"
        local objName = readString(readInteger(obj + 0x18),
            #CROC_OBJ_NAME + 1, false)
        if objName ~= CROC_OBJ_NAME then return 1 end
        -- Ignore addresses other than the lava contact counter
        if EAX ~= readInteger(obj + 0xE4) + 0x4c then return 1 end
        -- Skip lava contact counter update
        EIP = EIP + 6
        return 1
    end
end

debug_setBreakpoint(ADDR_BREAK)