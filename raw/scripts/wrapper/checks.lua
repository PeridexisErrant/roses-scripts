local function checkAge(unit,array,unitTarget) --CHECK 1
 local utils = require 'utils'
 local split = utils.split_string
 local rtempa,itempa,r,i,required,immune = {},{},1,1,false,false
 local rtext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is too young.'
 local itext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is too old.'
 if type(array) ~= 'table' then array = {array} end
 local utemp = dfhack.units.getAge(unit)
 for _,x in ipairs(array) do
  if split(x,':')[1] == 'min' then
   if tonumber(split(x,':')[2]) > utemp then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,':')[1] == 'max' then
   if tonumber(split(x,':')[2]) < utemp then
    itempa[i] = true
   else
    itempa[i] = false
   end
   i = i + 1
  elseif split(x,':')[1] == 'greater' then
   if utemp/dfhack.units.getAge(unitTarget) >= tonumber(split(x,':')[2]) then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,':')[1] == 'less' then
   if utemp/dfhack.units.getAge(unitTarget) <= tonumber(split(x,':')[2]) then
    itempa[i] = true
   else
    itempa[i] = false
   end
   i = i + 1
  end
 end
 for _,x in ipairs(rtempa) do
  if x then required = true end
 end
 for _,x in ipairs(itempa) do
  if x then immune = true end
 end
 if required and not immune then return false,itext end
 if required and immune then return true,'NONE' end
 if not required and immune then return false,rtext end
 if not required and not immune then return false,rtext end
end

local function getAttrValue(unit,attr,mental) -- CHECK 1
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

local function checkAttributes(unit,array,mental,unitTarget) -- CHECK 1
 local utils = require 'utils'
 local split = utils.split_string
 local rtempa,itempa,r,i,required,immune = {},{},1,1,false,false
 local rtext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. "'s attributes are too low."
 local itext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. "'s attributes are too high."
 if type(array) ~= 'table' then array = {array} end
 for _,x in ipairs(array) do
  local utemp = getAttrValue(unit,split(x,':')[2],mental)
  if split(x,':')[1] == 'min' then
   if tonumber(split(x,':')[3]) >= utemp then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,':')[1] == 'max' then
   if tonumber(split(x,':')[3]) <= utemp then
    itempa[r] = true
   else
    itempa[r] = false
   end
   i = i + 1
  elseif split(x,':')[1] == 'greater' then
   if utemp/getAttrValue(unitTarget,split(x,':')[2],mental) >= tonumber(split(x,':')[3]) then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,':')[1] == 'less' then
   if utemp/getAttrValue(unitTarget,split(x,':')[2],mental) <= tonumber(split(x,':')[3]) then
    itempa[i] = true
   else
    itempa[i] = false
   end
   i = i + 1
  end
 end
 for _,x in ipairs(rtempa) do
  if x then required = true end
 end
 for _,x in ipairs(itempa) do
  if x then immune = true end
 end
 if required and not immune then return false,itext end
 if required and immune then return true,'NONE' end
 if not required and immune then return false,rtext end
 if not required and not immune then return false,rtext end
end

local function checkBody(unit,array)
 local utils = require 'utils'
 local split = utils.split_string
 local rtempa,itempa,r,i,required,immune = {},{},1,1,false,false
 local rtext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' does not have the required body part.'
 local itext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' has an immune body part.'
 local tempa,utempa = split(array,','),unit.body.body_plan.body_parts
 for _,x in ipairs(tempa) do
  t = split(x,':')[2]
  b = split(x,':')[3]
  if split(x,':')[1] == 'required' then
   if t == 'token' then
    for j,y in ipairs(utempa) do
     if y.token == b and not unit.body.components.body_part_status[j].missing then 
      rtempa[r] = true
     else
      rtempa[r] = false
     end
     r = r + 1
    end
   elseif t =='category' then
    for j,y in ipairs(utempa) do
     if y.category == b and not unit.body.components.body_part_status[j].missing then 
      rtempa[r] = true
     else
      rtempa[r] = false
     end
     r = r + 1
    end
   elseif t =='flags' then
    for j,y in ipairs(utempa) do
     if y.flags[b] and not unit.body.components.body_part_status[j].missing then 
      rtempa[r] = true
     else
      rtempa[r] = false
     end
     r = r + 1
    end
   end
  elseif split(x,':')[1] == 'immune' then
   if t == 'token' then
    for j,y in ipairs(utempa) do
     if y.token == b and not unit.body.components.body_part_status[j].missing then 
      itempa[i] = true
     else
      itempa[i] = false
     end
     i = i + 1
    end
   elseif t =='category' then
    for j,y in ipairs(utempa) do
     if y.category == b and not unit.body.components.body_part_status[j].missing then 
      itempa[i] = true
     else
      itempa[i] = false
     end
     i = i + 1
    end
   elseif t =='flags' then
    for j,y in ipairs(utempa) do
     if y.flags[b] and not unit.body.components.body_part_status[j].missing then 
      rtempa[r] = true
     else
      rtempa[r] = false
     end
     i = i + 1
    end
   end
  end
 end
 for _,x in ipairs(rtempa) do
  if x then required = true end
 end
 for _,x in ipairs(itempa) do
  if x then immune = true end
 end
 if required and not immune then return true,'NONE' end
 if required and immune then return false,itext end
 if not required and immune then return false,itext end
 if not required and not immune then return false,rtext end
end

local function checkCounters(unit,array)
 local utils = require 'utils'
 local split = utils.split_string
 tempa = split(array,':')
 types = tempa[1]
 counters = tempa[2]
 ints = tempa[3] or 0
 style = tempa[4] or nil
 n = tempa[5] or -1
 if types == 'GLOBAL' then
  tables = persistTable.GlobalTable.roses.GlobalTable.Counters
 elseif types == 'UNIT' then
  unitTable = persistTable.GlobalTable.roses.UnitTable[tostring(unit.id)]
  if unitTable then
   if unitTable.Counters then
    tables = unitTable.Counters
   else
    unitTable.Counters = {}
	tables = unitTable.Counters
   end
  else
   unitTable = {}
   unitTable.Counters = {}
   tables = unitTable.Counters
  end
 end
 if tables[counter] then
  tables[counter] = tostring(tables[counter] + tonumber(increase))
 else
  tables[counter] = tostring(increase)
 end
 if style = 'minimum' then
  if tables[counter] >= cap and cap >= 0 then
   return true, "Minimum counter reached"
  else
   return false, "Minimum counter not reached"
  end
 elseif style = 'percent' then
  rando = dfhack.random.new()
  roll = rando:drandom()
  if roll <= tables[counter]/cap and cap >=1 then
   return true, "Percent counter triggered"
  else
   return false, "Percent counter not triggered"
  end
 else
  return false, "No Style given"
 end
 return false, "Incorrect counter check"
end

local function checkDistance(unitTarget,array,plan) -- CHECK 1
 local utils = require 'utils'
 local split = utils.split_string
 local unumber = 1

 local selected,targetList,announcement = {},{},{''}

 if plan ~= 'NONE' then
  local file = plan..".txt"
  local path = dfhack.getDFPath().."/raw/scripts/"..file

  local iofile = io.open(path,"r")
  local read = iofile:read("*all")
  iofile:close()

  local reada = split(read,',')
  local x = {}
  local y = {}
  local t = {}
  local xi = 0
  local yi = 1
  local x0 = 0
  local y0 = 0
  for i,v in ipairs(reada) do
   if split(v,'\n')[1] ~= v then
    xi = 1
    yi = yi + 1
   else
    xi = xi + 1
   end
   if v == 'X' or v == '\nX' then
    x0 = xi
    y0 = yi
   end
   if v == 'X' or v == '\nX' or v == '1' or v == '\n1' then
    t[i] = true
   else
    t[i] = false
   end
   x[i] = xi
   y[i] = yi
  end

  for i,_ in ipairs(x) do
   x[i] = x[i] - x0 + unitTarget.pos.x
   y[i] = y[i] - y0 + unitTarget.pos.y
   t[tostring(x[i])..'_'..tostring(y[i])] = t[i]
  end

  local unitList = df.global.world.units.active
  local mapx, mapy, mapz = dfhack.maps.getTileSize()

  for i = 0, #unitList - 1, 1 do
   local unit = unitList[i]

   if (t[tostring(unit.pos.x)..'_'..tostring(unit.pos.y)] and unit.pos.z == unitTarget.pos.z) and unit.id ~= unitTarget.id then
    targetList[unumber] = unit
    announcement[unumber] = ''
    selected[unumber] = true
    unumber = unumber + 1
   end
  end
 else
  local rx = tonumber(split(array,',')[1])
  local ry = tonumber(split(array,',')[2])
  local rz = tonumber(split(array,',')[3])
  if rx*ry*rz >= 0 then
   local unitList = df.global.world.units.active
   local mapx, mapy, mapz = dfhack.maps.getTileSize()

   for i = 0, #unitList - 1, 1 do
    local unit = unitList[i]
    local xmin = unitTarget.pos.x - rx
    local xmax = unitTarget.pos.x + rx
    local ymin = unitTarget.pos.y - ry
    local ymax = unitTarget.pos.y + ry
    local zmin = unitTarget.pos.z - rz
    local zmax = unitTarget.pos.z + rz
    if xmin < 1 then xmin = 1 end
    if ymin < 1 then ymin = 1 end
    if zmin < 1 then zmin = 1 end
    if xmax > mapx then xmax = mapx-1 end
    if ymax > mapy then ymax = mapy-1 end
    if zmax > mapz then zmax = mapz-1 end

    if (unit.pos.x >= xmin and unit.pos.x <= xmax and unit.pos.y >= ymin and unit.pos.y <= ymax and unit.pos.z >= zmin and unit.pos.z <= zmax) then
     targetList[unumber] = unit
     announcement[unumber] = ''
     selected[unumber] = true
     unumber = unumber + 1
    end
   end
   else
    targetList[unumber] = unitTarget
    announcement[unumber] = ''
    selected[unumber] = true
  end
 end

 return selected, targetList, announcement
end

local function checkEntity(unit,array) -- CHECK 1
 local utils = require 'utils'
 local split = utils.split_string
 local rtempa,itempa,r,i,required,immune = {},{},1,1,false,false
 local rtext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is not a member of a required entity.'
 local itext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is a member of an immune entity.'
 if unit.civ_id < 0 then return false, 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is an animal.' end
 if type(array) ~= 'table' then array = {array} end
 local utemp = df.global.world.entities[unit.civ_id].entity_raw.code
 for _,x in ipairs(array) do
  if split(x,':')[1] == 'required' then
   if split(x,':')[2] == utemp then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,':')[1] == 'immune' then
   if split(x,':')[2] == utemp then
    itempa[r] = true
   else
    itempa[r] = false
   end
   i = i + 1
  end
 end
 for _,x in ipairs(rtempa) do
  if x then required = true end
 end
 for _,x in ipairs(itempa) do
  if x then immune = true end
 end
 if required and not immune then return true,'NONE' end
 if required and immune then return false,itext end
 if not required and immune then return false,itext end
 if not required and not immune then return false,rtext end
end

local function checkNoble(unit,array) -- CHECK 1
 local utils = require 'utils'
 local split = utils.split_string
 local rtempa,itempa,r,i,required,immune = {},{},1,1,false,false
 local rtext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' does not hold the required position.'
 local itext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is holding an immune position.'
 if type(array) ~= 'table' then array = {array} end
 local utempa = dfhack.units.getNoblePositions(unit)
 for _,x in ipairs(array) do
  for _,y in ipairs(utempa) do
   if split(x,':')[1] == 'required' then
    if split(x,':')[2] == y.position.code then
     rtempa[r] = true
    else
     rtempa[r] = false
    end
    r = r + 1
   elseif split(x,':')[1] == 'immune' then
    if split(x,':')[2] == y.position.code then
     itempa[i] = true
    else
     itempa[i] = false
    end
    i = i + 1
   end
  end
 end
 for _,x in ipairs(rtempa) do
  if x then required = true end
 end
 for _,x in ipairs(itempa) do
  if x then immune = true end
 end
 if required and not immune then return true,'NONE' end
 if required and immune then return false,itext end
 if not required and immune then return false,itext end
 if not required and not immune then return false,rtext end
end

local function checkProfession(unit,array) -- CHECK 1
 local utils = require 'utils'
 local split = utils.split_string
 local rtempa,itempa,r,i,required,immune = {},{},1,1,false,false
 local rtext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is not the required profession.'
 local itext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is an immune profession.'
 if type(array) ~= 'table' then array = {array} end
 local utemp = unit.profession
 for _,x in ipairs(array) do
  if split(x,':')[1] == 'required' then
   if df.profession[split(x,':')[2]] == utemp then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,':')[1] == 'immune' then
   if df.profession[split(x,':')[2]] == utemp then
    itempa[i] = true
   else
    itempa[i] = false
   end
   i = i + 1
  end
 end
 for _,x in ipairs(rtempa) do
  if x then required = true end
 end
 for _,x in ipairs(itempa) do
  if x then immune = true end
 end
 if required and not immune then return true,'NONE' end
 if required and immune then return false,itext end
 if not required and immune then return false,itext end
 if not required and not immune then return false,rtext end
end

local function checkSkills(unit,array,unitTarget) -- CHECK 1
 local utils = require 'utils'
 local split = utils.split_string
 local rtempa,itempa,r,i,required,immune = {},{},1,1,false,false
 local rtext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. "'s skills are too low."
 local itext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. "'s skills are too high."
 if type(array) ~= 'table' then array = {array} end
 for _,x in ipairs(array) do
  local utemp = dfhack.units.getEffectiveSkill(unit,df.job_skill[split(x,':')[2]])
  if split(x,':')[1] == 'min' then
   if tonumber(split(age,':')[3]) > utemp then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,':')[1] == 'max' then
   if tonumber(split(age,':')[3]) < utemp then
    itempa[i] = true
   else
    itempa[i] = false
   end
   i = i + 1
  elseif split(x,':')[1] == 'greater' then
   if utemp/dfhack.units.getEffectiveSkill(unitTarget,df.job_skill[split(x,':')[2]]) >= tonumber(split(x,':')[3]) then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,':')[1] == 'less' then
   if utemp/dfhack.units.getEffectiveSkill(unitTarget,df.job_skill[split(x,':')[2]]) <= tonumber(split(x,':')[3]) then
    itempa[i] = true
   else
    itempa[i] = false
   end
   i = i + 1
  end
 end
 for _,x in ipairs(rtempa) do
  if x then required = true end
 end
 for _,x in ipairs(itempa) do
  if x then immune = true end
 end
 if required and not immune then return false,itext end
 if required and immune then return true,'NONE' end
 if not required and immune then return false,rtext end
 if not required and not immune then return false,rtext end
end

local function checkSpeed(unit,array,unitTarget) --CHECK 1
 local utils = require 'utils'
 local split = utils.split_string
 local rtempa,itempa,r,i,required,immune = {},{},1,1,false,false
 local rtext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is too slow.'
 local itext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is too fast.'
 if type(array) ~= 'table' then array = {array} end
 local utemp = dfhack.units.computeMovementSpeed(unit)
 for _,x in ipairs(array) do
  if split(x,':')[1] == 'min' then
   if tonumber(split(x,':')[2]) > utemp then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,':')[1] == 'max' then
   if tonumber(split(x,':')[2]) < utemp then
    itempa[i] = true
   else
    itempa[i] = false
   end
   i = i + 1
  elseif split(x,':')[1] == 'greater' then
   if utemp/dfhack.units.computeMovementSpeed(unitTarget) >= tonumber(split(x,':')[2]) then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,':')[1] == 'less' then
   if utemp/dfhack.units.computeMovementSpeed(unitTarget) <= tonumber(split(x,':')[2]) then
    itempa[i] = true
   else
    itempa[i] = false
   end
   i = i + 1
  end
 end
 for _,x in ipairs(rtempa) do
  if x then required = true end
 end
 for _,x in ipairs(itempa) do
  if x then immune = true end
 end
 if required and not immune then return false,itext end
 if required and immune then return true,'NONE' end
 if not required and immune then return false,rtext end
 if not required and not immune then return false,rtext end
end

local function checkTarget(unit,target,unitCaster) -- CHECK 1
 sel = true
 if target == 'invasion' then
  if unit.invasion_id ~= unitCaster.invasion_id then sel = false end
 elseif target == 'civ' then
  if unit.civ_id ~= unitCaster.civ_id then sel = false end
 elseif target == 'population' then
  if unit.population_id ~= unitCaster.population_id then sel = false end
 elseif target == 'race' then
  if unit.race ~= unitCaster.race then sel = false end
 elseif target == 'sex' then
  if unit.sex ~= unitCaster.sex then sel = false end
 elseif target == 'caste' then
  if unit.race ~= unitCaster.race or unit.caste ~= unitCaster.caste then sel = false end
 end
 return sel, ''
end

local function checkTraits(unit,array,unitTarget) -- CHECK 1
 local utils = require 'utils'
 local split = utils.split_string
 local rtempa,itempa,r,i,required,immune = {},{},1,1,false,false
 local rtext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. "'s traits are too low."
 local itext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. "'s traits are too high."
 if type(array) ~= 'table' then array = {array} end
 for _,x in ipairs(array) do
  local utemp = unit.status.current_soul.traits[split(x,':')[2]]
  if split(x,':')[1] == 'min' then
   if tonumber(split(x,':')[3]) >= utemp then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,':')[1] == 'max' then
   if tonumber(split(x,':')[3]) <= utemp then
    itempa[r] = true
   else
    itempa[r] = false
   end
   i = i + 1
  elseif split(x,':')[1] == 'greater' then
   if utemp/unitTarget.status.current_soul.traits[split(x,':')[2]] >= tonumber(split(x,':')[3]) then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,':')[1] == 'less' then
   if utemp/unitTarget.status.current_soul.traits[split(x,':')[2]] <= tonumber(split(x,':')[3]) then
    itempa[i] = true
   else
    itempa[i] = false
   end
   i = i + 1
  end
 end
 for _,x in ipairs(rtempa) do
  if x then required = true end
 end
 for _,x in ipairs(itempa) do
  if x then immune = true end
 end
 if required and not immune then return false,itext end
 if required and immune then return true,'NONE' end
 if not required and immune then return false,rtext end
 if not required and not immune then return false,rtext end
end

local function checkTypes(unit,class,creature,syndrome,token,immune) -- CHECK 1
 local utils = require 'utils'
 local split = utils.split_string
 local unitraws = df.creature_raw.find(unit.race)
 local casteraws = unitraws.caste[unit.caste]
 local unitracename = unitraws.creature_id
 local castename = casteraws.caste_id
 local unitclasses = casteraws.creature_class
 local syndromes = df.global.world.raws.syndromes.all
 local actives = unit.syndromes.active
 local flags1 = unitraws.flags
 local flags2 = casteraws.flags
 local tokens = {}
 for k,v in pairs(flags1) do
  tokens[k] = v
 end
 for k,v in pairs(flags2) do
  tokens[k] = v
 end
 local tempa,ttempa,i,t,yes,no = {},{},1,1,false,false
 local yestext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is not an allowed type.'
 local notext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is an immune type.' 

 if class ~= 'NONE' then
  if type(class) ~= 'table' then class = {class} end
  for _,unitclass in ipairs(unitclasses) do
   for _,x in ipairs(class) do
    if x == unitclass.value then
     tempa[i] = true
    else
     tempa[i] = false
    end
    i = i + 1
   end
  end
 end
 if creature ~= 'NONE' then
  if type(creature) ~= 'table' then creature = {creature} end
  for _,x in ipairs(creature) do
   local xsplit = split(x,':')
   if xsplit[1] == unitracename and xsplit[2] == castename then
    tempa[i] = true
   else
    tempa[i] = false
   end
   i = i + 1
  end
 end
 if syndrome ~= 'NONE' then
  if type(syndrome) ~= 'table' then syndrome = {syndrome} end
  for _,x in ipairs(actives) do
   local synclass=syndromes[x.type].syn_class
   for _,y in ipairs(synclass) do
    for _,z in ipairs(syndrome) do
     if z == y.value then
      tempa[i] = true
     else
      tempa[i] = false
     end
     i = i + 1
    end
   end
  end
 end
 if token ~= 'NONE' then
  if type(token) ~= 'table' then token = {token} end
  for _,x in ipairs(token) do
   ttempa[t] = tokens[x]
   t = t + 1       
  end
 end

 for _,x in ipairs(tempa) do
  if immune then
   if x then no = true end
  else
   if x then yes = true end
  end
 end
 for _,x in ipairs(ttempa) do
  if immune then
   if x then no = true end
  else
   if not x then 
    yes = false
    break
   else
    yes = true
   end
  end
 end
 if immune then
  if no then return false,notext end
 else
  if not yes then return false,yestext end
 end
 return true,'NONE'
end