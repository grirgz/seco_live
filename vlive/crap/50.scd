~tree = KDTree([[2,3], [5,4], [9,6], [4,7], [8,1], [7,2]]);
// Or create one with a "label" (an item) at each node:
~tree = KDTree([[2,3, \fred], [5,4, \yep], [9,6, \bonk], [4,7, \hat], [8,1, \smak], [7,2, \jexx]], lastIsLabel: true);
~tree.dumpTree;
~tree.asArray;
~tree.asArray(incLabels: true);
// Each KDTree node stores data in a leftChild, a rightChild, and a location
~tree.leftChild.asArray;
~tree.rightChild.asArray;
~tree.location;


///////// Searching ////////////

// The kd-tree structure means that large portions of the tree often don't need to be searched. 
// For large data (e.g. 100000 points) this gives a massive speed increase compared against 
// searching the corresponding array, even for ordinary exact-match search. 
// Also allows fast spatial searches which are very efficient even on medium-sized data.
// See benchmarks below.

// Simple exact-match search - returns the first matching node object if found, or nil otherwise.
~tree.find([5,9]); // Not found
~tree.find([5,4]).label; // Found

// Nearest neighbour search - returns only one node, although of course there could be a tie.
// What is actually returned is an array containing [node, distance]
~tree.nearest([3,3]);
~tree.nearest([3,3])[0].location;
~tree.nearest([7,6])[0].location;
~tree.nearest([6,6])[0].location;
