--unit/trait-change.lua v1.0

local utils = require 'utils'
local persistTable = require 'persist-table'

function effect(etype,unitTarget,ctype,strength)
 local value = 0
 local current = 0
 local change = 0
 
 current = unitTarget.status.current_soul.personality.traits[etype] 
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
 if value > 100 then value = 100 end
 if value < 0 then value = 0 end
 unitTarget.status.current_soul.personality.traits[etype] = value

 if persistTable.GlobalTable.roses then
  local unitTable = persistTable.GlobalTable.roses.UnitTable
  if unitTable[tostring(unitTarget.id)] then
   unitTable[tostring(unitTarget.id)].Traits = unitTable[tostring(unitTarget.id)].Traits or {}  
  else
   unitTable[tostring(unitTarget.id)] = {}
   unitTable[tostring(unitTarget.id)].Traits = {}
  end
  traitTable = unitTable[tostring(unitTarget.id)].Traits
  if traitTable[etype] then
   traitTable[etype].Current = tostring(current)
   if dur > 0 then
    traitTable[etype].Change = tostring(traitTable[etype].Change - change)
   else
    traitTable[etype].Base = tostring(value)
   end
  else
   traitTable[etype] = {}
   if dur > 0 then
    traitTable[etype].Change = tostring(change)
    traitTable[etype].Base = tostring(current)
    traitTable[etype].Current = tostring(current)
   else
    traitTable[etype].Base = tostring(value)
    traitTable[etype].Change = '0'
    traitTable[etype].Current = tostring(value)
   end
  end
 end
 
 return change
end

validArgs = validArgs or utils.invert({
 'help',
 'trait',
 'fixed',
 'percent',
 'set',
 'dur',
 'unit',
 'argument'
})
local args = utils.processArgs({...}, validArgs)

if args.help then -- Help declaration
 print([[unit/trait-change.lua
  Change the trait(s) of a unit
  arguments:
   -help
     print this help message
   -unit id
     REQUIRED
     id of the target unit
   -trait TRAIT_TOKEN
     REQUIRED
     trait to be changed
   -dur #
     length of time, in in-game ticks, for the change to last
     0 means the change is permanent
     DEFAULT: 0
   -fixed #                            \
     change trat by fixed amount       |
   -percent #                          |
     change trait by percentage amount | Must have one and only one of these arguments
   -set #                              |
     set trait to this value           /
  examples:
   unit/trait-change -unit \\UNIT_ID -fixed \-10 -trait ANGER
   unit/trait-change -unit \\UNIT_ID -set 100 -trait DEPRESSION
 ]])
 return
end

if args.unit and tonumber(args.unit) then -- Check for unit declaration !REQUIRED
 unit = df.unit.find(tonumber(args.unit))
else
 print('No unit selected')
 return
end

token = args.trait
if type(token) == 'string' then token = {token} end

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

for i,etype in ipairs(token) do -- !!RUN EFFECT!!
 change = effect(etype,unit,mode,tonumber(value[i]))
 if dur > 0 then
  script = 'unit/trait-change -unit '..tostring(unit.id)..' -fixed \\'..tostring(change)..' -trait '..etype
  dfhack.script_environment('persist-delay').persistantDelay(dur,script)
 end
end
if args.announcement then
--add announcement information
end