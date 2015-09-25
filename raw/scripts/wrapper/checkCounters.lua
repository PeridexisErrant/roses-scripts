function checkCounters(unit,array)
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
 if style == 'minimum' then
  if tables[counter] >= cap and cap >= 0 then
   return true, "Minimum counter reached"
  else
   return false, "Minimum counter not reached"
  end
 elseif style == 'percent' then
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