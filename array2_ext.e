class
	ARRAY2_EXT [G]

inherit
	ARRAY2 [G]
		rename
			height as row_count,
			width as column_count
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
