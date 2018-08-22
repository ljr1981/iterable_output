note
	description: "An extension of {ARRAY [G]} with {READABLE_INDEXABLE_EXT} features."

class
	ARRAY_EXT [G]

inherit
	ARRAY [G]
		undefine
			out
		end

	READABLE_INDEXABLE_EXT
		undefine
			is_equal,
			copy
		end

create
	make, make_empty, make_filled, make_from_array, make_from_cil, make_from_special

end
