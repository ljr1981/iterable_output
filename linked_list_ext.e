class
	LINKED_LIST_EXT [G]

inherit
	LINKED_LIST [G]
		undefine
			out
		end

	READABLE_INDEXABLE_EXT
		undefine
			is_equal,
			copy
		end

create
	make

end
