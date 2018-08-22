note
	description: "Extension of {HASH_TABLE [G, K]} with {READABLE_INDEXABLE_EXT}"

class
	HASH_TABLE_EXT [G, K -> detachable HASHABLE]

inherit
	HASH_TABLE [G, K]
		undefine
			print
		end
		
	READABLE_INDEXABLE_EXT
		undefine
			is_equal,
			copy
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

feature -- Outputs

	out_csv: STRING
			-- <Precursor>
		do
			Result := out_csv_common
		end

end
