note
	description: "An extension of {ARRAY [G]} with {READABLE_INDEXABLE_EXT} features."

class
	ARRAY_EXT [G]

inherit
	ARRAY [G]
		undefine
			out -- Use `out' from {READABLE_INDEXABLE_EXT}
		end

	READABLE_INDEXABLE_EXT
		undefine
			is_equal,
			copy
		end

create
	make, make_empty, make_filled, make_from_array, make_from_cil, make_from_special,
	make_with_rows

feature {NONE} -- Implementation

	make_with_rows (a_rows: ARRAY [G])
			-- See also: `make_from_array'
		do
			make_from_array (a_rows)
		end

end
