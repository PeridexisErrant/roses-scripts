local utils = require 'utils'
local split = utils.split_string
local persistTable = require 'persist-table'

function changeclass(unit,change,verbose)
 local key = tostring(unit.id)
-- Change the units class
 local currentClass = persistTable.GlobalTable.roses.UnitTable[key]['Classes']['Current']
 local nextClass = persistTable.GlobalTable.roses.UnitTable[key]['Classes'][change]
 local classes = persistTable.GlobalTable.roses.ClassTable
 if currentClass['Name'] == change then
  if verbose then print('Already this class') end
  return false
 end
 local currentClassExp = tonumber(currentClass['CurrentExp'])
 if currentClass['Name'] ~= 'None' then
  local storeClass = persistTable.GlobalTable.roses.UnitTable[key]['Classes'][currentClass['Name']]
  storeClass['Experience'] = tostring(tonumber(storeClass['Experience']) + currentClassExp)
  local currentClassLevel = storeClass['Level']
  dfhack.run_command("modtools/add-syndrome -target "..key.." -syndrome "..currentClass['Name'].." -eraseAll")
  for _,x in pairs(classes[currentClass['Name']]['BonusPhysical']._children) do
   local i = classes[currentClass['Name']]['BonusPhysical'][x]
   dfhack.run_command('unit/attribute-change -unit '..key..' -physical '..x..' -fixed \\'..tostring(-tonumber(split(i[currentClassLevel+1],']')[1])))
  end
  for _,x in pairs(classes[currentClass['Name']]['BonusMental']._children) do
   local i = classes[currentClass['Name']]['BonusMental'][x]
   dfhack.run_command('unit/attribute-change -unit '..key..' -mental '..x..' -fixed \\'..tostring(-tonumber(split(i[currentClassLevel+1],']')[1])))
  end
  for _,x in pairs(classes[currentClass['Name']]['BonusSkill']._children) do
   local i = classes[currentClass['Name']]['BonusSkill'][x]
   dfhack.run_command('unit/skill-change -unit '..key..' -skill '..x..' -fixed \\'..tostring(-tonumber(split(i[currentClassLevel+1],']')[1])))
  end
  for i,x in pairs(classes[currentClass['Name']]['BonusTrait']._children) do
   local i = classes[currentClass['Name']]['BonusTrait'][x]
   dfhack.run_command('unit/trait-change -unit '..key..' -trait '..x..' -fixed \\'..tostring(-tonumber(split(i[currentClassLevel+1],']')[1])))
  end
  for i,x in pairs(classes[currentClass['Name']]['Spells']._children) do
   dfhack.run_command('modtools/add-syndrome -target '..key..' -syndrome '..x,' -erase')
  end
 end
 currentClass['Name'] = change
 currentClass['CurrentExp'] = nextClass['Experience']
 currentClassLevel = nextClass['Level']
 dfhack.run_command('modtools/add-syndrome -target '..key..' -syndrome '..change)
 for _,x in pairs(classes[currentClass['Name']]['BonusPhysical']._children) do
  local i = classes[currentClass['Name']]['BonusPhysical'][x]
  dfhack.run_command('unit/attribute-change -unit '..key..' -physical '..x..' -fixed \\'..tostring(tonumber(split(i[currentClassLevel+1],']')[1])))
 end
 for _,x in pairs(classes[currentClass['Name']]['BonusMental']._children) do
  local i = classes[currentClass['Name']]['BonusMental'][x]
  dfhack.run_command('unit/attribute-change -unit '..key..' -mental '..x..' -fixed \\'..tostring(tonumber(split(i[currentClassLevel+1],']')[1])))
 end
 for _,x in pairs(classes[currentClass['Name']]['BonusSkill']._children) do
  local i = classes[currentClass['Name']]['BonusSkill'][x]
  dfhack.run_command('unit/skill-change -unit '..key..' -skill '..x..' -fixed \\'..tostring(tonumber(split(i[currentClassLevel+1],']')[1])))
 end
 for i,x in pairs(classes[currentClass['Name']]['BonusTrait']._children) do
  local i = classes[currentClass['Name']]['BonusTrait'][x]
  dfhack.run_command('unit/trait-change -unit '..key..' -trait '..x..' -fixed \\'..tostring(tonumber(split(i[currentClassLevel+1],']')[1])))
 end
 for i,x in pairs(classes[currentClass['Name']]['Spells']._children) do
  if persistTable.GlobalTable.roses.UnitTable[key].Spells[x] == '1' then
   dfhack.run_command('classes/learn-skill -unit '..key..' -spell '..x)
  end
  local i = classes[currentClass['Name']]['Spells'][x]
  if tonumber(i['RequiredLevel']) <= currentClassLevel then
   if verbose then
    if i['AutoLearn'] then dfhack.run_command('classes/learn-skill -unit '..key..' -spell '..x..' -verbose') end
   else
    if i['AutoLearn'] then dfhack.run_command('classes/learn-skill -unit '..key..' -spell '..x) end
   end
  end
 end
 if verbose then print('Class change successful. Changed to '..change..'.') end
 return true
end

validArgs = validArgs or utils.invert({
 'help',
 'unit',
 'class',
 'override',
 'verbose'
})
local args = utils.processArgs({...}, validArgs)

verbose = false
if args.verbose then verbose = true end

unit = df.unit.find(tonumber(args.unit))
dfhack.script_environment('classes/establish-class').establishClass(unit)
if args.override then
 yes = true
else
 yes = dfhack.script_environment('classes/requirements-class').checkClass(unit,args.class,verbose)
end
if yes then
 success = changeclass(unit,args.class,verbose)
 if success then
 -- Erase items used for reaction
 end
else
 if verbose then print('Failed to change class') end
end