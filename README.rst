.. _roses-scripts:

##############
Roses' scripts
##############

Roses' script collection is one of the biggest modding projects around.

.. warning::

    The following documentation was copied from the forum thread and formatted
    on 2015-11-01, and it's accuracy is not guaranteed.

    It is likely that these scripts will be reorganised to fit within the
    `modtools <modtools>` directory, changing the paths used to call them.
    This would break existing raws and there will be NO ATTEMPT at
    backwards-compatibility.


.. contents::
   :depth: 4


Roses' Script collection has two main parts: a collection of generally
useful scripts, and a set of custom in-game systems for unit classes,
civilisations, and events.

`The class system <roses-class-system>` includes:

- Experience system, based on kills (customize how much each creature is worth)
- Class upgrade trees (e.g. level 3 Warrior required for Knight,
  level 2 Knight and level 1 Priest required for Paladin)
- Spell learning based on various requirements
  (e.g. attributes, skills, traits, class)
- Completely configurable in external text file
  (follows format similar to DF raws for ease of use)

`The civilisation system <roses-civ-system>` includes:

- Define civilizations based on their entity
- Civilization level up during gameplay
- Add/Remove creatures/items/materials/etc from civilizations
  as they level up
- Add new noble positions to civilizations as they level up
- Completely configurable in external text file (follows format
  similar to DF raws for ease of use)

`The event system <roses-event-system>` includes:

- Trigger random events based on specified requirements
- Events are user specified scripts, allowing for things like spawn-unit
- Requirements are things like wealth, export, imports, deaths, etc...


==============
Useful Scripts
==============
Calling any of these scripts with the ``-help`` option should give
usage information and a summary of what it does.

*Some in-progress scripts are not documented here.*
:forums:`Check the forum thread. <135597.msg4928406#msg4928406>`

TODO:  ensure that all of these scripts have standard locations,
then link all references and keep updated.

Building Based Scripts
======================
- subtype-change - change the subtype of a building
  (i.e. change it from one - - custom building to another)
- remove - deletes the building

Unit Based Scripts
==================
- attribute-change - change a units physical or mental attributes
- body-change - change the temperature of a units body parts
- boolean-change - don't use this, it will crash your game
- skill-change - change a units skills
- trait-change - change a units traits
- counter-change - change the value of one of the various counters
  associated - with a unit (e.g. pain, paralysis, stun, blood, etc...)
- propel - turn a target unit into a projectile

Item Based Scripts
==================
- create - create an item that will last for a set amount of time
- remove - removes an item from existence
- material-change - change the material of a currently equipped item
- quality-change - change the quality of a currently equipped item
- subtype-change - change the subtype of a currently equipped item
- projectile - create (or use item from inventory) an item that shoots
  from one location to another or falls from the sky

Tile Based Scripts
==================
- material-change - change the material of a tile
- temperature-change - change the temperature of a tile

Flow Scripts
============
- customweather - spawn custom weather effects that last for a specified time
- spawnflow - spawn one of the various flows
- eruption - create water or magma in a radius about a unit/location

Special Scripts
===============
- counters - allows for custom tracking of things, persistent across saves
- teleport - teleport a unit or item to various locations
- wrapper: very very versatile, see `it's docs here <roses-wrapper>`.


.. _roses-wrapper:

===========
wrapper.lua
===========
Source:  :forums:`here <135597.msg5697736#msg5697736>`

The main function of wrapper.lua is to be able to select targets for
interactions with more options than provided by the in-game system. The
basic structure of the command to use the script is::

    wrapper -userSource UNIT_ID -userTarget UNIT_ID -script [ script information goes in here, see examples below ]

These are the only required inputs, where ``-userSource`` is the unit
doing the interaction and -unitTarget is the target unit that is first
receiving the interaction (i.e. the target that the game first picks out
when running an interaction).

For an example, lets look at a simple projectile script::

    modtools/interaction-trigger -onAttackStr "shoots a bolt of steel" -command [ special/projectile -unit_source \\ATTACKER_ID -unit_target \\DEFENDER_ID -item AMMO:ITEM_AMMO_BOLTS -mat STEEL -number 1 ]

This will cause the unit performing the interaction to "shoot" a steel
bolt at the target. For the exact same results using the wrapper script
we would use::

    modtools/interaction-trigger -onAttackStr "shoots a bolt of steel" -command [ wrapper -unitSource \\ATTACKER_ID -unitTarget \\DEFENDER_ID -script [ special/projectile -unit_source !SOURCE -unit_target !TARGET -item AMMO:ITEM_AMMO_BOLTS -mat STEEL -number 1 ] ]

Notice that the -unit_source and -unit_target have changed now that they
are inside the wrapper's -script. This is an important change, because
it allows for some of the more interesting options that I will mention
later.

So far we haven't gained anything from using the wrapper script. Both of
the above examples will perform exactly the same. So now let's talk
about what makes the wrapper script so useful. Options!

You can basically split all of these options into four categories,
Number Based, Token Based, Target Manipulation, and Script Manipulation

Number Based
============
The number based options are::

    -age
    -speed
    -physical
    -mental
    -skills
    -traits

Each of these options has the requirements min, max, greater, less. Min
and max are straight forward, they tell the script that for a target to
be acceptable they must have a minimum or maximum amount of a certain
type.
Greater and less perform slightly differently. They take the ratio
unitSource/unitTarget and compare it to a given value. Examples to follow

These can further be broken down into two separate groups.

``-age`` and ``-speed`` don't have any sub-types
associated with them and so have the format ``-age min:10``.
This means that the script will only accept the target if it is older
than 10. Multiple requirements for the same option can be included for
more configuration. For example ``-age [ min:10 max:20 ]``
will only accept the target if they are older than 10 but less than
20 years old.

The rest of the number based options all require an additional input of
a sub-type. This takes the form ``-physical STRENGTH:min:2000``,
which should be fairly straightforward. So, for instance, if you would
like an interaction to affect the target only if the user is twice as
strong as the target you would use ``-physical STRENGTH:less:0.5``,
or only if the user is at least as strong as the target, and the target
isn't super tough ``-physical [ STRENGTH:less:1 TOUGHNESS:max:2000 ]``.

The possibilities are endless. A full list of sub-types for each option is
`available on my github. <https://github.com/Pheosics/v24-r3_Scripts>`_

Token Based
===========
The token based options are::

    -aclass
    -acreature
    -asyndrome
    -atoken
    -iclass
    -icreature
    -isyndrome
    -itoken
    -noble
    -profession
    -entity

These can further be broken up into two groups:

-noble, -profession, and -entity all require an additional input, namely
``required`` or ``immune``. So to make an interaction that can only target
your leader you would use ``-noble required:MONARCH``. Just like the number based
options, multiple specifications can be placed, so if you would only
like an interaction to target carpenters or masons use
``-profession [ required:CARPENTER required:MASON ]``

The rest do not need the ``required`` or ``immune`` designation, as it is
already built in. As you can probably guess all of the i* options are the immune
versions, and the a* options are the required (or allowed as the a
stands for in this case) versions.

-aclass and -iclass check the units [CREATURE_CLASS:] tokens and
subsequently allow or deny a creature to be targeted. They can be
invoked by using ``-aclass GENERAL_POISON``.

-acreature and -icreature check the actual creature and caste to see if
the unit can be targeted. They are used with
``-icreature [ DRAGON:MALE DRAGON:FEMALE ]``

-asyndrome and -isyndrome check for any actives syndromes [SYN_CLASS].
Used just the same as -aclass and -iclass.

-atoken and -itoken, these are probably one of the more interesting
options, they check the unit for a myriad of a number of tokens ranging
from FLIER to MEGABEAST to AMPHIBIAN, basically anything that is
specified as a single token in the creatures raws. A full list of
supported tokens can be found on my github.

Note that none of these options are required in any way, and the logic
behind using them is the same as the in-game logic behind the ALLOWED
and IMMUNE options in interactions.


Target Manipulation
===================
Now we get into the more advanced options. These options are::

    -radius
    -plan
    -maxtargets
    -target
    -reflect
    -silence

Each one is fairly different, so lets take them one at a time.

-radius allows for selecting multiple targets in a given area around the
-unitTarget. This means that you could have all units within 10 tiles,
all units in a single square, or all units in a line be effected. The
default value for this is -1,-1,-1 which means just the -unitTarget is
effected. Change this by using ``-radius 10,10,0``, which, as you might
guess, is the radius around which a unit can be affected
(in the typical x,y,z coordinates).

-plan functions similarly to -radius but allows for more interesting
shapes. It requires an external text file, located in the hack/scripts
folder, for instance my example allows units within an X pattern of the
-unitTarget to be affected. 0's mean not allowed, 1's are allowed, and
the 'X' is the location of the -unitTarget. Note that this currently
only supports the current z-level of the ``-unitTarget``::

    1,0,0,0,1,
    0,1,0,1,0,
    0,0,X,0,0,
    0,1,0,1,0,
    1,0,0,0,1

This option is invoked, assuming the above in saved in
:file:`scripts/5x5_X.txt` by using ``-plan 5x5_X``.

-maxtargets is useable with -radius and -plan to limit the number of
targets that can be selected. If no -maxtargets option is selected, all
the targets found will be targeted, otherwise a random sample, the size
of -maxtargets will be selected from the list of available targets. This
option is used by specifying ``-maxtargets 10``.

-target is a rather difficult to use option, I have altered the logic
behind this option more times than I can count, and am still not
entirely happy with it. The gist of the option is to allow configurable
targeting based on the relationship between the -unitSource and
-unitTarget. The valid options for -target are::

    invasion
    civ
    population
    race
    sex
    caste
    enemy

Which, if you know how DFHack structures are enumerated you will see
that there are id numbers associated with each creature for each of
these options (except for enemy, which is basically just the inverse of
civ).

This would mean that only creatures that have the same civ_id as the
-unitSource are eligible for targeting.

-reflect and -silence both take [CREATURE_CLASS] and [SYN_CLASS] tokens
as their arguments, but check differently.

-reflect checks the -unitTarget's creature classes and any active
syndrome classes, and if any are found to match the given token the
-unitTarget will be changed to be the -unitSource, and as long as the
-unitSource passes the other options, the script will treat the
-unitSource as the -unitTarget and the -unitTarget as the -unitSource
(for functions where both are needed to be different, like
special/projectile). An example would be
``-reflect [ REFLECT_FIRE REFLECT_ELEMENTAL REFLECT_ALL ]``

-silence checks the -unitSource's creature classes and any active
syndrome classes, and if any are found to match the given token the
interaction simple won't be cast, effectively "silencing" the unit (or
disabling if you prefer not to think of the classic magic system).

Script Manipulation
===================
The final group of options are, possibly, the most unique::

    -chain
    -center
    -delay
    -value

-chain allows for "chaining" of spells. By default spells do not chain
(i.e. ``-chain 0``), but say you want the steel bolt from the above examples
to hit the first target and then hit another target (from the acceptable
target list) you would use ``-chain 1``.

Note that this means you MUST HAVE a -radius or -plan option specified,
otherwise it will just continually hit the same target (as there is no
one else to chain to). Also note that by default this example::

    -radius 5,5,5 -chain 1

Will hit all units within a block of 5x5x5 around the target AND then
each one of those will chain to another target (thus if there are 5
illegible units it will target all 5, then each of those 5 will chain to
a new set of units within 5x5x5 of them). To change this behavior so
that it still checks the targets in range, but only actually hits the
-unitTarget, you must use the -center option, so that
``-radius 5,5,5 -chain 1 -center`` would only hit the -unitTarget and
then select a random unit from those otherwise illegible to hit next.

-center forces the script to ignore any previous options and only target
the -unitTarget (note that it still keeps a list of otherwise illegible
targets for use in other options, like -chain).

-delay simply delays the effect of the script by a specified amount of
in-game ticks.

This would tell the wrapper script to calculate all of the illegible
targets now, but wait to apply the actual affect for 100 ticks.

``-value`` is my favorite option, and probably the most complex. It
allows you to pass different arguments to scripts based on the units
targeted and unit using the interaction. My go-to example is if you want
your warrior to have a "battle shout" type ability that gives their
willpower to all nearby friendly units you can do it with this option.

To break it down, this option required four different specifications
``TYPE:SUB_TYPE:VALUE:OFFSET``.

There are 4 valid types stacking, destacking, self, and target. Stacking
and destacking form one group of types and self and target form another.

Valid sub types for stacking and destacking are ``total``, ``allowed``,
and ``immune``.

Valid sub types for self and target are; strength, agility, endurance,
toughness, resistance, recuperation, analytical, focus, willpower,
creativity, intuition, patience, memory, linguistic, spatial,
musicality, kinesthetic, empathy, social, web, stun, winded,
unconscious, pain, nausea, dizziness, paralysis, numbness, fever,
exhaustion, hunger, thirst, sleep, infection, and blood.

Stacking and destacking work by checking the targets list and
manipulating the value based on the number of targets. It starts with
the given value and increases it by the offset. So, for example, if you
wanted to give a value of 100 + 10 for each creature targeted you would
use ``-value stacking:allowed:100:10``.  Destacking works the same way,
except it decreases the value by the offset instead of increases.

Self and target work by taking the ``-unitSource`` or ``-unitTarget``'s
value for a given sub type, taking a percentage of that value and then
increasing or decreasing it by a given offset. Thus, to give the unit
the same willpower as the ``-unitSource`` you would do ``-value
self:willpower:100:0``

Or to take the targets strength ``-value target:strength:100:0``

Then anywhere you put !VALUE in the command line, it would be replaced
by these calculations.

Those are all the "basic" options (I list them as "basic" only because
they are all fairly straight forward). There is also the "special"
option; -counters, this allows for scripts to be triggered only once
certain conditions are met. And is to be used in conjunction with the
special/counters script. See the -help documentation for that script to
understand the use of the -counters option.

Examples
========
Ok, now that was a lot of information. So how about some examples! Let's
take our original example::

    modtools/interaction-trigger -onAttackStr "shoots a bolt of steel" -command [ wrapper -unitSource \\ATTACKER_ID -unitTarget \\DEFENDER_ID -script [ special/projectile -unit_source !SOURCE -unit_target !TARGET -item AMMO:ITEM_AMMO_BOLTS -mat STEEL -number 1 ] ]

And add some options to it::

    modtools/interaction-trigger -onAttackStr "shoots a bolt of steel" -command [ wrapper -unitSource \\ATTACKER_ID -unitTarget \\DEFENDER_ID -script [ special/projectile -unit_source !SOURCE -unit_target !TARGET -item AMMO:ITEM_AMMO_BOLTS -mat STEEL -number 1 ] -radius 3,3,0 -maxtargets 5 ]

Now it will shoot a steel bolt at up to 5 targets within a 3x3x0 block
around the target. But this includes friendly units too! Well I don't
want that so I use::

    modtools/interaction-trigger -onAttackStr "shoots a bolt of steel" -command [ wrapper -unitSource \\ATTACKER_ID -unitTarget \\DEFENDER_ID -script [ special/projectile -unit_source !SOURCE -unit_target !TARGET -item AMMO:ITEM_AMMO_BOLTS -mat STEEL -number 1 ] -radius 3,3,0 -maxtargets 5 -target enemy ]

Now, instead, I want to just shoot one bolt, but have it chain to one of
the 5 targets::

    modtools/interaction-trigger -onAttackStr "shoots a bolt of steel" -command [ wrapper -unitSource \\ATTACKER_ID -unitTarget \\DEFENDER_ID -script [ special/projectile -unit_source !CENTER -unit_target !TARGET -item AMMO:ITEM_AMMO_BOLTS -mat STEEL -number 1 ] -radius 3,3,0 -maxtargets 5 -target enemy -chain 1 -center ]

Notice that I added -center, but I also changed !SOURCE to !CENTER. This
means that the script knows the bolt should go from the source to the
target, then from the target to the new, chained, target. If I had left
!CENTER as !SOURCE it would have, instead, shot a bolt from the source
to the target and then another from the source to the new target.

Now, what if I want to shoot a number of arrows, and a single target,
based on the number of allies around the unit?
::

    modtools/interaction-trigger -onAttackStr "shoots a bolt of steel" -command [ wrapper -unitSource \\ATTACKER_ID -unitTarget \\DEFENDER_ID -script [ special/projectile -unit_source !SOURCE -unit_target !TARGET -item AMMO:ITEM_AMMO_BOLTS -mat STEEL -number !VALUE ] -radius 3,3,0 -maxtargets 5 -center -target civ -value stacking:allowed:0:1 ]

Ok, so there are some offensive examples, but what about defensive
examples? How about my above mentioned example of giving willpower to
all nearby friendly units::

    modtools/interaction-trigger -onAttackStr "shouts a rallying battle cry" -command [ wrapper -unitSource \\ATTACKER_ID -unitTARGET \\ATTACKER_ID -script [ unit/attribute-change -unit !TARGET -set !VALUE -mental WILLPOWER -dur 1200 ] -radius 5x5x0 -value self:willpower:100:0 -target civ ]

I think that is enough information for now. Hopefully this is useful for
people attempting to use the wrapper script, I know it can seem very
daunting, but please feel free to ask, and please, post any of your uses
so people have more examples to look at.



.. _roses-class-system:

============
Class System
============
Source:  :forums:`here <135597.msg5768344#msg5768344>`

The Class System allows for a user defined upgrade structure for player
characters in Fortress mode. The key features are:

Working experience system

- Gain experience through killing, using interactions, and reactions
- Class requirements - Restrict classes based on experience, attributes,
  traits, skills
- Class bonuses - Gain attributes and skills based on class level
- Class trees - Create complicated class trees by requiring other classes

As you can see it allows for lots of different customization! So let's
get started. As well as the usual DF, DFHack, and scripts, you'll need
to have Python 3.3 or later installed.

The files in my script collection related to the Class System:

- hack/lua/classes/establish-class.lua
- hack/lua/classes/read-file.lua
- hack/lua/classes/requirements-class.lua
- hack/lua/classes/requirements-spell.lua
- hack/scripts/classes/add-experience.lua
- hack/scripts/classes/change-class.lua
- hack/scripts/classes/learn-skill.lua
- hack/scripts/base/classes.lua
- hack/scripts/unit/attribute-change.lua
- hack/scripts/unit/skill-change.lua
- hack/scripts/unit/trait-change.lua
- raw/objects/classes.txt
- raw/objects/spells.txt
- raw/classes_setup.py

So, where to start? For virtually everything you want to do, the only
two files you will need to work with are ``classes.txt`` and
``spells.txt``. classes is where you will specify everything related to
the classes, and spells is used to coordinate
reactions/inorganics/syndromes and everything else needed for ease of use.


classes.txt
===========
This text file will contain all of your defined classes, each following
a specific format. The structure of the classes can be broken down into
four separate parts, the base, bonuses, requirements, and spells::

    [CLASS:SQUIRE]
    # Base tokens
    [NAME:squire]
    [EXP:10:20]
    [LEVELS:2]
    # Bonus tokens
    [BONUS_PHYS:STRENGTH:50:75:100]
    [BONUS_MENT:WILLPOWER:10:20:30]
    [BONUS_SKILL:AXE:1:2:2]
    [BONUS_TRAIT:ANGER:-5:-5:-5]
    # Requirement tokens
    [REQUIREMENT_PHYS:STRENGTH:1500]
    [REQUIREMENT_MENT:WILLPOWER:1000]
    [REQUIREMENT_SKILL:AXE:4]
    [REQUIREMENT_TRAIT:ANGER:45]
    [REQUIREMENT_CLASS:PEASANT:1]
    [REQUIREMENT_COUNTER:TRAIN:5]
    [FORBIDDEN_CLASS:ACOLYTE:1]
    # Spell tokens
    [SPELL:SPELL_TEST_1:0]
        [SPELL_REQUIRE_PHYS:AGILITY:1500]
        [SPELL_REQUIRE_MENT:FOCUS:1500]
        [SPELL_FORBIDDEN_CLASS:ACOLYTE:0]
        [SPELL_FORBIDDEN_SPELL:SOME_OTHER_SPELL]
        [SPELL_COST:100]
        [SPELL_UPGRADE:SOME_OTHER_SPELL]

Those are all of the currently supported tokens for each class. You can
have as many or as few of each that you want (e.g. you can require
multiple physical attributes or none)

Now to looks at the tokens individually and see what each one does.

Base tokens
-----------
These tokens are the only mandatory tokens for a class

- [NAME] specifies what the class is called in-game, and what name
  appears next to your dwarf (e.g. Squire Urist McDwarf)
- [LEVELS] specifies how many different levels a class has
- [EXP] specifies the required experience amount for each level, note
  that you need as many numbers here as you have levels

Bonus tokens
------------
These tokens give your dwarf extra bonuses for being the class, and for
each level, note that, unlike experience, you need to have 1 + the
number of levels, where the first number signifies the bonus for level
0. You can have any number of these bonuses.

- [BONUS_PHYS] - adds (or subtracts) a set amount from the units
  specified physical attribute, the amount is total, not cumulative, so a
  level 2 Squire has a total of +100 strength, not +225
- [BONUS_MENT] - same as [BONUS_PHYS] except for the mental attributes
- [BONUS_SKILL] - same as [BONUS_PHYS] except for the units skills
- [BONUS_TRAIT] - same as [BONUS_PHYS] except for the units traits

Requirement tokens
------------------
These tokens place restrictions on the class and which Dwarfs can be the
class. Unlike bonuses there is only one number needed, as bonuses are
checked for becoming the class, not for each level.

- [REQUIREMENT_PHYS] - this states that the unit must have a minimum
  amount of the specified physical attribute in order to become the class
- [REQUIREMENT_MENT] - same as [REQUIREMENT_PHYS] except for mental
  attributes
- [REQUIREMENT_SKILL] - same as [REQUIREMENT_PHYS] except for skills
- [REQUIREMENT_TRAIT] - same as [REQUIREMENT_PHYS] except for traits
- [REQUIREMENT_CLASS] - this states that the unit must have reached the
  specified level in the specified class
- [REQUIREMENT_COUNTER] - this is to be used with my counters script,
  and so is outside of the scope of this tutorial
- [FORBIDDEN_CLASS] - this works in conjunction with [REQUIREMENT_CLASS]
  except instead of needing the specified class at the specified level, it
  forbids a unit of class/level from being this class

Spell tokens
------------
Here is where the classes get interesting. You can only learn specific
spells (i.e. interactions) if you are a specific class. Each spell is
defined in the same way, and comes with it's own set of special tokens

- [SPELL] - this always starts off the defining of a spell and is the
  only mandatory token, the name is arbitrary, but must be unique, the
  number is the level at which the spell can be learned by the class.
  Instead of a number, 'AUTO' can be placed instead, this will mean that,
  as soon as the Dwarf becomes the class, it will learn those spells (as
  opposed to being taught through reactions)
- [SPELL_REQUIRED_PHYS], [SPELL_REQUIRED_MENT], and
  [SPELL_FORBIDDEN_CLASS] - these work the same as the class versions,
  except dictate whether the unit can learn the spell
- [SPELL_FORBIDDEN_SPELL] - this only lets a unit learn this spell if it
  hasn't learned the specified forbidden spell
- [SPELL_COST] - this is an advanced tag that I will touch on later, by
  default the cost of learning all spells is set to 0
- [SPELL_UPGRADE] - instead of learning a completely new spell, you will
  instead forget an old spell and learn this one in it's place (in game
  terms, you will lose the syndrome that gave you the previous spell, and
  gain the syndrome that gives you this spell, instead of keeping both)

Misc tokens
-----------
There is currently only one other token available besides the above
mentioned, and that is the [AUTO_UPGRADE] token. Formatted like
``[AUTO_UPGRADE:WARRIOR]`` this token tells the game that as soon as the
max level of the class is reached, to change the units class to the
WARRIOR class (e.g. when you reach SQUIRE level 2, change to WARRIOR
level 0). This simplifies some of the micro-management of certain class
trees.

So now you know how to set up your classes.txt file, note that there is
no limit to the number of classes you can have, but each one must have a
unique identifier (e.g. SQUIRE)


spells.txt
==========
Now we will take a look at the spells.txt file, this file will help you
set up everything you need in game, and, along with the python routine,
automate several steps. This file is very basic::

    [SPELL:SPELL_TEST_1] <- simply label each [SPELL] as they are labelled in the classes.txt file
    [CDI:INTERACTION:SPELL_FIRE_FIREBALL] <- and place any interaction information you would normally have here
    [CDI:ADV_NAME:Fire Ball]
    [CDI:TARGET:C:LINE_OF_SIGHT]
    [CDI:TARGET_RANGE:C:15]
    [CDI:USAGE_HINT:ATTACK]
    [CDI:VERB:cast Fire Ball:casts Fire Ball:NA]
    [CDI:TARGET_VERB:is caught in a ball of fire:is caught in a ball of fire]
    [CDI:MAX_TARGET_NUMBER:C:1]
    [CDI:WAIT_PERIOD:2000]

That's it!

Spell costs
-----------
In addition to class and global experience, the system also tracks, what
I call, skill experience. You can think of this as the "skill points".
By default all spells cost 0 skill points to learn. Increasing this
number means that a unit will spend these skill points to learn the
spell. An example::

    Unit becomes class Squire
    Unit kills 20 experience worth of creatures
    Unit now has 20 class experience, 20 global experience and 20 skill experience
    Unit learns a spell that costs 10 skill points
    Unit now has 20 class experience, 20 global experience, and 10 skill experience
    Unit then changes to class Warrior
    Unit kills 10 experience worth of creatures
    Unit now has 10 class experience, 20 global experience, and 20 skill experience

In the future it may be possible to relate skill experience to levels
gained, instead of experience gains, but for now, the system is set with
experience.


raw/classes-setup.py
====================
With classes.txt and spells.txt placed in your raw/objects/ folder and
the python placed in the raw/ folder. Run the python script. If all goes
well it will generate four text files:

- ``dfhack_input.txt``: Simply copy and paste the information from
  dfhack_input.txt into onLoad.init in your raws/objects folder
- ``inorganic_dfhack_class.txt``: Double check to make sure it looks
  correct, then simply move the file into your raws/objects folder
- ``permitted_reactions.txt``: Copy and paste this text into your
  desired entity
- ``reaction_classes.txt``

    - If you have a CDI:ADV_NAME in spells.txt you will see it appear in
      the NAME of the reaction, otherwise you will see
      #YOUR_SPELL_NAME_HERE#, replace this with your desired spell name
    - In the BUILDING of the reaction, you will see
      #YOUR_BUILDING_HERE#, replace this with your desired building name
    - You will notice there are no skills, reagents, or products
      associated with these reactions. While none are necessary, you may
      wish to add material costs to changing classes or learning spells
    - Once you are happy with your changes, simply move the file into
      the raws/objects/ folder

And now you are all set to start using classes!


Experience system
=================
By default the game awards 1 experience point for each kill, whether it
be a turtle or a dragon, to address this issue there are several avenues
a modder can take.

- Adding [CREATURE_CLASS:EXPERIENCE_X], where X is some positive
  integer, will instead mean that killing that creature rewards X amount
  of experience
- In hack/scripts/base/classes.lua, at the top of the file, you will see
  radius = -1, this is the default behavior, and means that only the unit
  that struck the killing blow (in truth, only the unit listed as
  LAST_ATTACKER in DFHack when the target dies) will gain the experience.
  Increasing the number to above 0 means that any friendly unit within the
  radius of the unit who struck the killing blow will receive the
  experience.
- Experience can be gained through reactions by placing
  ::

    modtools/reaction-trigger -reaction 'YOUR_REACTION_HERE' -command [ classes/add-experience -unit \\WORKER_ID -amount X ]

  into your onLoad.init, and every time you run the given reaction, you
  will gain X experience for your current class
- Modders can also add experience gains to interaction usage (this
  allows for classes like healers, who will rarely kill anything, to still
  gain experience). This experience is not shared over nearby units if the
  radius is increased, but instead is just for the user of the
  interaction. To do this simply place
  ::

    modtools/interaction-trigger -onAttackStr 'YOUR_CDI:VERB_HERE' -command [ classes/add-experience -unit \\ATTACKER_ID -amount X ]

  into your onLoad.init, and every usage of the interaction will award
  you with X experience for your current class

These options allow for earning experience to be smoother and more
reliable.



.. _roses-civ-system:

===================
Civilisation System
===================
Source:  :forums:`here <135597.msg5799440#msg5799440>`

Everything talked about in this section is for NPC entities, not your fort.

Have you ever thought to yourself, "Man, these goblins are just no
challenge now that I have my full steel clad army", or "I wish the game
could change while I play"? If so, then this is for you!

The Civilization system allows you to customize the advancement of any
entity you would like, and have them advance during game play!

Types of advancement
====================
- Add/Remove Available Inorganics (Metals/Stones/Gems)
- Add/Remove Available Organics (Leather/Wood/Cloth/Silk/Plants)
- Add/Remove Available Creatures (Pets/Minions/Pack Animals/Mounts/Wagon
  Pullers)
- Add/Remove Available Items (Weapons/Armor/Toys/Tools/etc...)
- Add/Remove Available Refuse (Bones/Shell/Ivory/Pearl/Horn)
- Add/Remove Noble Positions (DO NOT REMOVE THEM! IT WILL CAUSE THE GAME
  TO CRASH)

All of these will effect the various stuff that an entity would bring
for trade AND for attacks. You can even add Adamantine and other SPECIAL
materials, so be careful!

Advancement is handled separately for each instance of an entity. That
means that if you have 3 different Human entities placed, each one will be
treated as it's own unique Civilization, but they will all follow the same
advancement system.

Methods of advancement
======================
- Time Based (Daily/Weekly/Monthly/Seasonal/Yearly) - as a probability of
  triggering at each selected timescale
- Kill Based - triggers when they kill a certain number of your units
- Invasion Based - triggers after they commit a certain number of
  invasions with your fort
- Trade Based - triggers after they commit a certain number of trades with
  your fort
- Counter Based - for the advanced users that use my counters script

All of the non-Time Based methods check for advancement at the start of
every new season. Advancements can occur as many times as you would like.
Each Civilization "level" counts as one advancement.

All of this means that you can have a lot of customization in your game!

The files in my script collection that are related to the Civilization
System:

- hack/lua/civilizations/establish-civ.lua
- hack/lua/civilizations/read-file.lua
- hack/scripts/civilizations/level-up.lua
- hack/scripts/civilizations/noble-change.lua
- hack/scripts/civilizations/resource-change.lua
- hack/scripts/base/civilizations.lua
- raw/objects/civilizations.txt

So now that we know what it does, and we know what we need. How do we get
started? Well for virtually everything you want to do, the only file you
will need to modify is the civilization.txt file.

So let's take a look at civilization.txt::

    [CIV:PLAINS]
    #Base Tokens
    [NAME:humans from the north]
    [LEVELS:1]
    [LEVEL_METHOD:YEARLY:100]
    #Level Tokens
    [LEVEL:0]
    [LEVEL_NAME:started in the stone age]
    #Resource Tokens
    ## Creature Tokens
    [LEVEL_REMOVE:CREATURE:PET:ALL:ALL]
    [LEVEL_REMOVE:CREATURE:WAGON:ALL:ALL]
    [LEVEL_REMOVE:CREATURE:MOUNT:ALL:ALL]
    [LEVEL_REMOVE:CREATURE:PACK:ALL:ALL]
    [LEVEL_REMOVE:CREATURE:MINION:ALL:ALL]
    [LEVEL_REMOVE:CREATURE:EXOTIC:ALL:ALL]
    [LEVEL_REMOVE:CREATURE:FISH:ALL:ALL]
    [LEVEL_REMOVE:CREATURE:EGG:ALL:ALL]
    ## Item Tokens
    [LEVEL_REMOVE:ITEM:WEAPON:ALL]
    [LEVEL_REMOVE:ITEM:SHIELD:ALL]
    [LEVEL_REMOVE:ITEM:AMMO:ALL]
    [LEVEL_REMOVE:ITEM:HELM:ALL]
    [LEVEL_REMOVE:ITEM:ARMOR:ALL]
    [LEVEL_REMOVE:ITEM:PANTS:ALL]
    [LEVEL_REMOVE:ITEM:SHOES:ALL]
    [LEVEL_REMOVE:ITEM:GLOVES:ALL]
    [LEVEL_REMOVE:ITEM:TRAP:ALL]
    [LEVEL_REMOVE:ITEM:SIEGE:ALL]
    [LEVEL_REMOVE:ITEM:TOY:ALL]
    [LEVEL_REMOVE:ITEM:INSTRUMENT:ALL]
    [LEVEL_REMOVE:ITEM:TOOL:ALL]
    ## Inorganic Tokens
    [LEVEL_REMOVE:INORGANIC:METAL:ALL]
    [LEVEL_REMOVE:INORGANIC:STONE:ALL]
    [LEVEL_REMOVE:INORGANIC:GEM:ALL]
    ## Organic Tokens
    [LEVEL_REMOVE:ORGANIC:LEATHER:ALL:ALL]
    [LEVEL_REMOVE:ORGANIC:FIBER:ALL:ALL]
    [LEVEL_REMOVE:ORGANIC:SILK:ALL:ALL]
    [LEVEL_REMOVE:ORGANIC:WOOL:ALL:ALL]
    [LEVEL_REMOVE:ORGANIC:WOOD:ALL:ALL]
    [LEVEL_REMOVE:ORGANIC:PLANT:ALL:ALL]
    [LEVEL_REMOVE:ORGANIC:SEED:ALL:ALL]
    ## Refuse Tokens
    [LEVEL_REMOVE:REFUSE:BONE:ALL:ALL]
    [LEVEL_REMOVE:REFUSE:SHELL:ALL:ALL]
    [LEVEL_REMOVE:REFUSE:PEARL:ALL:ALL]
    [LEVEL_REMOVE:REFUSE:IVORY:ALL:ALL]
    [LEVEL_REMOVE:REFUSE:HORN:ALL:ALL]
    ## Misc Tokens
    [LEVEL_REMOVE:MISC:BOOZE:ALL:ALL]
    [LEVEL_REMOVE:MISC:CHEESE:ALL:ALL]
    [LEVEL_REMOVE:MISC:POWDER:ALL:ALL]
    [LEVEL_REMOVE:MISC:EXTRACT:ALL:ALL]
    [LEVEL_REMOVE:MISC:MEAT:ALL:ALL]
    [LEVEL_REMOVE:MISC:GLASS:ALL:ALL]
    # Expanded Level Tokens
    [LEVEL:1]
    [LEVEL_NAME:entered the copper age]
    [LEVEL_CHANGE_METHOD:YEARLY:50]
    # Noble Tokens
    [LEVEL_ADD_POSITION:MONARCH2]
        # details for this position below

That includes all of the currently supported tokens for each civilization.
Note that the X in [CIV:X] must be the same as the entity you are
interested in modifying (i.e. PLAINS in Vanilla DF is Humans) Let's talk
about what they do.

Base Tokens
============
These tokens are mandatory for each civilization and should only occur once.

- [NAME] - What the civilization is called, not currently used for
  anything. This will make an appearance in the upcoming Journal project
- [LEVELS] - Number of levels that your civilization has
- [LEVEL_METHOD] - The method for levelling that the civilization starts
  with. Valid entries include:

    - DAILY/WEEKLY/MONTHLY/SEASON/YEARLY - The number then specifies the
      probability for it to occur at each time step
    - KILLS - The number is the number of kills needed
    - INVASION - The number is the number of invasions needed
    - TRADE - The number is the number of trades needed
    - COUNTER:X, where X is the name of the counter to check - The number is
      the number of the counter needed


Level Tokens
============
These are the tokens that defined each level

- [LEVEL] - The start of the level declaration, the number specifies the
  level
- [LEVEL_NAME] - The name of the level, currently appears in an in-game
  announcement, "Entity 1 has X", where X is the entered text
- [LEVEL_CHANGE_METHOD] - This allows the method of leveling to change as
  the civilization advances, valid tokens are the same as [LEVEL_METHOD]

Resource Tokens
===============
These are the tokens that will handle all of the adding and removing of
availability to specific things. The basic syntax is [LEVEL_ADD] and
[LEVEL_REMOVE]. I will split these into their various sub-types

Creature Tokens
---------------
To add/remove creatures we start with the basic syntax
[LEVEL_ADD]/[LEVEL_REMOVE] and add to it.

- [LEVEL_ADD:CREATURE:type] - valid types include

    - PET:creature:caste - adds creature to the available pets of an entity
    - WAGON:creature:caste - adds creature to the available wagon pullers
      of an entity
    - MOUNT:creature:caste - adds creature to the available mounts of an entity
    - PACK:creature:caste - adds creature to the available pack animals of
      an entity
    - MINION:creature:caste - adds creature to the available minions of an entity
    - EXOTIC:creature:caste - adds creature to the available exotic pets
      of an entity
    - FISH:creature:caste - adds creature to the available fish of an entity
    - EGG:creature:caste - adds creature to the available egg producers of
      an entity

- [LEVEL_REMOVE:CREATURE] - all of the same tokens as for [LEVEL_ADD] are
  valid for [LEVEL_REMOVE]

There is the special token ALL for both creature and class. For example
creature:ALL would add all the castes of a particular creature, ALL:caste
would add the caste of all the creatures in game, and ALL:ALL would add
all the creatures and all their castes.

Item Tokens
-----------
To add/remove items you follow a similar method to the creatures. Start
with [LEVEL_ADD]/[LEVEL_REMOVE] and add to it

- [LEVEL_ADD:ITEM:type:subtype] - valid types include

    - WEAPON
    - SHIELD
    - AMMO
    - HELM
    - ARMOR
    - PANTS
    - SHOES
    - GLOVES
    - TRAP
    - SIEGE
    - TOY
    - INSTRUMENT
    - TOOL

- [LEVEL_REMOVE:ITEM:type:subtype] - the same as available for
  [LEVEL_ADD:ITEM]

There is a special token ALL for the subtype. WEAPON:ALL will add all
weapons to a given entity

Inorganic Tokens
----------------
To add/remove inorganic materials you follow a similar method to the
creatures. Start with [LEVEL_ADD]/[LEVEL_REMOVE] and add to it

- [LEVEL_ADD:INORGANIC:type:subtype] - valid types include

    - METAL
    - STONE
    - GEM

- [LEVEL_REMOVE:INORGANIC:type:subtype] - the same as available for
  [LEVEL_ADD:INORGANIC]

There is a special token ALL for the subtype. METAL:ALL will add all
inorganics with the tag [IS_METAL] to the entity

Organic Tokens
--------------
To add/remove organic materials you follow a similar method to the
creatures. Start with [LEVEL_ADD]/[LEVEL_REMOVE] and add to it

- [LEVEL_ADD:ORGANIC:type] - valid types include

    - LEATHER:creature:material
    - FIBER:plant:material
    - SILK:creature:material
    - WOOL:creature:material
    - WOOD:plant:material
    - PLANT:plant:material
    - SEED:plant:material

- [LEVEL_REMOVE:ORGANIC:type] - the same as available for
  [LEVEL_ADD:ORGANIC]

Organic tokens work a little differently than the other tokens. Some come
from creatures and some come from plants. The first token (creature/plant)
will either be something like SHEEP if it is a creature or
MUSHROOM_HELMET_PLUMP if it is a plant. The second token (material) is the
name you have given to the material in the raw. For vanilla it is just
things like LEATHER, SEED, SILK, etc... but it doesn't have to be. You
might have a mod that has TOUGH_LEATHER as the defined material.

There is a special token ALL:ALL for the creature:material pair.
LEATHER:ALL:ALL will add all organics with the tag [LEATHER] to the entity

Refuse Tokens
-------------
Refuse tokens function the same as organic tokens, just with different
types.

- [LEVEL_ADD:REFUSE:type] - valid types include

    - BONE:creature:material
    - HORN:creature:material
    - SHELL:creature:material
    - PEARL:creature:material
    - IVORY:creature:material

- [LEVEL_REMOVE:REFUSE:type] - the same as available for [LEVEL_ADD:REFUSE]

Refuse tokens work just like organic tokens, but take different materials
(and all come from creatures).

There is a special token ALL:ALL for the creature:material pair.
BONE:ALL:ALL will add all materials with the tag [BONE] to the entity.

Misc Tokens
-----------
Misc tokens work just like organic and refuse tokens

- [LEVEL_ADD:MISC:type] - valid types include

    - CHEESE:creature:material
    - BOOZE:plant:material
    - POWDER:creature:material
    - EXTRACT:creature:material
    - MEAT:creature:material

- [LEVEL_REMOVE:ORGANIC:type] - the same as available for [LEVEL_ADD:MISC]

Misc tokens are tricky because they don't always have to be from one
source. But the same premise applies no matter where they are from.

Noble Tokens
============
Adding nobles requires a little bit more work than adding resources, but
is just as straightforward as in the raws. To add a noble all you need to
do is place [LEVEL_ADD_POSITION:X], where X is some name you choose (e.g. MONARCH).
Then everything after that, until a new [LEVEL_ADD_POSITION:X], or a
non-position raws token will be attributed to the position. In our example
above::

    [LEVEL_ADD_POSITION:MONARCH2]
    [NAME_MALE:great king:great kings]
    [NAME_FEMALE:great queen:great queens]
    [NUMBER:1]
    [SPOUSE_MALE:great king consort:great kings consort]
    [SPOUSE_FEMALE:great queen consort:great queens consort]
    [SUCCESSION:BY_HEIR]
    [RESPONSIBILITY:LAW_MAKING]
    [RESPONSIBILITY:RECEIVE_DIPLOMATS]
    [RESPONSIBILITY:MILITARY_GOALS]
    [PRECEDENCE:1]
    [SPECIAL_BURIAL]
    [RULES_FROM_LOCATION]
    [MENIAL_WORK_EXEMPTION]
    [MENIAL_WORK_EXEMPTION_SPOUSE]
    [SLEEP_PRETENSION]
    [PUNISHMENT_EXEMPTION]
    [FLASHES]
    [BRAG_ON_KILL]
    [CHAT_WORTHY]
    [DO_NOT_CULL]
    [KILL_QUEST]
    [EXPORTED_IN_LEGENDS]
    [DETERMINES_COIN_DESIGN]
    [COLOR:5:0:1]
    [ACCOUNT_EXEMPT]
    [DUTY_BOUND]
    [DEMAND_MAX:20]
    [MANDATE_MAX:10]
    [REQUIRED_BOXES:20]
    [REQUIRED_CABINETS:10]
    [REQUIRED_RACKS:10]
    [REQUIRED_STANDS:10]
    [REQUIRED_OFFICE:20000]
    [REQUIRED_BEDROOM:20000]
    [REQUIRED_DINING:20000]
    [REQUIRED_TOMB:20000]

I just copied the MOUNTAIN entities MONARCH and made one that requires
more things. Simple enough.

And there you have it, that is all that is needed to start making your
game evolve and change while you play! Please post your custom
civilizations here so that others can see all the fun things you can do!

Custom Levels
=============
You can custom level a civilization through a reaction/interaction/command
line by using ``civilizations/level-up CIV_ID``.
The counters system also allows for a much more rigorous custom levelling
structure. Especially when combined with [LEVEL_CHANGE_METHOD].



.. _roses-event-system:

============
Event System
============
Source:  :forums:`here <135597.msg5947454#msg5947454>`

Have you ever thought to yourself, "There aren't enough random events
that occur while I play, I wish I could get a double mega-beast attack,
or meteors could fall from the sky"? If so, then this is for you!

The Event System allows you to program customizable events to randomly
occur while playing. Anything that is do-able with DFHack scripts is able
to be triggered by this systems. Events are triggered randomly depending
on specified requirements and checked at various intervals.

This means that you can have a lot of customization in your game!

The files in my script collection that are related to the Civilization System:

- hack/lua/events/requirement-check.lua
- hack/lua/events/findunit.lua
- hack/lua/events/finditem.lua
- hack/lua/events/findlocation.lua
- hack/lua/events/findbuilding.lua
- hack/scripts/events/trigger.lua
- hack/scripts/base/events.lua
- raw/objects/event.txt

So now that we know what it does, and we know what we need. How do we get
started? Well for virtually everything you want to do, the only file you
will need to modify is the event.txt file.

So let's take a look at event.txt::

    [EVENT:SAMPLE_EVENT]
        [NAME:this is a sample event]
        [CHECK:MONTHLY]
        [CHANCE:10]
        [DELAY:RANDOM:12000]
        [REQUIREMENT:BUILDING:SAMPLE_WORKSHOP:1]
        [REQUIREMENT:COUNTER:SAMPLE_COUNTER:10]
        [REQUIREMENT:TIME:10000]
        [REQUIREMENT:POPULATION:50]
        [REQUIREMENT:WEALTH:TOTAL:10000]
        [REQUIREMENT:CLASS:SAMPLE_CLASS:3]
        [REQUIREMENT:SKILL:MINER:15]
        [REQUIREMENT:KILLS:GOBLIN:10]
        [REQUIREMENT:DEATHS:ALL:50]
        [REQUIREMENT:TRADES:PLAINS:5]
        [REQUIREMENT:SIEGES:EVIL:5]
        [EFFECT:1]
            [EFFECT_NAME:first sample effect of the event]
            [EFFECT_CHANCE:100]
            [EFFECT_DELAY:STATIC:100]
            [EFFECT_CONTINGENT:0]
            [EFFECT_ARGUMENT:1]
            *EFFECT_REQUIREMENT:* <- same as for just normal REQUIREMENT
                [ARGUMENT_WEIGHTING:100,100,100,10,10,10,1]
                [ARGUMENT_VARIABLE:HUMAN_MERCHANT,ELF_MERCHANT,DWARF_MERCHANT,TRAVELING_MERCHANT.GOBLIN_MERCHANT,KOBOLD_MERCHANT,EXOTIC_MERCHANT]
            [EFFECT_SCRIPT:"building/change -from EMPTY_MERCHANTS_STALL -to !ARG_1 -dur 25200"]

That includes all of the currently supported tokens for each event. Note
that the X in [EVENT:X] must be the unique. Now let's talk about what
each one does.

Starting with the event declaration itself;

Event Tokens
============

Base Tokens
-----------
These tokens are mandatory for each event, and should only occur once.
If they are repeated, they will be overwritten.

- [NAME] - what the event is called, not currently used for anything,
  but will be included later
- [CHECK] - how often to check if they event should be triggered.
  Valid entries include:

    - DAILY
    - WEEKLY
    - MONTHLY
    - SEASON
    - YEARLY

- [CHANCE] - the percentage chance that the event will be triggered
- [DELAY] - the amount of time, in in-game ticks, after the check that
  the  event should be triggered. Can be either a STATIC delay or a
  RANDOM delay.

Requirement Tokens
------------------
These tokens specify what requirements must be met in order for the
event to be triggered. They can be combined in any number of ways.

- COUNTER - for use with the counters script
- TIME - checks the age of the fortress, in in-game ticks
- POPULATION - checks the population of the fortress
- WEALTH - checks the wealth of the fortress, Valid secondary tokens include

    - TOTAL - checks total wealth
    - IMPORTED - checks imported wealth
    - EXPORTED - checks exported wealth
    - WEAPONS - checks cumulative value of all weapons
    - ARMOR - checks cumulative value of all armor
    - FURNITURE - checks cumulative value of all furniture
    - DISPLAYED - checks cumulative value of all displayed items
    - HELD - checks cumulative value of all held items
    - ARCHITECTURE - checks cumulative wealth of all architecture
    - OTHER - no idea, everything else I guess?

- BUILDING - checks for a number of specified custom workshops and furnaces
- SKILL - checks for any units that have a specified skill at a specified level
- CLASS - for use with the Class System, checks for a number of units
  with the specified class
- KILLS - checks for a specific amount of kills
- DEATHS - checks for a specific amount of deaths
- TRADES - checks for a specific number of trades
- SIEGES - checks for a specific number of sieges


Effect Tokens
=============
Effect tokens are where the magic really happens.

Base Tokens
-----------
The same as the base event tokens, these tokens must occur once for each effect.

- [EFFECT_NAME] - name of the effect, not currently used
- [EFFECT_CHANCE] - chance the effect will be triggered after the event
  has already been triggered
- [EFFECT_DELAY] - delay of effect triggering, cumulative with event [DELAY]

Requirement Tokens
------------------
The exact same as the event requirement tokens, just change [REQUIREMENT]
to [EFFECT_REQUIREMENT], with one addition.
[EFFECT_CONTINGENT] specifies that a previous effect must have triggered
in order for the current effect to trigger.

Script Tokens
-------------
The effects are where the scripts are actually run, and can contain as
many scripts as you would like. The scripts are specified just as they
would be on the command line with a few differences for special inputs.
The following special inputs are used to modify the scripts.

[li]!UNIT - for use with [EFFECT_UNIT][/li]
[li]!LOCATION - for use with [EFFECT_LOCATION][/li]
[li]!BUILDING - for use with [EFFECT_BUILDING][/li]
[li]!ITEM - for use with [EFFECT_ITEM][/li]
[li]!ARG_X - for use with [EFFECT_ARGUMENT:X][/li]

[EFFECT_UNIT]
~~~~~~~~~~~~~
This is how the effect identifies a unit to send to the script being run.
Valid arguments include

- RANDOM - picks any active unit
- RANDOM:CIVILIZATION - picks any active unit that is a member of your
  fort's civilzation
- RANDOM:POPULATION - picks any active unit that is a member of your fort
- RANDOM:INVADER - picks any unit that is currently invading your fort
- RANDOM:MALE - picks any male on the map
- RANDOM:FEMALE - picks any female on the map
- RANDOM:PROFESSION:PROFESSION_NAME - picks any unit of the given profession
- RANDOM:CLASS:CLASS_NAME - for use with the Class System, picks any unit
  of the given class
- RANDOM:SKILL:SKILL_NAME:VALUE - picks any unit with the specified
  skill/value combination
- RANDOM:CREATURE:CASTE - picks any unit of the specified creature/caste combination

[EFFECT_LOCATION]
~~~~~~~~~~~~~~~~~
Use this when you need to pass a location to a script

- RANDOM - picks any location on the map
- RANDOM:SURFACE - picks any location on the surface
- RANDOM:SURFACE:EDGE - picks any location on the surface on an edge
- RANDOM:SURFACE:CENTER:X - picks any location on the surface
  within X tiles of the x,y center
- RANDOM:UNDERGROUND - picks any location underground
  (this includes inside stone walls and the like)
- RANDOM:UNDERGROUND:CAVERN:X - picks any open location in a specified
  cavern level
- RANDOM:SKY - picks any location above the surface
- RANDOM:SKY:EDGE - picks any location above the surface on an edge
- RANDOM:SKY:CENTER:X - picks any location above the surface
  within X tiles of the x,y center

[EFFECT_ITEM]
~~~~~~~~~~~~~
When you need an item ID for a script you can use this. Valid arguments include:

- RANDOM - picks any item on the map at random
- RANDOM:WEAPON - picks any weapon on the map, can include an optional :SUBTYPE
- RANDOM:ARMOR - picks any armor on the map, can include an optional :SUBTYPE
- RANDOM:HELM - picks any helm on the map, can include an optional :SUBTYPE
- RANDOM:PANTS - picks any pants on the map, can include an optional :SUBTYPE
- RANDOM:GLOVE - picks any glove on the map, can include an optional :SUBTYPE
- RANDOM:SHOE - picks any shoe on the map, can include an optional :SUBTYPE
- RANDOM:SHIELD - picks any shield on the map, can include an optional :SUBTYPE
- RANDOM:AMMO - picks any piece of ammo on the map, can include an optional :SUBTYPE
- RANDOM:MATERIAL - picks any item made of a specific material,
  currently only supports INORGANIC materials

[EFFECT_BUILDING]
~~~~~~~~~~~~~~~~~
For when you need to pass a building ID to a script

- RANDOM - picks any building on the map
- RANDOM:WORKSHOP - picks any workshop on the map
- RANDOM:FURNACE - picks any furnace on the map
- RANDOM:CUSTOM:CUSTOM_BUILDING - picks any custom building
- RANDOM:TRADE_DEPOT - picks any trade depot on the map
- RANDOM:STOCKPILE - picks any stockpile on the map
- RANDOM:ZONE - picks any civ zone on the map

[EFFECT_ARGUMENT]
~~~~~~~~~~~~~~~~~
This allows for even more customization in an individual script call. The
way it works is, any time the script sees !ARG_X it will replace it with
whatever [EFFECT_ARGUMENT:X] is. In order for this too work new tokens
must be defined.

Argument Tokens
---------------
Each [EFFECT_ARGUMENT] must have a corresponding weighting and value so
that it can randomly pick what to replace.

- [ARGUMENT_WEIGHTING] - this is mandatory, it tells the script how to
  handle multiple options
- [ARGUMENT_VALUE] - this tells the script the various values to choose
  for an effect (note these can be numeric values or strings)[/li]
- [ARGUMENT_EQUATION] - this is a special case of [ARGUMENT_VALUE] and is
  more complex, see the wrapper documentation to see how equations work

And that is all the tokens currently available to use in event.txt. Let
us take a look at an example in order to provide some clarity.
::

    [EVENT:MERCHANT_ARRIVAL]
        [NAME:a new merchant arrives]
        [REQUIREMENT:BUILDING:EMPTY_MERCHANTS_STALL:1]
        [CHECK:MONTHLY]
        [CHANCE:100]
        [DELAY:STATIC:0]
        [EFFECT:1]
            [EFFECT_NAME:merchants arrive for a short time]
            [EFFECT_CHANCE:100]
            [EFFECT_DELAY:STATIC:0]
            [EFFECT_BUILDING:RANDOM:CUSTOM:EMPTY_MERCHANTS_STALL]
            [EFFECT_ARGUMENT:1]
                [ARGUMENT_WEIGHTING:100,100,100,10,10,10,1]
                [ARGUMENT_VARIABLE:HUMAN_MERCHANT,ELF_MERCHANT,DWARF_MERCHANT,TRAVELING_MERCHANT.GOBLIN_MERCHANT,KOBOLD_MERCHANT,EXOTIC_MERCHANT]
            [EFFECT_SCRIPT:"building/change -building !BUILDING -to !ARG_1 -dur 25200"][/code]

In words, this event changes the building EMPTY_MERCHANTS_STALL into a
different building at the start of every month. The building it changes
in to is chosen randomly from those found in [ARGUMENT_VALUE] with the
weighting found in [ARGUMENT_WEIGHTING].

And that's everything you need to know. I hope to be able to create some
of my own custom events to share with all of you, but please, if you
create any events for yourself, or for your mod, please post them so that
others can see more examples!

Addendum
========
You can force an event to trigger by using the dfhack command::

    events/trigger -event EVENT_ID

This will still run the requirement checks, but will by-pass the [CHECK]
and [CHANCE] tokens. In order to by-pass the requirements as well, you
can use the command::

    events/trigger -event EVENT_ID -force

Which will by-pass the event requirements, or::

    events/trigger -event EVENT_ID -forceAll

Which will by-pass both the event and effect requirements.

