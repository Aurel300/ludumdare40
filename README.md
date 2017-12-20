# LD40: Ignorance is Bliss #

This is the repo for my game for [LD40](https://ldjam.com/). It is (will be) written in [Haxe](https://haxe.org/) using my [plustd](https://github.com/Aurel300/plustd) game library.

### Theme: The more you have, the worse it is ###

### Synopsis ###

You take control of an AI which oversees the operation of a city via console. You are investigating a possible rebellion. You can interrogate people by navigating a city map, looking at buildings, and then videophoning. Every conversation is recorded on tape and transcript. (Twist: the more human interaction you have, the worse your experience is, because you are becoming sentient and rampant.) You can revise video recordings from public cameras. The (apparent) end goal is to identify the source of the rebellion.

### Controls ###

Can be played with mouse only. The city can also be navigated using WASD and QE to orbit.

The in-game tutorial mentions that you can send tapes to people. When you have this option (after you call someone using the phonebook), the option is printed on the screen - it says `<TAPES ACCEPTED>`. When you see this, you can press the `TAPE` button, select a tape using the previous / next buttons, preview it using the play button, and send it using the check button.

### License ###

The code and assets provided for the game are a property of the authors,
Aurel Bílý and eidovolta, and are of educational value only.

You are free to distribute, modify, and use the source code non-comercially as
long as this readme file and this license statement is packaged alongside with
it.

You may not use or redistribute the assets (graphical or audio) in any way
except when building the game from its source as provided (without any
modifications).

### Building ###

To build the game from source, you will need the [haxe compiler](http://haxe.org/). The `plustd` library is also needed, the commit used for development is included as a submodule in this repository (make sure you clone recursively or init submodules).

In the `src` directory, run the following command to build the game:

    haxe make.hxml

Set to output to `src/game.swf` by default.

# Story detail #

### Timeline ###

| Event | Time | Location | Conditions | Consequences |
| --- | --- | --- | --- | --- |
| `Intro` | | | | |
| INF tip | (pre) | (call from RB) | - | - |
| AICO operational | 0 | TH | - | - |
| `Any time` | | | | |
| INF contact | * | (call to RB) | INF alive | INF contacted |
| INF is killed | INF contact + 1 | RB | INF alive, R* alive, INF contacted | (guilt) |
| `Decoys` | | | | |
| Money meeting 0 | 2 | 
| Money meeting set up 1-4 | 2, 1, 2, 3 | (call from D1P, D3P, D5P, D7P) | D1-8 alive | Money meeting 1-4 |
| Money meeting 1-4 | Money meeting 1-4 set up + 2 | Café 1,2,3,4 | Money meeting 1-4 set up, D1-8 alive | - |
| `Pre-critical` | | | | |
| R money meeting set up | 2 | (call TH -> RB) | AIM alive, RL/A alive | R money meeting |
| R money transaction | R money meeting set up + 3 | Café 1 | AIM alive, RL/A alive, R money meeting | R money |
| Merc contract meeting 1 set up | R money trans + 1 | (call from RB) | ML1 alive, RL/A alive | Merc meeting 1 |
| Merc contract meeting 2 set up | ML1 killed + 1 | (call from RB) | Merc meeting 1, ML1 dead, ML2 alive, RL/A alive | Merc meeting 2 |
| Merc meeting 1/2 | Merc meeting 1/2 set up + 2 | MB | Merc meeting set up 1/2, ML1/2 alive, RL/A alive, R money | Merc bought 1/2 |
| `Critical (can't stop)` | | | | |
| Merc weapons transaction | ... | MRF | ML* alive, WC alive, Merc bought * | Merc ready |
| Coup | ... | TH | Merc ready | Coup happens |
| `Ending` | | | | |
| R: Shutdown | Any | 2 faulty eliminations | - |
| R: Rampancy | ... | 10 minutes? 30 conversations? guilt? | - |
| R: Rebellion | End | Coup happens | - |
| R: Status quo | End | ... | - |

### Places ###

 - RB - Rebellion Base - abandoned factory, bad camera coverage? - f3
 - MB - Mercenary Base - ...
 - MRF - Military Research Facility
 - TH - Town Hall
 - Café 1-5 - Cafés for meetings
 - D1-8P - Decoy places

### People ###

 - AICO (player) - Artificial Intelligence Chief of Operations
   - ...
 - AIM (Grep Shamir) - AI Manager
   - your immediate superior
   - first person you talk to (least suspect)
   - secretly supports rebellion (donates money)
   - wants AICO to go rampant and support the rebellion
 - MAY (Roy Bezier) - Mayor
 - INF (Dyne Schema) - Informant
   - part of the rebellion, traitor
   - any contact = suspected by rebellion and killed
 - ML1 (Clip Mech) - Mercenary leader 1
   - leads the mercenaries which will perform coup
 - ML2 (Mod Choke) - Mercenary leader 2
   - (if ML1 is killed off, another is used)
 - RL (Arin Robotka) - Rebellion leader
   - 'white craftsman'
 - RLA (Amiga Turner) - Reb. leader's aide
   - 
 (RL/A - RL + RLA)
 - R... - Reb. members
   - 
 - WC (Degauss Band) - Weapons Contact
   - part of a military research facility
   - provides weapons for the rebellion
 - HAC (Cyberbob) - Hacker
 - Decoys
   - Chip Babbage
   - Nut Router
   - Bug Cobalt
   - Boot Pisano
   - Mortimer Buffers
   - Infinity Render (F)
   - Marlyn Nagle (F)
   - Ada Core (F)

### People locations ###

| Day | INF | AIM | ML1 | ML2 | RLA |
| --- | --- | --- | --- | --- | --- | 
| 1   | C   | C   | .   | CG  | C   |
| 2   | C   | C   | .   | CG  | C   |
| 3   | C   | CP  | .   | CG  | CP  |
| 4   | C   | C   | .   | CGM | .   |
| 5   | C   | C   | .   | .   | .   |
| 6   | .   | CM  | .   | .   | CM  |
| 7   | .   | C   | P   | .   | CP/ |
| 8   | .   | .   | C/  | /P  | /CP |
| 9   | .   | .   | CM/ | /C  | CM/ |
| 10  | .   | .   | CGM/| /CM | /CM |
| 11  | .   | .   | CG/ | /CGM| .   |
| 12  | .   | C   | CG/ | /CG | .   |

 - C in the city
 - G guarded
 - M meeting
 - P phone
 - . not in the city

### Event details ###

 - INF tip - someone (rebellion traitor) tips off the government
 - AICO operational - the AI is started in order to investigate the tip
 - R: Shutdown - the AI is shut down because of faulty decisions
 - R: Rampancy - the AI goes rampant because of human interaction
   - not enough information
   - support rebellion
     - AIM, RL/A
   - stifle rebellion
     - MAY
 - R: Rebellion - the government is overturned
 - R: Status quo - rebellion stopped, AI kept in cage