--item/material-change.lua v1.0

local utils = require 'utils'

function imbueinventory(v,mat,dur)
 local mat_type = mat.type
 local mat_index = mat.index

 local inv = unit.inventory
 local items = {}
 local j = 1
 for i = 0, #inv - 1, 1 do
  if v:is_instance(inv[i].item) then
   items[j] = i
   j = j+1
  end
 end

 if #items == 0 then
  print('No necessary item equiped')
  return
 end

 for i,x in ipairs(items) do
  local sitem = inv[x].item
  local stype = sitem.mat_type
  local sindex = sitem.mat_index
  sitem.mat_type = mat_type
  sitem.mat_index = mat_index

  if dur ~= 0 then
   script = 'item/material-change -item '..tostring(sitem.id)..' -mat '..dfhack.matinfo.getToken(stype,sindex)
   dfhack.script_environment('persist-delay').persistentDelay(dur,script)
  end
 end
end

function imbueitem(item,mat,dur)
 local mat_type = mat.type
 local mat_index = mat.index

 local sitem = item
 local stype = sitem.mat_type
 local sindex = sitem.mat_index
 sitem.mat_type = mat_type
 sitem.mat_index = mat_index

 if dur ~= 0 then
  script = 'item/material-change -item '..tostring(sitem.id)..' -mat '..dfhack.matinfo.getToken(stype,sindex)
  dfhack.script_environment('persist-delay').persistentDelay(dur,script)
 end
end

validArgs = validArgs or utils.invert({
 'help',
 'unit',
 'item',
 'weapon',
 'armor',
 'helm',
 'shoes',
 'shield',
 'gloves',
 'pants',
 'ammo',
 'mat',
 'dur',
})
local args = utils.processArgs({...}, validArgs)

if args.help then -- Help declaration
 print([[item/material-change.lua
  Change the material a equipped item is made out of
  arguments:
   -help
     print this help message
   -unit id                   \
     id of the target unit    |
   -item id                   | Must have one and only one of them
     id of the target item    /
   -weapon          \
     change weapons |
   -armor           |
     change armor   |
   -helm            |
     change helm    |
   -shoes           |
     change shoes   | Must have at least one of these arguments if using -unit
   -shield          |
     change shield  |
   -gloves          |
     change gloves  |
   -pants           |
     change pants   |
   -ammo            |
     change ammo    /
   -mat matstring
     specify the material of the item to be changed to
     examples:
      INORGANIC:IRON
      CREATURE_MAT:DWARF:BRAIN
      PLANT_MAT:MUSHROOM_HELMET_PLUMP:DRINK
   -dur #
     length of time, in in-game ticks, for the material change to last
     0 means the change is permanent
     DEFAULT: 0
  examples:
   item/material-change -unit \\UNIT_ID -weapon -ammo -mat IMBUE_FIRE -dur 3600
   item/material-change -unit \\UNIT_ID -armor -helm -shoes -pants -gloves -mat IMBUE_STONE -dur 1000
   item/material-change -unit \\UNIT_ID -shield -mat IMBUE_AIR
 ]])
 return
end

if args.unit and tonumber(args.unit) then -- Check for unit declaration !REQUIRED
 unit = df.unit.find(tonumber(args.unit))
else
 if args.item and tonumber(args.item) then
  item = df.item.find(tonumber(args.item))
 else
  print('No unit selected')
  return
 end
end
if args.mat then -- Check for material !REQUIRED
 mat = dfhack.matinfo.find(args.mat)
else
 print('No material specified')
 return
end
dur = tonumber(args.dur) or 0 -- Specify duration of change (default 0)
if args.weapon then imbueinventory(df.item_weaponst,mat,dur) end
if args.armor then imbueinventory(df.item_armorst,mat,dur) end
if args.helm then imbueinventory(df.item_helmst,mat,dur) end
if args.shoes then imbueinventory(df.item_shoesst,mat,dur) end
if args.shield then imbueinventory(df.item_shieldst,mat,dur) end
if args.gloves then imbueinventory(df.item_glovesst,mat,dur) end
if args.pants then imbueinventory(df.item_pantsst,mat,dur) end
if args.ammo then imbueinventory(df.item_ammost,mat,dur) end
if args.item then imbueitem(item,mat,dur) end

