local persistTable = require 'persist-table'
local utils = require 'utils'
local split = utils.split_string

validArgs = validArgs or utils.invert({
 'help',
 'civ',
 'position',
 'remove',
 'add'
})
local args = utils.processArgs({...}, validArgs)

civid = tonumber(args.civ)
civs = persistTable.GlobalTable.roses.CivilizationTable
civ = df.global.world.entities.all[civid]
positions = civ.positions
mobj = args.position
removes = false
add = false
if args.remove then removes = true end
if args.add then add = true end
if add and removes then return end
if not add and not removes then
 print('No valid command, use -remove or -add')
 return
end

if removes then
 for i,x in pairs(positions.own) do
  if mobj == x.code then
   positions.own:erase(i)
  end
 end
 for i,x in pairs(positions.site) do
  if mobj == x.code then
   positions.site:erase(i)
  end
 end
 for i,x in pairs(positions.conquered_site) do
  if mobj == x.code then
   positions.conquered_site:erase(i)
  end
 end
end

if add then
 civ = df.global.world.entities.all[civid]
 entity = civ.entity_raw.code
 if civs[entity] then
  if civs[entity]['Level'] then
   for _,i in pairs(civs[entity]['Level']._children) do
    local x = civs[entity]['Level'][i]
    for _,j in pairs(x['AddPosition']._children) do
	 local y = x['AddPosition'][j]
     if mobj == j then
      pos = df['entity_position']:new()
      pos.code = mobj
      pos.id = positions.next_position_id
      positions.next_position_id = positions.next_position_id + 1
      for _,k in pairs(y['AllowedCreature']._children) do
	   local z = y['AllowedCreature'][k]
       for _,w in pairs(df.global.world.raws.creatures.all) do
        if k == w.creature_id then
         for _,v in pairs(w.caste) do
          if z == v.caste_id then
           pos.allowed_creature:insert('#',v.index)
          end
         end
        end
       end
      end
      for _,k in pairs(y['RejectedCreature']._children) do
	   local z = y['RejectedCreature'][k]
       for _,w in pairs(df.global.world.raws.creatures.all) do
        if k == w.creature_id then
         for _,v in pairs(w.caste) do
          if z == v.caste_id then
           pos.rejected_creature:insert('#',v.index)
          end
         end
        end
       end
      end
      for _,k in pairs(y['AllowedClass']._children) do
	   local z = y['AllowedClass'][k]
       pos.allowed_class:insert('#',z)
      end
      for _,k in pairs(y['RejectedClass']._children) do
	   local z = y['AllowedClass'][k]
       pos.rejected_class:insert('#',z)
      end
      if y['Name'] then 
       pos.name[0] = split(y['Name'],':')[1]
       pos.name[1] = split(y['Name'],':')[2]
       pos.name_female[0] = ''
       pos.name_female[1] = ''
       pos.name_male[0] = ''
       pos.name_male[1] = ''
      else
       pos.name[0] = ''
       pos.name[1] = ''
       pos.name_female[0] = ''
       pos.name_female[1] = ''
       pos.name_male[0] = ''
       pos.name_male[1] = ''
      end
      if y['NameFemale'] then
       pos.name_female[0] = split(y['NameFemale'],':')[1]
       pos.name_female[1] = split(y['NameFemale'],':')[2]
      end
      if y['NameMale'] then 
       pos.name_male[0] = split(y['NameMale'],':')[1]
       pos.name_male[1] = split(y['NameMale'],':')[2]
      end
      if y['Spouse'] then 
       pos.spouse[0] = split(y['Spouse'],':')[1]
       pos.spouse[1] = split(y['Spouse'],':')[2]
       pos.spouse_female[0] = ''
       pos.spouse_female[1] = ''
       pos.spouse_male[0] = ''
       pos.spouse_male[1] = ''
      else
       pos.spouse[0] = ''
       pos.spouse[1] = ''
       pos.spouse_female[0] = ''
       pos.spouse_female[1] = ''
       pos.spouse_male[0] = ''
       pos.spouse_male[1] = ''
      end
      if y['SpouseFemale'] then
       pos.spouse_female[0] = split(y['SpouseFemale'],':')[1]
       pos.spouse_female[1] = split(y['SpouseFemale'],':')[2]
      end
      if y['SpouseMale'] then 
       pos.spouse_male[0] = split(y['SpouseMale'],':')[1]
       pos.spouse_male[1] = split(y['SpouseMale'],':')[2]
      end
      if y['Squad'] then
       pos.squad_size = tonumber(split(y['Squad'],':')[1])
       pos.squad[0] = split(y['Squad'],':')[2]
       pos.squad[1] = split(y['Squad'],':')[3]
      else
       pos.squad[0] = ''
       pos.squad[1] = ''
       pos.squad_size = 0
      end
      if y['LandName'] then
       pos.land_name = y['LandName']
      else
       pos.land_name = ''
      end
      if y['LandHolder'] then
       pos.land_holder = tonumber(y['LandHolder'])
      else
       pos.land_holder = 0
      end
      if y['RequiredBoxes'] then
       pos.required_boxes = tonumber(y['RequiredBoxes'])
      else
       pos.required_boxes = 0
      end
      if y['RequiredCabinets'] then
       pos.required_cabinets = tonumber(y['RequiredCabinets'])
      else
       pos.required_cabinets = 0
      end
      if y['RequiredRacks'] then
       pos.required_racks = tonumber(y['RequiredRacks'])
      else
       pos.required_racks = 0
      end
      if y['RequiredStands'] then
       pos.required_stands = tonumber(y['RequiredStands'])
      else
       pos.required_stands = 0
      end
      if y['RequiredOffice'] then
       pos.required_office = tonumber(y['RequiredOffice'])
      else
       pos.required_office = 0
      end
      if y['RequiredBedroom'] then
       pos.required_bedroom = tonumber(y['RequiredBedroom'])
      else
       pos.required_bedroom = 0
      end
      if y['RequiredDining'] then
       pos.required_dining = tonumber(y['RequiredDining'])
      else
       pos.required_dining = 0
      end
      if y['RequiredTomb'] then
       pos.required_tomb = tonumber(y['RequiredTomb'])
      else
       pos.required_tomb = 0
      end
      if y['MandateMax'] then
       pos.mandate_max = tonumber(y['MandateMax'])
      else
       pos.mandate_max = 0
      end
      if y['DemandMax'] then
       pos.demand_max = tonumber(y['DemandMax'])
      else
       pos.demand_max = 0
      end
      if y['Color'] then
       pos.color[0] = split(y['Color'],':')[1]
       pos.color[1] = split(y['Color'],':')[2]
       pos.color[2] = split(y['Color'],':')[3]
      else
       pos.color[0] = 5
       pos.color[1] = 0
       pos.color[2] = 0
      end
      if y['Precedence'] then
       pos.precedence = tonumber(y['Precedence'])
      else
       pos.precedence = -1
      end
      for v,w in pairs(pos.responsibilities) do
       if y['Responsibility'][v] then
        pos.responsibilities[v] = true
       else
        pos.responsibilities[v] = false
       end
      end
      for v,w in pairs(pos.flags) do
       if y[v] then
        pos.flags[v] = true
       else
        pos.flags[v] = false
       end
      end
      if y['Flags'] then
       for _,v in pairs(y['Flags']._children) do
	    local w = y['Flags'][v]
        if pos.flags[v] then pos.flags[v] = true end
       end
      end
      if y['Number'] then
       pos.number = tonumber(y['Number'])
      else
       pos.number = -1
      end
      for _,v in pairs(y['AppointedBy']._children) do
	   local w = y['Flags'][v]
       p = -1
       own = false
       site = false
       for s,t in pairs(positions.own) do
        if v == t.code then
         p = t.id
         own = true
         break
        end
       end
       if p == -1 then
        for s,t in pairs(positions.site) do
         if v == t.code then 
          p = t.id
          site = true
          break
         end
        end
       end
       if p == -1 then
        for s,t in pairs(positions.conquered_site) do
         if v == t.code then 
          p = t.id
          break
         end
        end
       end
       if p == -1 then
        print('No valid APPOINTED_BY position found')
       else
        pos.appointed_by:insert('#',p)
        if own then pos.appointed_by_civ:insert('#',civid) end
        if site then pos.appointed_by_civ:insert('#',-1) end
       end
      end
      if y['Commander'] then
       v = split(y['Commander'],':')[1]
       p = -1
       own = false
       site = false
       for s,t in pairs(positions.own) do
        if v == t.code then
         p = t.id
         own = true
         break
        end
       end
       if p == -1 then
        for s,t in pairs(positions.site) do
         if v == t.code then 
          p = t.id
          site = true
          break
         end
        end
       end
       if p == -1 then
        for s,t in pairs(positions.conquered_site) do
         if v == t.code then 
          p = t.id
          break
         end
        end
       end
       if p == -1 then
        print('No valid COMMANDER position found')
       else
        pos.commander_id:insert('#',p)
        pos.commander_types:insert('#',0)
        if own then pos.commander_civ:insert('#',civid) end
        if site then pos.commander_civ:insert('#',-1) end
       end
      end
      if y['ReplacedBy'] then
       v = y['ReplacedBy']
       p = -1
       own = false
       site = false
       for s,t in pairs(positions.own) do
        if v == t.code then
         p = t.id
         own = true
         break
        end
       end
       if p == -1 then
        for s,t in pairs(positions.site) do
         if v == t.code then 
          p = t.id
          site = true
          break
         end
        end
       end
       if p == -1 then
        for s,t in pairs(positions.conquered_site) do
         if v == t.code then 
          p = t.id
          break
         end
        end
       end
       if p == -1 then
        print('No valid REPLACED_BY position found')
       else
        pos.replaced_by = p
       end
      else
       pos.replaced_by = -1
      end
      positions.own:insert('#',pos)
     else
      print('No valid position found in civilization.txt')
      return
     end
    end
   end
  end
 end
end