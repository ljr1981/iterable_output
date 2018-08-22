class
	STRING_TABLE_EXT [G]

inherit
	STRING_TABLE [G]
		undefine
			out
		end

	READABLE_INDEXABLE_EXT
		undefine
			is_equal,
			copy
		end

create
	make, make_equal, make_caseless, make_equal_caseless

end
