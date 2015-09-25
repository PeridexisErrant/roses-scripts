function getAttrValue(unit,attr,mental)
 if unit.curse.attr_change then
  if mental then
   return (unit.status.current_soul.mental_attrs[attr].value+unit.curse.attr_change.ment_att_add[attr])*unit.curse.attr_change.ment_att_perc[attr]/100
  else
   return (unit.body.physical_attrs[attr].value+unit.curse.attr_change.phys_att_add[attr])*unit.curse.attr_change.phys_att_perc[attr]/100
  end
 else
  if mental then
   return unit.status.current_soul[attr].value
  else
   return unit.body.physical_attrs[attr].value
  end
 end
end

function checkClass(unit,change,verbose)
 local persistTable = require 'persist-table'
 local key = tostring(unit.id)
 local yes = true
 local unitClasses = persistTable.GlobalTable.roses.UnitTable[key]['Classes']
 local unitCounters = persistTable.GlobalTable.roses.UnitTable[key]['Counters']
 local currentClass = unitClasses['Current']
 local classes = persistTable.GlobalTable.roses.ClassTable
 local currentClassName = currentClass['Name']
 local currentClassLevel = 0
-- Check if the unit meets the class and attribute requirements
 for _,x in pairs(classes[change]['RequiredClass']._children) do
  local classCheck = unitClasses[x]
  local i = classes[change]['RequiredClass'][x]
  if tonumber(classCheck['Level']) < tonumber(i) then
   if verbose then print('Class requirements not met. '..x..' level '..i..' needed. Current level is '..tostring(classCheck['Level'])) end
   yes = false
  end
 end
 for _,x in pairs(classes[change]['ForbiddenClass']._children) do
  local classCheck = unitClasses[x]
  local i = classes[change]['ForbiddenClass'][x]
  if tonumber(classCheck['Level']) >= tonumber(i) and tonumber(i) ~= 0 then
   if verbose then print('Already a member of a forbidden class. '..x) end
   yes = false
  elseif tonumber(i) == 0 and tonumber(classCheck['Experience']) > 0 then
   if verbose then print('Already a member of a forbidden class. '..x) end
   yes = false
  end
 end
 for _,x in pairs(classes[change]['RequiredCounter']._children) do
  local i = classes[change]['RequiredCounter'][x]
  if unitCounters[x] then
   if tonumber(unitCounters[x]['Value']) < tonumber(x) then
    if verbose then print('Counter requirements not met. '..i..x..' needed. Current amount is '..unitCounters[i]['Value']) end
    yes = false
   end
  else
   if verbose then print('Counter requirements not met. '..i..x..' needed. No current counter on the unit') end
   yes = false
  end
 end
 for _,x in pairs(classes[change]['RequiredPhysical']._children) do
  local currentStat = getAttrValue(unit,x,false)
  local i = classes[change]['RequiredPhysical'][x]
  local bonus = 0
  if currentClassName ~= 'None' then
   currentClassLevel = tonumber(unitClasses[currentClassName]['Level'])+1
   if classes[currentClassName]['BonusPhysical'][x] then bonus = classes[currentClassName]['BonusPhysical'][x][currentClassLevel] end
  end
  if currentStat-bonus < tonumber(i) then
   if verbose then print('Stat requirements not met. '..i..' '..x..' needed. Current amount is '..tostring(currentStat)) end
   yes = false
  end
 end
 for _,x in pairs(classes[change]['RequiredMental']._children) do
  local currentStat = getAttrValue(unit,x,true)
  local i = classes[change]['RequiredMental'][x]
  local bonus = 0
  if currentClassName ~= 'None' then
   currentClassLevel = tonumber(unitClasses[currentClassName]['Level'])+1
   if classes[currentClassName]['BonusMental'][x] then bonus = classes[currentClassName]['BonusMental'][x][currentClassLevel] end
  end
  if currentStat-bonus < tonumber(i) then
   if verbose then print('Stat requirements not met. '..i..' '..x..' needed. Current amount is '..tostring(currentStat)) end
   yes = false
  end
 end
 for _,x in pairs(classes[change]['RequiredSkill']._children) do
  local currentSkill = dfhack.units.getEffectiveSkill(unit,x)
  local i = classes[change]['RequiredSkill'][x]
  local bonus = 0
  if currentClassName ~= 'None' then
   currentClassLevel = tonumber(unitClasses[currentClassName]['Level'])+1
   if classes[currentClassName]['BonusSkill'][x] then bonus = classes[currentClassName]['BonusSkill'][x][currentClassLevel] end
  end
  if currentSkill-bonus < tonumber(i) then
   if verbose then print('Skill requirements not met. '..i..' '..x..' needed. Current amount is '..tostring(currentSkill)) end
   yes = false
  end
 end
 for _,x in pairs(classes[change]['RequiredTrait']._children) do
  local currentTrait = dfhack.units.getMiscTrait(unit,x)
  local i = classes[change]['RequiredTrait'][x]
  if currentTrait < tonumber(i) then
   if verbose then print('Trait requirements not met. '..i..' '..x..' needed. Current amount is '..tostring(currentTrait)) end
   yes = false
  end
 end
 return yes
end