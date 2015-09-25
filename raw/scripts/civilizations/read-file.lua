function tchelper(first, rest)
  return first:upper()..rest:lower()
end

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
 civs = persistTable.GlobalTable.roses.CivilizationTable
 count = 1
 for i,x in ipairs(totdat) do
  if split(x,':')[1] == '[CIV' then
   d[count] = {split(split(x,':')[2],']')[1],i,0}
   count = count + 1
  end
 end
 for i,x in ipairs(d) do
  civToken = x[1]
  startLine = x[2]+1
  if i == #d then
   endLine = #totdat
  else
   endLine = d[i+1][2]-1
  end
  civs[civToken] = {}
  civs[civToken]['Level'] = {}
  for j = startLine,endLine,1 do
   test = totdat[j]:gsub("%s+","")
   testa = split(test,':')
   array = split(totdat[j],':')
   for k = 1, #array, 1 do
    array[k] = split(array[k],']')[1]
   end
   if testa[1] == '[NAME' then
    civs[civToken]['Name'] = array[2]
   elseif testa[1] == '[LEVELS' then
    civs[civToken]['Levels'] = array[2]
   elseif testa[1] == '[LEVEL_METHOD' then
    civs[civToken]['LevelMethod'] = array[2]
    civs[civToken]['LevelPercent'] = array[3]
   elseif testa[1] == '[LEVEL' then
    level = array[2]
    civs[civToken]['Level'][level] = {}
    civsLevel = civs[civToken]['Level'][level]
    civsLevel['Ethics'] = {}
    civsLevel['RemovePosition'] = {}
    civsLevel['AddPosition'] = {}
    civsLevel['Remove'] = {}
    civsLevel['Remove']['Creature'] = {}
    civsLevel['Remove']['Organic'] = {}
    civsLevel['Remove']['Inorganic'] = {}
    civsLevel['Remove']['Refuse'] = {}
    civsLevel['Remove']['Item'] = {}
    civsLevel['Remove']['Misc'] = {}
    --Creatures
    civsRemoveCreature = civsLevel['Remove']['Creature']
    civsRemoveCreature['Pet'] = {}
    civsRemoveCreature['Wagon'] = {}
    civsRemoveCreature['Mount'] = {}
    civsRemoveCreature['Pack'] = {}
    civsRemoveCreature['Minion'] = {}
    civsRemoveCreature['Exotic'] = {}
    civsRemoveCreature['Fish'] = {}
    civsRemoveCreature['Egg'] = {}
    --Inorganics
    civsRemoveInorganic = civsLevel['Remove']['Inorganic']
    civsRemoveInorganic['Metal'] = {}
    civsRemoveInorganic['Stone'] = {}
    civsRemoveInorganic['Gem'] = {}
    --Organics
    civsRemoveOrganic = civsLevel['Remove']['Organic']
    civsRemoveOrganic['Leather'] = {}
    civsRemoveOrganic['Fiber'] = {}
    civsRemoveOrganic['Silk'] = {}
    civsRemoveOrganic['Wool'] = {}
    civsRemoveOrganic['Wood'] = {}
    civsRemoveOrganic['Plant'] = {}
    civsRemoveOrganic['Seed'] = {}
    --Refuse
    civsRemoveRefuse = civsLevel['Remove']['Refuse']
    civsRemoveRefuse['Bone'] = {}
    civsRemoveRefuse['Shell'] = {}
    civsRemoveRefuse['Pearl'] = {}
    civsRemoveRefuse['Ivory'] = {}
    civsRemoveRefuse['Horn'] = {}
    --Item
    civsRemoveItem = civsLevel['Remove']['Item']
    civsRemoveItem['Weapon'] = {}
    civsRemoveItem['Shield'] = {}
    civsRemoveItem['Ammo'] = {}
    civsRemoveItem['Helm'] = {}
    civsRemoveItem['Armor'] = {}
    civsRemoveItem['Pants'] = {}
    civsRemoveItem['Shoes'] = {}
    civsRemoveItem['Gloves'] = {}
    civsRemoveItem['Trap'] = {}
    civsRemoveItem['Siege'] = {}
    civsRemoveItem['Toy'] = {}
    civsRemoveItem['Instrument'] = {}
    civsRemoveItem['Tool'] = {}
    civsRemoveItem['Digger'] = {}
    civsRemoveItem['Training'] = {}
    --Misc
    civsRemoveMisc = civsLevel['Remove']['Misc']
    civsRemoveMisc['Booze'] = {}
    civsRemoveMisc['Cheese'] = {}
    civsRemoveMisc['Powder'] = {}
    civsRemoveMisc['Extract'] = {}
    civsRemoveMisc['Meat'] = {}
    civsLevel['Add'] = {}
    civsLevel['Add']['Creature'] = {}
    civsLevel['Add']['Organic'] = {}
    civsLevel['Add']['Inorganic'] = {}
    civsLevel['Add']['Refuse'] = {}
    civsLevel['Add']['Item'] = {}
    civsLevel['Add']['Misc'] = {}
    --Creatures
    civsAddCreature = civsLevel['Add']['Creature']
    civsAddCreature['Pet'] = {}
    civsAddCreature['Wagon'] = {}
    civsAddCreature['Mount'] = {}
    civsAddCreature['Pack'] = {}
    civsAddCreature['Minion'] = {}
    civsAddCreature['Exotic'] = {}
    civsAddCreature['Fish'] = {}
    civsAddCreature['Egg'] = {}
    --Inorganics
    civsAddInorganic = civsLevel['Add']['Inorganic']
    civsAddInorganic['Metal'] = {}
    civsAddInorganic['Stone'] = {}
    civsAddInorganic['Gem'] = {}
    --Organics
    civsAddOrganic = civsLevel['Add']['Organic']
    civsAddOrganic['Leather'] = {}
    civsAddOrganic['Fiber'] = {}
    civsAddOrganic['Silk'] = {}
    civsAddOrganic['Wool'] = {}
    civsAddOrganic['Wood'] = {}
    civsAddOrganic['Plant'] = {}
    civsAddOrganic['Seed'] = {}
    --Refuse
    civsAddRefuse = civsLevel['Add']['Refuse']
    civsAddRefuse['Bone'] = {}
    civsAddRefuse['Shell'] = {}
    civsAddRefuse['Pearl'] = {}
    civsAddRefuse['Ivory'] = {}
    civsAddRefuse['Horn'] = {}
    --Item
    civsAddItem = civsLevel['Add']['Item']
    civsAddItem['Weapon'] = {}
    civsAddItem['Shield'] = {}
    civsAddItem['Ammo'] = {}
    civsAddItem['Helm'] = {}
    civsAddItem['Armor'] = {}
    civsAddItem['Pants'] = {}
    civsAddItem['Shoes'] = {}
    civsAddItem['Gloves'] = {}
    civsAddItem['Trap'] = {}
    civsAddItem['Siege'] = {}
    civsAddItem['Toy'] = {}
    civsAddItem['Instrument'] = {}
    civsAddItem['Tool'] = {}
    civsAddItem['Digger'] = {}
    civsAddItem['Training'] = {}
    --Misc
    civsAddMisc = civsLevel['Add']['Misc']
    civsAddMisc['Booze'] = {}
    civsAddMisc['Cheese'] = {}
    civsAddMisc['Powder'] = {}
    civsAddMisc['Extract'] = {}
    civsAddMisc['Meat'] = {}
   elseif testa[1] == '[LEVEL_NAME' then
    civsLevel['Name'] = array[2]
   elseif testa[1] == '[LEVEL_REMOVE' then
    if array[2] == 'CREATURE' then
     civsRemoveCreature[array[3]:gsub("(%a)([%w_']*)", tchelper)][array[4]] = array[5]
    elseif array[2] == 'INORGANIC' then
     civsRemoveInorganic[array[3]:gsub("(%a)([%w_']*)", tchelper)][array[4]] = array[4]
    elseif array[2] == 'ORGANIC' then
     civsRemoveOrganic[array[3]:gsub("(%a)([%w_']*)", tchelper)][array[4]] = array[5]
    elseif array[2] == 'REFUSE' then
     civsRemoveRefuse[array[3]:gsub("(%a)([%w_']*)", tchelper)][array[4]] = array[5]
    elseif array[2] == 'ITEM' then
     civsRemoveItem[array[3]:gsub("(%a)([%w_']*)", tchelper)][array[4]] = array[4]
    elseif array[2] == 'MISC' then
     civsRemoveMisc[array[3]:gsub("(%a)([%w_']*)", tchelper)][array[4]] = array[5]
    end
   elseif testa[1] == '[LEVEL_ADD' then
    if array[2] == 'CREATURE' then
     civsAddCreature[array[3]:gsub("(%a)([%w_']*)", tchelper)][array[4]] = array[5]
    elseif array[2] == 'INORGANIC' then
     civsAddInorganic[array[3]:gsub("(%a)([%w_']*)", tchelper)][array[4]] = array[4]
    elseif array[2] == 'ORGANIC' then
     civsAddOrganic[array[3]:gsub("(%a)([%w_']*)", tchelper)][array[4]] = array[5]
    elseif array[2] == 'REFUSE' then
     civsAddRefuse[array[3]:gsub("(%a)([%w_']*)", tchelper)][array[4]] = array[5]
    elseif array[2] == 'ITEM' then
     civsAddItem[array[3]:gsub("(%a)([%w_']*)", tchelper)][array[4]] = array[4]
    elseif array[2] == 'MISC' then
     civsAddMisc[array[3]:gsub("(%a)([%w_']*)", tchelper)][array[4]] = array[5]
    end
   elseif testa[1] == '[LEVEL_CHANGE_ETHIC' then
    civsLevel['Ethics'][array[2]:gsub("(%a)([%w_']*)", tchelper)] = array[3]
   elseif testa[1] == '[LEVEL_CHANGE_METHOD' then
    civsLevel['LevelMethod'] = array[2]
    civsLevel['LevelPercent'] = array[3]
   elseif testa[1] == '[LEVEL_REMOVE_POSITION' then
    civsLevel['RemovePosition'][array[2]] = array[2]
   elseif testa[1] == '[LEVEL_ADD_POSITION' then
    position = array[2]
    civsLevel['AddPosition'][position] = {}
    civsAddPosition = civsLevel['AddPosition'][position]
    civsAddPosition['AllowedCreature'] = {}
    civsAddPosition['AllowedClass'] = {}
    civsAddPosition['RejectedCreature'] = {}
    civsAddPosition['RejectedClass'] = {}
    civsAddPosition['Responsibility'] = {}
    civsAddPosition['AppointedBy'] = {}
    civsAddPosition['Flags'] = {}
   elseif testa[1] == '[ALLOWED_CREATURE' then
--    printall(split(totdat[j-1],':'))
--    printall(array)
--    printall(civs[civToken]['LEVEL'][level])
--    printall(civs[civToken]['LEVEL'][level]['ADD_POSITION'])
--    printall(civs[civToken]['LEVEL'][level]['ADD_POSITION'][position])
    civsAddPosition['AllowedCreature'][array[2]] = array[3]
   elseif testa[1] == '[REJECTED_CREATURE' then
    civsAddPosition['RejectedCreature'][array[2]] = array[3]
   elseif testa[1] == '[ALLOWED_CLASS' then
    civsAddPosition['AllowedClass'][array[2]] = array[2]
   elseif testa[1] == '[REJECTED_CLASS' then
    civsAddPosition['RejectedClass'][array[2]] = array[2]
   elseif testa[1] == '[NAME' then
    civsAddPosition['Name'] = array[2]..':'..array[3]
   elseif testa[1] == '[NAME_MALE' then
    civsAddPosition['NameMale'] = array[2]..':'..array[3]
   elseif testa[1] == '[NAME_FEMALE' then
    civsAddPosition['NameFemale'] = array[2]..':'..array[3]
   elseif testa[1] == '[SPOUSE' then
    civsAddPosition['Spouse'] = array[2]..':'..array[3]
   elseif testa[1] == '[SPOUSE_MALE' then
    civsAddPosition['SpouseMale'] = array[2]..':'..array[3]
   elseif testa[1] == '[SPOUSE_FEMALE' then
    civsAddPosition['SpouseFemale'] = array[2]..':'..array[3]
   elseif testa[1] == '[NUMBER' then
    civsAddPosition['Number'] = array[2]
   elseif testa[1] == '[SUCCESSION' then
    civsAddPosition['Sucession'] = array[2]
   elseif testa[1] == '[LAND_HOLDER' then
    civsAddPosition['LandHolder'] = array[2]
   elseif testa[1] == '[LAND_NAME' then
    civsAddPosition['LandName'] = array[2]
   elseif testa[1] == '[APPOINTED_BY' then
    civsAddPosition['AppointedBy'][array[2]] = array[2]
   elseif testa[1] == '[REPLACED_BY' then
    civsAddPosition['ReplacedBy'] = array[2]
   elseif testa[1] == '[RESPONSIBILITY' then
    civsAddPosition['Responsibility'][array[2]] = array[2]
   elseif testa[1] == '[PRECEDENCE' then
    civsAddPosition['Precedence'] = array[2]
   elseif testa[1] == '[REQUIRES_POPULATION' then
    civsAddPosition['RequiresPopulation'] = array[2]
   elseif testa[1] == '[REQUIRED_BOXES' then
    civsAddPosition['RequiredBoxes'] = array[2]
   elseif testa[1] == '[REQUIRED_CABINETS' then
    civsAddPosition['RequiredCabinets'] = array[2]
   elseif testa[1] == '[REQUIRED_RACKS' then
    civsAddPosition['RequiredRacks'] = array[2]
   elseif testa[1] == '[REQUIRED_STANDS' then
    civsAddPosition['RequiredStands'] = array[2]
   elseif testa[1] == '[REQUIRED_OFFICE' then
    civsAddPosition['RequiredOffice'] = array[2]
   elseif testa[1] == '[REQUIRED_BEDROOM' then
    civsAddPosition['RequiredBedroom'] = array[2]
   elseif testa[1] == '[REQUIRED_DINING' then
    civsAddPosition['RequiredDining'] = array[2]
   elseif testa[1] == '[REQUIRED_TOMB' then
    civsAddPosition['RequiredTomb'] = array[2]
   elseif testa[1] == '[MANDATE_MAX' then
    civsAddPosition['MandateMax'] = array[2]
   elseif testa[1] == '[DEMAND_MAX' then
    civsAddPosition['DemandMax'] = array[2]
   elseif testa[1] == '[COLOR' then
    civsAddPosition['Color'] = array[2]..':'..array[3]..':'..array[4]
   elseif testa[1] == '[SQUAD' then
    civsAddPosition['Squad'] = array[2]..':'..array[3]..':'..array[4]
   elseif testa[1] == '[COMMANDER' then
    civsAddPosition['Commander'] = array[2]..':'..array[3]
   elseif testa[1] == '[FLAGS' then
    civsAddPosition['Flags'][array[2]] = 'true'
   else
    if position then civsAddPosition[split(split(totdat[j],']')[1],'%[')[2]] = 'true' end
   end
  end
 end
 return civs
end