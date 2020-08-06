local ADDR_MAP = 0x4B78A8
local OFFS_MAP_SCRIPT = 0x14
local OFFS_SCRIPT_NUM_LZ = 0x288
local OFFS_SCRIPT_LZ = 0x28C
local SIZE_LZ = 0x5C
local OFFS_LZ_POS = 0

function listLZ()
  local script = readInteger(ADDR_MAP + OFFS_MAP_SCRIPT)
  local numLZ = readInteger(script + OFFS_SCRIPT_NUM_LZ)
  local firstLZ = readInteger(script + OFFS_SCRIPT_LZ)
  for i = 0, numLZ - 1 do
    local lz = firstLZ + SIZE_LZ * i
    local x = readInteger(lz + OFFS_LZ_POS    ) << 12
    local y = readInteger(lz + OFFS_LZ_POS + 4) << 12
    local z = readInteger(lz + OFFS_LZ_POS + 8) << 12
    print(string.format("lz %d: x=%d y=%d z=%d", i, x, y, z))
  end
end
