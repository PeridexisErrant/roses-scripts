--special-projectile.lua v1.0

local utils = require 'utils'

function projectile(args,locSource,locTarget,itemType,itemSubtype,number,velocity,hitrate,maxrange,minrange,height,create)
 for i = 1, number, 1 do
  item = nil
  if create then
   if not args.creator or not tonumber(args.creator) or not df.unit.find(tonumber(args.creator)) then
    print('Invalid creator')
	return
   end
   args.creator = df.unit.find(tonumber(args.creator))
   if not args.creator then
    print('Invalid creator')
	return
   end
   if not args.mat then
    print('Invalid material')
    return
   end
   args.material = dfhack.matinfo.find(args.mat)
   if not args.material then
    print('Invalid material')
    return
   end
   item = dfhack.items.createItem(itemType, itemSubtype, args.material['type'], args.material.index,args.creator)
   item = df.item.find(item)
   dfhack.items.moveToGround(item,{x=tonumber(locSource.x),y=tonumber(locSource.y),z=tonumber(locSource.z+height)})
  else
   local inventory = args.creator.inventory
   for k,v in ipairs(inventory) do
    testitem = v.item
	if testitem:getType() == itemType and testitem:getSubtype() == itemSubtype then
	 item = testitem
	else
	 for l,w in ipairs(dfhack.items.getContainedItems(testitem)) do
	  if w:getType() == itemType and w:getSubtype() == itemSubtype then
	   item = w
	   break
	  end
	 end
	end
    if item then break end
   end
   if not item then 
    print('Needed item not equipped')
    return
   end
   if item.stack_size == 1 then
    dfhack.items.moveToGround(item,{x=tonumber(locSource.x),y=tonumber(locSource.y),z=tonumber(locSource.z+height)})
   else
    item.stack_size = item.stack_size - 1
	item = dfhack.items.createItem(itemType,itemSubtype,item.mat_type,item.mat_index,dfhack.items.getHolderUnit(item))
	item = df.item.find(item)
	dfhack.items.moveToGround(item,{x=tonumber(locSource.x),y=tonumber(locSource.y),z=tonumber(locSource.z+height)})
   end
  end
  
  block = dfhack.maps.ensureTileBlock(locSource.x,locSource.y,locSource.z+height)
--  item.flags.removed=true
  proj = dfhack.items.makeProjectile(item)
  proj.origin_pos.x=locSource.x
  proj.origin_pos.y=locSource.y
  proj.origin_pos.z=locSource.z+height
  proj.prev_pos.x=locSource.x
  proj.prev_pos.y=locSource.y
  proj.prev_pos.z=locSource.z+height
  proj.cur_pos.x=locSource.x
  proj.cur_pos.y=locSource.y
  proj.cur_pos.z=locSource.z+height
  if not args.falling then
   proj.target_pos.x=locTarget.x
   proj.target_pos.y=locTarget.y
   proj.target_pos.z=locTarget.z
   proj.flags.no_impact_destroy=false
   proj.flags.bouncing=false
   proj.flags.piercing=false
   proj.flags.parabolic=false
   proj.flags.unk9=false
   proj.flags.no_collide=false
-- Need to figure out these numbers!!!
   proj.distance_flown=0 -- Self explanatory
   proj.fall_threshold=maxrange -- Seems to be able to hit units further away with larger numbers
   proj.min_hit_distance=minrange -- Seems to be unable to hit units closer than this value
   proj.min_ground_distance=maxrange-1 -- No idea
   proj.fall_counter=0 -- No idea
   proj.fall_delay=0 -- No idea
   proj.hit_rating=hitrate -- I think this is how likely it is to hit a unit (or to go where it should maybe?)
   proj.unk22 = velocity
   proj.speed_x=0
   proj.speed_y=0
   proj.speed_z=0
  else
   proj.flags.no_impact_destroy=false
   proj.flags.bouncing=true
   proj.flags.piercing=true
   proj.flags.parabolic=true
   proj.flags.unk9=true
   proj.flags.no_collide=true
   proj.speed_x=0
   proj.speed_y=0
   proj.speed_z=0
  end
 end
end

validArgs = validArgs or utils.invert({
 'help',
 'unitSource',
 'unitTarget',
 'locationSource',
 'locationTarget',
 'creator',
 'mat',
 'item',
 'number',
 'maxrange',
 'velocity',
 'minrange',
 'hitchance',
 'height',
 'equipped',
 'falling'
})
local args = utils.processArgs({...}, validArgs)

if args.help then -- Help declaration
 print([[item/projectile.lua
  Creates an item that shoots as a projectile
  arguments:
   -help
     print this help message
   -unitSource id                                                   \
     id of the unit to use for position of origin of projectile     |
   -locationSource [#,#,#]                                          | Must have one and only one of these arguments, if both, ignore -locationSource
     x,y,z coordinates to use for position for origin of projectile /
   -unitTarget id                                                  \
     id of the unit to use for position of target of projectile    |
   -locationTarget [#,#,#]                                         | Must have one and only one of these arguments, if both, ignore -locationTarget
     x,y,z coordinates to use for position of target of projectile /
   -creator id
     id of unit to use as creator of item, if not included assumes unitSource as creator
   -item itemstr
     specify the itemdef of the item to be created
     examples:
      WEAPON:ITEM_WEAPON_PICK
	  AMMO:ITEM_AMMO_BOLT
   -mat matstring
     specify the material of the item to be created
     examples:
      INORGANIC:IRON
      CREATURE_MAT:DWARF:BRAIN
      PLANT_MAT:MUSHROOM_HELMET_PLUMP:DRINK
   -number #
     number of items to fire as projectiles
     DEFAULT 1
   -maxrange #
     maximum range in tiles that the projectile can travel to hit its target
     DEFAULT 10
   -minrange #
     minimum range in tiles that the projectile needs to travel to hit its target
     DEFAULT 1
   -velocity #
     speed of projectile (does not affect how fast it moves across the map, only force that it hits the target with)
     DEFAULT 20
   -hitchance #
     chance for projectile to hit target (assume %?)
     DEFAULT 50
   -height #
     height above the source location to start the item
	 DEFAULT 0
   -equipped
     whether to check unitSource for the equipped item, if absent assumes you want the item to be created
   -falling
     whether to use falling mechanics, if absent assumes you want to use shooting mechanics
	 Falling Mechanics:
	  Only -height is used, item will start at the source location + height. unitTarget/locationTarget is not needed
	 Shooting Mechanics:
	  -minrange, -maxrange, -velocity, -hitchance, and -height are all used. unitTarget/locationTarget are required
  examples:
   special-projectile -unit_source \\UNIT_ID -location_target [\\LOCATION] -item AMMO:ITEM_AMMO_ARROWS -mat STEEL -number 10 -maxrange 50 -minrange 10 -velocity 30 -hitchance 10
 ]])
 return
end

if args.unitSource and args.locationSource then -- Check that unit and location sources have not been both specified
 print("Can't have unit and location specified as source at same time")
 args.locationSource = nil
end
if args.unitTarget and args.locationTarget then -- Check that unit and location targets have not been both specified
 print("Can't have unit and location specified as target at same time")
 args.locationTarget = nil
end
if args.unitSource then -- Check for source declaration !REQUIRED
 locSource = df.unit.find(tonumber(args.unitSource)).pos
elseif args.locationSource then
 locSource = {x=args.locationSource[1],y=args.locationSource[2],z=args.locationSource[3]}
else
 print('No source specified')
 return
end
if args.unitSource and not args.creator then
 args.creator = args.unitSource
end
if args.unitTarget then -- Check for target declaration !REQUIRED
 locTarget = df.unit.find(tonumber(args.unitTarget)).pos
elseif args.locationTarget then
 locTarget = {x=args.locationTarget[1],y=args.locationTarget[2],z=args.locationTarget[3]}
else
 locTarget = locSource
if not args.item then
 print('Invalid item')
 return
end
local itemType = dfhack.items.findType(args.item)
if itemType == -1 then
 print('Invalid item')
 return
end
local itemSubtype = dfhack.items.findSubtype(args.item)
local create = true
if args.equipped and not args.unitSource then
 print('No unit to check for equipment')
 return
elseif args.equipped and args.unitSource then
 create = false
 args.creator = df.unit.find(tonumber(args.unitSource))
end

number = tonumber(args.number) or 1 -- Specify number of projectiles (default 1)
vel = tonumber(args.velocity) or 20 -- Specify velocity of projectiles (default 20)
hr = tonumber(args.hitchance) or 50 -- Specify hit percent of projectiles (default 50)
ft = tonumber(args.maxrange) or 10 -- Specify max range of projectiles (default 10)
md = tonumber(args.minrange) or 1 -- Specify minimum range of projectiles (default 1)
height = tonumber(args.height) or 0

projectile(args,locSource,locTarget,itemType,itemSubtype,number,vel,hr,ft,md,height,create)