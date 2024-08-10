# MOVING TO PostGres
First of all PostGres is Open Source, moreover it is not limited and available for any one that has processor and disc space.
It has no nice APEX that does what it wants, not what the developer wants. So more possiblities to setup a database and application without not needed overhead.

# PostGres tools
**psql** works as expected. My main tool.

**pgTap** seems very ok and very helpful. Works as expected until now.

*pgAdmin4* only in special cases useful. Too unstable, too much logins to get really the objects in the database, out of the sudden loosing all objects known, ERD is a pain, no useful formatting options for complicated designs, if version changes, old files are not accessible or writable any more.

Nice to just look up, if it works, the objects and source code of an schema object.

If you have a version that works, **don't** upgrade. From 8.7 to 8.10 I noticed more and more additional bugs, making everything worse, not better. 8.10 is definitely unusable. Before somehow, but not really usable.

# Current state
**Under Construction - heavy redesign currently**

Make things work with PostGres. Started first tables and functions, as well as testing with pgTap. Currently designing id creation for getting long living ids without getting into a overflow situation and managed sequences for primary keys.
# Intention
This is an attempt to create a (whatsoever) multiverse that creates its own space volume and try to discover patterns we know from our universe, we are living in (like a big bang burst with a following dark period until something starts to happen).
## Expectations
- The total energy sums up to zero in dimension zero at position zero with sign zero and does not change after emitting a energy value of 1 to the first dimension.
- The system should keep running as long as ressources are provided/available, even if single universes die and get full entropy (every node equilibrated to zero, nothing happens anymore).
- Even without a meta-model of energies reacting with all other energies, there should be at least one universe, where energy levels concentrate and raise to a point, where a big bang is possible. Spikes in time and space.
  - With active meta-model for all energies react with all other energies, there should be at least one universe comparable to our universe.
- Without a meta-model of energies reacting the amount of black holes/new universes should be less then currently observed in our universe.
- With a meta-model of energies reacting the amount of black holes/new universes should at least in one universe correspond to currently observed objects in our universe. Correspond means in measures of distribution as we can't observe everything, only closer distances better.
- The wavelength of the space itself is getting lower as available space gets bigger (reciprocally proportional).
  - This does not include wavelengths generated from energy events within the created space. They only have an implicite relation.
  - If there is a relation to our current universe, on a long time scale with expectation that the universe inflates, the background wavelength should change.
    - As we currently measure only the current background wavelength of an energy event (big bang), the implicite impact may be significant lower.
- During expansion the universes should behave like open and flat universes (you can't see your back if looking too far).

**Attention** I'm using terms that have an exact and sharp definition in our universe, just because I'm to lazy to create new terms. So thinking about the terms and definitions has to include, that we observe a universe/multiverse from outside, not only from inside. And inside views are also used, but not very often.

## Terms & definitions
- **Multiverse** - Even if I don't like the idea of a multiverse, I found no other way to realize a generic model, that is able to overcome mathematical constraints (like available number space). Thus a universe reaching the mathematical limits of a (whatsoever) used system, will try to "*escape*", either to new coordinates, new dimensions or a new universe, to ensure, that within an universe the mathematical constraints are still valid. Of course there is a price to pay, but the price is measured in memory and disk space, not in, e.g. number spaces, that exceed the limits of the used system.
- **Universe** - A universe is an almost independent part of the multiverse, that, depending on the start parameters, may be influenced by another universe or the universe seed. If a universe is created, all dimension axis will have a +/- potential and act as "mirrors". The energy of all dimension axis has to sum up to 0 otherwise the universe is considered crashed. If the energy of a universe is equal to zero, the universe is considered dead. Every universe is in the end a closed universe whenever it reaches the limits of expansion (number limits). Nevertheless it may appear as an open and flat universe during expansion or by energy consumed from contained and related other universes.
- **Planck** - I am using the term planck in different ways. Inside a given universe, all planck attributes like time, length and speed will equal 1. But outside, an universe can be created, that has an initialization value of, e.g. 1.3 for planck length, used by the universe. This has consequences inside a universe, as speed and time, internally 1, will have a different meaning and behavior as in an universe, where outside and inside planck attributes are equal.
- **Units** - From a universe perspective, our units, like seconds, make no sense. Every unit is measured in units based on the outside planck definition. Thus we have generalized units like planck units without the need, to transform them to units, that make sense for us, in our universe. We have a generalized time, speed and length unit without any transforms needed. Until we want to transfer it to our definitions.
- **Dimension** - The dimension term I use is based on the n-sphere model, but only more or less equal. Dimensions are used to define the volume structure and the borders for this structure. Dimensions depend on possible number signs. Dimension 0 with sign 0 has therefore only one dimension axis, whereas dimensions > 0 always have two (+/-) dimension axis. Moreover every dimension axis is associated to its base dimension axis and has its own 0 coordinate, which is parented by the 0 coordinate of the parent dimension axis. This enables the construction of space areas without interferences that accumulate positive and negative energy on the 0 coordinates of dim axis 1 which should sum up to zero in dimension n = 0, coordinate 0.
- **Seed** - A seed is the base of the multiverse, existing only in dimension n = 0. It's a highlander situation: There can only be one (seed for a running simulation)! The seed has no parent. All other objects, including universes have a parent.
- **Structure or volume structure** - A volume structure is a meta structure and consists of nodes, defining the border of this volume. Depending on the dimension n, the volume structure is a line (n=1), a square (n=2), a quadratic cube (n=3) or a geometric object of a higher dimension, that we are currently not able to display properly. Volume structures are only helpers for visualization including a displayable structure in our universe. In the end a complete volume structure (all dimensions) defines a single point in the universe with internal planck length 1 for every border in every dimension. The point itself is the frontier of resolution.
- **Energy** - Energy in context of volume structures can be seen as a (somehow) potential energy/mass, not equal to energy in our known universe. It is used as a driver to make things happen in the multiverse, but not to represent particles, quarks or other things we know from our universe. The activities of this energy may cause the birth of particles and electromagnetic waves inside a universe, but basically they only flood the multiverse with potential energy, that may lead to unpredictable effects, creating space, nothing more. A meta-model, to develop, is necessary to calculate all space energy events with all other energy events. On space creation, energy is just an attribute, that flows through the available space nodes and returns predictable (space should be stable) results. Energy on space nodes is potential until used in a meta model. It describes only the space topology itself, not the possibly created energy objects in this created space.
- **Node** - A node is a virtual entity, that can accumulate energy and has a position that is, may be, represented in different dimensions. The seed itself is a node, with coordinate 0 in every dimension n >= 0. A node is unique over all universes in the multiverse. And a node has no size, it is, so to say, a "*pointless*" point defining a part of the space volume structure borders in all dimensions currently active. Moreover a node has parent-child relations for every dimension setting (parent node dimension - child node dimension). Depending on the context a node has one and only one parent or a lot of childs or parents over all active dimensions. The parent-child relation is m:n. A node is also static (exists as long as the related universe exists) and can't move (as soon as it has a coordinate assigned). It is not behaving like a particle or something similar. It is an input and output point for energy that operates on the connected nodes to form space itself.
- **Node distance** - Every child node is just one (internal) planck length away. You may imagine this like constructing a quadratic cube (n = 3), where every side has the same length, in every dimension (I assume that this behavior is not changing in dimensions n > 3).
- **Volume** Meta structure for a space volume with borders of length planck 1 in every dimension, e.g. a cube in dimension 3. This structure defines nothing more than a single point in the associated dimension space and time in the smallest possible unit.
- **Waves and gravity** - I'm laying out the foundation for waves and gravity, without applying them in the way, we use them inside our universe. I flood the nodes and their childs with energy, that uses the gravity formula from Newton in a different way. First the gravity effect is calculated for the next child and added to its energy, which will be the output to the child of the child until the current dimensional barrier is reached and the last node has no child anymore. Thus I'm creating a wave-like behavior. When this enery wave breaks at the frontier, it returns to the parents, using again the gravity formula in the opposite way. I don't calculate both sides of the force in one attempt, only the side of the direction the wave has. The sender is never directly impacted by the force it sends. This creates (a desired) feedback behavior and ensures that the universes inherit basically wave and gravity rules.
## Building a universe
This is a very hard point, technically and philosophically. Dimension n = 0 is the unthinkable, the point where our imagination gets to its limits. Anything I do there is pure assumption.

First I assume that I can put a something into nothing. If I do that, I inherit a **binary concept**. A something, let's call it one, put into nothing, let's call it zero. At this point and in this dimension, I can't think something greater one, but I can think zero and one or plus and minus. I even can think one attribute, with the characteristic of plus and minus in any dimension n > 0.

Next risky assumption is, if I have that something in the nothing, I'm able to give it one impulse and a base to work on (dimension n = 1) with basic nodes 0,1 and -0,-1. Things I know in dimension n = 0 so far by binary concept. Moreover, plus and minus exist in dimension n = 0 only virtually, I can output simultaneously +1 and -1 as the only one impulse possible to the child nodes.

To make it a little bit more complicated, I also can define the rules, how this should be handled. Not on an exception base. Preferably with generic rules that are valid in any situation including the seed in dimension n = 0.

And of course I have limitations. The available number space is a side effect related to our current possiblities, but in any case, I have to ensure, in whatever dimension or universe I am, the sum of the energy, I put into dimension n > 0 has to be zero after processing on return. Otherwise I would build something, that is, assumed, impossible, as it changes the environment, the something in the nothing it is in.
### Overflow algorithms - under construction
To overcome limitations in the number space (we can't calculate with infinity), I implement an overflow behavior, that gets active, whenever a overflow would occure (coordinates, calculations). The generic overflow behavior is, that the energy, that would have caused an overflow, is used to create new coordinates in the available dimensions, escape to other dimensions or even build a new universe if all limits are reached related to the node where the overflow has happened.

We have different situations. The seed energy has an overflow, a node between dimensions has an overflow, a node at the dimension frontier has an overflow and the whole universe has an overflow (no more coordinates, dimensions, energy values possible).

And we are maybe still within the limitations of dimension n = 0. Means we may add +1/-1 and that's it. Other concepts are not available within dimension n = 0.

Infinity is the currency for creation of objects like new nodes, new dimensions and new universes. One infinity, one new object.
#### Overflow rules - under construction
- **Generic overflow behavior**
  - Add the negative amount of energy (e * -1), that would have caused an overflow, to the node energy of the impacted node that has an overflow. Means set the node energy to 0.
  - Set energy to 0 as default for the new created node / base node. All overflow energy is consumed by creating a new node, dimension or universe. The input for new universes is retrieved by the next energy input received from parent node.
  - Any zero position dimension axis is able to create new universes, dimensions or nodes. New dimension node childs are limited to position 1 on every dimension axis. As long as space is not filled continously any node can delegate the next node, dimension or universe creation to the zero position of its dimension axis. If the node is a zero position dimension axis it can also delegate to its parent, if a parent exists. Delegate is needed, if the node is not able to expand to a new node in the available dimensions.
  - If the parent node of a new universe is in dimension n > 0, it can't output any energy anymore to the universe it is located in. It can receive energy from the parent universe, but it will never distribute energy to this parent universe, as it is now part of a new universe located in an old universe. Close nodes may still emit energy to the parent universe, but they are only close. *Anybody mentioned black holes^^?*
  - Prefer lower values in dimensions and positions
  - Prefer coordinates closer to the center
  - If no unique next possible coordinate can be identified, prefer symmetry. Create symmetric nodes in all alternative positions.
- **Node overflow**
  - Seed node overflow
    - Should not happen, as the value of the seed node should sum up to zero.
  - Node overflow
    - Has possible child connections free to a node in the available dimensions
      - Create new node and parent it
    - Has no connections free
      - Delegate to zero node of current dimension axis (position 0 on dimension axis), zero node must decide how to handle the situation
  - Zero node overflow (zero node = position 0 on dimension axis)
    - Create dimension or node with lowest possible number as long as universe has no overflow in dimensions and positions
      - Prefer position in current dimensions as long as current available positions have not spread to all available dimensions
      - Prefer position if next dimension n < max coordinate
      - Intention: Fill all existing dimensions with coordinates <= dimension n before creating a new dimension. If the dimension maximum is reached, fill the lower position nodes before the higher ones. For every possible position, fill first all dimensions before going to next possible position, e.g. n=3 pos=3 fill all possible coordinates between 0 and 3 (0,0,0 up to +/-3,+/-3,+/-3) for all available dimensions before creating pos=+/-4 which will enable the possible creation of dim n=4.
    - Create new universe related to zero node, if current universe has overflow in dimensions and positions
  - Zero node delegate
    - Same as zero node overflow, but universes get connected to the node, that has caused the overflow event.
## What about the foam, he saw it all?
A reminiscence to the rock opera Tommy from Who: What about the boy, he saw it all? You didn't hear it, you didn't see it ...

Now we are in the vast field of speculations and hopes. The hope is to find behaviors that seem similar to things we can observe. The speculation and far, far away thing is (*the meta model for this reactions is not yet developed, not even from the technical concept*), that the whirlpool of wave behavior within a space volume structure creates new effects, not foreseen.

Depending on the return rule (any border, ultimate border), the parent-child design leads to chaotic ripples or a single wave front (a sphere in dimension 3) expanding and collapsing to the source point.

Chaos is just one step away and I'm still not at the point of interaction between different space volumes, treating energy as energy/mass/velocity and apply the rules of our universe to them.

This is, what I call **foam**. Swirls in swirls of swirls, apart from the wave movement and structure itself. Currently I have no clue how to realize this with the current technical system restrictions we have (including the impossibility to visualize anything above n = 3 in a correct way). Thus I implement a playback log for the multiverse, which can be used as input for the foam chaos calculation at a later point in time, which may create a playback log for the visualization of dimension n < 4.

But even if this can be visualized, we will see it from outside, not from inside. A blind god so to say. You may choose a point inside and calculate everything including relativity from this point to get an idea of the inside. But you won't be able to see everything from inside within a time frame that is limited to human life with current tools and systems.

# Technical
Removed DOC folder, to get a correct representation of the code base. Anyone may create the documentation with tools like SQL Developer. As long as this project is marked under construction, use cleanup before a pull, to remove existing objects, as model and objects may change at any time.

Sorry for not branching currently. I'm not at this point yet. While designing and creating I noticed that a lot of things didn't work the way I want it to operate. From the point, where I have the feeling it is a more or less stable code base, I will start with branches. So the only way to get to a specific point of the repository is rebasing it to a certain commit. I'm still renaming and restructuring the data model and packages.
## Setup
Development and scripts executed on Oracle XE version 21.0 with SQL Developer version 23.1.0.097. Also tested with Oracle 23ai Free Devlopement OVA as separate Linux server.
All setup scripts are in the folder ../SETUP.
### Database preparation
You will need DBA rights to execute the scripts creating users and tablespaces. Big file tablespaces can be adjusted to a higher size, if using full Oracle version, not XE.
Use **../SETUP/USIM_DBA_SETUP.sql** to create the normal and test user with its tablespaces.
### Test model creation
Execute the setup script **../SETUP/USIM_TEST_SETUP_MANUAL.sql** with user USIM_TEST.

### Application
Execute the setup script **../SETUP/USIM_SETUP_MANUAL.sql** with user USIM.

You may try to import the workspace and application. Currently I have no tests made and application is under development.
<img width="1241" alt="image" src="https://github.com/AlterMannomann/SQL/assets/100498474/a82d00bc-b38a-4db4-8855-89d3eb55c707">


### Adjusting the defaults
You may adjust **USIM_PROCESS.PLACE_START_NODE** to define and create the defaults for base data and seed universe. You may also create base data and seed universe before using the USIM_DBIF.INIT_BASEDATA and USIM_CREATOR.CREATE_NEW_UNIVERSE functions.

### Visualisation
Now included is the very beginning of a small JS visualisation using P5.js. USIM_CREATOR can create JSON logs in the appropriate directory. Old JSON logs are saved in the history directory. The DBA setup now includes the creation of the directories and the necessary rights for the schema owners.
To put it to work, the JS directory has to be made the root of a local web server and the necessary grants for web server and Oracle groups/roles on the operation system.
The included example is too big for good performace. Only dimension axis and axis coordinates are created up to now.

If you collect more than 50 planck ticks, the visualization slows down more and more. The performance issue will not be solved on JS base. The switch buttons are not fully operational. Zero structure display is missing for simulation process. View is not perfect, you'll have to move the axis to see 3rd dimension. Zoom and axis movement is possible and works better with higher frame rates. Mouse wheel will zoom, right mouse button and mouse move will move axis.

## Table packages
- package names
  - Package name is usually USIM_*table alias*, like USIM_DIM.
- function names
  - has_data... - checks in general or for specific ids, if the table has data. Return 0 or 1.
  - ..._exists - checks for specific attributes, if the table has data. Return 0 or 1.
  - get_id_... - retrieves the pk of the table by ids or attributes.
  - insert_... - inserts an record into the table by given parameters and returns the new id.

  ### Package organization
  Packages are divided in three levels. The overall dependencies are used types.
  #### Low level packages
  Those packages have only dependencies to package USIM_STATIC, the associated table and views, if they exist for the package, e.g. USIM_SPC relates to USIM_SPC and USIM_SPC_V. Views can be seen as an additional interfaces that create dependencies.
  #### Interface packages
  Those packages have dependencies to all low level objects and define the access interface on this objects, e.g. USIM_DBIF. Simulation rules and
  constraints are forced by those packages through wrappers for the low level packages. Functions and procedures are designed to identify exceptions and errors. Severe errors lead to crashed multiverse.
  #### High level packages
  Those packages depend on interface packages. The manage complex creation of objects and simulation processing, e.g. USIM_PROCESS, USIM_CREATOR. Actions are depending on state of universes and initialized base data.

  ### Risky attempts.
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

Another reason for saving space, as a side effect, is, to see things as they are. **Unique.** Everyone, everything. Of course we have similarities. But any object (on whatever level you like to see it), is unique. Somehow. Thus, by saving space, I also create the uniqueness we get and expect from our universe. Redundancy would be like beaming. If you reassemble me, you can do it as often as you want. I may most likely get into the problems with the copies of myself, not knowing, which is the original, if there still is any ... apart from the problem where do I get the mass from for the copies?

Long story short, it is an attempt. Nothing more, nothing less. Results will proof it.
## Dimensions
Handling of dimensions is not trivial. Every new dimension updates the coordinate system and available space areas. New dimensions n can only be created from position 0 with dimension n-1. Any attempt to create a dimension axis should consider the fact, that the dimension axis already exists. Dimensions are limited to 99 to be able to create a storeable dimension coordinate index in the form xyz...n.
### Dimension n=0
This is a very special dimension, able to hold only one space node. The space node with mandatory position 0 is only able to connect to space nodes with position +/-1 in any active dimension axis where n > 0. There is only one dimension axis for dimension n=0 and it has the sign 0.
### Dimension n>0
Every dimension has two axis with a different sign (+/-), e.g. +x and -x. Every dimension has its own position 0 on every axis. This is used to decouple positive and negative energy flows. Any position is in sense of space and energy not unique if n > 0.
## Positions
Positions are generic and reusable. Any attempt to create a position should consider the fact, that the position already exists. Positions get unique with all dimensions considered.
## Space nodes
Space nodes define the border of volumes with internal planck length 1 that define the space (a single point) in the universe. Nodes may exist, that may not yet be part of a complete volume (e.g. a cube in 3d) over all dimensions. At least dimension n=1 is guaranteed, a line. With all parallel shifts of dimension n=1.

Correct parenting is crucial to define a space node at the desired position as space nodes can only be identified unique by id, node id, current dimension coordinate index (this index may change over time) or unique parents. For sake of easy identification space nodes that are on a dimension axis are not parented by 0 coordinates of other dimension axis. Space nodes between dimension axis are parented by every other active dimension axis and the axis coordinate.

Every coordinate > 0 on a dimensions axis can have n childs (one per dimension) with same attributes including coordinate. The only difference is the position parents they have. Thus identification by child or parent relation is easy, identification of some node somewhere without any relation is difficult.

If a space node is extended, only one node is created. But it has to be parented by all other existing dimensions to get a correct dimension coordinate index.
## Dimension axis position node relation
Apart from relating a space node with universe, dimension axis, relative position and the node containing the energy, those space nodes have another more complicated relation to resolve the absolute coordinates. As only parent-child relations are maintained, not absolute coordinates, we do not move simply on x, then y, then z. We move with steps on one of the dimensions, sometimes in direction of the higher dimension axis, sometimes in the direction of one of the lower or current dimension axis. And we could be miles away, in terms of parents, from the node directly on the related dimension axis, e.g. x=3, y=5000.

The current space node should be able to figure out easily, which positions in lower dimensions are related to be able to deliver at least 3d coordinates for visualization.

Every child must inherit the position from the base node at its base dimension axis. If nodes meet (child gets an additional parent), the new (higher) dimension axis has to be added to the coordinate relation. Lower dimensions, once set, stay stable, whereas higher dimensions can always be positive or negative until they are set.
## Processing nodes
Space nodes are processed one by one. The possible reactions of a space node are limited to the reaction with childs or, on overflow, causing the creation of dimensions or childs. They must not be synchronized with any nodes in "mirror" areas. The mirror effect is expected to appear by itself.
## Processing volumes
The meta-structure of volumes is only important for displaying the space creation. With complete volumes for at least three dimensions it gets a 3d tetris like form, not considering lower dimension volumes, which are space volume cubes with planck length 1. Volumes get important to define the action-reaction between volume energy in the meta-model of the space creation effects. Volumes translated to our universe define a single point, e.g. x=3 and y=200. In volume and node terminology for creating space they would be just nodes of a volume with x, x+/-1, y, y+/-1 that defines the space of such a point.
## Parents and childs
Parents and childs have a m:n relationsship, limited by dimension x. m <= n <= x. x >= 0, integer. p0 is defined as the amount of 0 positions in the complete coordinates with all dimensions.

Nodes per volume for a dimension x: 2<sup>x</sup>

Parent range: {0, x} and {1, x} for x > 0

Child range: {0, 2x}

Childs for special positions 0: always 2, both dimension axis

Childs for position > 0: 2x - (x - p0). Formula would be true for position 0 if unique.

**Currently not implemented correctly.** I have to step back and rework the concept. See *VolumeParentChildConnections.mp4* where I tried to visualize what is happening in the system building up a space by parent-child connections. Volumes stay a meta concepts and may not be complete at a given point in time. Using parent-child instead of dimension index like x,y,z (we should be able to deal with any amount of dimensions) causes too much overhead on constructing a complete volume. It is enough to construct new nodes that spread in every dimension on overflow, where they may find already a child from another parent to connect. Moreover I have to take in account, that the coordinate system changes with every dimension opening more spaces, so a mirror concept makes only sense in dimension 1. It is a 2<sup>n</sup> function describing the meta volume nodes, where n = dimension. Possible axis nodes are defined by 2n. But I use a zero representation in every dimension to ensure that every dimension has the same number space. Moreover there is a zero node for every axis of every dimension. In sense of geometry they have all the same position, whereas every node with a position != 0 is unique. In sense of space and energy they decouple the positive and negative energy flow of space creation, leading to a zero energy result in the node in dimension 0 as long as the universe is equilibrated. This is only valid for space creation. Energies on a meta level may react all with each other independend of their space dimension position.

https://github.com/AlterMannomann/SQL/assets/100498474/8c27127c-f247-4222-bff0-1a001fcc047e


Interesting point at dimension n = 2 was the attempt to visualize two variations of the return rule. If the return rule would be to return as soon as a node reaches a border even with partners left to react, a highly chaotic system will send return waves (one wave moves out, many waves return to the source at different times where the source may already emit new energy). With the rule to return if no child can have a partner to react, it is a stable wave structure without chaotic behavior (one wave moves out, one wave returns to the source at the same time). Currently I prefer the stable version, but would be probably worth, to be able to switch return rules.

Example of processing volumes with 3 dimensions.

https://github.com/AlterMannomann/SQL/assets/100498474/673b2543-533d-405e-96ca-dff05c55b547

Example of creating a volume in 3 dimensions.

https://github.com/AlterMannomann/SQL/assets/100498474/b26b8d3d-aedc-4335-9387-b88e7a98a245

P5 JSON Visualization

![P5Visualize](https://github.com/AlterMannomann/SQL/assets/100498474/88bc6c2c-3373-4993-9106-91eb720838cd)


https://github.com/AlterMannomann/SQL/assets/100498474/b357ff94-e69d-4224-880d-b7a7ec069fba



