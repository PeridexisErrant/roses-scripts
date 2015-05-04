function persistantDelay(ticks,script)
 local persistTable = require 'persist-table'
 local currentTick = 1200*28*3*4*df.global.cur_year + df.global.cur_year_tick
 local runTick = currentTick + ticks
 local persistDelay = persistTable.GlobalTable.roses.PersistTable
 local number = #persistDelay._children
 persistDelay[tostring(number+1)] = {}
 persistDelay[tostring(number+1)].Tick = tostring(runTick)
 persistDelay[tostring(number+1)].Script = script
 dfhack.timeout(ticks,'ticks',function () dfhack.run_command(script) end)
end