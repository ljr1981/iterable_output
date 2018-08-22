note
	description: "Abstract notion of extension to {READABLE_INDEXABLE} things."

deferred class
	READABLE_INDEXABLE_EXT

inherit
	ANY
		redefine
			out
		end

feature -- Output

	out: STRING
			-- <Precursor>
			-- Common output for all conforming to {READABLE_INDEXABLE_EXT}.
		note
			details: "[
				Presumes that the array may be of n-dimensions, where additional
				dimensions are of type {READABLE_INDEXABLE_EXT}. If so, it traverses
				down the dimensions, calling `out_csv' on each one.
				
				Only basic types (see `is_basic_type') are directl outputted. All
				others are marked as "n/a", which means we have no representation
				to present in a convenient way. If one does have a convenient
				string output representation, then one must redefine `is_basic_type'
				and add in the new class type to the attachment test list, such that
				the new type will have its `out' called.
				]"
		do
			create Result.make_empty
			if attached {READABLE_INDEXABLE [ANY]} Current as al_current then
				across
					al_current as ic
				loop
					if attached {READABLE_INDEXABLE_EXT} ic.item as al_row then
						Result.append_string_general (al_row.out)
					elseif is_basic_type (ic.item) and then attached ic.item as al_item then
						Result.append_string_general (al_item.out); Result.append_character (',')
						-- Convert known collections into analogous ?_EXT objects in order to `out' them as Current.
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
						end
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

feature -- Queries

	array_ext_from_array (a_item: ARRAY [ANY]): ARRAY_EXT [ANY]
			-- Create an {ARRAY_EXT} from `a_item'.
		do
			create Result.make_from_array (a_item)
		end

	array2_ext_from_array2 (a_item: ARRAY2 [ANY]): ARRAY2_EXT [ANY]
			-- Create an {ARRAY2_EXT} from `a_item'.
		do
			create Result.make_from_array2 (a_item)
		end

	arrayed_list_ext_from_arrayed_list (a_item: ARRAYED_LIST [ANY]): ARRAYED_LIST_EXT [ANY]
			-- Create an {ARRAYED_LIST_EXT} from `a_item'.
		do
			create Result.make_from_array (a_item.to_array)
		end

	arrayed_stack_ext_from_arrayed_stack (a_item: ARRAYED_STACK [ANY]): ARRAYED_STACK_EXT [ANY]
			-- Create an {ARRAYED_STACK_EXT} from `a_item'.
		do
			create Result.make (a_item.count)
			across
				a_item as ic
			loop
				Result.force (ic.item)
			end
		end

	hash_table_ext_from_hash_table (a_item: HASH_TABLE [ANY, detachable HASHABLE]): HASH_TABLE_EXT [ANY, detachable HASHABLE]
			-- Create an {HASH_TABLE_EXT} from `a_item'.
		do
			create Result.make (a_item.count)
			across
				a_item as ic
			loop
				Result.force (ic.item, ic.key)
			end
		end

	string_table_ext_from_string_table (a_item: STRING_TABLE [ANY]): STRING_TABLE_EXT [ANY]
			-- Create an {STRING_TABLE_EXT} from `a_item'.
		do
			create Result.make (a_item.count)
			across
				a_item as ic
			loop
				Result.force (ic.item, ic.key)
			end
		end

	is_basic_type (a_item: detachable ANY): BOOLEAN
			-- Is `a_item' an basic type?
		note
			to_do: "[
				It may be we can add {JSON_VALUE} to this list when we find a way
				to have `representation' called instead of `out'.
				]"
		do
			Result := attached {STRING} a_item or else attached {STRING_8} a_item or else attached {STRING_32} a_item or else
						attached {CHARACTER} a_item or else attached {CHARACTER_8} a_item or else attached {CHARACTER_32} a_item or else
						attached {INTEGER} a_item or else
						attached {INTEGER_8} a_item or else attached {INTEGER_16} a_item or else attached {INTEGER_32} a_item or else
						attached {INTEGER_64} a_item or else attached {NATURAL} a_item or else
						attached {NATURAL_8} a_item or else attached {NATURAL_16} a_item or else attached {NATURAL_32} a_item or else
						attached {NATURAL_64} a_item or else
						attached {REAL} a_item or else attached {REAL_32} a_item or else attached {REAL_64} a_item or else
						attached {DECIMAL} a_item or else
						attached {TIME} a_item or else attached {DATE} a_item or else attached {DATE_TIME} a_item
		end

end
