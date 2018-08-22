# Iterable Output

A library to extend collections or list classes to have a CSV-like "out" feature (or output to plain text).

## Purpose

We often find ourselves wanting to print out (usually for debugging purposes) a structure such as a hash table, i.e. writing `print (city_table)` and getting a reasonable default view such as list of [value, key] pairs:

                [“PARIS”, 'P'] [“CHICAGO”, 'C'] [“RIGA”, ‘R’] ...

`print (x)` actually displays `x.out` where `out` is a STRING-returning function from class ANY which (by default) yields an internal format but may be redefined in any class. Such redefinitions exist for basic types `INTEGER` etc., but no one has ever taken the trouble to write some for EiffelBase data structure classes. (Gobo may have something.) 

What we might find useful is the kind of above simple representation, directly adapted to the semantics of each kind of data structure as understood by their users. If we have a hash table this is how we might like to see it in the debugger, not the internal representation. (Admittedly, EiffelStudio gurus generally say they don’t care, and can read that representation.) There is a class DEBUG_OUTPUT but its idea has not been exploited much either so far.

Building such a readable representation for the major data structures in EiffelBase does not seem to be a very large effort. We are talking about maybe a dozen cases.

Messing right away with `ANY` or a core library class such as `DEBUG_OUTPUT` is not a good idea, so as a first step we might propose a visitor-style approach, talking “about” structures from the outside rather than working inside of them. In other words, a solution such as

```
{RENDERER}.output (my_structure)
```

yielding a `STRING` representing `my_structure` if `RENDERER` knows about its type, otherwise defaulting to `my_structure.out`. In other words, output in `RENDERER (ms)` would be written as something like:

```
if {ARRAY [ANY]] ms as a then

... nice representation of array a ...

elseif {HASH_TABLE [ANY, COMPARABLE] ms as h then

... nice representation of hash table h

...

else ms.out end
```

(This is a first cut, there may be a more clever way.) Of course this scheme does not look like the ideal OO structure but it is what you have to write if you want an outside, visitor-style mechanism that applies to various types. It  has the dual advantage of allowing several renderers (inheriting from a general RENDERER class providing defaults). Once we are happy with one of them, we can always lobby for inclusion of the best solutions as redefinitions of `out` in EiffelBase classes, restoring a textbook OO approach.

The representations, as with the hash table representation above, should  be terse and as much as possible use symbols rather than words, to avoid having to worry about translation into various human languages.

Perhaps having such code would be useful. This is not a major endeavor but it will proceed faster if a few people help. This would mean taking up a couple of example structures, telling us about it, and within a month or so (let’s say August 31) sending the corresponding branches of the above, with examples and test results.

## Extended Classes

The following classes are included in this library, which provides a new `out` feature.

```
READABLE_INDEXABLE_EXT
   ARRAY2_EXT [G]
   ARRAYED_LIST_EXT [G]
   ARRAYED_STACK_EXT [G]
   ARRAY_EXT [G]
   HASH_TABLE_EXT [G, K -> detachable HASHABLE]
   LINKED_LIST_EXT [G]
   STRING_TABLE_EXT [G]
```

Each class having an `_EXT` suffix denotes the class offers extended or redefined features from its ancestor. For example: The `ARRAY2_EXT [G]` class inherits from `ARRAY2 [G]` and "extends" by either the facilities of `READABLE_INDEXABLE_EXT` or the features directly on the `ARRAY2_EXT [G]` class itself. Moreover—the `ARRAY2_EXT [G]` class adds convenience creation procedures as well as a specialized version of the `out` feature. 

Please explore the `?_EXT` classes and the `READABLE_INDEXABLE_EXT` class, specifically.

## Output Style

Presently, the `out` feature aims to output an n-dim array (usually n = 1 or n = 2) in a CSV-ish format. Data from `my_structure.out` might look something like:

```
moe,100,01/01/2018
curly,200,01/02/2018
shemp,300,01/03/2018
```
This structure being created by:

```
			create {ARRAY2_EXT [ANY]}.make_with_rows (<<
						<<"moe", 100, create {DATE}.make (2018, 1, 1)>>,
						<<"curly", 200, create {DATE}.make (2018, 1, 2)>>,
						<<"shemp", 300, create {DATE}.make (2018, 1, 3)>>
						>>)
```

Another example might be:
```
101,102,103
201,202,203
```
This structure being created by:
```
			create {LINKED_LIST_EXT [ANY]}.make_with_rows (<<
						<<101, 102, 103>>,
						<<201, 202, 203>>
					>>)
```
## N-Dim Structures
Structures with 3 or more dimensions will not render well in the CSV style. Therefore, we need something to handle more complex structures. As a suggestion—JSON might be a more suitable representation for n-dim structures.

```
NOTE: Each of the items in a typical n-dim structure at not named. in a 1 or 2 dimensional array, we naturally expect rows with either a single column (1-dim array) or rows and columns (2-dim array). Once we get to 3 or more dimensions, the row-column paradigm does not work well. Moreover, we lack names to identify the contents of each cell. 
```
The JSON format wants a `key:value` pair, where our structure has the values, but lacks the keys. Therefore, a suggestion is to use numeric coordinate values concatenated together as a key. For example: `3-2-5` represents `x = 3`, `y = 2`, `z = 5`. This form of building keys for JSON can be extended and represented without technical limits (although beyond `n = 3`, the representations might become unreadable).

