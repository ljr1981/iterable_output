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
			out -- Use `out' from {READABLE_INDEXABLE_EXT}
		end

	READABLE_INDEXABLE_EXT
		undefine
			is_equal,
			copy
		redefine
			out --due to 2-dim specialization requirements
		end

create
	make, make_filled,
	make_with_rows, make_from_array2

feature {NONE} -- Initialization

	make_with_rows (a_rows: ARRAY [ARRAY [G]])
			-- Make Current with `a_rows' (i.e. array of arrays of [G]).
		do
			if not a_rows.is_empty then
				make_filled (a_rows [1] [1], a_rows.count, a_rows [1].count)
				across a_rows as ic loop
					set_row (ic.cursor_index, ic.item)
				end
			else
				make_empty
			end
		end

	make_from_array2 (a_item: ARRAY2 [G])
			-- Make Current from {ARRAY2} `a_item'.
		do
			make_empty
			across
				1 |..| a_item.height as ic_row
			loop
				across
					1 |..| a_item.width as ic_col
				loop
					force (a_item [ic_row.item, ic_col.item], ic_row.item, ic_col.item)
				end
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

	out: STRING
			-- <Precursor>
		note
			details: "[
				The common redefinition of `out' will not work for ARRAY2.
				So, we redefine it and reimplement it with the specialized
				knowledge of always having 2 dimensions (rows and columns).
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
