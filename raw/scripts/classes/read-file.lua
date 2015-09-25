function readFile(path)
 local utils = require 'utils'
 local split = utils.split_string
 local persistTable = require 'persist-table'
 local iofile = io.open(path,"r")
 local totdat = {}
 local count = 1
 while true do
  local line = iofile:read("*line")
  if line == nil then break end
  totdat[count] = line
  count = count + 1
 end
 iofile:close()

 d = {}
 classes = persistTable.GlobalTable.roses.ClassTable
 spells = persistTable.GlobalTable.roses.SpellTable
 count = 1
 for i,x in ipairs(totdat) do
  if split(x,':')[1] == '[CLASS' then
   d[count] = {split(split(x,':')[2],']')[1],i,0}
   count = count + 1
  end
 end
 for i,x in ipairs(d) do
  classToken = x[1]
  startLine = x[2]+1
  if i ==#d then
   endLine = #totdat
  else
   endLine = d[i+1][2]-1
  end
  classes[classToken] = {}
  for j = startLine,endLine,1 do
   test = totdat[j]:gsub("%s+","")
   test = split(test,':')[1]
   if test == '[NAME' then
    classes[classToken]['Name'] = split(split(totdat[j],':')[2],']')[1]
   elseif test == '[LEVELS' then
    classes[classToken]['Levels'] = split(split(totdat[j],':')[2],']')[1]
   end
   if classes[classToken]['Name'] and classes[classToken]['Levels'] then break end
  end
  classes[classToken]['Experience'] = {}
  classes[classToken]['LevelBonus'] = {}
  classes[classToken]['RequiredClass'] = {}
  classes[classToken]['RequiredPhysical'] = {}
  classes[classToken]['RequiredCounter'] = {}
  classes[classToken]['RequiredMental'] = {}
  classes[classToken]['RequiredCreature'] = {}
  classes[classToken]['BonusPhysical'] = {}
  classes[classToken]['BonusMental'] = {}
  classes[classToken]['RequiredSkill'] = {}
  classes[classToken]['RequiredTrait'] = {}
  classes[classToken]['ForbiddenClass'] = {}
  classes[classToken]['BonusSkill'] = {}
  classes[classToken]['BonusTrait'] = {}
  classes[classToken]['Spells'] = {}
  for j = startLine,endLine,1 do
   test = totdat[j]:gsub("%s+","")
   test = split(test,':')[1]
   array = split(totdat[j],':')
   for k = 1, #array, 1 do
    array[k] = split(array[k],']')[1]
   end
   if test == '[AUTO_UPGRADE' then
    classes[classToken]['AutoUpgrade'] = array[2]
   elseif test == '[EXP' then
    local temptable = {select(2,table.unpack(array))}
    strint = '1'
    for _,v in pairs(temptable) do
     classes[classToken]['Experience'][strint] = v
     strint = tostring(strint+1)
    end
    if tonumber(strint)-1 < tonumber(classes[classToken]['Levels']) then
--     print('Incorrect amount of experience numbers, must be equal to number of levels. Assuming linear progression for next experience level')
     while (tonumber(strint)-1) < tonumber(classes[classToken]['Levels']) do
--      print('Incorrect amount of experience numbers, must be equal to number of levels. Assuming linear progression for next experience level')
      classes[classToken]['Experience'][strint] = tostring(2*tonumber(classes[classToken]['Experience'][tostring(strint-1)])-tonumber(classes[classToken]['Experience'][tostring(strint-2)]))
      strint = tostring(tonumber(strint)+1)
     end
    end
   elseif test == '[REQUIREMENT_CLASS' then
    classes[classToken]['RequiredClass'][array[2]] = array[3]
   elseif test == '[FORBIDDEN_CLASS' then
    classes[classToken]['ForbiddenClass'][array[2]] = array[3]
   elseif test == '[REQUIREMENT_SKILL' then
    classes[classToken]['RequiredSkill'][array[2]] = array[3]
   elseif test == '[REQUIREMENT_TRAIT' then
    classes[classToken]['RequiredTrait'][array[2]] = array[3]
   elseif test == '[REQUIREMENT_COUNTER' then
    classes[classToken]['RequiredCounter'][array[2]] = array[3]
   elseif test == '[REQUIREMENT_PHYS' then
    classes[classToken]['RequiredPhysical'][array[2]] = array[3]
   elseif test == '[REQUIREMENT_MENT' then
    classes[classToken]['RequiredMental'][array[2]] = array[3]
   elseif test == '[REQUIREMENT_CREATURE' then
    classes[classToken]['RequiredCreature'][array[2]] = array[3]
   elseif test == '[LEVELING_BONUS' then
    classes[classToken]['LevelBonus']['Physical'] = classes[classToken]['LevelBonus']['Physical'] or {}
    classes[classToken]['LevelBonus']['Mental'] = classes[classToken]['LevelBonus']['Mental'] or {}
    classes[classToken]['LevelBonus']['Skill'] = classes[classToken]['LevelBonus']['Skill'] or {}
    classes[classToken]['LevelBonus']['Trait'] = classes[classToken]['LevelBonus']['Trait'] or {}
    if array[2] == 'PHYSICAL' then
     classes[classToken]['LevelBonus']['Physical'][array[3]] = array[4]
    elseif array[2] == 'MENTAL' then
     classes[classToken]['LevelBonus']['Mental'][array[3]] = array[4]
    elseif array[2] == 'SKILL' then
     classes[classToken]['LevelBonus']['Skill'][array[3]] = array[4]
    elseif array[2] == 'TRAIT' then
     classes[classToken]['LevelBonus']['Trait'][array[3]] = array[4]
    end
   elseif test == '[BONUS_PHYS' then
    local temptable = {select(3,table.unpack(array))}
    local strint = '1'
    classes[classToken]['BonusPhysical'][array[2]] = {}
    for _,v in pairs(temptable) do
     classes[classToken]['BonusPhysical'][array[2]][strint] = v
     strint = tostring(strint+1)
    end
    if tonumber(strint)-1 < tonumber(classes[classToken]['Levels'])+1 then
--     print('Incorrect amount of physical bonus numbers, must be equal to number of levels + 1. Assuming previous physical bonus')
     while tonumber(strint)-1 < tonumber(classes[classToken]['Levels'])+1 do
      classes[classToken]['BonusPhysical'][array[2]][strint] = classes[classToken]['BonusPhysical'][array[2]][tostring(strint-1)]
      strint = tostring(strint+1)
     end
    end
   elseif test == '[BONUS_TRAIT' then
    local temptable = {select(3,table.unpack(array))}
    local strint = '1'
    classes[classToken]['BonusTrait'][array[2]] = {}
    for _,v in pairs(temptable) do
     classes[classToken]['BonusTrait'][array[2]][strint] = v
     strint = tostring(strint+1)
    end
    if tonumber(strint)-1 < tonumber(classes[classToken]['Levels'])+1 then
--     print('Incorrect amount of trait bonus numbers, must be equal to number of levels + 1. Assuming previous trait bonus')
     while tonumber(strint)-1 < tonumber(classes[classToken]['Levels'])+1 do
      classes[classToken]['BonusTrait'][array[2]][strint] = classes[classToken]['BonusTrait'][array[2]][tostring(strint-1)]
      strint = tostring(strint+1)
     end
    end
   elseif test == '[BONUS_SKILL' then
    local temptable = {select(3,table.unpack(array))}
    local strint = '1'
    classes[classToken]['BonusSkill'][array[2]] = {}
    for _,v in pairs(temptable) do
     classes[classToken]['BonusSkill'][array[2]][strint] = v
     strint = tostring(strint+1)
    end
    if tonumber(strint)-1 < tonumber(classes[classToken]['Levels'])+1 then
--     print('Incorrect amount of skill bonus numbers, must be equal to number of levels + 1. Assuming previous skill bonus')
     while tonumber(strint)-1 < tonumber(classes[classToken]['Levels'])+1 do
      classes[classToken]['BonusSkill'][array[2]][strint] = classes[classToken]['BonusSkill'][array[2]][tostring(strint-1)]
      strint = tostring(strint+1)
     end
    end
   elseif test == '[BONUS_MENT' then
    local temptable = {select(3,table.unpack(array))}
    local strint = '1'
    classes[classToken]['BonusMental'][array[2]] = {}
    for _,v in pairs(temptable) do
     classes[classToken]['BonusMental'][array[2]][strint] = v
     strint = tostring(strint+1)
    end
    if tonumber(strint)-1 < tonumber(classes[classToken]['Levels'])+1 then
--     print('Incorrect amount of mental bonus numbers, must be equal to number of levels + 1. Assuming previous mental bonus')
     while tonumber(strint)-1 < tonumber(classes[classToken]['Levels'])+1 do
      classes[classToken]['BonusMental'][array[2]][strint] = classes[classToken]['BonusMental'][array[2]][tostring(strint-1)]
      strint = tostring(strint+1)
     end
    end
   elseif test == '[SPELL' then
    spell = array[2]
    spells[spell] = spell
    classes[classToken]['Spells'][spell] = {}
    classes[classToken]['Spells'][spell]['RequiredLevel'] = array[3]
--    classes[classToken]['Spells'][spell]['AutoLearn'] = 'false'
    classes[classToken]['Spells'][spell]['Cost'] = '0'
    classes[classToken]['Spells'][spell]['RequiredPhysical'] = {}
    classes[classToken]['Spells'][spell]['RequiredMental'] = {}
    classes[classToken]['Spells'][spell]['ForbiddenSpell'] = {}
    classes[classToken]['Spells'][spell]['ForbiddenClass'] = {}
    if classes[classToken]['Spells'][spell]['RequiredLevel'] == 'AUTO' then
     classes[classToken]['Spells'][spell]['RequiredLevel'] = '0'
     classes[classToken]['Spells'][spell]['AutoLearn'] = 'true'
    end
   elseif test == '[SPELL_REQUIRE_PHYS' then
    classes[classToken]['Spells'][spell]['RequiredPhysical'][array[2]] = array[3]
   elseif test == '[SPELL_REQUIRE_MENT' then
    classes[classToken]['Spells'][spell]['RequiredMental'][array[2]] = array[3]
   elseif test == '[SPELL_FORBIDDEN_SPELL' then
    classes[classToken]['Spells'][spell]['ForbiddenSpell'][array[2]] = array[2]
   elseif test == '[SPELL_FORBIDDEN_CLASS' then
    classes[classToken]['Spells'][spell]['ForbiddenClass'][array[2]] = array[3]
   elseif test == '[SPELL_UPGRADE' then
    classes[classToken]['Spells'][spell]['Upgrade'] = array[2]
   elseif test == '[SPELL_COST' then
    classes[classToken]['Spells'][spell]['Cost'] = array[2]
   elseif test == '[SPELL_EXP_GAIN' then
    classes[classToken]['Spells'][spell]['ExperienceGain'] = array[2]
   elseif test == '[SPELL_AUTO_LEARN]' then
    classes[classToken]['Spells'][spell]['AutoLearn'] = 'true'
--   else
--    print('Unrecognized token in classes.txt '..totdat[j]..' line '..tostring(j))
   end
  end
 end
 return classes
end