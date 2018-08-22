note
	description: "Summary description for {ARRAYED_LIST_EXT}."

class
	ARRAYED_LIST_EXT [G]

inherit
	ARRAYED_LIST [G]
		undefine
			out -- Use `out' from {READABLE_INDEXABLE_EXT}
		end

	READABLE_INDEXABLE_EXT
		undefine
			is_equal,
			copy
		end

create
	make, make_filled, make_from_array,
	make_with_rows

feature {NONE} -- Initialization

	make_with_rows (a_rows: ARRAY [G])
			-- Make Current with `a_rows' (i.e. array of arrays of [G]).
		do
			make (a_rows.count)
			across a_rows as ic loop
				force (ic.item)
			end
		end

end
