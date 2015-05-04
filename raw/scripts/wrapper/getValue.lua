local function getAttrValue(unit,attr,mental)
 if unit.curse.attr_change then
  if mental then
   return (unit.status.current_soul.mental_attrs[attr].value+unit.curse.attr_change.ment_att_add[attr])*unit.curse.attr_change.ment_att_perc[attr]/100
  else
   return (unit.body.physical_attrs[attr].value+unit.curse.attr_change.phys_att_add[attr])*unit.curse.attr_change.phys_att_perc[attr]/100
  end
 else
  if mental then
   return unit.status.current_soul.mental_attrs[attr].value
  else
   return unit.body.physical_attrs[attr].value
  end
 end
end

local function getValue(equation,unitSelf,unitTarget) -- CHECK 1
 unit = 'source'
 if equation:find(unit) then
  if not unitSelf then
   print('Unable to determine equation "'..equation..'" no source selected')
   return nil
  end
  if equation:find(unit..'.strength') then equation = equation:gsub(unit..'.strength',tostring(getAttrValue(unitSelf,'STRENGTH',false))) end
  if equation:find(unit..'.agility') then equation = equation:gsub(unit..'.agility',tostring(getAttrValue(unitSelf,'AGILITY',false))) end
  if equation:find(unit..'.toughness') then equation = equation:gsub(unit..'.toughness',tostring(getAttrValue(unitSelf,'TOUGHNESS',false))) end
  if equation:find(unit..'.endurance') then equation = equation:gsub(unit..'.endurance',tostring(getAttrValue(unitSelf,'ENDURANCE',false))) end
  if equation:find(unit..'.resistance') then equation = equation:gsub(unit..'.resistance',tostring(getAttrValue(unitSelf,'DISEASE_RESISTANCE',false))) end
  if equation:find(unit..'.recuperation') then equation = equation:gsub(unit..'.recuperation',tostring(getAttrValue(unitSelf,'RECUPERATION',false))) end
  if equation:find(unit..'.analytical') then equation = equation:gsub(unit..'.analytical',tostring(getAttrValue(unitSelf,'ANALYTICAL_ABILITY',true))) end
  if equation:find(unit..'.focus') then equation = equation:gsub(unit..'.focus',tostring(getAttrValue(unitSelf,'FOCUS',true))) end
  if equation:find(unit..'.willpower') then equation = equation:gsub(unit..'.willpower',tostring(getAttrValue(unitSelf,'WILLPOWER',true))) end
  if equation:find(unit..'.creativity') then equation = equation:gsub(unit..'.creativity',tostring(getAttrValue(unitSelf,'CREATIVITY',true))) end
  if equation:find(unit..'.intuition') then equation = equation:gsub(unit..'.intuition',tostring(getAttrValue(unitSelf,'INTUITION',true))) end
  if equation:find(unit..'.patience') then equation = equation:gsub(unit..'.patience',tostring(getAttrValue(unitSelf,'PATIENCE',true))) end
  if equation:find(unit..'.memory') then equation = equation:gsub(unit..'.memory',tostring(getAttrValue(unitSelf,'MEMORY',true))) end
  if equation:find(unit..'.linguistic') then equation = equation:gsub(unit..'.linguistic',tostring(getAttrValue(unitSelf,'LINGUISTIC_ABILITY',true))) end
  if equation:find(unit..'.spatial') then equation = equation:gsub(unit..'.spatial',tostring(getAttrValue(unitSelf,'SPATIAL_SENSE',true))) end
  if equation:find(unit..'.musicality') then equation = equation:gsub(unit..'.musicality',tostring(getAttrValue(unitSelf,'MUSICALITY',true))) end
  if equation:find(unit..'.kinesthetic') then equation = equation:gsub(unit..'.kinesthetic',tostring(getAttrValue(unitSelf,'KINESTHETIC_SENSE',true))) end
  if equation:find(unit..'.empathy') then equation = equation:gsub(unit..'.empathy',tostring(getAttrValue(unitSelf,'EMPATHY',true))) end
  if equation:find(unit..'.social') then equation = equation:gsub(unit..'.social',tostring(getAttrValue(unitSelf,'SOCIAL_AWARENESS',true))) end
  if equation:find(unit..'.web') then equation = equation:gsub(unit..'.web',tostring(unitSelf.counters.webbed)) end
  if equation:find(unit..'.stun') then equation = equation:gsub(unit..'.stun',tostring(unitSelf.counters.stunned)) end
  if equation:find(unit..'.unconscious') then equation = equation:gsub(unit..'.unconscious',tostring(unitSelf.counters.unconscious)) end
  if equation:find(unit..'.pain') then equation = equation:gsub(unit..'.pain',tostring(unitSelf.counters.pain)) end
  if equation:find(unit..'.nausea') then equation = equation:gsub(unit..'.nausea',tostring(unitSelf.counters.nausea)) end
  if equation:find(unit..'.dizziness') then equation = equation:gsub(unit..'.dizziness',tostring(unitSelf.counters.dizziness)) end
  if equation:find(unit..'.paralysis') then equation = equation:gsub(unit..'.paralysis',tostring(unitSelf.counters.paralysis)) end
  if equation:find(unit..'.numbness') then equation = equation:gsub(unit..'.numbness',tostring(unitSelf.counters.numbness)) end
  if equation:find(unit..'.fever') then equation = equation:gsub(unit..'.fever',tostring(unitSelf.counters.fever)) end
  if equation:find(unit..'.exhaustion') then equation = equation:gsub(unit..'.exhaustion',tostring(unitSelf.counters.exhaustion)) end
  if equation:find(unit..'.hunger') then equation = equation:gsub(unit..'.hunger',tostring(unitSelf.counters.hunger_timer)) end
  if equation:find(unit..'.thirst') then equation = equation:gsub(unit..'.thirst',tostring(unitSelf.counters.thirst_timer)) end
  if equation:find(unit..'.sleep') then equation = equation:gsub(unit..'.sleep',tostring(unitSelf.counters.sleepiness_timer)) end
  if equation:find(unit..'.infection') then equation = equation:gsub(unit..'.infection',tostring(unitSelf.body.infection_level)) end
  if equation:find(unit..'.blood') then equation = equation:gsub(unit..'.blood',tostring(unitSelf.body.blood_count)) end
 end
 unit = 'target'
 if equation:find(unit) then
  if not unitTarget then
   print('Unable to determine equation "'..equation..'" no target selected')
   return nil
  end
  if equation:find(unit..'.strength') then equation = equation:gsub(unit..'.strength',tostring(getAttrValue(unitTarget,'STRENGTH',false))) end
  if equation:find(unit..'.agility') then equation = equation:gsub(unit..'.agility',tostring(getAttrValue(unitTarget,'AGILITY',false))) end
  if equation:find(unit..'.toughness') then equation = equation:gsub(unit..'.toughness',tostring(getAttrValue(unitTarget,'TOUGHNESS',false))) end
  if equation:find(unit..'.endurance') then equation = equation:gsub(unit..'.endurance',tostring(getAttrValue(unitTarget,'ENDURANCE',false))) end
  if equation:find(unit..'.resistance') then equation = equation:gsub(unit..'.resistance',tostring(getAttrValue(unitTarget,'DISEASE_RESISTANCE',false))) end
  if equation:find(unit..'.recuperation') then equation = equation:gsub(unit..'.recuperation',tostring(getAttrValue(unitTarget,'RECUPERATION',false))) end
  if equation:find(unit..'.analytical') then equation = equation:gsub(unit..'.analytical',tostring(getAttrValue(unitTarget,'ANALYTICAL_ABILITY',true))) end
  if equation:find(unit..'.focus') then equation = equation:gsub(unit..'.focus',tostring(getAttrValue(unitTarget,'FOCUS',true))) end
  if equation:find(unit..'.willpower') then equation = equation:gsub(unit..'.willpower',tostring(getAttrValue(unitTarget,'WILLPOWER',true))) end
  if equation:find(unit..'.creativity') then equation = equation:gsub(unit..'.creativity',tostring(getAttrValue(unitTarget,'CREATIVITY',true))) end
  if equation:find(unit..'.intuition') then equation = equation:gsub(unit..'.intuition',tostring(getAttrValue(unitTarget,'INTUITION',true))) end
  if equation:find(unit..'.patience') then equation = equation:gsub(unit..'.patience',tostring(getAttrValue(unitTarget,'PATIENCE',true))) end
  if equation:find(unit..'.memory') then equation = equation:gsub(unit..'.memory',tostring(getAttrValue(unitTarget,'MEMORY',true))) end
  if equation:find(unit..'.linguistic') then equation = equation:gsub(unit..'.linguistic',tostring(getAttrValue(unitTarget,'LINGUISTIC_ABILITY',true))) end
  if equation:find(unit..'.spatial') then equation = equation:gsub(unit..'.spatial',tostring(getAttrValue(unitTarget,'SPATIAL_SENSE',true))) end
  if equation:find(unit..'.musicality') then equation = equation:gsub(unit..'.musicality',tostring(getAttrValue(unitTarget,'MUSICALITY',true))) end
  if equation:find(unit..'.kinesthetic') then equation = equation:gsub(unit..'.kinesthetic',tostring(getAttrValue(unitTarget,'KINESTHETIC_SENSE',true))) end
  if equation:find(unit..'.empathy') then equation = equation:gsub(unit..'.empathy',tostring(getAttrValue(unitTarget,'EMPATHY',true))) end
  if equation:find(unit..'.social') then equation = equation:gsub(unit..'.social',tostring(getAttrValue(unitTarget,'SOCIAL_AWARENESS',true))) end
  if equation:find(unit..'.web') then equation = equation:gsub(unit..'.web',tostring(unitTarget.counters.webbed)) end
  if equation:find(unit..'.stun') then equation = equation:gsub(unit..'.stun',tostring(unitTarget.counters.stunned)) end
  if equation:find(unit..'.unconscious') then equation = equation:gsub(unit..'.unconscious',tostring(unitTarget.counters.unconscious)) end
  if equation:find(unit..'.pain') then equation = equation:gsub(unit..'.pain',tostring(unitTarget.counters.pain)) end
  if equation:find(unit..'.nausea') then equation = equation:gsub(unit..'.nausea',tostring(unitTarget.counters.nausea)) end
  if equation:find(unit..'.dizziness') then equation = equation:gsub(unit..'.dizziness',tostring(unitTarget.counters.dizziness)) end
  if equation:find(unit..'.paralysis') then equation = equation:gsub(unit..'.paralysis',tostring(unitTarget.counters.paralysis)) end
  if equation:find(unit..'.numbness') then equation = equation:gsub(unit..'.numbness',tostring(unitTarget.counters.numbness)) end
  if equation:find(unit..'.fever') then equation = equation:gsub(unit..'.fever',tostring(unitTarget.counters.fever)) end
  if equation:find(unit..'.exhaustion') then equation = equation:gsub(unit..'.exhaustion',tostring(unitTarget.counters.exhaustion)) end
  if equation:find(unit..'.hunger') then equation = equation:gsub(unit..'.hunger',tostring(unitTarget.counters.hunger_timer)) end
  if equation:find(unit..'.thirst') then equation = equation:gsub(unit..'.thirst',tostring(unitTarget.counters.thirst_timer)) end
  if equation:find(unit..'.sleep') then equation = equation:gsub(unit..'.sleep',tostring(unitTarget.counters.sleepiness_timer)) end
  if equation:find(unit..'.infection') then equation = equation:gsub(unit..'.infection',tostring(unitTarget.body.infection_level)) end
  if equation:find(unit..'.blood') then equation = equation:gsub(unit..'.blood',tostring(unitTarget.body.blood_count)) end
 end
 equals = load('value='..equation)
 equals()
 return value
end