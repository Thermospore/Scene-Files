-- This Cheat Engine script for Croc 2 teleports Croc close to the Golden Gobbo

-- Determine game version from the process' main module size
local VER = ({[0x23A000] = "US", [0x242000] = "EU"})[getModuleSize(process)]
if not VER then
  print("Unknown game version")
  return
end

local ADDR_SCRIPT_MGR = ({US = 0x4B78BC, EU = 0x4BEAAC})[VER]

local OFFS_OBJ_NAME = 0x18
local OFFS_OBJ_POS  = 0x2C

local function getObjName(obj)
  return readString(readInteger(obj + OFFS_OBJ_NAME), 100, false)
end

local function getObjPos(obj)
  return {
    readInteger(obj + OFFS_OBJ_POS + 0),
    readInteger(obj + OFFS_OBJ_POS + 4),
    readInteger(obj + OFFS_OBJ_POS + 8)
  }
end

local function setObjPos(obj, pos)
  writeInteger(obj + OFFS_OBJ_POS + 0, pos[1])
  writeInteger(obj + OFFS_OBJ_POS + 4, pos[2])
  writeInteger(obj + OFFS_OBJ_POS + 8, pos[3])
end

local function getObjs()
  -- Get pointer to first object
  local obj = readInteger(readInteger(ADDR_SCRIPT_MGR) + 0x20)

  local objs = {}
  while obj ~= 0 do
    -- Add object to list
    table.insert(objs, obj)
    -- Get pointer to next object
    obj = readInteger(obj)
  end
  return objs
end

local function getObjsByName(name)
  local objs = {}
  for i, obj in ipairs(getObjs()) do
    local curName = getObjName(obj)
    if curName == name then
      table.insert(objs, obj)
	  return objs
    end
  end
  return objs
end

local function getObjByName(name)
  local objs = getObjsByName(name)
  if #objs == 0 then
    print(string.format("Cannot find \"%s\" object", name))
    return nil
  elseif #objs > 1 then
    print(string.format("Found more than one \"%s\" object", name))
    return nil
  end
  return objs[1]
end

local function teleportToGoldenGobbo()
  -- Get pointers to Croc and Golden Gobbo object
  local croc = getObjByName("WalkingCroc")
  if not croc then return end
  local gobbo = getObjByName("Golden Gobbo")
  if not gobbo then return end
  -- Teleport
  local pos = getObjPos(gobbo)
  pos[1] = pos[1] + 0x700
  setObjPos(croc, pos)
end

teleportToGoldenGobbo()