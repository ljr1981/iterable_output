deferred class
	READABLE_INDEXABLE_EXT

feature -- Output

	out_csv: STRING
		deferred
		end

feature -- Queries

	is_basic_type (a_item: detachable ANY): BOOLEAN
		do
			Result := attached {STRING} a_item or else attached {STRING_8} a_item or else attached {STRING_32} a_item or else
						attached {CHARACTER} a_item or else attached {CHARACTER_8} a_item or else attached {CHARACTER_32} a_item or else
						attached {INTEGER} a_item or else
						attached {INTEGER_8} a_item or else attached {INTEGER_16} a_item or else attached {INTEGER_32} a_item or else
						attached {INTEGER_64} a_item or else attached {NATURAL} a_item or else
						attached {NATURAL_8} a_item or else attached {NATURAL_16} a_item or else attached {NATURAL_32} a_item or else
						attached {NATURAL_64} a_item or else
						attached {REAL} a_item or else attached {REAL_32} a_item or else attached {REAL_64} a_item or else
						attached {DECIMAL} a_item
		end

end
