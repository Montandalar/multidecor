local function get_shelf_formspec(name, pos)
	return table.concat({
		"formspec_version[5]",
		"size[11,9]",
		"list[nodemeta:" .. pos.x .. "," .. pos.y .. "," .. pos.z .. ";" .. multidecor.helpers.build_name_from_tmp(name, "list", 1) .. ";0.5,0.5;7,2;]",
		"list[current_player;main;0.5,3.5;8,4;]"
	}, "")
end

local shelf_on_construct = function(pos)
	local meta = minetest.get_meta(pos)
	local name = minetest.get_node(pos).name
	meta:set_string("formspec", get_shelf_formspec(name, pos))

	local inv = minetest.get_inventory({type="node", pos=pos})
	local list_name = multidecor.helpers.build_name_from_tmp(name, "list", 1)
	inv:set_size(list_name, 7*2)
	inv:set_width(list_name, 7)

	inv:set_size("main", 8*4)
	inv:set_width("main", 8)
end

local shelf_can_dig = function(pos)
	local inv = minetest.get_inventory({type="node", pos=pos})

	return inv:is_empty(multidecor.helpers.build_name_from_tmp(minetest.get_node(pos).name, "list", 1))
end


for _, wood_n in ipairs({"", "jungle", "pine", "aspen"}) do
	wood_n = wood_n .. (wood_n ~= "" and wood_n ~= "jungle" and "_" or "")
	local tex = "multidecor_" .. wood_n .. (wood_n == "jungle" and "_" or "") .. "wood.png^[sheet:2x2:0,0"

	multidecor.register.register_table("modern_wooden_" .. wood_n .. "closed_shelf", {
		style = "modern",
		material = "wood",
		drawtype = "nodebox",
		visual_scale = 1,
		description = "Modern Wooden " .. wood_n:sub(1, 1):upper() .. wood_n:sub(2, -1) .. " Closed Shelf (without back)",
		tiles = {tex, tex, tex, tex, tex, tex},
		bounding_boxes = {
			{-0.5, -0.4, -0.5, -0.4, 0.4, 0.5},			-- Left side
			{0.4, -0.4, -0.5, 0.5, 0.4, 0.5},			-- Right side
			{-0.5, -0.5, -0.5, 0.5, -0.4, 0.5},			-- Bottom side
			{-0.5, 0.4, -0.5, 0.5, 0.5, 0.5}			-- Top side
		},
		callbacks = {
			on_construct = shelf_on_construct,
			can_dig = shelf_can_dig
		}
	},
	{
		recipe = {
			{"multidecor:" .. wood_n .. "board", "multidecor:" .. wood_n .. "board", "multidecor:" .. wood_n .. "board"},
			{"multidecor:" .. wood_n .. "board", "multidecor:" .. wood_n .. "board", ""},
			{"", "", ""}
		}
	})

	multidecor.register.register_table("modern_wooden_" .. wood_n .. "closed_shelf_with_back", {
		style = "modern",
		material = "wood",
		drawtype = "nodebox",
		visual_scale = 1,
		description = "Modern Wooden " .. wood_n:sub(1, 1):upper() .. wood_n:sub(2, -1) .. " Closed Shelf (with back)",
		tiles = {tex, tex, tex, tex, tex, tex},
		bounding_boxes = {
			{-0.5, -0.4, -0.5, -0.4, 0.4, 0.5},			-- Left side
			{0.4, -0.4, -0.5, 0.5, 0.4, 0.5},			-- Right side
			{-0.5, -0.5, -0.5, 0.5, -0.4, 0.5},			-- Bottom side
			{-0.5, 0.4, -0.5, 0.5, 0.5, 0.5},			-- Top side
			{-0.4, -0.4, 0.4, 0.4, 0.4, 0.5}			-- Back side
		},
		callbacks = {
			on_construct = shelf_on_construct,
			can_dig = shelf_can_dig
		}
	},
	{
		recipe = {
			{"multidecor:" .. wood_n .. "board", "multidecor:" .. wood_n .. "board", ""},
			{"multidecor:" .. wood_n .. "board", "multidecor:" .. wood_n .. "board", ""},
			{"", "", ""}
		}
	})

	multidecor.register.register_table("modern_wooden_" .. wood_n .. "wall_shelf", {
		style = "modern",
		material = "wood",
		visual_scale = 0.5,
		paramtype2 = "wallmounted",
		description = "Modern Wooden " .. wood_n:sub(1, 1):upper() .. wood_n:sub(2, -1) .. " Wall Shelf",
		mesh = "multidecor_wall_shelf.obj",
		tiles = {tex},
		bounding_boxes = {
			{-0.5, 0, 0.4, 0.5, -0.5, 0.5},
			{-0.5, 0, 0.15, -0.4, -0.5, 0.4},
			{0.4, 0, 0.15, 0.5, -0.5, 0.4}
		}
	},
	{
		type = "shapeless",
		recipe = {"multidecor:" .. wood_n .. "plank", "multidecor:" .. wood_n .. "plank"}
	})

	multidecor.register.register_table("modern_corner_wooden_" .. wood_n .. "wall_shelf", {
		style = "modern",
		material = "wood",
		visual_scale = 0.5,
		paramtype2 = "wallmounted",
		description = "Modern Corner Wooden " .. wood_n:sub(1, 1):upper() .. wood_n:sub(2, -1) .. " Wall Shelf",
		mesh = "multidecor_corner_wall_shelf.b3d",
		tiles = {tex},
		bounding_boxes = {
			{-0.5, 0, 0.4, 0.5, -0.5, 0.5},
			--{-0.5, 0, 0.15, -0.4, -0.5, 0.4},
			{0.4, 0, 0.15, 0.5, -0.5, 0.4},
			{-0.5, 0.5, 0.4, 0, 0, 0.5},
			{-0.5, 0.4, 0.15, 0, 0.5, 0.4}
		}
	},
	{
		type = "shapeless",
		recipe = {"multidecor:modern_wooden_" .. wood_n .. "wall_shelf", "multidecor:" .. wood_n .. "plank"}
	})

	multidecor.register.register_table("modern_wooden_" .. wood_n .. "wall_shelf_with_books", {
		style = "modern",
		material = "wood",
		visual_scale = 0.5,
		paramtype2 = "wallmounted",
		description = "Modern Wooden " .. wood_n:sub(1, 1):upper() .. wood_n:sub(2, -1) .. " Wall Shelf With Books",
		mesh = "multidecor_wall_shelf_with_books.b3d",
		tiles = { -- Red, blue, green, darkmagenta, darkorange
			tex,
			"multidecor_book_envelope.png^[multiply:red^multidecor_book.png",
			"multidecor_book_envelope.png^[multiply:darkorange^multidecor_book.png",
			"multidecor_book_envelope.png^[multiply:blue^multidecor_book_pattern.png^multidecor_book.png",
			"multidecor_book_envelope.png^[multiply:green^multidecor_book_pattern2.png^multidecor_book.png",
			"multidecor_book_envelope.png^[multiply:darkmagenta^multidecor_book_pattern.png^multidecor_book.png",
		},
		bounding_boxes = {
			{-0.5, 0, 0.4, 0.5, -0.5, 0.5},
			{-0.5, 0, 0.15, -0.4, -0.5, 0.4},
			{0.4, 0, 0.15, 0.5, -0.5, 0.4}
		}
	},
	{
		type = "shapeless",
		recipe = {"multidecor:modern_wooden_" .. wood_n .. "wall_shelf", "multidecor:books_stack"}
	})
end
