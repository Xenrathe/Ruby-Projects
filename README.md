# README

## Ruby-Projects, a monorepo containing all major Ruby projects

Each individual project can be accessed from a selector CLI.

Ruby-Projects is active at (replit)

### Binary Search Tree

[Assignment on The Odin Project](https://www.theodinproject.com/lessons/ruby-binary-search-trees)

A balanced Binary Search Tree capable of deletion (both simple and self-balancing), insertion (simple and self-balancing), various traversal, re-balancing, and other functions.

### Features:

- Access to the Core-book SRD data (in the form of JSON data)
- Simple to use, belying the complex data and relationships underneath
- Enabling Print Ability Info will include ability & talent cards when printed
- Save/Load characters in simple JSON data format
- Responsive design for mobile, tablet, and desktop
- Support for dark mode

![Screenshot of mobile](https://github.com/Xenrathe/React-FormGen/blob/main/Mobile.png?raw=true)

### Tech Stack:

- CSS: Vanilla
- JS: React
- Backend: N/A - no database
- Other: Packery to condense the printed ability cards; vite-svgr to easily import svgs

![Screenshot of printed abilities](https://github.com/Xenrathe/React-FormGen/blob/main/PrintScreen.png?raw=true)

### Future To-do List

- tooltips explaining calculation
- pop-up info / info button on 13th age CharGen
- a fourth row in stats block (atk: crit; defenses: save; HP: ?; Stats: Rolling?)
- improved icon relations (dropdown for hostile / neutral / favorable?) or an image pop-up selector; integrate w/ icon-based talents
- SpellInfo dynamically updates depending on level (big change in dataset, I think?)
- AbilitiesBlock sub-blocks borrows space from other sub-blocks to maintain formatting
- clean up printing / don't break cards in half?
- SorcererFamiliar has permanent / random button
- Magical item info (a button to include bonuses from item types, e.g. +2 on weapon is included in ATK roll)
- Include other classes and their ability info?
- Update for second edition?
- A guided step-by-step character creator process (see Lancer's COMP/CON app)?

![Screenshot of add talents modal in dark mode](https://github.com/Xenrathe/React-FormGen/blob/main/AddTalents.png?raw=true)

### Design Brief

This project was created as part of The Odin Project curriculum, expanding on the <a href="https://www.theodinproject.com/lessons/react-new-cv-application">React: CV Application</a> project.

### Attribution

- The 13th Age TTRPG system (& icon) is published by <a href="https://pelgranepress.com/13th-age/" target="_blank" title="Pelgrane Press">Pelgrane Press</a>