local persistTable = require 'persist-table'
local utils = require 'utils'

validArgs = validArgs or utils.invert({
 'help',
 'civ',
 'unit',
})
local args = utils.processArgs({...}, validArgs)

if args.unit then
 args.civ = df.unit.find(tonumber(args.unit)).civ_id
end
civid = tonumber(args.civ)
civ = persistTable.GlobalTable.roses.EntityTable[tostring(civid)]
civilizations = persistTable.GlobalTable.roses.CivilizationTable
entity = df.global.world.entities.all[civid].entity_raw.code
level = tostring(civ.Civilization.Level + 1)
if civilizations[entity] then
 if civilizations[entity]['Level'] then
  if civilizations[entity]['Level'][tostring(level)] then
   for _,i in pairs(civilizations[entity]['Level'][tostring(level)]['Remove']._children) do
    local w = civilizations[entity]['Level'][tostring(level)]['Remove'][i]
    for _,j in pairs(w._children) do
     local x = w[j]
     for _,k in pairs(x._children) do
      local y = x[k]
      dfhack.run_command('civilizations/resource-change',table.unpack({'-civ',civid,'-type',i..':'..j,'-obj',k..':'..y,'-remove'}))
     end
    end
   end
   for _,i in pairs(civilizations[entity]['Level'][tostring(level)]['Add']._children) do
    local w = civilizations[entity]['Level'][tostring(level)]['Add'][i]
    for _,j in pairs(w._children) do
     local x = w[j]
     for _,k in pairs(x._children) do
      local y = x[k]
      dfhack.run_command('civilizations/resource-change',table.unpack({'-civ',civid,'-type',i..':'..j,'-obj',k..':'..y,'-add'}))
     end
    end
   end
   for _,i in pairs(civilizations[entity]['Level'][tostring(level)]['RemovePosition']._children) do
    local w = civilizations[entity]['Level'][tostring(level)]['RemovePosition'][i]
    dfhack.run_command('civilizations/noble-change',table.unpack({'-civ',civid,'-position',i,'-remove'}))
   end
   for _,i in pairs(civilizations[entity]['Level'][tostring(level)]['AddPosition']._children) do
    local w = civilizations[entity]['Level'][tostring(level)]['AddPosition'][i]
    dfhack.run_command('civilizations/noble-change',table.unpack({'-civ',civid,'-position',i,'-add'}))
   end
  end
 end
end
