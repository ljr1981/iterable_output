note
	description: "An extension of {ARRAY2 [G]} with {READABLE_INDEXABLE_EXT} features."

class
	ARRAY2_EXT [G]

inherit
	ARRAY2 [G]
		rename
			height as row_count,
			width as column_count
		undefine
			print
		end

	READABLE_INDEXABLE_EXT
		undefine
			is_equal,
			copy
		end

create
	make, make_filled, make_with_rows

feature {NONE} -- Initialization

	make_with_rows (a_rows: ARRAY [ARRAY [G]])
			-- Make Current with `a_rows' (i.e. array of arrays of [G]).
		require
			has_items: not a_rows.is_empty and then not a_rows [1].is_empty
		do
			make_filled (a_rows [1] [1], a_rows.count, a_rows [1].count)
			across a_rows as ic loop
				set_row (ic.cursor_index, ic.item)
			end
		end

feature -- Setters

	set_row (a_row: INTEGER; a_items: ARRAY [G])
			-- Set `a_items' into Current at `a_row'.
		require
			has_row: a_row <= row_count
			enough_columns: a_items.count <= column_count
		do
			across a_items as ic_items loop
				put (ic_items.item, a_row, ic_items.cursor_index)
			end
		end

feature -- Output

	out_csv: STRING
			-- <Precursor>
		note
			details: "[
				Presumes that the array may be of 2-dimensions and traverses
				both dimensions, calling `out_csv' on each item.
				
				Only basic types (see `is_basic_type') are directl outputted. All
				others are marked as "n/a", which means we have no representation
				to present in a convenient way. If one does have a convenient
				string output representation, then one must redefine `is_basic_type'
				and add in the new class type to the attachment test list, such that
				the new type will have its `out' called.
				]"
		do
			create Result.make_empty
			across
				1 |..| row_count as ic_row
			loop
				across
					1 |..| column_count as ic_col
				loop
					if attached item (ic_row.item, ic_col.item) as al_item and then
						is_basic_type (al_item)
					then
						Result.append_string_general (al_item.out)
						Result.append_character (',')
					else
						Result.append_string_general ("n/a")
					end
				end
				if Result [Result.count] = ',' then
					Result.remove_tail (1)
					Result.append_character ('%N')
				end
			end
		end

end
