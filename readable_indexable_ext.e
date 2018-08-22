deferred class
	READABLE_INDEXABLE_EXT

feature -- Output

	out_csv: STRING
			-- Output of Current in CSV format.
		deferred
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
