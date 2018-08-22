class
	ARRAYED_STACK_EXT [G]

inherit
	ARRAYED_STACK [G]
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
