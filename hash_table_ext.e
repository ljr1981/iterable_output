class
	HASH_TABLE_EXT [G, K -> detachable HASHABLE]

inherit
	HASH_TABLE [G, K]

	READABLE_INDEXABLE_EXT
		undefine
			is_equal,
			copy
		end

create
	make,
	make_equal
	
feature -- Outputs

	out_csv: STRING
			-- <Precursor>
		do
			create Result.make_empty
			across
				Current as ic
			loop
				if attached {READABLE_INDEXABLE_EXT} ic.item as al_row then
					Result.append_string_general (al_row.out_csv)
				elseif is_basic_type (ic.item) and then attached ic.item as al_item then
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
