--unit/attribute-change.lua v1.0

local utils = require 'utils'
local persistTable = require 'persist-table'

function effect(etype,mental,unitTarget,ctype,strength,dur)
 local value = 0
 local int16 = 30000
 local current = 0
 local change = 0
 
 if mental == 'physical' then
  current = unitTarget.body.physical_attrs[etype].value
 elseif mental == 'mental' then
  current = unitTarget.status.current_soul.mental_attrs[etype].value
 end
 if ctype == 'fixed' then
  value = current + strength
  change = -strength
 elseif ctype == 'percent' then
  local percent = (100+strength)/100
  value = current*percent
  change = current-value
 elseif ctype == 'set' then
  value = strength
  change = current-value
 end
 
 value = math.floor(value)
 if value > int16 then value = int16 end
 if value < 0 then value = 0 end
 if mental == 'physical' then
  unitTarget.body.physical_attrs[etype].value = value
 elseif mental == 'mental' then
  unitTarget.status.current_soul.mental_attrs[etype].value = value
 end

 if persistTable.GlobalTable.roses then
  local unitTable = persistTable.GlobalTable.roses.UnitTable
  if unitTable[tostring(unitTarget.id)] then
   unitTable[tostring(unitTarget.id)].Stats = unitTable[tostring(unitTarget.id)].Stats or {}
  else
   unitTable[tostring(unitTarget.id)] = {}
   unitTable[tostring(unitTarget.id)].Stats = {}
  end
  statTable = unitTable[tostring(unitTarget.id)].Stats
  if statTable[etype] then
   statTable[etype].Current = tostring(current)
   if dur > 0 then
    statTable[etype].Change = tostring(statTable[etype].Change - change)
   else
    statTable[etype].Base = tostring(value)
   end
  else
   statTable[etype] = {}
   if dur > 0 then
    statTable[etype].Change = tostring(change)
    statTable[etype].Base = tostring(current)
    statTable[etype].Current = tostring(current)
   else
    statTable[etype].Base = tostring(value)
    statTable[etype].Change = '0'
    statTable[etype].Current = tostring(value)
   end
  end
 end
 
 return change
end

validArgs = validArgs or utils.invert({
 'help',
 'mental',
 'physical',
 'fixed',
 'percent',
 'set',
 'dur',
 'unit',
 'announcement'
})
local args = utils.processArgs({...}, validArgs)

if args.help then -- Help declaration
 print([[unit/attribute-change.lua
  Change the attribute(s) of a unit
  arguments:
   -help
     print this help message
   -unit id
     REQUIRED
     id of the target unit
   -dur #
     length of time, in in-game ticks, for the change to last
     0 means the change is permanent
     DEFAULT: 0
   -fixed #                                \
     change attribute by fixed amount      |
   -percent #                              |
     change attribute by percentage amount | Must have one and only one of these arguments
   -set #                                  |
     set attribute to this value           /
   -mental ATTRIBUTE_ID    \
     mental attribute id   |
   -physical ATTRIBUTE_ID  | Must have one and only one of these arguments
     physical attribute id /
   -announcement string
    optional argument to create an announcement and combat log report
  examples:
   unit/attribute-change -unit \\UNIT_ID -fixed 100 -physical STRENGTH
   unit/attribute-change -unit \\UNIT_ID -percent [10,10,10] -physical [ENDURANCE,TOUGHNESS,RECUPERATION] -dur 3600
   unit/attribute-change -unit \\UNIT_ID -set 5000 -mental WILLPOWER -dur 1000
 ]])
 return
end

if args.unit and tonumber(args.unit) then -- Check for unit declaration !REQUIRED
 unit = df.unit.find(tonumber(args.unit))
else
 print('No unit selected')
 return
end
if args.fixed then -- Check for type of change to make, fixed, percent, or set (default fixed)
 mode = 'fixed'
elseif args.percent then
 mode = 'percent'
elseif args.set then
 mode = 'set'
end
value = args.fixed or args.percent or args.set
if type(value) == 'string' then value = {value} end
dur = tonumber(args.dur) or 0 -- Check if there is a duration (default 0)

if args.mental then -- Check if you are changing mental attributes. !!RUN EFFECT!! !REQUIRED
 mental = 'mental'
elseif args.physical then
 mental = 'physical'
end
token = args.mental or args.physical
if type(token) == 'string' then token = {token} end
for i,etype in ipairs(token) do
 change = effect(etype,mental,unit,mode,tonumber(value[i]),dur)
 if dur > 0 then
  script = 'unit/attribute-change -unit '..tostring(unit.id)..' -fixed \\'..tostring(change)..' -'..mental..' '..etype
  dfhack.script_environment('persist-delay').persistentDelay(dur,script)
 end
end
if args.announcement then
--add announcement information
end