--unit/skill-change.lua v1.0

local utils = require 'utils'
local persistTable = require 'persist-table'

function effect(skill,unit,ctype,strength)
 local skills = unit.status.current_soul.skills
 local skillid = df.job_skill[skill]
 local value = 0
 local found = false
 local current = 0
 local change = 0
 
 if skills ~= nil then
  for i,x in ipairs(skills) do
   if x.id == skillid then
    found = true
	token = x
    current = x.rating
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
    break
   end
  end
 end
 
 if not found then
  utils.insert_or_update(unit.status.current_soul.skills,{new = true, id = skillid, rating = 0},'id')
  skills = unit.status.current_soul.skills
  for i,x in ipairs(skills) do
   if x.id == skillid then
    found = true
	token = x
    current = x.rating
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
   end
  end
 end
 
 value = math.floor(value)
 if value > 20 then value = 20 end
 if value < 0 then value = 0 end
 token.rating = value
 
 if persistTable.GlobalTable.roses then
  local unitTable = persistTable.GlobalTable.roses.UnitTable
  if unitTable[tostring(unit.id)] then
   unitTable[tostring(unit.id)].Skills = unitTable[tostring(unit.id)].Skills or {}  
  else
   unitTable[tostring(unit.id)] = {}
   unitTable[tostring(unit.id)].Skills = {}
  end
  skillTable = unitTable[tostring(unit.id)].Skills
  if skillTable[skill] then
   skillTable[skill].Current = tostring(current)
   if dur > 0 then
    skillTable[skill].Change = tostring(skillTable[skill].Change - change)
   else
    skillTable[skill].Base = tostring(value)
   end
  else
   skillTable[skill] = {}
   if dur > 0 then
    skillTable[skill].Change = tostring(change)
    skillTable[skill].Base = tostring(current)
    skillTable[skill].Current = tostring(current)
   else
    skillTable[skill].Change = '0'
    skillTable[skill].Base = tostring(value)
    skillTable[skill].Current = tostring(value)
   end
  end
 end
 
 return change
end

validArgs = validArgs or utils.invert({
 'help',
 'skill',
 'fixed',
 'percent',
 'set',
 'dur',
 'unit',
 'argument'
})
local args = utils.processArgs({...}, validArgs)

if args.help then -- Help declaration
 print([[unit/skill-change.lua
  Change the skill(s) of a unit
  arguments:
   -help
     print this help message
   -unit id
     REQUIRED
     id of the target unit
   -skill SKILL_TOKEN
     REQUIRED
     skill to be changed
   -dur #
     length of time, in in-game ticks, for the change to last
     0 means the change is permanent
     DEFAULT: 0
   -fixed #                            \
     change skill by fixed amount      |
   -percent #                          |
     change skill by percentage amount | Must have one and only one of these arguments
   -set #                              |
     set skill to this value           /
  examples:
   unit/skill-change -unit \\UNIT_ID -fixed 1 -skill ALCHEMY
   unit/skill-change -unit \\UNIT_ID -set [0,0,0] -skill [GRASP_STRIKE,STANCE_STRIKE,DODGER]
 ]])
 return
end

if args.unit and tonumber(args.unit) then -- Check for unit declaration !REQUIRED
 unit = df.unit.find(tonumber(args.unit))
else
 print('No unit selected')
 return
end

token = args.skill
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
  script = 'unit/skill-change -unit '..tostring(unit.id)..' -fixed \\'..tostring(change)..' -skill '..etype
  dfhack.script_environment('persist-delay').persistantDelay(dur,script)
 end
end
if args.announcement then
--add announcement information
end