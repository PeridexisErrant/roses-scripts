function permute(tab)
 n = #tab
 for i = 1, n do
  local j = math.random(i, n)
  tab[i], tab[j] = tab[j], tab[i]
 end
 return tab
end

function findLocation(search)
 local primary = search[1]
 local secondary = search[2] or 'NONE'
 local tertiary = search[3] or 'NONE'
 local quaternary = search[4] or 'NONE'
 local x_map, y_map, z_map = dfhack.maps.getTileSize()
 x_map = x_map - 1
 y_map = y_map - 1
 z_map = z_map - 1
 local targetList = {}
 local target = nil
 local found = false
 local n = 0
 local rando = dfhack.random.new()
 if primary == 'RANDOM' then
  if secondary == 'NONE' or secondary == 'ALL' then
   n = 1
   targetList = {{x = rando:random(x_map-1)+1,y = rando:random(y_map-1)+1,z = rando:random(z_map-1)+1}}
  elseif secondary == 'SURFACE' then
   if tertiary == 'ALL' or tertiary == 'NONE' then
    for i = 1,x_map,1 do
     for j = 1,y_map,1 do
      for k = z_map,1,-1 do
       if dfhack.maps.getTileFlags(i,j,k).subterranean then
        n = n+1
        targetList[n] = {x = i, y = j, z = k+1}
        break
       end
      end
     end
    end
   elseif tertiary == 'EDGE' then
    for i = 1,x_map,1 do
     for j = 1,y_map,1 do
      if i == 1 or i == x_map or j == 1 or j == y_map then
       for k = z_map,1,-1 do
        if dfhack.maps.getTileFlags(i,j,k).subterranean then
         n = n+1
         targetList[n] = {x = i, y = j, z = k+1}
         break
        end
       end
      end
     end
    end
   elseif tertiary == 'CENTER' then
    for i = 1+tonumber(quaternary),x_map-tonumber(quaternary),1 do
     for j = 1+tonumber(quaternary),y_map-tonumber(quaternary),1 do
      for k = z_map,1,-1 do
       if dfhack.maps.getTileFlags(i,j,k).subterranean then
        n = n+1
        targetList[n] = {x = i, y = j, z = k+1}
        break
       end
      end
     end
    end
   end
  elseif secondary == 'UNDERGROUND' then
   if tertiary == 'ALL' or tertiary == 'NONE' then
    for i = 1,x_map,1 do
     for j = 1,y_map,1 do
      for k = 1,z_map,1 do
       if dfhack.maps.getTileFlags(i,j,k).subterranean then
        n = n+1
        targetList[n] = {x = i, y = j, z = k}
       else
        break
       end
      end
     end
    end
   elseif tertiary == 'CAVERN' then
    for i = 1,x_map,1 do
     for j = 1,y_map,1 do
      for k = 1,z_map,1 do
       if dfhack.maps.getTileFlags(i,j,k).subterranean then
        if dfhack.maps.getTileBlock(i,j,k).global_feature >= 0 then
         for l,v in pairs(df.global.world.features.feature_global_idx) do
          if v == dfhack.maps.getTileBlock(i,j,k).global_feature then
           feature = df.global.world.features.map_features[l]
           if feature.start_depth == tonumber(quaternary) or quaternary == 'NONE' then
            if df.tiletype.attrs[dfhack.maps.getTileType(i,j,k)].caption == 'stone floor' then
             n = n+1
             targetList[n] = {x = i, y = j, z = k}
            end
           end
          end
         end
        end
       else
        break
       end
      end
     end
    end
   end
  elseif secondary == 'SKY' then
   if tertiary == 'ALL' or tertiary == 'NONE' then
    for i = 1,x_map,1 do
     for j = 1,y_map,1 do
      for k = z_map,1,-1 do
       if dfhack.maps.getTileFlags(i,j,k).subterranean then break end
       n = n+1
       targetList[n] = {x = i, y = j, z = k+1}
      end
     end
    end
   elseif tertiary == 'EDGE' then
    for i = 1,x_map,1 do
     for j = 1,y_map,1 do
      if i == 1 or i == x_map or j == 1 or j == y_map then
       for k = z_map,1,-1 do
        if dfhack.maps.getTileFlags(i,j,k).subterranean then break end
        n = n+1
        targetList[n] = {x = i, y = j, z = k+1}
       end
      end
     end
    end
   elseif tertiary == 'CENTER' then
    for i = 1+tonumber(quaternary),x_map-tonumber(quaternary),1 do
     for j = 1+tonumber(quaternary),y_map-tonumber(quaternary),1 do
      for k = z_map,1,-1 do
       if dfhack.maps.getTileFlags(i,j,k).subterranean then break end
       n = n+1
       targetList[n] = {x = i, y = j, z = k+1}
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
  print('No valid location found for event')
  return nil
 end
end