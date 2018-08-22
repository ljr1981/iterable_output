class
	ARRAY_EXT [G]

inherit
	ARRAY [G]

	READABLE_INDEXABLE_EXT
		undefine
			is_equal,
			copy
		end

create
	make, make_empty, make_filled, make_from_array, make_from_cil, make_from_special

feature -- Output

	out_csv: STRING
			-- Current output as CSV
		do
			create Result.make_empty
			across
				1 |..| count as ic
			loop
				if attached {READABLE_INDEXABLE_EXT} item (ic.item) as al_row then
					Result.append_string_general (al_row.out_csv)
				elseif is_basic_type (item (ic.item)) and then attached item (ic.item) as al_item then
					Result.append_string_general (al_item.out); Result.append_character (',')
				else
					Result.append_string_general ("n/a"); Result.append_character (',')
				end
			end
			if Result [Result.count] = ',' then
				Result.remove_tail (1)
				Result.append_character ('%N')
			end
		end

end
