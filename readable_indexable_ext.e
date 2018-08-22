note
	description: "Abstract notion of extension to {READABLE_INDEXABLE} things."
deferred class
	READABLE_INDEXABLE_EXT

feature -- Output

	out_csv: STRING
			-- Output of Current in CSV format.
		deferred
		end

	out_csv_common: STRING
			-- Output of Current in common CSV format if Current is {ITERABLE [ANY]}
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

feature -- Queries

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
