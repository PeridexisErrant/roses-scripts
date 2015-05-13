--unit/value-change.lua v1.0

local utils = require 'utils'

function effect(e,unitTarget,ctype,strength)
 local value = 0
 local t = 0
 local int16 = 30000
 local int32 = 200000000
 if (e == 'webbed' or e == 'stunned' or e == 'winded' or e == 'unconscious' or e == 'pain'
 or e == 'nausea' or e == 'dizziness') then
  current = unitTarget.counters[e] 
 elseif (e == 'paralysis' or e == 'numbness' or e == 'fever' or e == 'exhaustion' 
 or e == 'hunger' or e == 'thirst' or e == 'sleepiness') then
  if (e == 'hunger' or e == 'thirst' or e == 'sleepiness') then e = e .. '_timer' end
  current = unitTarget.counters2[e] 
 elseif e == 'blood' then
  current = unitTarget.body.blood_count
 elseif e == 'infection' then
  current = unitTarget.body.infection_level 
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
 
 if (e == 'webbed' or e == 'stunned' or e == 'winded' or e == 'unconscious' or e == 'pain'
 or e == 'nausea' or e == 'dizziness') then
  if value > int16 then value = int16 end
  if value < 0 then value = 0 end
  unitTarget.counters[e] = value
 elseif (e == 'paralysis' or e == 'numbness' or e == 'fever' or e == 'exhaustion' 
 or e == 'hunger' or e == 'thirst' or e == 'sleepiness') then
  if (e == 'hunger' or e == 'thirst' or e == 'sleepiness') then e = e .. '_timer' end
  if value > int16 then value = int16 end
  if value < 0 then value = 0 end
  unitTarget.counters2[e] = value
 elseif e == 'blood' then
  if value > unitTarget.body.blood_max then value = unitTarget.body.blood_max end
  if value < 0 then value = 0 end
  unitTarget.body.blood_count = value
 elseif e == 'infection' then
  if value > int16 then value = int16 end
  if value < 0 then value = 0 end
  unitTarget.body.infection_level = value
 end 

 return change
end

validArgs = validArgs or utils.invert({
 'help',
 'token',
 'fixed',
 'percent',
 'set',
 'dur',
 'unit',
 'argument'
})
local args = utils.processArgs({...}, validArgs)

if args.help then -- Help declaration
 print([[unit/counter-change.lua
  Change the value(s) of a unit
  arguments:
   -help
     print this help message
   -unit id
     REQUIRED
     id of the target unit
   -token TYPE
     REQUIRED
     token to be changed
     valid types:
      webbed
      stunned
      winded
      unconscious
      pain
      nausea
      dizziness
      paralysis
      numbness
      fever
      exhaustion
      hunger
      thirst
      sleepiness
      blood
      infection    
   -dur #
     length of time, in in-game ticks, for the change to last
     0 means the change is permanent
     DEFAULT: 0
   -fixed #                                  \
     change token value by fixed amount      |
   -percent #                                |
     change token value by percentage amount | Must have one and only one of these arguments
   -set #                                    |
     set token value to this value           /
  examples:
   unit/counter-change -unit \\UNIT_ID -fixed 10000 -token stunned -dur 10
   unit/counter-change -unit \\UNIT_ID -set [0,0,0,0] -token [nausea,dizziness,numbness,fever]
   unit/counter-change -unit \\UNIT_ID -percent \-100 -token blood
 ]])
 return
end

if args.unit and tonumber(args.unit) then -- Check for unit declaration !REQUIRED
 unit = df.unit.find(tonumber(args.unit))
else
 print('No unit selected')
 return
end

token = args.token
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
  script = 'unit/counter-change -unit '..tostring(unit.id)..' -fixed \\'..tostring(change)..' -token '..etype
  dfhack.script_environment('persist-delay').persistentDelay(dur,script)
 end
end
if args.announcement then
--add announcement information
end