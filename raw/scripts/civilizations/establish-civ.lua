function establishCivilization(civ)
 local utils = require 'utils'
 local split = utils.split_string
 local persistTable = require 'persist-table'
 local key = tostring(civ.id)
 local entity = civ.entity_raw.code
 local civilizations = persistTable.GlobalTable.roses.CivilizationTable
 local entityTable = persistTable.GlobalTable.roses.EntityTable[key]
-- Check if the persistent variables are present
 if not entityTable then
  entityTable = {}
  entityTable.Civilization = {}
  entityTable.Stats = {}
  entityTable.Stats.Kills = '0'
  entityTable.Stats.Deaths = '0'
  entityTable.Stats.Trades = '0'
  entityTable.Stats.Sieges = '0'
  if civilizations[entity] then
   entityTable.Civilization.Name = entity
   entityTable.Civilization.Level = '0'
   entityTable.Civilization.CurrentMethod = civilizations[entity]['LevelMethod']
   entityTable.Civilization.CurrentPercent = civilizations[entity]['LevelPercent']
   if civilizations[entity]['Level'] then
    if civilizations[entity]['Level']['0'] then
     for _,i in pairs(civilizations[entity]['Level']['0']['Remove']._children) do
      local w = civilizations[entity]['Level']['0']['Remove'][i]
      for _,j in pairs(w._children) do
       local x = w[j]
       for _,k in pairs(x._children) do
        local y = x[k]
        dfhack.run_command('civilizations/resource-change',table.unpack({'-civ',key,'-type',i..':'..j,'-obj',k..':'..y,'-remove'}))
       end
      end
     end
     for _,i in pairs(civilizations[entity]['Level']['0']['Add']._children) do
      local w = civilizations[entity]['Level']['0']['Add'][i]
      for _,j in pairs(w._children) do
       local x = w[j]
       for _,k in pairs(x._children) do
        local y = x[k]
        dfhack.run_command('civilizations/resource-change',table.unpack({'-civ',key,'-type',i..':'..j,'-obj',k..':'..y,'-add'}))
       end
      end
     end
    end
   end
  end
 end
end