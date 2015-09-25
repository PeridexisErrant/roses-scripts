function permute(tab)
 n = #tab
 for i = 1, n do
  local j = math.random(i, n)
  tab[i], tab[j] = tab[j], tab[i]
 end
 return tab
end

function findItem(search)
 local primary = search[1]
 local secondary = search[2] or 'NONE'
 local tertiary = search[3] or 'NONE'
 local quaternary = search[4] or 'NONE'
 local itemList = df.global.world.items.all
 local targetList = {}
 local target = nil
 local n = 0
 if primary == 'RANDOM' then
  if secondary == 'NONE' or secondary == 'ALL' then
   for i,x in pairs(itemList) do
    if dfhack.items.getPosition(x) then
     n = n + 1
     targetList[n] = x
    end
   end
  elseif secondary == 'WEAPON' then
   for i,x in pairs(itemList) do
    if dfhack.items.getPosition(x) and df.item_weaponst:is_instance(x) then
     if x.subtype then
      if tertiary == x.subtype.id or tertiary == 'NONE' then
       n = n + 1
       targetList[n] = x
      end
     end
    end
   end
  elseif secondary == 'ARMOR' then
   for i,x in pairs(itemList) do
    if dfhack.items.getPosition(x) and df.item_armorst:is_instance(x) then
     if x.subtype then
      if tertiary == x.subtype.id or tertiary == 'NONE' then
       n = n + 1
       targetList[n] = x
      end
     end
    end
   end
  elseif secondary == 'HELM' then
   for i,x in pairs(itemList) do
    if dfhack.items.getPosition(x) and df.item_helmst:is_instance(x) then
     if x.subtype then
      if tertiary == x.subtype.id or tertiary == 'NONE' then
       n = n + 1
       targetList[n] = x
      end
     end
    end
   end
  elseif secondary == 'SHIELD' then
   for i,x in pairs(itemList) do
    if dfhack.items.getPosition(x) and df.item_shieldst:is_instance(x) then
     if x.subtype then
      if tertiary == x.subtype.id or tertiary == 'NONE' then
       n = n + 1
       targetList[n] = x
      end
     end
    end
   end
  elseif secondary == 'GLOVE' then
   for i,x in pairs(itemList) do
    if dfhack.items.getPosition(x) and df.item_glovesst:is_instance(x) then
     if x.subtype then
      if tertiary == x.subtype.id or tertiary == 'NONE' then
       n = n + 1
       targetList[n] = x
      end
     end
    end
   end
  elseif secondary == 'SHOE' then
   for i,x in pairs(itemList) do
    if dfhack.items.getPosition(x) and df.item_shoesst:is_instance(x) then
     if x.subtype then
      if tertiary == x.subtype.id or tertiary == 'NONE' then
       n = n + 1
       targetList[n] = x
      end
     end
    end
   end
  elseif secondary == 'PANTS' then
   for i,x in pairs(itemList) do
    if dfhack.items.getPosition(x) and df.item_pantsst:is_instance(x) then
     if x.subtype then
      if tertiary == x.subtype.id or tertiary == 'NONE' then
       n = n + 1
       targetList[n] = x
      end
     end
    end
   end
  elseif secondary == 'AMMO' then
   for i,x in pairs(itemList) do
    if dfhack.items.getPosition(x) and df.item_ammost:is_instance(x) then
     if x.subtype then
      if tertiary == x.subtype.id or tertiary == 'NONE' then
       n = n + 1
       targetList[n] = x
      end
     end
    end
   end
  elseif secondary == 'MATERIAL' then
   local mat_type = dfhack.matinfo.find(tertiary).type
   local mat_index = dfhack.matinfo.find(tertiary).index
   for i,x in pairs(itemList) do
    if dfhack.items.getPosition(x) and x.mat_type == mat_type and x.mat_index == mat_index then
     n = n + 1
     targetList[n] = x
    end
   end
  elseif secondary == 'VALUE' then
   if tertiary == 'LESS_THAN' then
    for i,x in pairs(itemList) do
     if dfhack.items.getPosition(x) and dfhack.items.getValue(x) <= tonumber(quaternary) then
      n = n + 1
      targetList[n] = x
     end
    end
   elseif tertiary == 'GREATER_THAN' then
    for i,x in pairs(itemList) do
     if dfhack.items.getPosition(x) and dfhack.items.getValue(x) >= tonumber(quaternary) then
      n = n + 1
      targetList[n] = x
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
  print('No valid item found for event')
  return nil
 end
end