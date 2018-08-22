# Iterable Output

A library to extend collections or list classes to have a CSV-like "out" feature (or output to plain text).

## Purpose

We often find ourselves wanting to print out (usually for debugging purposes) a structure such as a hash table, i.e. writing `print (city_table)` and getting a reasonable default view such as list of [value, key] pairs:

                [“PARIS”, 'P'] [“CHICAGO”, 'C'] [“RIGA”, ‘R’] ...

`print (x)` actually displays `x.out` where `out` is a STRING-returning function from class ANY which (by default) yields an internal format but may be redefined in any class. Such redefinitions exist for basic types INTEGER etc., but no one has ever taken the trouble to write some for for EiffelBase data structure classes. (I am not a Gobo user but a quick look also did not reveal such redefinitions – maybe there is something else that I missed.) 

What I would find useful is the kind of above simple representation, directly adapted to the semantics of each kind of data structure as understood by their users. If I have a hash table this is how I would like to see it in the debugger, not the internal representation. (Admittedly, EiffelStudio gurus tell me they don’t care, and can read that representation.) There is a class DEBUG_OUTPUT but its idea has not been exploited much either so far.

Building such a readable representation for the major data structures in EiffelBase does not seem to be a very large effort. We are talking about maybe a dozen cases. If anyone is willing to help I’d be happy to coordinate the effort. (Let me use this opportunity to apologize for not pushing more yet on the LLVM/WebAssembly idea discussed some time ago. It is a much more ambitious project and not enough people were willing to commit the necessary resources, which is understandable. This one is much smaller.)

Messing up right away with ANY or a core library class such as DEBUG_OUTPUT is not a good idea so as a first step I would propose a visitor-style approach, talking “about” structures from the outside rather than working inside of them. In other words, a solution such as

`{RENDERER}.output (my_structure)`

yielding a STRING representing my_structure if RENDERER knows about its type, otherwise defaulting to my_structure.out. In other words, output in RENDERER (ms) would be written as something like

```
if {ARRAY [ANY]] ms as a then

... nice representation of array a ...

elseif {HASH_TABLE [ANY, COMPARABLE] ms as h then

... nice representation of hash table h

...

else ms.out end
```

(This is a first cut, there may be a more clever way.) Of course this scheme does not look like the ideal OO structure but it is what you have to write if you want an outside, visitor-style mechanism that applies to various types. It  has the dual advantage of allowing several renderers (inheriting from a general RENDERER class providing defaults). Once we are happy with one of them, we can always lobby for inclusion of the best solutions as redefinitions of `out` in EiffelBase classes, restoring a textbook OO approach.

In my opinion the representations, as with the hash table representation above, should  be terse and as much as possible use symbols rather than words, to avoid having to worry about translation into various human languages.

I think having such code would be useful. This is not a major endeavor but it will proceed faster if a few people help. This would mean taking up a couple of example structures, telling me about it, and within a month or so (let’s say August 31) sending me the corresponding branches of the above conditional, with examples and test results. I am happy to do HASH_TABLE and provide it as a guideline for others.

Thanks,

-- BM

## Extended Classes

The following classes are included in the extension, which provides a new `out` feature.

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

Each class has an `_EXT` suffix, which denotes the class offers extended or redefined features from its ancestor. For example: The `ARRAY2_EXT [G]` class inherits from `ARRAY2 [G]`, but is "extended" by the facilities of `READABLE_INDEXABLE_EXT` as well as features on the `ARRAY2_EXT [G]` class itself. Moreover—the `ARRAY2_EXT [G]` class adds convenience creation procedures as well as a specialized version of the `out` feature. Please explore the `?_EXT` classes and the `READABLE_INDEXABLE_EXT` class, specifically.
