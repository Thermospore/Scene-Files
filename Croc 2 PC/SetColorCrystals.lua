function setColorCrystals(count)
  -- Find string "crystal\0GGEffect"
  local addrCrystalString = AOBScanUnique("63 72 79 73 74 61 6C 00 47 47 45 66 66 65 63 74", "+W")
  -- Get address of color crystal count variable
  local addrCrystalCount = addrCrystalString - 0x24
  -- Write new value
  writeInteger(addrCrystalCount, count << 12)
end
