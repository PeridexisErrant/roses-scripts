
local utils = require 'utils'
local split = utils.split_string
local delay = require 'persist-delay'

function itemSubtypes(item) -- Taken from Putnam's itemSyndrome
   local subtypedItemTypes =
    {
    ARMOR = df.item_armorst,
    WEAPON = df.item_weaponst,
    HELM = df.item_helmst,
    SHOES = df.item_shoesst,
    SHIELD = df.item_shieldst,
    GLOVES = df.item_glovest,
    PANTS = df.item_pantsst,
    TOOL = df.item_toolst,
    SIEGEAMMO = df.item_siegeammost,
    AMMO = df.item_ammost,
    TRAPCOMP = df.item_trapcompst,
    INSTRUMENT = df.item_instrumentst,
    TOY = df.item_toyst}
    for x,v in pairs(subtypedItemTypes) do
        if v:is_instance(item) then 
   return df.item_type[x]
  end
    end
    return false
end
function upgradeitem(args,v,dur,subtype)
 local sitems = {}
 if args.equipped and args.unit then
  unit = df.unit.find(tonumber(args.unit))
-- Upgrade only the input items with preserve reagent
  local inv = unit.inventory
  local j = 1
  for i,x in ipairs(inv) do
   if (v:is_instance(x.item) and (x.item.subtype.id == subtype or subtype == 'ALL')) then
    sitems[j] = x.item
    j = j+1
   end
  end
 elseif args.all then
-- Upgrade all items of the same type as input
  local itemList = df.global.world.items.all
  local k = 1
  for i,x in ipairs(itemList) do
   if (v:is_instance(x) and (x.subtype.id == subtype or subtype == 'ALL')) then 
    sitems[k] = itemList[i] 
    k = k + 1
   end
  end
 elseif args.random then
-- Randomly upgrade one specific item
  local itemList = df.global.world.items.all
  local k = 1
  for i,x in ipairs(itemList) do
   if (v:is_instance(x) and (x.subtype.id == subtype or subtype == 'ALL')) then 
    sitems[k] = itemList[i] 
    k = k + 1
   end
  end
  local rando = dfhack.random.new()
  sitems = {sitems[rando:random(#sitems)]}
 elseif args.item then
  local itemList = df.global.world.items.all
  sitems = {df.item.find(tonumber(args.item))}
 end

 if args.upgrade then
-- Increase items number by one
  for _,x in ipairs(sitems) do
   local name = x.subtype.id
   local namea = split(name,'_')
   local num = tonumber(namea[#namea])
   num = num + 1
   namea[#namea] = tostring(num)
   name = table.concat(namea,'_')
   item_index = itemSubtypes(x)
   for i=0,dfhack.items.getSubtypeCount(item_index)-1,1 do
    item_sub = dfhack.items.getSubtypeDef(item_index,i)
    if item_sub.id == name then x:setSubtype(item_sub.subtype) end
   end
   if dur > 0 then dfhack.script_environment('persist-delay').persistantDelay(dur,'item/subtype-change -item '..tostring(x.id)..' -downgrade') end
  end
 elseif args.downgrade then
-- Decrease items number by one
  for _,x in ipairs(sitems) do
   local name = x.subtype.id
   local namea = split(name,'_')
   local num = tonumber(namea[#namea])
   num = num - 1
   if num > 0 then namea[#namea] = tostring(num) end
   name = table.concat(namea,'_')
   item_index = itemSubtypes(x)
   for i=0,dfhack.items.getSubtypeCount(item_index)-1,1 do
    item_sub = dfhack.items.getSubtypeDef(item_index,i)
    if item_sub.id == name then x:setSubtype(item_sub.subtype) end
   end
   if dur > 0 then dfhack.script_environment('persist-delay').persistantDelay(dur,'item/subtype-change -item '..tostring(x.id)..' -upgrade') end
  end
 else
-- Change item to new item
  for _,x in ipairs(sitems) do
   printall(x)
   if dur > 0 then sid = x.subtype.id end
   item_index = itemSubtypes(x)
   for i=0,dfhack.items.getSubtypeCount(item_index)-1,1 do
    item_sub = dfhack.items.getSubtypeDef(item_index,i)
    if item_sub.id == args.type then 
	 x:setSubtype(item_sub.subtype)
	end
   end
   if dur > 0 then dfhack.script_environment('persist-delay').persistantDelay(dur,'item/subtype-change -item '..tostring(x.id)..' -type '..tostring(sid)) end
  end
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
 'equipped',
 'all',
 'type',
 'dur',
 'upgrade',
 'downgrade',
})
local args = utils.processArgs({...}, validArgs)

if args.help then -- Help declaration
 print([[item/subtype-change.lua
  Change the subtype of an item
  arguments:
   -help
     print this help message
   -unit id
     id of the target unit
     required if using -equipped
   -item id                                                        \
     id of the target item                                         |
   -equipped                                                       |
     change SUBTYPE of only equipped items of the declared type(s) | Must have one and only one of these arguments
   -all                                                            |
     change SUBTYPE of all item of the declared type(s)            |
   -random                                                         |
     change SUBTYPE of a random item of the declared type(s)       /
   -weapon SUBTYPE or ALL \
     change weapons       |
   -armor SUBTYPE or ALL  |
     change armor         |
   -helm SUBTYPE or ALL   |
     change helm          |
   -shoes SUBTYPE or ALL  |
     change shoes         | Must have at least one of these arguments
   -shield SUBTYPE or ALL |
     change shield        | 
   -gloves SUBTYPE or ALL |
     change gloves        |
   -pants SUBTYPE or ALL  |
     change pants         | 
   -ammo SUBTYPE or ALL   |
     change ammo          /
   -dur #
	 length of time, in in-game ticks, for the quality change to last
     0 means the change is permanent
     DEFAULT: 0
   -upgrade                                              \
     increase the number of the item SUBTYPE by 1        |
     (i.e. ITEM_WEAPON_DAGGER_1 -> ITEM_WEAPON_DAGGER_2) |
   -downgrade                                            |
     decrease the number of the item SUBTYPE by 1        | Must have one and only one of these arguments
     (i.e. ITEM_WEAPON_DAGGER_2 -> ITEM_WEAPON_DAGGER_1) |
   -type SUBTYPE                                         |
     change the item to the new SUBTYPE                  /
  examples:
   item/subtype-change -unit \\UNIT_ID -weapon ALL -equipped -upgrade -dur 1000
   item/subtype-change -all -weapon ITEM_WEAPON_GIANTS -item ITEM_WEAPON_GIANTS_WEAK -dur 1000
   item/subtype-change -unit \\UNIT_ID -armor ALL -pants ALL -helm ALL -shoes ALL -gloves ALL -equipped -downgrade -dur 3600
 ]])
 return
end

dur = tonumber(args.dur) or 0 -- Specify duration of change (default 0)
if args.weapon then upgradeitem(args,df.item_weaponst,dur,args.weapon) end
if args.armor then upgradeitem(args,df.item_armorst,dur,args.armor) end
if args.helm then upgradeitem(args,df.item_helmst,dur,args.helm) end
if args.shoes then upgradeitem(args,df.item_shoesst,dur,args.shoes) end
if args.shield then upgradeitem(args,df.item_shieldst,dur,args.shield) end
if args.gloves then upgradeitem(args,df.item_glovest,dur,args.gloves) end
if args.pants then upgradeitem(args,df.item_pantsst,dur,args.pants) end
if args.ammo then upgradeitem(args,df.item_ammost,dur,args.ammo) end
if args.item then upgradeitem(args,0,dur,0) end
