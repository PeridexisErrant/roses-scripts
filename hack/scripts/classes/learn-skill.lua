
local split = require('split')
local utils = require 'utils'
local establishclass = require('classes.establish-class')
local checkspell = require('classes.requirements-spell')
local persistTable = require 'persist-table'

function findUnitSyndrome(unit,syn_id)
 for index,syndrome in ipairs(unit.syndromes.active) do
  if syndrome['type'] == syn_id then
   return syndrome
  end
 end
 return nil
end

function learnspell(unit,spell,classes,upgrade,verbose)
 local syndrome
 for _,syn in ipairs(df.global.world.raws.syndromes.all) do
  if syn.syn_name == spell then
   syndrome = syn
   break
  end
 end
 oldsyndrome = findUnitSyndrome(unit,syndrome.id)
 if oldsyndrome then
  if verbose then print('Already knows this spell') end
  return false
 end
 if upgrade then
  dfhack.run_command('modtools/add-syndrome -target '..tostring(unit.id)..' -syndrome '..spell)
  dfhack.run_command('modtools/add-syndrome -target '..tostring(unit.id)..' -syndrome '..upgrade,' -eraseAll')
 else
  dfhack.run_command('modtools/add-syndrome -target '..tostring(unit.id)..' -syndrome '..spell)
 end
 if verbose then print(spell..' learned successfully!') end
 persistTable.GlobalTable.roses.UnitTable[tostring(unit.id)].Spells[spell] = '1'
 return true
end

validArgs = validArgs or utils.invert({
 'help',
 'unit',
 'spell',
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
 yes,upgrade = dfhack.script_environment('classes/requirements-spell').checkSpell(unit,args.spell,verbose)
end
if yes then 
 success = learnspell(unit,args.spell,upgrade,verbose)
 if success then
 -- Erase items used for reaction
 end
else
 if verbose then print('Failed to learn spell') end
end