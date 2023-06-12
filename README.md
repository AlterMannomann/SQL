# UNDER CONSTRUCTION
Feel free to use, extend and modify this. Free as free beer. No restrictions. You may also use it simply to learn something about SQL.
# Intention
This is a simulation of a (whatsoever) universe, starting with the building of space itself. The simulation uses the model of n-spheres for dimension.
Btw. I'm aware of the fact, that I'm using terms & definitions not in the pure mathematical sense, like dimension and point. It is more likely an approximation to avoid constructing new words. I'll work on that. Probably this attempt is more something like Conways Game of life.

Dimension n = 0 is the very very unknown, where I put my assumptions in:

A (whatsoever) *particle* that rotates and spreads its energy.

Going further, we have to consider we are in the midst of nothing, really nothing. We have three wishes free.

1. To know what add, substract, rotation and PI or so to say mathematics is.
2. To provide a basic *point/particle* structure with rules.
3. To use and give the imaginary *point/particle* energy for one imaginary rotation.

The overall rule is, the energy of the nothing (0) we had before, must never change or our universe will crash. Moreover one space point has one position that can't be shared, changed or used by another space point in every dimension supported.

**Caution**: If the simulation works (so far it creates waves going forth and back reaching infinity), the probability raises, that we are part of a simulated universe. If it works, watch the foam on the space point energy reaction. It will create its own rules.

## The one thing
If we try to imagine nothing, we fail. How else? Thinking of dimension n = 0 is almost similar, but we can imagine at least something binary, zero and one, minus and plus. We have space for at least one *something* not more, not less. Means before we had nothing, lets name it zero and now we have something, lets name it one. By creating a dimension n = 0 we inherit a binary concept. So plus and minus are also in reach. Not in dimension n = 0, but in every following dimension.

To make it obvious, I put point one, the universe seed at position 0.

I'm playing a little bit god using wish 2 and provide two basic space point structures up to the dimension, we support (you may adjust this to your needs). As we know one, we can build points by adding one to our position and another one for the second position. To build a point in different dimensions, we only need two position values, as they will spread with every new axis of every new dimension.

To respect the one thing, I start the universe seed with one (1, -1) as the only start value for attributes.

## The Planck thing
Everything is at level Planck, means we have planck time t = 1 with planck velocity c = 1. We can't see what is happening in space points or space point trees. We can only observe the result. Means we'll may see the energy, wave amplitude and wave length arriving to the next coordinate, but not the wave movement, as we can't look into the coordinate dynamics itself, the reaction between coordinates that form a space point.

When one planck time tick has passed, all calculations for the universe are done. All space points/coordinates are most likely in reach within this time frame at least from their parent.

This means also, that planck time definition in relation to length is variable, as the length between the seed and the farest space point will change constantly as long as the universe builds new space. The bigger the universe gets, the more the planck time to length relation will look like a constant. Same for planck velocity. Especially if we have limited number size.

## Space points
Space points are defined as perfect binary trees of coordinates up to the supported dimension, where every tree node describes and contains the coordinates for
the associated dimension:

**tree height - 1 equals n-sphere dimension**

Space points are, moreover, stationary and timeless. They can't move, but they can accumulate energy. And they can't be destroyed as long as the universe exists. They can have positive, negative or zero potential energy and that's it. They are formed by coordinates (outer bounds) to define the area, a space point is active. In n = 1 it is the line between the two coordinates, in n = 2 the coordinates form a square and so forth. In documentation I use coordinate as well as point (not space point) simultaneously for the outer bounds of space points, which is, of course not very accurate.

What we know as our universe is in my opinion the foam on top of this space points created by the available energy.

On overflow, means any calculation of coordinate attributes results in infinity (for our available systems), the coordinate attributes are not updated. Instead the space point will create a new
tree structure and initialize it with the negative values of the source attributes, that would have caused an overflow. You may imagine this as similar to the process to give birth. First it needs a lot of energy taken from the parent, in human case mother, to give a new life birth.

## Space point trees
There is only one universe seed possible, a space point that has **no** parent. As of the fact, that IT systems can't differentiate well between -0 and +0, what would have been my preferred solution, I'm using base coordinates 1, 2 (base) and -1, -2 (mirror) for the basic point trees. This means also, that positive and negative trees do not get to close, as we start with a vector distance around 4.4... between positive and negative space getting bigger with every new space point. Of course this in not conform with our current understanding, but I'm still talking about space itself, not about things, that may happen within this created space time or with foam particles on the top of the space points. To keep things a little bit smaller, I limit the dimensions currently to n = 3. But I'm using a database, so it is only a question of available space and processing capacities.

The sum of the energy of all trees, has to sum up to 0 to not break the universe.

As I assume that the energy of the universe seed in dimension n = 0 is as well positive and negative, I spread the energy on each tree with the sign of the position of each tree to our childs.

The childs will react first only in one direction. They react with the source input and deliver the result to their childs until no more child is left. Then the last childs will send their results to their parents until the universe seed is reached. That is the process within one planck time unit. Which will be repeated either to the point where every space point attribute is zero or space point extension reaches the ressource limits of used machines.

In fact this is some kind of feedback machine.

Independent of the size of the universe space (means, again, the basic space structure, not the foam on top). Of course our simulation will spend more and more time on this, but this is only an effect of our reality within an universe.

The tick outside is different from the tick inside. Everything inside will only notice a change, when the tick has changed. How long the outside tick ever has taken, is not relevant for the inside, because inside it will look the same, whenever time tick dependent space point or foam action happens.

## Dimension n = 0
In this dimension I place the seed for the universe. It can hold one object and attributes of this object, which are irrelevant to the rest of the simulated universe. Therefore the seed is never taken into account on calculating the energy level of the universe. Only dimensions n > 0 have to be equilibrated, if there exist childs of the seed.

## Subtree structure
Any point can have any number of subtrees. The limitation lies on position and available ressources. If a higher dimension has already used the position, the subtree can
only spread up to the dimension that holds equivalent position values. Aim is, that all values exist in all dimension, but parentship can be different through overflow events on different coordinates of a tree or subtree.

## The foam thing
**not implemented yet**

Space points are only defining the potential energy attributes on every point in the simulated universe currently modeled and will or should only lead to an extension of the available space. Thus we have a binary concept and a potential concept. Something that may happen on top of the potential energy it accumulates.

Whereas the space point arithmetics are quite simple, the foam arithmetics have to consider time, location, distance and are under relativity. They have to operate most likely on more than one point representation, have to be a meta model, which either shows up or not.

To get a wave like behaviour, we do not use direct actio / reactio. I flood the coordinate attributes in one direction up to the farest coordinates using Newtons F = m1 * m2 / distance<sup>2</sup> to first calculate the reaction on the childs, without applying the same force immediately to the parent (we are still below planck time = 1, so it looks for the rest of the universe as if it is an immediate reaction). I interpret mass as equal to energy. If the wave of energy reaches the last available coordinates the energy wave floods back applying the force to the parents until the universe seed is reached. The space points can't be seen as particles, they only form the space time of the universe. The energy in the space points may create something similar as particles on the available space points which I call foam. The waves in one space point will build different waves if other space point waves are taken into account if seen from above.

Thus I implement implicitly the gravitation rule as well as wave like behaviour. The rest is up to the foam.

Thus, even a god creating some similar kind of universe would be blind, not able to see more in the foam than foam, if this god would not be looking for something similar than our foam here. And even if, this god could maybe pick up some reference points for an inside view, but never ever all points at the same time. Ok, if this god is a god, probably possible. But if this god is me, no chance. And I truly believe, if there is something above us, what we can't understand and that has more possibilities, it is still bound to rules and limits of whatever universe it is living in. If there are limits, any limited god will be in the same situation as myself, probably only having bigger quantities of samples and greater numbers, but no possibility to interact without destroying the universe (that is very bad for most of the religions we have, a blind god seeing all, with no clue what is happening and no chance to interact).

# Build
To build the model from scratch you currently need Oracle (developed on Oracle 21c) and an empty schema, where you want to install it.

**Run USIM_MODEL.sql** to build the basic universe simulation db model.

**Run EXEC usim_ctrl.run_planck_cycles([CycleLoops]);** for the given cycle amount for space points reactions within one planck time unit per cycle (currently not supporting creation of subtrees - in work). The packages and their functions and procedures are highly integrated to provide the correct and expected input values. If you want to use them separatly be aware of this limitation. I'm not checking too much situations, which would not occur by design.

## Limitations
### Sequences
As Oracle provides 38 digits for any number, the size of indices is very limited. Better to build an index as char based on combined numbers at their maximum digits supported by the system. With numbers it may be sufficient to identify a system limitated infinity situation and handle it. Whatever system limits we may have.

Indices by sequences are limited by number capacity of the system. To overcome this limit we can use char columns which combine a current timestamp with a cycling sequence like

TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3') || LPAD([sequence], 38, '0')

Tables needing big primary keys will use in this implementation CHAR(55) columns.

### Point coordinates
Currently a point coordinate is limited n<sup>n</sup> (n = maximum integer value a system can provide).

To overcome limits on numbers for positions, I use number levels, which result in n<sup>n</sup> more or less for possible numbers (maybe something like n<sup>n</sup> - 1 or n<sup>n-1</sup>, currently I don't care). Not well defined yet. If distances are not too extreme, which I don't expect from binary trees (who knows), calculation should be more or less correct. No way to calculate distances with number level difference > 1. Check handling of distance of points defining a point and correct it, wherever necessary.
### Learning SQL and PL/SQL
You may want to look at table USIM_LEVELS how to restrict records on a table, Package USIM_DEBUG to learn more about debugging and logging (PL/)SQL and much more. Feel free to explore the code. Apart from this, I'm convinced that there exist much more better solutions than the solutions I've found and established. It is only a starting point. Btw. I didn't care about performance currently.

## To do
* remove all position attributes apart from energy. One thing, one attribute. Waves and frequencies are functions on top of the topology.
* fillPointStructure has to find out the maximum dimension possible for the given position values. The minimum dimension is given by the parent.
* A check for new coordinates is needed. They should fit in the dimensions of the tree/subtree without creating values that already exist in this dimension. A parent coordinate, where a overflow happened, can have any dimension. New subtrees are limited to exist below any other dimension, already containing the position coordinates used by that dimension. If I imagine a coordinate overflow in dimension n = 2 the subtree will only fill dimension n > 2 with new coordinates. The space in the lower dimension will not have the new coordinates, but can insert this values. Reaction on final dimension on overflow unclear at the moment as there is no upper dimension available. Probably a moment to raise the possible dimensions.
* create usim_ctrl.runSimulation. A table is needed, that can be updated and is read by runSimulation to find out, if a simulation should be stopped at a certain point. Otherwise the simulation may run endlessly. Mostly equal to run_planck_cycles, without a limit of cycles. The future main interface to the simulation. A procedure to stop and continue is needed as well.

