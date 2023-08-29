**Under Construction - heavy redesign currently**
Feel free to use, extend and modify this. Free as free beer. No restrictions. You may also use it simply to learn something about SQL and how to make it better than I do.
# Intention
This is an attempt to create a (whatsoever) multiverse that creates its own space volume and try to discover patterns we know from our universe, we are living in (like a big bang burst with a following dark period until something starts to happen).

**Attention** I'm using terms that have an exact and sharp definition in our universe, just because I'm to lazy to create new terms. So thinking about the terms and definitions has to include, that we observe a universe/multiverse from outside, not only from inside. And inside views are also used, but not very often.

## Terms & definitions
- **Multiverse** - Even if I don't like the idea of a multiverse, I found no other way to realize a generic model, that is able to overcome mathematical constraints (like available number space). Thus a universe reaching the mathematical limits of a (whatsoever) used system, will try to "*escape*", either to new coordinates, new dimensions or a new universe, to ensure, that within an universe the mathematical constraints are still valid. Of course there is a price to pay, but the price is measured in memory and disk space, not in, e.g. number spaces, that exceed the limits of the used system.
- **Universe** - A universe is an almost independent part of the multiverse, that, depending on the start parameters, may be influenced by another universe or the universe seed. If a base universe is created, a mirror universe with opposite sign is as well created, to keep the energy level equilibrated and equal to 0. The energy of the two universes has to sum up to 0 otherwise the universe pair is considered crashed. If the energy of the base and mirror universe are equal to zero, the universes are considered dead. Every universe is in the end a closed universe whenever it reaches the limits of expansion. Nevertheless it may appear as an open and flat universe during expansion or by energy consumed from contained and related other universes.
- **Planck** - I am using the term planck in different ways. Inside a given universe, all planck attributes like time, length and speed will equal 1. But outside, an universe can be created, that has an initialization value of, e.g. 1.3 for planck length, used by the universe. This has consequences inside a universe, as speed and time, internally 1, will have a different meaning and behavior as in an universe, where outside and inside planck attributes are equal.
- **Units** - From a universe perspective, our units, like seconds, make no sense. Every unit is measured in units based on the outside planck definition. Thus we have generalized units like planck units without the need, to transform them to units, that make sense for us, in our universe. We have a generalized time, speed and length unit without any transforms needed.
- **Dimension** - The dimension term I use is based on the n-sphere model, but only more or less equal. Dimensions are used to define the volume structure and the borders for this structure.
- **Seed** - A seed is the base of the multiverse, existing in dimension n = 0. It's a highlander situation: There can only be one (seed for a running simulation)!
- **Structure or volume structure** - A volume structure is a meta structure and consists of nodes, defining the border of this volume. Depending on the dimension n, the volume structure is a line (n=1), a square (n=2), a quadratic cube (n=3) or a geometric object of a higher dimension, that we are currently not able to display properly.
- **Energy** - Energy in context of volume structures can be seen as a (somehow) potential energy/mass, not equal to energy in our known universe. It is used as a driver to make things happen in the multiverse, but not to represent particles, quarks or other things we know from our universe. The activities of this energy may cause the birth of particles and electromagnetic waves inside a universe, but basically they only flood the multiverse with potential energy, that may lead to unpredictable effects.
- **Node** - A node is a virtual entity, that can accumulate energy and has a position that is, may be, represented in different dimensions. The seed itself is a node, with coordinate 0 in every dimension n >= 0. A node is unique over all universes in the multiverse. And a node has no size, it is, so to say, a "*pointless*" point defining the borders of a space volume structure in all dimensions currently active. Moreover a node has one parent-child relation for every dimension setting (parent node dimension - child node dimension). Depending on the context a node has one and only one child or a lot of childs over all active dimensions. It is the equation of the sailor stereotype, in this harbor I have only one wife, unluckily there are so many harbors. A node is also static (exists as long as the related universe exists) and can't move (as soon as it has a coordinate assigned). It is not behaving like a particle or something similar. It is an input and output point for energy that operates on the whole volume described by nodes.
- **Node distance** - Every child node is just one (internal) planck length away. You may imagine this like constructing a quadratic cube (n = 3), where every side has the same length, in every dimension (I assume that this behavior is not changing in dimensions n > 3).
- **Volume** Meta structure for a space volume with borders of length planck 1 in every dimension, e.g. a cube in dimension 3. This structure defines nothing more than a single point in space and time in the smallest possible unit.
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
      - Build a new coordinate adding +1/-1 to the absolute maximum of current coordinates
      - Create a new node with the new coordinate in the next dimension (n = 1)
    - Energy overflow, but new dimensions are available, no coordinates left in number space
      - Build a new dimension by adding +1 to current maximum dimension
      - Create a new node in the new dimension with the current node coordinate (0)
    - Number space exhausted (coordinates, dimensions, energy)
      - Build a new universe
  - Node (between dimensions, not seed, has child in next dimension) overflow
    - Build a new universe
      - Only option on any type of overflow for nodes in between, because new coordinates and new dimensions are not reachable as the node is not on the dimension frontier and has already a child in the next dimension
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
- In dimension n = 2 I have a wave front, running from 0,0 to 0,1 and 1,0 to 1,1 (and back) where the parent nodes 0,1 and 1,0 have, most likely, different energy levels. We probably get a swirl (or many) around the middle of the square, if we would calculate it.
- In dimension n = 3 I have a wave front, running from 0,0,0 / 0,1,0 / 1,0,0 / 1,1,0 to 0,0,1 / 0,1,1 / 1,0,1 / 1,1,1 (and back) where every node, most likely, has a different energy level and we are still not considering the effects of n < 3.

Chaos is just one step away and I'm still not at the point of interaction between different space volumes.

This is, what I call **foam**. Swirls in swirls of swirls, apart from the wave movement and structure itself. Currently I have no clue how to realize this with the current technical system restrictions we have (including the impossibility to visualize anything above n = 3 in a correct way). Thus I implement a playback log for the multiverse, which can be used as input for the foam chaos calculation at a later point in time, which may create a playback log for the visualization of dimension n < 4.

But even if this can be visualized, we will see it from outside, not from inside. A blind god so to say. You may choose a point inside and calculate everything including relativity from this point to get an idea of the inside. But you won't be able to see everything from inside within a time frame that is limited to human life with current tools and systems.

# Technical
Removed DOC folder, to get a correct representation of the code base. Anyone may create the documentation with tools like SQL Developer. As long as this project is marked under construction, use cleanup before a pull, to remove existing objects, as model and objects may change at any time.

Sorry for not branching currently. I'm not at this point yet. While designing and creating I noticed that a lot of things didn't work the way I want it to operate. From the point, where I have the feeling it is a more or less stable code base, I will start with branches. So the only way to get to a specific point of the repository is rebasing it to a certain commit. I'm still renaming and restructuring the data model and packages.
## Setup
Development and scripts executed on Oracle XE version 21.0 with SQL Developer version 23.1.0.097.
All setup scripts are in the folder ../SETUP.
### Database preparation
You will need DBA rights to execute the scripts creating users and tablespaces. Big file tablespaces can be adjusted to a higher size, if using full Oracle version, not XE.
Use **../SETUP/USIM_DBA_SETUP.sql** to create the normal and test user with its tablespaces.
### Test model creation
Execute the setup script **../SETUP/USIM_TEST_SETUP.sql** with user USIM_TEST.

### Application
Execute the setup script **../SETUP/USIM_SETUP.sql** with user USIM.

## Table packages
- package names
  - Package name is usually USIM_*table alias*, like USIM_DIM.
- function names
  - has_data... - checks in general or for specific ids, if the table has data. Return 0 or 1.
  - ..._exists - checks for specific attributes, if the table has data. Return 0 or 1.
  - get_id_... - retrieves the pk of the table by ids or attributes.
  - insert_... - inserts an record into the table by given parameters and returns the new id.

  ### Risky attempts
  In the packages I reduce sometimes complexity, in form of a very hard "normalization" to 1 or 0, even if a count delivers more than one record. This implies loss of information. Of course. But it also implies rules, valid for this system. In other situations I rely on constraints and triggers, not expecting a result > 1, which still may happen. But isn't handled. Most likely, this will crash at a certain point in time the application.

  Intention: Feed Schrödingers cat and Heisenbergs uncertainty principle.


## Exceptions
Exceptions are used very limited. Mostly tables will raise exceptions on insert, if requirements like base data exist are not fulfilled. Packages will avoid to raise application errors, instead they may return default values or NULL as an indicator that the desired operation is not available. Oracle errors simply show application errors not covered by tests and design.

Defined errors
- -20000 Insert requirement not fulfilled.
- -20001 Update requirement not fulfilled.

## NF problematic
You probably (I myself do this) may ask you, why I go at least 3NF, more likely 4NF/5NF. A f...ing overhead in joining the things together. But also f...ing true, if you get to mass data, really mass data, like a universe or a multiverse, this it is, so far known, the best way to reduce redundancy and thus save disk space, in the end. Remember? I try to make a compromise about number space, possible planck time and calculations for the price of memory and disk space.

And of course, I try, in the end, to save disk space on cost of processors. There is no perfect way, costs remain costs, in whatever currency. But with Moore's law I bet on processors more than on disk space. Currently. They go hand in hand, obvîously.

Another reason for saving space, as a side effect, is, to see things as they are. **Unique.** Everyone, everything. Of course we have similarities. But any object (on whatever level you like to see it), is unique. Somehow. Thus, by saving space, I also create the uniqueness we get and expect from out universe. Redundancy would be like beaming. If you reassemble me, you can do it as often as you want. I may most likely get into the problems with the copies of myself, not knowing, which is the original, if there still is any ... apart from the problem where do I get the mass from for the copies?

Long story short, it is an attempt. Nothing more, nothing less. Results will proof it.
## Processing volumes

**Currently not implemented correctly.** I have to step back and rework the concept. See *VolumeParentChildConnections.mp4* where I tried to visualize what is happening in the system building up a space by parent-child connections. Volumes stay a meta concepts and may not be complete at a given point in time. Using parent-child instead of dimension index like x,y,z (we should be able to deal with any amount of dimensions) causes too much overhead on constructing a complete volume. It is enough to construct new nodes that spread in every dimension on overflow, where they may find already a child from another parent to connect. Moreover I have to take in account, that the coordinate system changes with every dimension opening more spaces, so a mirror concept makes only sense in dimension 1. It is a 2<sup>n</sup> function describing the possible +/- axis combinations, where n = dimension.

https://github.com/AlterMannomann/SQL/assets/100498474/8c27127c-f247-4222-bff0-1a001fcc047e


Interesting point at dimension n = 2 was the attempt to visualize two variations of the return rule. If the return rule would be to return as soon as a node reaches a border even with partners left to react, a highly chaotic system will send return waves (one wave moves out, many waves return to the source at different times where the source may already emit new energy). With the rule to return if no child can have a partner to react, it is a stable wave structure without chaotic behavior (one wave moves out, one wave returns to the source at the same time). Currently I prefer the stable version, but would be probably worth, to be able to switch return rules.

Example of processing volumes with 3 dimensions.
https://github.com/AlterMannomann/SQL/assets/100498474/673b2543-533d-405e-96ca-dff05c55b547
Exmple of creating a volume in 3 dimensions.
https://github.com/AlterMannomann/SQL/assets/100498474/b26b8d3d-aedc-4335-9387-b88e7a98a245


