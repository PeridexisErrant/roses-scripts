function permute(tab)
 n = #tab
 for i = 1, n do
  local j = math.random(i, n)
  tab[i], tab[j] = tab[j], tab[i]
 end
 return tab
end

function findBuilding(search)
 local primary = search[1]
 local secondary = search[2] or 'NONE'
 local tertiary = search[3] or 'NONE'
 local quaternary = search[4] or 'NONE'
 local buildingList = df.global.world.buildings.all
 local targetList = {}
 local target = nil
 local n = 0
 if primary == 'RANDOM' then
  if secondary == 'NONE' or secondary == 'ALL' then
   for i,x in pairs(buildingList) do
    n = n + 1
    targetList[n] = x
   end
  elseif secondary == 'WORKSHOP' then
   for i,x in pairs(buildingList) do
    if df.building_workshopst:is_instance(x) then
     n = n + 1
     targetList[n] = x
    end
   end
  elseif secondary == 'FURNACE' then
   for i,x in pairs(buildingList) do
    if df.building_furnacest:is_instance(x) then
     n = n + 1
     targetList[n] = x
    end
   end
  elseif secondary == 'TRADE_DEPOT' then
   for i,x in pairs(buildingList) do
    if df.building_tradedepotst:is_instance(x) then
     n = n + 1
     targetList[n] = x
    end
   end
  elseif secondary == 'STOCKPILE' then
   for i,x in pairs(buildingList) do
    if df.building_stockpilest:is_instance(x) then
     n = n + 1
     targetList[n] = x
    end
   end
  elseif secondary == 'ZONE' then
   for i,x in pairs(buildingList) do
    if df.building_civzonest:is_instance(x) then
     n = n + 1
     targetList[n] = x
    end
   end
  elseif secondary == 'CUSTOM' then
   for i,x in pairs(buildingList) do
    if df.building_workshopst:is_instance(x) or df.building_furnacest:is_instance(x) then
     if ctype >= 0 then
      if df.global.world.raws.buildings.all[ctype].code == tertiary then
       n = n+1
       targetList[n] = x
      end
     end
    end
   end
  end
 end
 if n > 0 then
  targetList = permute(targetList)
  target = targetList[1]
  return target
 else
  print('No valid building found for event')
  return nil
 end
end