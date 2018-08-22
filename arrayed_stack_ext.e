note
	description: "Representation of a Extended {ARRAYED_STACK}"

class
	ARRAYED_STACK_EXT [G]

inherit
	ARRAYED_STACK [G]
		undefine
			out -- Use `out' from {READABLE_INDEXABLE_EXT}
		end

	READABLE_INDEXABLE_EXT
		undefine
			is_equal,
			copy
		end

create
	make,
	make_with_rows

feature {NONE} -- Implementation

	make_with_rows (a_rows: ARRAY [G])
			-- Make Current with rows-of-arrays (as columns).
		do
			make (a_rows.count)
			across
				a_rows as ic_rows
			loop
				force (ic_rows.item)
			end
		end

end
