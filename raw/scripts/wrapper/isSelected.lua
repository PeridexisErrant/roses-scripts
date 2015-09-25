local function isSelected(unitSelf,unitCenter,unitTarget,args,count)
 local silence = args.silence or 'NONE'
 local reflect = args.reflect or 'NONE'
 local radius = args.radius or '-1,-1,-1'
 local plan = args.plan or 'NONE'
 local age = args.age or 'NONE'
 local speed = args.speed or 'NONE'
 local physical = args.physical or 'NONE'
 local mental = args.mental or 'NONE'
 local skill = args.skill or 'NONE'
 local trait = args.trait or 'NONE'
 local noble = args.noble or 'NONE'
 local profession = args.profession or 'NONE'
 local entity = args.entity or 'NONE'
 local iclass = args.iclass or 'NONE'
 local icreature = args.icreature or 'NONE'
 local isyndrome = args.isyndrome or 'NONE'
 local itoken = args.itoken or 'NONE'
 local aclass = args.aclass or 'NONE'
 local acreature = args.acreature or 'NONE'
 local asyndrome = args.asyndrome or 'NONE'
 local atoken = args.atoken or 'NONE'
 local counters = args.counters or 'NONE'
 local checks = dfhack.script_environment('wrapper/checks')
 local output = {
 caster = unitSelf,
 verbose = args.verbose or false,
 }

-- Silence Check
 if silence ~= 'NONE' then
  if type(silence) ~= 'table' then silence = {silence} end
  local syndromes = df.global.world.raws.syndromes.all
  local sactives = unitSelf.syndromes.active
  for _,x in ipairs(sactives) do
   local ssynclass=syndromes[x.type].syn_class
   for _,y in ipairs(ssynclass) do
    for _,z in ipairs(silence) do
     if z == y.value then
      output['selected'] = {false}
      output['targets'] = {'NONE'}
      output['announcement'] = {'Casting failed, ' .. tostring(unitSelf.name.first_name) .. ' is prevented from using the interaction.'}
      return output
     end
    end
   end
  end
 end

-- Distance Check
 local selected,targetList,announcement = checks.checkDistance(unitTarget,radius,plan)

-- Unit Checks
 for i = 1, #targetList, 1 do
  local unitCheck = targetList[i]

-- Target Check
  selected[i],announcement[i] = checks.checkTarget(unitCheck,args.target,unitSelf)

-- Reflect Check
  if reflect ~= 'NONE' and selected[i] then
   if type(reflect) ~= 'table' then reflect = {reflect} end
   local syndromes = df.global.world.raws.syndromes.all
   local actives = unitCheck.syndromes.active
   for _,x in ipairs(actives) do
    local rsynclass=syndromes[x.type].syn_class
    for _,y in ipairs(rsynclass) do
     for _,z in ipairs(reflect) do
      if z == y.value then
       targetList[i] = unitSelf
       announcement[i] = tostring(unitCheck.name.first_name) .. ' reflects the interaction back towards ' .. tostring(unitSelf.name.first_name) .. '.'
       unitCheck = unitSelf
      end
     end
    end
   end
  end

-- Age Check
  if age~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checks.checkAge(unitCheck,age,unitSelf)
  end

-- Speed Check
  if speed ~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checks.checkSpeed(unitCheck,speed,unitSelf)
  end

-- Physical Attributes Check
  if physical ~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checks.checkAttributes(unitCheck,physical,false,unitSelf)
  end

-- Mental Attributes Check
  if mental ~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checks.checkAttributes(unitCheck,mental,true,unitSelf)
  end

-- Skill Level Check
  if skill ~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checks.checkSkills(unitCheck,skill,unitSelf)
  end

-- Trait Check
  if trait ~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checks.checkTraits(unitCheck,trait,unitSelf)
  end

-- Noble Check
  if noble ~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checks.checkNoble(unitCheck,noble)
  end

-- Profession Check
  if profession ~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checks.checkProfession(unitCheck,profession)
  end

-- Entity Check
  if entity ~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checks.checkEntity(unitCheck,entity)
  end

-- Immune Check
  if (iclass ~= 'NONE' or icreature ~= 'NONE' or isyndrome ~= 'NONE' or itoken ~= 'NONE') and selected[i] then
   selected[i],announcement[i] = checks.checkTypes(unitCheck,iclass,icreature,isyndrome,itoken,true)
  end

-- Required Check
  if (aclass ~= 'NONE' or acreature ~= 'NONE' or asyndrome ~= 'NONE' or atoken ~= 'NONE') and selected[i] then
   selected[i],announcement[i] = checks.checkTypes(unitCheck,aclass,acreature,asyndrome,atoken,false)
  end

-- Counters Check
  if counters ~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checks.checkCounters(unitCheck,counters)
  end

 end

 return selected,targetList,unitSelf,output['verbose'],announcement
end