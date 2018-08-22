note
	description: "Tests of {ITERABLE_OUTPUT}."
	testing: "type/manual"

class
	ITERABLE_OUTPUT_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

feature -- Tests

	array2_multi_type_output_tests
			-- Can we successfully create ad-hoc arrays of various type mixtures and successfully output?
		local
			l_array2_any: ARRAY2_EXT [ANY]
		do
			create l_array2_any.make_with_rows (<<
						<<"moe", 100, create {DATE}.make (2018, 1, 1)>>,
						<<"curly", 200, create {DATE}.make (2018, 1, 2)>>,
						<<"shemp", 300, create {DATE}.make (2018, 1, 3)>>
						>>)
			assert_strings_equal ("multi_type_out_1", array2_multi_type_output_string_1, l_array2_any.out)
			create l_array2_any.make_with_rows (<<
						<<create {DATE}.make (2018, 1, 1), "moe", 100>>,
						<<200, "curly", create {DATE}.make (2018, 1, 2)>>,
						<<"shemp", 300, create {DATE}.make (2018, 1, 3)>>
						>>)
			assert_strings_equal ("multi_type_out_2", array2_multi_type_output_string_2, l_array2_any.out)
		end

	array2_multi_type_output_string_1: STRING = "[
moe,100,01/01/2018
curly,200,01/02/2018
shemp,300,01/03/2018

]"

	array2_multi_type_output_string_2: STRING = "[
01/01/2018,moe,100
200,curly,01/02/2018
shemp,300,01/03/2018

]"

	array2_output_tests
			-- Tests of {ARRAY2_EXT [G]}
		local
			l_array2_string: ARRAY2_EXT [STRING]
			l_array2_integer: ARRAY2_EXT [INTEGER]
			l_array2_real: ARRAY2_EXT [REAL]
		do
			create l_array2_string.make_with_rows (<<
							<<"moe", "curly", "shemp">>,
							<<"bugs", "daffy", "porky">>
						>>)
			assert_strings_equal ("array_ext_1", array_ext_1_string, l_array2_string.out)
			create l_array2_integer.make_with_rows (<<
							<<100, 200, 300>>,
							<<150, 250, 350>>
						>>)
			assert_strings_equal ("array_ext_2", array_ext_2_string, l_array2_integer.out)
			create l_array2_real.make_with_rows (<<
							<<100.1, 200.2, 300.3>>,
							<<150.4, 250.5, 350.6>>
						>>)
			assert_strings_equal ("array_ext_3", array_ext_3_string, l_array2_real.out)
		end

	array_ext_1_string: STRING = "[
moe,curly,shemp
bugs,daffy,porky

]"

	array_ext_2_string: STRING = "[
100,200,300
150,250,350

]"

	array_ext_3_string: STRING = "[
100.1,200.2,300.3
150.4,250.5,350.6

]"

	hash_table_ext_string_output_tests
			-- Tests for HASH_TABLE_EXT [ARRAY_EXT [STRING]]
		local
			l_array: HASH_TABLE_EXT [ARRAY [STRING], INTEGER]
		do
			create l_array.make (2)
			l_array.force (create {ARRAY_EXT [STRING]}.make_from_array (<<"moe", "curly", "shemp">>), 1)
			l_array.force (create {ARRAY_EXT [STRING]}.make_from_array (<<"bugs", "daffy", "porky">>), 2)

			assert_strings_equal ("hash_table_ext_1", array_ext_1_string, l_array.out)

				-- The convenience feature removes the need to call force multiple times and introduces
				-- the capacity for loading it with arrays + keys.
			create l_array.make_with_rows (<<
							[create {ARRAY_EXT [STRING]}.make_from_array (<<"moe", "curly", "shemp">>), 1],
							[create {ARRAY_EXT [STRING]}.make_from_array (<<"bugs", "daffy", "porky">>), 2]
						>>)

			assert_strings_equal ("hash_table_ext_2", array_ext_1_string, l_array.out)
		end

	arrayed_list_ext_string_output_tests
			-- Tests for ARRAYED_LIST_EXT [ARRAY_EXT [STRING]]
		local
			l_array: ARRAYED_LIST_EXT [ARRAY_EXT [STRING]]
			l_row: ARRAY_EXT [STRING]
		do
			create l_array.make (2)
			l_array.force (create {ARRAY_EXT [STRING]}.make_from_array (<<"moe", "curly", "shemp">>))
			l_array.force (create {ARRAY_EXT [STRING]}.make_from_array (<<"bugs", "daffy", "porky">>))

			assert_strings_equal ("array_ext", array_ext_1_string, l_array.out)

			create l_array.make_with_rows (<<
						create {ARRAY_EXT [STRING]}.make_from_array (<<"moe", "curly", "shemp">>),
						create {ARRAY_EXT [STRING]}.make_from_array (<<"bugs", "daffy", "porky">>)
						>>)

			assert_strings_equal ("array_ext", array_ext_1_string, l_array.out)
		end

	array_ext_string_output_tests
			-- Tests for ARRAY_EXT [ARRAY_EXT [STRING]]
		local
			l_array: ARRAY_EXT [ARRAY_EXT [STRING]]
			l_row: ARRAY_EXT [STRING]
		do
			create l_row.make_from_array (<<"moe", "curly", "shemp">>)
			create l_array.make_filled (l_row, 1, 2)
			create l_row.make_from_array (<<"bugs", "daffy", "porky">>)
			l_array.force (l_row, 2)

			assert_strings_equal ("array_ext", array_ext_1_string, l_array.out)
		end

	array_ext_int_output_tests
			-- Tests for ARRAY_EXT [ARRAY_EXT [INTEGER]]
		local
			l_array: ARRAY_EXT [ARRAY_EXT [INTEGER_32]]
			l_row: ARRAY_EXT [INTEGER_32]
		do
			create l_row.make_from_array (<<100, 200, 300>>)
			create l_array.make_filled (l_row, 1, 2)
			create l_row.make_from_array (<<150, 250, 350>>)
			l_array.force (l_row, 2)

			assert_strings_equal ("array_ext", array_ext_2_string, l_array.out)
		end

	array_ext_real_output_tests
			-- Tests for ARRAY_EXT [ARRAY_EXT [REAL]]
		local
			l_array: ARRAY_EXT [ARRAY_EXT [REAL]]
			l_row: ARRAY_EXT [REAL]
		do
			create l_row.make_from_array (<<100.1, 200.2, 300.3>>)
			create l_array.make_filled (l_row, 1, 2)
			create l_row.make_from_array (<<150.4, 250.5, 350.6>>)
			l_array.force (l_row, 2)

			assert_strings_equal ("array_ext", array_ext_3_string, l_array.out)
		end

end
