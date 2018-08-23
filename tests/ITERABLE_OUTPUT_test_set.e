note
	description: "Tests of Iterable Output."
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

feature -- Tests: Multi-type

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

feature {NONE} -- Test Support: Constants

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

feature -- Tests

	linked_list_ext_tests
			--
		local
			l_list: LINKED_LIST_EXT [ARRAY_EXT [INTEGER]]
			l_list_1_col: LINKED_LIST_EXT [INTEGER]
			l_list_plain: LINKED_LIST_EXT [ARRAY [INTEGER]]
			l_list_any: LINKED_LIST_EXT [ANY]
		do
			create l_list.make
			l_list.put_front (create {ARRAY_EXT [INTEGER]}.make_from_array (<<101, 102, 103>>))
			l_list.put_front (create {ARRAY_EXT [INTEGER]}.make_from_array (<<201, 202, 203>>))
			assert_strings_equal ("linked_list_1", linked_list_string_1, l_list.out)

			create l_list_1_col.make
			l_list_1_col.put_front (101)
			l_list_1_col.put_front (102)
			l_list_1_col.put_front (103)
			l_list_1_col.put_front (201)
			l_list_1_col.put_front (202)
			l_list_1_col.put_front (203)
			assert_strings_equal ("linked_list_2", linked_list_string_2, l_list_1_col.out)

			create l_list_plain.make
			l_list_plain.put_front (<<101, 102, 103>>)
			l_list_plain.put_front (<<201, 202, 203>>)
			assert_strings_equal ("linked_list_3", linked_list_string_1, l_list_plain.out)

			create l_list_any.make
			l_list_any.put_front ("blah1")
			l_list_any.put_front (101)
			l_list_any.put_front (create {DATE}.make (2018, 1, 10))
			assert_strings_equal ("list_any_1", "1:01/10/2018,2:101,3:blah1%N", l_list_any.out)

			create l_list_any.make_with_rows (<<
						<<101, 102, 103>>,
						<<201, 202, 203>>
					>>)
			assert_strings_equal ("list_any_2", linked_list_string_3, l_list_any.out)
		end

feature {NONE} -- Test Support: Constants

	linked_list_string_1: STRING = "[
1:1:201,2:202,3:203
2:1:101,2:102,3:103

]"

	linked_list_string_2: STRING = "[
1:203,2:202,3:201,4:103,5:102,6:101

]"

	linked_list_string_3: STRING = "[
1:1:101,2:102,3:103
2:1:201,2:202,3:203

]"

feature -- Tests

	arrayed_stack_ext_tests
			-- Testing of ARRAYED_STACK_EXT and variants.
		local
			l_stack: ARRAYED_STACK_EXT [ARRAY_EXT [ANY]]
			l_stack_plain: ARRAYED_STACK_EXT [ARRAY [ANY]]
			l_stack_any: ARRAYED_STACK_EXT [ANY]
		do
			create l_stack.make (2)
			l_stack.force (create {ARRAY_EXT [ANY]}.make_from_array (<<100, "blah1", 20.1>>))
			l_stack.force (create {ARRAY_EXT [ANY]}.make_from_array (<<200, "blah2", 20.2>>))

			assert_strings_equal ("stack_test_1", stack_string_1, l_stack.out)

			create l_stack_plain.make (2)
			l_stack_plain.force (<<100, "blah1", 20.1>>)
			l_stack_plain.force (<<200, "blah2", 20.2>>)
			assert_strings_equal ("stack_test_2", stack_string_1, l_stack_plain.out)

			create l_stack_any.make (2)
			l_stack_any.force (create {DATE}.make (2018, 5, 15))
			l_stack_any.force ("blah1")
			l_stack_any.force (200)
			l_stack_any.force (200.99)
			assert_strings_equal ("stack_test_3", "1:05/15/2018,2:blah1,3:200,4:200.99000000000001%N", l_stack_any.out)

			create l_stack_plain.make_with_rows (<<
							<<100, "blah1", 20.1>>,
							<<200, "blah2", 20.2>>
						>>)
			assert_strings_equal ("stack_test_4", stack_string_1, l_stack_plain.out)
		end

	string_table_ext_tests
			--
		do

		end

feature {NONE} -- Test Support: Constants

	stack_string_1: STRING = "[
1:1:100,2:blah1,3:20.100000000000001
2:1:200,2:blah2,3:20.199999999999999

]"

feature -- Tests

	array2_output_tests
			-- Tests of {ARRAY2_EXT [G]} and variants.
		local
			l_array2_string: ARRAY2_EXT [STRING]
			l_array2_integer: ARRAY2_EXT [INTEGER]
			l_array2_real: ARRAY2_EXT [REAL]
		do
			create l_array2_string.make_with_rows (<<
							<<"moe", "curly", "shemp">>,
							<<"bugs", "daffy", "porky">>
						>>)
			assert_strings_equal ("array_ext_1", array_ext_1c_string, l_array2_string.out)
			create l_array2_integer.make_with_rows (<<
							<<100, 200, 300>>,
							<<150, 250, 350>>
						>>)
			assert_strings_equal ("array_ext_2", array_ext_2_string, l_array2_integer.out)
			create l_array2_real.make_with_rows (<<
							<<100.1, 200.2, 300.3>>,
							<<150.4, 250.5, 350.6>>
						>>)
			assert_strings_equal ("array_ext_3", array_ext_3b_string, l_array2_real.out)
		end

feature {NONE} -- Test Support: Constants

	array_ext_1_string: STRING = "[
#17 - 1:moe,2:curly,3:shemp
#28 - 1:bugs,2:daffy,3:porky

]"

	array_ext_1b_string: STRING = "[
1:1:moe,2:curly,3:shemp
2:1:bugs,2:daffy,3:porky

]"

	array_ext_1c_string: STRING = "[
moe,curly,shemp
bugs,daffy,porky

]"

	array_ext_1d_string: STRING = "[
#PEOPLE - 1:moe,2:curly,3:shemp
#ANIMATIONS - 1:bugs,2:daffy,3:porky

]"

	array_ext_2_string: STRING = "[
100,200,300
150,250,350

]"

	array_ext_3_string: STRING = "[
1:1:100.1,2:200.2,3:300.3
2:1:150.4,2:250.5,3:350.6

]"

	array_ext_3b_string: STRING = "[
100.1,200.2,300.3
150.4,250.5,350.6

]"



feature -- Tests

	hash_table_ext_string_output_tests
			-- Tests for HASH_TABLE_EXT [ARRAY_EXT [STRING]] and variants.
		local
			l_array: HASH_TABLE_EXT [ARRAY [STRING], INTEGER]
			l_array2: HASH_TABLE_EXT [ARRAY [STRING], STRING]
		do
			create l_array.make (2)
			l_array.force (create {ARRAY_EXT [STRING]}.make_from_array (<<"moe", "curly", "shemp">>), 17)
			l_array.force (create {ARRAY_EXT [STRING]}.make_from_array (<<"bugs", "daffy", "porky">>), 28)

			assert_strings_equal ("hash_table_ext_1", array_ext_1_string, l_array.out)

				-- The convenience feature removes the need to call force multiple times and introduces
				-- the capacity for loading it with arrays + keys.
			create l_array.make_with_rows (<<
							[create {ARRAY_EXT [STRING]}.make_from_array (<<"moe", "curly", "shemp">>), 17],
							[create {ARRAY_EXT [STRING]}.make_from_array (<<"bugs", "daffy", "porky">>), 28]
						>>)

			assert_strings_equal ("hash_table_ext_2", array_ext_1_string, l_array.out)

			create l_array2.make (2)
			l_array2.force (create {ARRAY_EXT [STRING]}.make_from_array (<<"moe", "curly", "shemp">>), "PEOPLE")
			l_array2.force (create {ARRAY_EXT [STRING]}.make_from_array (<<"bugs", "daffy", "porky">>), "ANIMATIONS")

			assert_strings_equal ("hash_table_ext_2", array_ext_1d_string, l_array2.out)
		end

	arrayed_list_ext_string_output_tests
			-- Tests for ARRAYED_LIST_EXT [ARRAY_EXT [STRING]] and variants.
		local
			l_array: ARRAYED_LIST_EXT [ARRAY_EXT [STRING]]
			l_row: ARRAY_EXT [STRING]
		do
			create l_array.make (2)
			l_array.force (create {ARRAY_EXT [STRING]}.make_from_array (<<"moe", "curly", "shemp">>))
			l_array.force (create {ARRAY_EXT [STRING]}.make_from_array (<<"bugs", "daffy", "porky">>))

			assert_strings_equal ("array_ext", array_ext_1b_string, l_array.out)

			create l_array.make_with_rows (<<
						create {ARRAY_EXT [STRING]}.make_from_array (<<"moe", "curly", "shemp">>),
						create {ARRAY_EXT [STRING]}.make_from_array (<<"bugs", "daffy", "porky">>)
						>>)

			assert_strings_equal ("array_ext", array_ext_1b_string, l_array.out)
		end

	array_ext_string_output_tests
			-- Tests for ARRAY_EXT [ARRAY_EXT [STRING]] and variants.
		local
			l_array: ARRAY_EXT [ARRAY_EXT [STRING]]
			l_row: ARRAY_EXT [STRING]
			l_array_3: ARRAY_EXT [ARRAY [ARRAY [STRING]]]
		do
			create l_row.make_from_array (<<"moe", "curly", "shemp">>)
			create l_array.make_filled (l_row, 1, 2)
			create l_row.make_from_array (<<"bugs", "daffy", "porky">>)
			l_array.force (l_row, 2)

			assert_strings_equal ("array_ext", array_ext_1b_string, l_array.out)

				-- N-dim (x-y-z axis) array does not present well in CSV-ish style.
			create l_array_3.make_filled (<< <<"a", "b", "c">>, <<"x", "y">> >>, 1, 2)
			assert_strings_equal ("array_3", array_3_string, l_array_3.out)
		end

feature {NONE} -- Support: Constants

	array_3_string: STRING = "[
1:1:1:a,2:b,3:c
2:1:x,2:y
2:1:1:a,2:b,3:c
2:1:x,2:y

]"

feature -- Tests

	array_ext_int_output_tests
			-- Tests for ARRAY_EXT [ARRAY_EXT [INTEGER]] and variants.
		local
			l_array: ARRAY_EXT [ARRAY_EXT [INTEGER_32]]
			l_row: ARRAY_EXT [INTEGER_32]
		do
			create l_row.make_from_array (<<100, 200, 300>>)
			create l_array.make_filled (l_row, 1, 2)
			create l_row.make_from_array (<<150, 250, 350>>)
			l_array.force (l_row, 2)

			assert_strings_equal ("array_ext", array_ext_int_string, l_array.out)
		end

	array_ext_real_output_tests
			-- Tests for ARRAY_EXT [ARRAY_EXT [REAL]] and variants.
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

feature {NONE} -- Test Support: ARRAY_EXT

	array_ext_int_string: STRING = "[
1:1:100,2:200,3:300
2:1:150,2:250,3:350

]"

feature -- Tests

	json_tests
			-- Test of `out' of JSON.
		local
			l_array2: HASH_TABLE_EXT [ARRAY [STRING], STRING]
			l_array2_any: ARRAY2_EXT [ANY]
		do
			create l_array2.make (2)
			l_array2.force (create {ARRAY_EXT [STRING]}.make_from_array (<<"moe", "curly", "shemp">>), "PEOPLE")
			l_array2.force (create {ARRAY_EXT [STRING]}.make_from_array (<<"bugs", "daffy", "porky">>), "ANIMATIONS")

			assert_strings_equal ("json_1_string", json_1_string, l_array2.out_json)

			create l_array2_any.make_with_rows (<<
						<<"moe", "curly", "shemp">>,
						<<"bugs", "daffy", "porky">>
						>>)
			assert_strings_equal ("json_2_string", json_2_string, l_array2_any.out_json)
		end

feature {NONE} -- Support

	json_1_string: STRING = "[
{"PEOPLE": [ {"1":"moe"},{"2":"curly"},{"3":"shemp"} ],
"ANIMATIONS": [ {"1":"bugs"},{"2":"daffy"},{"3":"porky"} ]}

]"

	json_2_string: STRING = "[
{"1": [ {"1":"moe"},{"2":"curly"},{"3":"shemp"} ],
"2": [ {"1":"bugs"},{"2":"daffy"},{"3":"porky"} ]}

]"

end
