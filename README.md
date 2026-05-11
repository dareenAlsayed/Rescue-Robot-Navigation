# Rescue Robot Navigation
A Prolog project that applies search algorithms to autonomous robot navigation in a grid-based rescue environment.
The system explores valid paths while avoiding blocked cells and locating survivors within the grid.

## Search Algorithms
-Breadth-First Search (BFS)
-Greedy Best-First Search

## Features
• Grid navigation  
• Obstacle avoidance  
• Survivor collection  
• Path tracking  
• Heuristic evaluation  
• Explicit open and closed lists  

## Example Grid 
grid([
  [e, e, s, d, e],
  [r, d, e, e, e],
  [e, f, e, d, s],
  [e, e, e, e, e]
]).

## Grid Symbols
r  → Robot  
s  → Survivor  
d  → Debris  
f  → Fire  
e  → Empty cell
