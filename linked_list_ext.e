note
	description: "Representation of an Extension of {LINKED_LIST}"

class
	LINKED_LIST_EXT [G]

inherit
	LINKED_LIST [G]
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
			-- Make Current with rows-of-arrays (as columns, which is G).
		do
			make
			across
				a_rows as ic_rows
			loop
				force (ic_rows.item)
			end
		end

end
