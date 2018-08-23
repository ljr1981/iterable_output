note
	description: "Extension of {HASH_TABLE [G, K]} with {READABLE_INDEXABLE_EXT}"

class
	HASH_TABLE_EXT [G, K -> detachable HASHABLE]

inherit
	HASH_TABLE [G, K]
		undefine
			out -- Use `out' from {READABLE_INDEXABLE_EXT}
		end

	READABLE_INDEXABLE_EXT
		undefine
			is_equal,
			copy
		redefine
			out
		end

create
	make,
	make_equal,
	make_with_rows

feature {NONE} -- Initialization

	make_with_rows (a_rows: ARRAY [TUPLE [values: G; key: K]])
			-- Make Current with `a_rows' of values and a key for each.
		do
			make (a_rows.count)
			across
				a_rows as ic
			loop
				force (ic.item.values, ic.item.key)
			end
		end

feature -- Output

	out: STRING
			-- <Precursor>
		do
			create Result.make_empty
			if attached {READABLE_INDEXABLE [ANY]} Current as al_current then
				if attached {HASH_TABLE [G, K]} al_current as al_hash_table then
					al_hash_table.start
				end
				across
					al_current as ic
				loop
					if attached {HASH_TABLE [G, K]} al_current as al_hash_table then
						if attached al_hash_table.key_for_iteration as al_key then
							Result.append_character ('#')
							Result.append_string_general (al_key.out)
							Result.append_string_general (" - ")
						end
					end
					if attached {READABLE_INDEXABLE_EXT} ic.item as al_row then
						Result.append_string_general (al_row.out)
						-- Plain ole READABLE_INDEXABLE things might possibly be converted and output.
					elseif attached {READABLE_INDEXABLE [ANY]} ic.item as al_row then
						if attached {ARRAY2 [ANY]} al_row as al_item then
							Result.append_string_general (array2_ext_from_array2 (al_item).out)
						elseif attached {ARRAYED_LIST [ANY]} al_row as al_item then
							Result.append_string_general (arrayed_list_ext_from_arrayed_list (al_item).out)
						elseif attached {ARRAYED_STACK [ANY]} al_row as al_item then
							Result.append_string_general (arrayed_stack_ext_from_arrayed_stack (al_item).out)
						elseif attached {ARRAY [ANY]} al_row as al_item then
							Result.append_string_general (array_ext_from_array (al_item).out)
						elseif attached {HASH_TABLE [ANY, detachable HASHABLE]} al_row as al_item then
							Result.append_string_general (hash_table_ext_from_hash_table (al_item).out)
						elseif attached {STRING_TABLE [ANY]} al_row as al_item then
							Result.append_string_general (string_table_ext_from_string_table (al_item).out)
						elseif is_basic_type (ic.item) and then attached ic.item as al_item then
							Result.append_string_general (al_item.out); Result.append_character (',')
						else -- Otherwise, we don't know, but want to be aware!
							Result.append_string_general ("n/a"); Result.append_character (',')
							check unknown_condition: False end
						end
					elseif is_basic_type (ic.item) and then attached ic.item as al_item then
						Result.append_string_general (al_item.out); Result.append_character (',')
					else -- Otherwise, we don't want complex outputs.
						Result.append_string_general ("n/a"); Result.append_character (',')
					end
					if attached {HASH_TABLE [G, K]} al_current as al_hash_table then
						al_hash_table.forth
					end
				end
				if Result [Result.count] = ',' then
					Result.remove_tail (1)
					Result.append_character ('%N')
				end
			end
		end

end
