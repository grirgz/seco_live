// KDTree with no labels stored:
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
// Let's map out the nearest symbol at every point in a grid
11.do({|y| 11.do({|x| format("%\t", ~tree.nearest([x, y])[0].label).post; });    "".postln; });""

// To find the nearest point to a point that's already in the tree (excluding self), call nearestToNode on the node in question:
// (again, what is actually returned is an array containing [node, distance])
~tree.location
~tree.nearestToNode
~tree.nearestToNode[0].location
~tree.leftChild.location
~tree.leftChild.nearestToNode[0].location
~tree.do{|node| "node: %\t nearest other: %".format(node.location, node.nearestToNode[0].location).postln};

// "All Nearest Neighbour" search - each point finds its neighbour.
// This returns an array of assocations of the form (node -> [nearestneighbour, distance]).
// It should be possible to optimise this relative to lots of separate .nearest queries, but at present speed is only a little bit faster.
~tree.allNearest
~tree.allNearest.do({|res| "(% -> %)".format(res.key.location, res.value[0].location).postln});

// Search within a rectangle (/hyperrectangle), defined by low and high co-ordinates
~tree.rectSearch([4,4], [8,8]).collect(_.location);
~tree.rectSearch([2,1], [8,4]).collect(_.location);
~tree.rectSearch([12,11], [18,41]).collect(_.location);

// Search within a circle (/hypersphere), defined by a point and a radius
~tree.radiusSearch([3,6], 2).collect(_.location);
~tree.radiusSearch([3,6], 3).collect(_.location);
~tree.radiusSearch([3,6], 3).collect({ arg x; x.nearestToNode[0].location });


////////// Other things ////////

// min and max are measured independently on each dimension.
// They aren't cached, but calculated when requested.
~tree.min;
~tree.max;
~tree.leftChild.min;
~tree.leftChild.max;

// .do and .collect are implemented to iterate the whole tree, evaluating func for every (non-deleted) node
~tree.do({|node| node.location[0].postln});
~tree.collect({|node| node.location[0]});

// Adding and removing are NOT RECOMMENDED, because the change doesn't generally result in a balanced tree. To balance the tree you have to re-create it from scratch from the flat array, which the .recreate method will do - however if you're happy to use an un-balanced tree you may add/delete/undelete data:
~tree.dumpTree;   // Orig tree
~tree.add([5,5]).dumpTree;   // Now with new element, but unbalanced
~tree = ~tree.recreate; // Recreates structure from scratch! Not recommended! But will be balanced.
~tree.dumpTree;   // Recreated, the order is quite different
~tree.find([5,5]);
~tree.delete([5,5]); // "delete" marks a node as deleted, without removing it
~tree.find([5,5]);
~tree.find([5,5], incDeleted: true);
~tree.dumpTree;
~tree.undelete([5,5]);
~tree.find([5,5]);
~tree.dumpTree;
~tree.delete([5,5]);
~tree = ~tree.recreate; // Recreates structure from scratch! Not recommended! But will be balanced.
~tree.dumpTree; // Deleted nodes are not included in the recreated version.

// The DIFFERENTIAL ENTROPY of the spatial distribution can be estimated from nearest-neighbour distances:
~tree.entropyNN;
// Let's generate trees based on known distributions and estimate the entropy:
// 2D uniform distrib has the MAXIMAL entropy of anything with the same range (here 0 to 1):
~tree = KDTree({[1.0.rand, 1.0.rand]}.dup(1000));
~tree.entropyNN;
// The following should have a lower entropy than the above:
KDTree({[1.0.linrand, 1.0.linrand]}.dup(1000)).entropyNN;
// Even lower entropy:
KDTree({[1.0.linrand.squared, 1.0.linrand.squared]}.dup(1000)).entropyNN;
// For a 1D uniform distribution ranging from zero to one, the true entropy is zero:
KDTree({[1.0.rand]}.dup(1000)).entropyNN;
