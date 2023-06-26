**Under Construction - description is out of sync due to redesign**
Feel free to use, extend and modify this. Free as free beer. No restrictions. You may also use it simply to learn something about SQL.
# Intention
This is an attempt to create a (whatsoever) multiverse that creates its own space volume and try to discover patterns we know from our universe, we are living in (like a big bang burst with a following dark period until something starts to happen).

**Attention** I'm using terms that have an exact and sharp definition in our universe, just because I'm to lazy to create new terms. So thinking about the terms and definitions has to include, that we observe a universe/multiverse from outside, not only from inside. And inside views are also used, but not very often.

## Terms & definitions
- **Multiverse** - Even if I don't like the idea of a multiverse, I found no other way to realize a generic model, that is able to overcome mathematical constraints (like available number space). Thus a universe reaching the mathematical limits of a (whatsoever) used system, will try to "*escape*", either to new coordinates, new dimensions or a new universe, to ensure, that within an universe the mathematical constraints are still valid. Of course there is a price to pay, but the price is measured in memory and disk space, not in, e.g. number spaces, that exceed the limits of the used system.
- **Universe** - A universe is an almost independent part of the multiverse, that, depending on the start parameters, may be influenced by another universe or the universe seed. If a base universe is created, a mirror universe with opposite sign is as well created, to keep the energy level equilibrated and equal to 0. The energy of the two universes has to sum up to 0 otherwise the universe pair is considered crashed. If the energy of the base and mirror universe are equal to zero, the universes are considered dead.
- **Planck** - I am using the term planck in different ways. Inside a given universe, all planck attributes like time, length and speed will equal 1. But outside, an universe can be created, that has an initialization value of, e.g. 1.3 for planck length, used by the universe. This has consequences inside a universe, as speed and time, internally 1, will have a different meaning and behavior as in an universe, where outside and inside planck attributes are equal.
- **Units** - From a universe perspective, our units, like seconds, make no sense. Every unit is measured in units based on the outside planck definition. Thus we have generalized units like planck units without the need, to transform them to units, that make sense for us, in our universe. We have a generalized time, speed and length unit without any transforms needed.
- **Dimension** - The dimension term I use is based on the n-sphere model, but only more or less equal. Dimensions are used to define the volume structure and the borders for this structure.
- **Seed** - A seed is the base of the multiverse, existing in dimension n = 0. It's a highlander situation: There can only be one (seed for a running simulation)!
- **Structure or volume structure** - A volume structure consists of nodes, defining the border of this volume. Depending on the dimension n, the volume structure is a line (n=1), a square (n=2), a quadratic cube (n=3) or a geometric object of a higher dimension, that we are currently not able to display properly.
- **Energy** - Energy in context of volume structures can be seen as a (somehow) potential energy/mass, not equal to energy in our known universe. It is used as a driver to make things happen in the multiverse, but not to represent particles, quarks or other things we know from our universe. The activities of this energy may cause the birth of particles and electromagnetic waves inside a universe, but basically they only flood the multiverse with potential energy, that may lead to unpredictable effects.
- **Node** - A node is a virtual entity, that can accumulate energy and has a position that is, may be, represented in different dimensions. The seed itself is a node, with coordinate 0 in every dimension n >= 0. A node is unique over all universes in the multiverse. And a node has no size, it is, so to say, a "*pointless*" point defining the borders of a space volume structure in all dimensions currently active. Moreover a node has one parent-child relation for every dimension setting (parent node dimension - child node dimension). Depending on the context a node has one and only one child or a lot of childs over all active dimensions. It is the equation of the sailor stereotype, in this harbor I have only one wife, unluckily there are so many harbors. A node is also static (exists as long as the related universe exists) and can't move (as soon as it has a coordinate assigned). It is not behaving like a particle or something similar. It is an input and output point for energy that operates on the whole volume described by nodes.
- **Node distance** - Every child node is just one (internal) planck length away. You may imagine this like constructing a quadratic cube (n = 3), where every side has the same length, in every dimension (I assume that this behavior is not changing in dimensions n > 3).
- **Waves and gravity** - I'm laying out the foundation for waves and gravity, without applying them in the way, we use them inside our universe. I flood the nodes and their childs with energy, that uses the gravity formula from Newton in a different way. First the gravity effect is calculated for the next child and added to its energy, which will be the output to the child of the child until the current dimensional barrier is reached and the last node has no child anymore. Thus I'm creating a wave-like behavior. When this enery wave breaks at the frontier, it returns to the parents, using again the gravity formula in the opposite way. I don't calculate both sides of the force, only the side of the direction the wave has. The sender is never impacted by the force it sends. This creates (a desired) feedback behavior and ensures that the universes inherit basically wave and gravity rules.
## Building a universe
This is a very hard point, technically and philosophically. Dimension n = 0 is the unthinkable, the point where our imagination gets to its limits. Anything I do there is pure assumption.

First I assume that I can put a something into nothing. If I do that, I inherit a **binary concept**. A something, let's call it one, put into nothing, let's call it zero. At this point and in this dimension, I can't think something greater one, but I can think zero and one or plus and minus. I even can think one attribute, with the characteristic of plus and minus in any dimension n > 0.

Next risky assumption is, if I have that something in the nothing, I'm able to give it one impulse and a base to work on (dimension n = 1) with basic nodes 0,1 and -0,-1. Things I know in dimension n = 0 so far by binary concept. Moreover, plus and minus exist in dimension n = 0 only virtually, I can output simultaneously +1 and -1 as the only one impulse possible to the child nodes.

To make it a little bit more complicated, I also can define the rules, how this should be handled. Not on an exception base. Preferably with generic rules that are the valid in any situation apart from seed in dimension n = 0.

And of course I have limitations. The available number space is a side effect related to our current possiblities, but in any case, I have to ensure, in whatever dimension or universe I am, the sum of the energy, I put into dimension n > 0 has to be zero. Otherwise I would build something, that is, assumed, impossible, as it changes the environment, the something in the nothing it is in.

### Overflow algorithms
To overcome limitations in the number space (we can't calculate with infinity), I implement an overflow behavior, that gets active, whenever a overflow would occure (coordinates, calculations). The generic overflow behavior is, that the energy, that would have caused an overflow, is used to create new coordinates in the available dimensions, escape to other dimensions or even build a new universe if all limits are reached.

We have different situations. The seed energy has an overflow, a node between dimensions has an overflow, a node at the dimension frontier has an overflow and the whole universe has an overflow (no more coordinates, dimensions, energy values possible).

And we are still within the limitations of dimension n = 0. Means we may add +1/-1 and that's it. Other concepts are not available within dimension n = 0.
#### Overflow rules
- **Generic overflow behavior**
  - Add the negative amount of energy, that would have caused an overflow, to the node energy of the impacted node.
  - Add the positive amount of overflow energy to the new created node.
  - The seed node is very special due to dimension n = 0 and has access to anything in the universe, whereas all other nodes have only access to attributes in reach. Thus a node with childs in a higher dimension, can't create a new dimension, as it already exists for this node.
  - If the parent node of a new universe is in dimension n > 0, it can't output any energy anymore to the universe it is located in. It can receive energy from the parent universe, but it will never distribute energy to this parent universe, as it is now part of a new universe located in an old universe. *Anybody mentioned black holes^^?*
- **Node overflow**
  - Seed overflow
    - Energy overflow, but new coordinates are available in number space
      - Build a new coordinate adding +1/-1 to the absolute maximum of current coordinates.
      - Create a new node with the new coordinate.
    - Energy overflow, but new dimensions are available, no coordinates left in number space
      - Build a new dimension by adding +1 to current maximum dimension
      - Create a new node in the new dimension with the current node coordinate (0)
    - Number space exhausted (coordinates, dimensions, energy)
      - Build a new universe
  - Node (between dimensions, not seed) overflow
    - Build a new universe
      - Only option on any type of overflow for nodes in between, as coordinates have to be build by the seed to be consistent in all dimensions and new dimensions are not reachable as the node is not on the dimension frontier
  - Node (dimension frontier, no child) overflow
    - Energy overflow, but new dimensions are available in number space
      - Build a new dimension by adding +1 to current node dimension
      - Create a new node in the new dimension with the current node coordinate
    - Number space exhausted
      - Build a new universe
  - Node (upper dimension available, but no child yet)
    - Energy overflow, but empty upper dimension available
      - Create a new node in the upper dimension with the current node coordinate
    - Number space exhausted
      - Build a new universe

## What about the foam, he saw it all?
A reminiscence to the rock opera Tommy from Who: What about the boy, he saw it all? You didn't hear it, you didn't see it ...

Now we are in the vast field of speculations and hopes. The hope is to find behaviors that seem similar to things we can observe. The speculation and far, far away thing is (*the meta model for this reactions is not yet developed, not even from the technical concept*), that the whirlpool of wave behavior within a space volume structure creates new effects, not foreseen.

If I reduce the whirlpool to a quadratic cube, there are a lot of waves influencing each other, if I calculate this. Let's start an example with coordinates 0 and 1.
- In dimension n = 1 I have a wave running from 0 to 1 and back.
- In dimension n = 2 I have a wave front, running from 0,0 to 0,1 and 1,0 to 1,1 (and back) where the parent nodes 0,1 and 1,0 have, most likely, different energy levels. We get a swirl around the middle of the square, if we would calculate it.
- In dimension n = 3 I have a wave front, running from 0,0,0 / 0,1,0 / 1,0,0 / 1,1,0 to 0,0,1 / 0,1,1 / 1,0,1 / 1,1,1 (and back) where every node, most likely, has a different energy level and we are still not considering the effects of n < 3.

Chaos is just one step away and I'm still not at the point of interaction between different space volumes.

This is, what I call **foam**. Swirls in swirls of swirls, apart from the wave movement and structure itself. Currently I have no clue how to realize this with the current technical system restrictions we have (including the impossibility to visualize anything above n = 3 in a correct way). Thus I implement a playback log for the multiverse, which can be used as input for the foam chaos calculation at a later point in time, which may create a playback log for the visualization of dimension n < 4.

But even if this can be visualized, we will see it from outside, not from inside. A blind god so to say. You may choose a point inside and calculate everything including relativity from this point to get an idea of the inside. But you won't be able to see everything from inside within a time frame that is limited to human life with current tools and systems.
