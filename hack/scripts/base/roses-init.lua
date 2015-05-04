--MUST BE LOADED IN DFHACK.INIT

local utils = require 'utils'
local split = utils.split_string
local persistTable = require 'persist-table'

validArgs = validArgs or utils.invert({
 'help',
 'all',
 'classSystem',
 'civilizationSystem',
 'eventSystem',
 'persistentDelay',
 'globalTracking',
 'forceReload'
})
local args = utils.processArgs({...}, validArgs)

persistTable.GlobalTable.roses = persistTable.GlobalTable.roses or {}
persistTable.GlobalTable.roses.UnitTable = persistTable.GlobalTable.roses.UnitTable or {}
persistTable.GlobalTable.roses.EntityTable = persistTable.GlobalTable.roses.EntityTable or {}
persistTable.GlobalTable.roses.ClassTable = persistTable.GlobalTable.roses.ClassTable or {}
persistTable.GlobalTable.roses.SpellTable = persistTable.GlobalTable.roses.SpellTable or {}
persistTable.GlobalTable.roses.CivilizationTable = persistTable.GlobalTable.roses.CivilizationTable or {}
persistTable.GlobalTable.roses.EventTable = persistTable.GlobalTable.roses.EventTable or {}
persistTable.GlobalTable.roses.PersistTable = persistTable.GlobalTable.roses.PersistTable or {}

local function civilizationNotAlreadyLoaded()
 return (not persistTable.GlobalTable.roses.CivilizationTable) or #persistTable.GlobalTable.roses.CivilizationTable._children < 1
end
local function classNotAlreadyLoaded()
 return (not persistTable.GlobalTable.roses.ClassTable) or #persistTable.GlobalTable.roses.ClassTable._children < 1
end
local function eventNotAlreadyLoaded()
 return (not persistTable.GlobalTable.roses.EventTable) or #persistTable.GlobalTable.roses.EventTable._children < 1
end

if args.all or args.classSystem then
 print('Loading Class System')
 local dir = dfhack.getDFPath().."/raw/objects/"
 for _,fname in pairs(dfhack.internal.getDir(dir)) do
  if (split(fname,'_')[1] == 'classes' or fname == 'classes.txt') and (classNotAlreadyLoaded() or args.forceReload) then
   print('Reading class file '..fname)
   dfhack.script_environment('classes/read-file').readFile(dir..fname)
   print('Done reading file')
  end
 end
 dfhack.run_command('base/classes')
 print('Class System successfully loaded')
end
if args.all or args.civilizationSystem then
 print('Loading Civilization System')
 local dir = dfhack.getDFPath().."/raw/objects/"
 for _,fname in pairs(dfhack.internal.getDir(dir)) do
  if (split(fname,'_')[1] == 'civilizations' or fname == 'civilizations.txt') and (civilizationNotAlreadyLoaded() or args.forceReload) then
   print('Reading civilization file '..fname)
   dfhack.script_environment('civilizations/read-file').readFile(dir..fname)
   print('Done reading file')
  end
 end
 dfhack.run_command('base/civilizations')
 print('Civilization System successfully loaded')
end
if args.all or args.eventSystem then
 print('Loading Event System')
 local dir = dfhack.getDFPath().."/raw/objects/"
 for _,fname in pairs(dfhack.internal.getDir(dir)) do
  if (split(fname,'_')[1] == 'events' or fname == 'events.txt') and (eventNotAlreadyLoaded() or args.forceReload) then
   print('Reading event file '..fname)
   dfhack.script_environment('events/read-file').readFile(dir..fname)
   print('Done reading file')
  end
 end
 dfhack.run_command('base/events')
 print('Event System successfully loaded')
end
if args.all or args.persistentDelay then
 print('Creating persistent function calls')
 dfhack.run_command('base/persist-delay')
end
if args.all or args.globalTracking then
 print('Loading Global Tracking System')
 dfhack.run_command('base/global-tracking')
end