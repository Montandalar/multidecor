local bathtub_def = {{
	style = "modern",
	material = "stone",
	description = "Bathtub",
	visual_scale = 0.5,
	mesh = "multidecor_bathtub.b3d",
	tiles = {
		"multidecor_marble_material.png",
		"multidecor_metal_material.png",
		"multidecor_bathroom_leakage.png",
		"multidecor_coarse_metal_material.png"
	},
	groups = {sink=1},
	bounding_boxes = {
		{-0.5, -0.5, -0.5, 1.5, -0.1, 0.5},
		{-0.5, -0.1, -0.35, -0.35, 0.5, 0.35},
		{1.35, -0.1, -0.35, 1.5, 0.5, 0.35},
		{-0.5, -0.1, -0.5, 1.5, 0.5, -0.35},
		{-0.5, -0.1, 0.35, 1.5, 0.5, 0.5}
	}
},
{
	seat_data = {
		pos = {x=0.8, y=0.2, z=0.0},
		rot = {x=0, y=0, z=0},
		model = multidecor.sitting.standard_model,
		anims = {"sit1", "sit2"}
	}
}}

multidecor.register.register_seat("bathtub", bathtub_def[1], bathtub_def[2])

local ceramic_tiles = {
	"darkceladon",
	"darksea",
	"light",
	"sand",
	"red",
	"green_mosaic"
}

local tile_bboxes = {
	type = "wallmounted",
	wall_top = {-0.5, 0.4, -0.5, 0.5, 0.5, 0.5},
	wall_bottom = {-0.5, -0.5, -0.5, 0.5, -0.4, 0.5},
	wall_side = {-0.5, -0.5, -0.5, -0.4, 0.5, 0.5}

}

for _, tile in ipairs(ceramic_tiles) do
	local tile_name = "multidecor:bathroom_ceramic_" .. tile .. "_tile"
	local tex_name = "multidecor_bathroom_ceramic_" .. tile .. "_tile.png"
	local upper_tile = multidecor.helpers.upper_first_letters(tile)

	minetest.register_node(":" .. tile_name, {
		description = "Bathroom Ceramic " .. upper_tile .. " Tile",
		drawtype = "nodebox",
		visual_scale = 1.0,
		paramtype = "light",
		paramtype2 = "wallmounted",
		tiles = {tex_name},
		groups = {cracky=1.5},
		node_box = tile_bboxes,
		selection_box = tile_bboxes,
		sounds = default.node_sound_stone_defaults()
	})

	local block_name = "multidecor:bathroom_ceramic_" .. tile .. "_tiles_block"
	minetest.register_node(":" .. block_name, {
		description = "Bathroom Ceramic " .. upper_tile .. " Tiles Block",
		visual_scale = 0.5,
		paramtype = "light",
		paramtype2 = "facedir",
		tiles = {tex_name},
		groups = {cracky=1.5},
		sounds = default.node_sound_stone_defaults()
	})

	local bathtub_with_shields_def = table.copy(bathtub_def)
	bathtub_with_shields_def[1].description = "Bathtub With " .. upper_tile .. " Shields"
	bathtub_with_shields_def[1].mesh = "multidecor_bathtub_with_shields.b3d"
	table.insert(bathtub_with_shields_def[1].tiles, tex_name)

	multidecor.register.register_seat("bathtub_with_shields_" .. tile, bathtub_with_shields_def[1], bathtub_with_shields_def[2])

	multidecor.register.register_table("bathroom_washbasin_" .. tile, {
		style = "modern",
		material = "stone",
		description = "Bathroom Washbasin With " .. upper_tile .. " Doors",
		mesh = "multidecor_bathroom_washbasin.b3d",
		visual_scale = 0.5,
		inventory_image = "multidecor_bathroom_" .. tile .. "_washbasin_inv.png",
		tiles = {
			"multidecor_marble_material.png",
			"multidecor_metal_material.png",
			"multidecor_coarse_metal_material.png",
			"multidecor_bathroom_leakage.png",
			tex_name,
		},
		groups = {sink=1},
		bounding_boxes = {
			{-0.375, -0.5, -0.075, 0.375, 0.25, 0.5},
			{-0.5, 0.25, -0.4, -0.4, 0.5, 0.5}, 		-- left
			{0.4, 0.25, -0.4, 0.5, 0.5, 0.5},			-- right
			{-0.4, 0.25, -0.4, 0.4, 0.5, -0.2},			-- front
			{-0.4, 0.25, 0.3, 0.4, 0.5, 0.5}			-- back
		},
		callbacks = {
			on_construct = function(pos)
				multidecor.shelves.set_shelves(pos)

				multidecor.tap.register_water_stream(pos, {x=0.0, y=0.65, z=-0.1}, {x=0.0, y=0.65, z=-0.1}, 30, 2, {x=0, y=-1, z=0}, "multidecor_tap", false)
			end,
			can_dig = multidecor.shelves.default_can_dig,
			on_rightclick = function(pos)
				multidecor.tap.toggle(pos)
			end,
			on_destruct = function(pos)
				multidecor.tap.off(pos)
			end
		}
	},
	{
		shelves_data = {
			common_name = "bathroom_washbasin_" .. tile,
			{
				type = "sym_doors",
				pos = {x=0.35, y=-0.2, z=0.08},
				pos2 = {x=-0.35, y=-0.2, z=0.08},
				base_texture = tex_name,
				object = "modern:bathroom_washbasin_door",
				inv_size = {w=5,h=3},
				acc = 1,
				sounds = {
					open = "multidecor_squeaky_door_open",
					close = "multidecor_squeaky_door_close"
				}
			}
		}
	})

	multidecor.register.register_table("bathroom_wall_cabinet_" .. tile, {
		style = "modern",
		material = "wood",
		description = "Bathroom Wall Cabinet With " .. upper_tile .. " Doors",
		mesh = "multidecor_bathroom_wall_cabinet.b3d",
		visual_scale = 0.5,
		tiles = {"multidecor_white_pine_wood.png"},
		inventory_image = "multidecor_bathroom_" .. tile .. "_wall_cabinet_inv.png",
		bounding_boxes = {
			{-0.5, -0.5, -0.1, 0.5, 0.5, 0.5}
		},
		callbacks = {
			on_construct = function(pos)
				multidecor.shelves.set_shelves(pos)
			end,
			can_dig = multidecor.shelves.default_can_dig
		}
	},
	{
		shelves_data = {
			common_name = "bathroom_wall_cabinet_" .. tile,
			{
				type = "sym_doors",
				pos = {x=0.5, y=0, z=0.1},
				pos2 = {x=-0.5, y=0, z=0.1},
				base_texture = tex_name,
				object = "modern:bathroom_wall_cabinet_door",
				inv_size = {w=6,h=4},
				acc = 1,
				sounds = {
					open = "multidecor_squeaky_door_open",
					close = "multidecor_squeaky_door_close"
				}
			}
		}
	})

	multidecor.register.register_table("bathroom_wall_set_with_mirror_" .. tile, {
		style = "modern",
		material = "wood",
		visual_scale = 0.5,
		description = "Bathroom " .. upper_tile .. "Wall Set With Mirror",
		mesh = "multidecor_bathroom_wall_set_with_mirror.b3d",
		tiles = {
			"multidecor_white_pine_wood.png",
			"multidecor_gloss.png",
			"multidecor_plastic_material.png",
			"multidecor_metal_material.png",
			"multidecor_bathroom_set.png",
			"multidecor_shred.png"
		},
		inventory_image = "multidecor_bathroom_" .. tile .. "_wall_set_with_mirror_inv.png",
		bounding_boxes = {{-0.5, -1.0, -0.125, 0.5, 0.5, 0.5}},
		callbacks = {
			on_construct = function(pos)
				multidecor.shelves.set_shelves(pos)
			end,
			can_dig = multidecor.shelves.default_can_dig
		}
	},
	{
		shelves_data = {
			common_name = "bathroom_wall_set_with_mirror_" .. tile,
			{
				type = "door",
				pos = {x=0.5, y=-0.25, z=0.05},
				base_texture = tex_name,
				object = "modern:bathroom_wall_set_with_mirror_door",
				inv_size = {w=5,h=2},
				side = "left",
				acc = 1,
				sounds = {
					open = "multidecor_squeaky_door_open",
					close = "multidecor_squeaky_door_close"
				}
			}
		}
	})
end

multidecor.register.register_furniture_unit("bathroom_fluffy_rug", {
	type = "decoration",
	style = "modern",
	material = "plastic",
	visual_scale = 0.5,
	description = "Bathroom Fluffy Rug",
	mesh = "multidecor_bathroom_fluffy_rug.b3d",
	tiles = {
		"multidecor_fluff_material.png"
	},
	bounding_boxes = {{-0.45, -0.5, -0.3, 0.45, -0.4, 0.3}}
})

multidecor.register.register_furniture_unit("bathroom_sink", {
	type = "decoration",
	style = "modern",
	material = "stone",
	visual_scale = 0.5,
	description = "Bathroom Sink",
	mesh = "multidecor_bathroom_sink.b3d",
	groups = {sink=1},
	tiles = {
		"multidecor_marble_material.png",
		"multidecor_metal_material.png",
		"multidecor_coarse_metal_material.png",
		"multidecor_bathroom_leakage.png"
	},
	bounding_boxes = {
		{-0.5, -0.5, -0.4, 0.5, 0.25, 0.5},
		{-0.5, 0.25, -0.4, -0.4, 0.5, 0.5}, 		-- left
		{0.4, 0.25, -0.4, 0.5, 0.5, 0.5},			-- right
		{-0.4, 0.25, -0.4, 0.4, 0.5, -0.3},			-- front
		{-0.4, 0.25, 0.4, 0.3, 0.5, 0.5}			-- back
	}
})

multidecor.register.register_seat("toilet", {
	style = "modern",
	material = "stone",
	visual_scale = 0.5,
	description = "Toilet",
	mesh = "multidecor_toilet.b3d",
	tiles = {
		"multidecor_marble_material.png",
		"multidecor_metal_material.png",
		"multidecor_water.png"
	},
	bounding_boxes = {
		{-0.3, -0.5, -0.4, 0.3, -0.4, 0.5},		-- down
		{-0.3, -0.4, -0.4, -0.2, -0.1, 0.3},	-- left
		{0.2, -0.4, -0.4, 0.3, -0.1, 0.3},		-- right
		{-0.2, -0.4, -0.4, 0.2, -0.1, -0.3},	-- front
		{-0.3, -0.1, 0.3, 0.3, 0.475, 0.5}		-- back
	},
	callbacks = {
		on_punch = function(pos, node, puncher)
			local dir = multidecor.helpers.get_dir(pos)
			local rel_pos_min = multidecor.helpers.rotate_to_node_dir(pos, vector.new(-0.125, -0.2, 0.05))
			local rel_pos_max = multidecor.helpers.rotate_to_node_dir(pos, vector.new(0.125, -0.2, -0.175))

			minetest.add_particlespawner({
				amount = 40,
				time = 0.1,
				minexptime = 3,
				maxexptime = 5,
				collisiondetection = true,
				object_collision = true,
				collision_removal = true,
				texture = "multidecor_water_drop.png",
				minpos = pos+rel_pos_min,
				maxpos = pos+rel_pos_max,
				minvel = dir*0.5,
				maxvel = dir*0.5,
				minacc = vector.new(0, -9.8, 0),
				maxacc = vector.new(0, -9.8, 0),
				minsize = 0.8,
				maxsize = 1.5
			})

			minetest.sound_play("multidecor_toilet_flush", {gain=1.0, pitch=1.0, pos=pos, max_hear_distance=15})
		end
	}
},
{
	seat_data = {
		pos = {x=0.0, y=-0.1, z=0.0},
		rot = {x=0, y=0, z=0},
		model = multidecor.sitting.standard_model,
		anims = {"sit1"}
	}
}
)

multidecor.register.register_curtain("bathroom_curtain", {
	style = "modern",
	material = "plastic",
	visual_scale = 0.5,
	bounding_boxes = {
		{-0.5, -0.5, -0.1, 0.5, 0.5, 0.1}
	}
},
{
	common_name = "bathroom_curtain",
	curtains_data = {
		sound = "multidecor_curtain_sliding",
		curtain_with_rings = {
			name = "bathroom_curtain_with_rings",
			description = "Bathroom Curtain With Rings",
			mesh = "multidecor_curtain_with_rings.b3d",
			tiles = {"multidecor_cloth.png", "multidecor_metal_material.png"}
		},
		curtain = {
			name = "bathroom_curtain",
			description = "Bathroom Curtain",
			mesh = "multidecor_curtain.b3d",
			tiles = {"multidecor_cloth.png"}
		}
	}
})

multidecor.register.register_table("plastic_quadratic_cornice", {
	style = "modern",
	material = "plastic",
	visual_scale = 0.5,
	description = "Plastic Quadratic Cornice",
	mesh = "multidecor_quadratic_cornice.b3d",
	tiles = {"multidecor_plastic_material.png"},
	groups = {hanger=1},
	bounding_boxes = {
		{-0.5, -0.45, -0.1, 0.5, -0.25, 0.1}
	},
	callbacks = {
		on_construct = function(pos)
			multidecor.connecting.update_adjacent_nodes_connection(pos, "directional")
		end,
		after_dig_node = function(pos, old_node)
			multidecor.connecting.update_adjacent_nodes_connection(pos, "directional", true, old_node)
		end
	}
},
{
	common_name = "plastic_quadratic_cornice",
	connect_parts = {
		["left_side"] = "multidecor_quadratic_cornice_1.b3d",
		["right_side"] = "multidecor_quadratic_cornice_2.b3d",
		["middle"] = "multidecor_quadratic_cornice_3.b3d",
		["corner"] = "multidecor_quadratic_cornice_4.b3d"
	},
})

multidecor.register.register_furniture_unit("bathroom_tap_with_cap_flap", {
	type = "decoration",
	style = "modern",
	material = "metal",
	visual_scale = 0.5,
	description = "Bathroom Tap With Cap Flap",
	mesh = "multidecor_bathroom_tap_with_cap_flap.b3d",
	tiles = {"multidecor_metal_material.png"},
	bounding_boxes = {{-0.3, -0.1, 0.0, 0.3, 0.2, 0.5}},
	callbacks = {
		on_construct = function(pos)
			multidecor.tap.register_water_stream(pos, {x=0.0, y=-0.2, z=0.0}, {x=0.0, y=-0.2, z=0.0}, 30, 2, {x=0, y=-1, z=0}, "multidecor_tap", true)

			minetest.get_node_timer(pos):start(1)
		end,
		on_rightclick = multidecor.tap.default_on_rightclick,
		on_destruct = multidecor.tap.default_on_destruct,
		on_timer = multidecor.tap.default_on_timer
	}
})

multidecor.register.register_furniture_unit("bathroom_tap_with_side_flaps", {
	type = "decoration",
	style = "modern",
	material = "metal",
	visual_scale = 0.5,
	description = "Bathroom Tap With Side Flaps",
	mesh = "multidecor_bathroom_tap_with_side_flaps.b3d",
	tiles = {"multidecor_metal_material.png"},
	bounding_boxes = {{-0.3, -0.2, 0.0, 0.3, 0.1, 0.5}},
	callbacks = {
		on_construct = function(pos)
			multidecor.tap.register_water_stream(pos, {x=0.0, y=-0.3, z=0.0}, {x=0.0, y=-0.3, z=0.0}, 30, 2, {x=0, y=-1, z=0}, "multidecor_tap", true)

			minetest.get_node_timer(pos):start(1)
		end,
		on_rightclick = multidecor.tap.default_on_rightclick,
		on_destruct = multidecor.tap.default_on_destruct,
		on_timer = multidecor.tap.default_on_timer
	}
})

multidecor.register.register_furniture_unit("shower_head", {
	type = "decoration",
	style = "modern",
	material = "metal",
	visual_scale = 0.5,
	description = "Shower Head",
	mesh = "multidecor_shower_head.b3d",
	tiles = {"multidecor_metal_material5.png", "multidecor_shower_head.png"},
	bounding_boxes = {{-0.2, -0.5, -0.2, 0.2, 0.35, 0.5}},
	callbacks = {
		on_construct = function(pos)
			multidecor.tap.register_water_stream(pos, {x=-0.15, y=0.05, z=-0.1}, {x=0.15, y=0.2, z=-0.1}, 40, 2,
				vector.rotate_around_axis(vector.new(0, 1, 0), vector.new(1, 0, 0), -math.pi/3), "multidecor_tap", true)

			minetest.get_node_timer(pos):start(1)
		end,
		on_rightclick = multidecor.tap.default_on_rightclick,
		on_destruct = multidecor.tap.default_on_destruct,
		on_timer = multidecor.tap.default_on_timer
	}
})

multidecor.register.register_furniture_unit("crooked_shower_head", {
	type = "decoration",
	style = "modern",
	material = "metal",
	visual_scale = 0.5,
	description = "Crooked Shower Head",
	mesh = "multidecor_crooked_shower_head.b3d",
	tiles = {"multidecor_coarse_metal_material.png", "multidecor_crooked_shower_head.png"},
	bounding_boxes = {{-0.2, -0.3, -0.3, 0.2, 0.3, 0.5}},
	callbacks = {
		on_construct = function(pos)
			multidecor.tap.register_water_stream(pos, {x=-0.25, y=-0.4, z=-0.25}, {x=0.25, y=-0.4, z=0.25}, 40, 2, {x=0, y=-1, z=0}, "multidecor_tap", true)

			minetest.get_node_timer(pos):start(1)
		end,
		on_rightclick = multidecor.tap.default_on_rightclick,
		on_destruct = multidecor.tap.default_on_destruct,
		on_timer = multidecor.tap.default_on_timer
	}
})

multidecor.register.register_furniture_unit("bathroom_mirror", {
	type = "decoration",
	style = "modern",
	material = "glass",
	visual_scale = 0.5,
	description = "Bathroom Mirror",
	mesh = "multidecor_bathroom_mirror.b3d",
	tiles = {"multidecor_gloss.png"},
	bounding_boxes = {{-0.4, -0.5, 0.4, 0.4, 0.5, 0.5}}
})

multidecor.register.register_furniture_unit("toilet_paper_reel", {
	type = "decoration",
	style = "modern",
	material = "plastic",
	visual_scale = 0.5,
	description = "Toilet Paper Reel",
	mesh = "multidecor_toilet_paper_reel.b3d",
	tiles = {"multidecor_metal_material5.png", "multidecor_wool_material.png"},
	bounding_boxes = {{-0.3, -0.2, 0.0, 0.3, 0.2, 0.5}}
})

multidecor.register.register_furniture_unit("underwear_tank", {
	type = "decoration",
	style = "modern",
	material = "plastic",
	description = "Underwear Tank",
	mesh = "multidecor_underwear_tank.b3d",
	visual_scale = 0.5,
	tiles = {"multidecor_shred.png"},
	bounding_boxes = {{-0.4, -0.5, -0.3, 0.4, 0.35, 0.3}},
	callbacks = {
		on_construct = function(pos)
			multidecor.shelves.set_shelves(pos)
		end,
		can_dig = multidecor.shelves.default_can_dig
	},
	add_properties = {
		shelves_data = {
			common_name = "underwear_tank",
			{
				type = "door",
				object = "modern:underwear_tank_cover",
				pos = {x=0, y=0.375, z=-0.3},
				acc = 1,
				inv_size = {w=5,h=4},
				side = "up",
				sounds = {
					open = "multidecor_cabinet_door_open",
					close = "multidecor_cabinet_door_close"
				}
			}
		}
	}
})


minetest.register_entity("modern:bathroom_washbasin_door", {
	visual = "mesh",
	visual_size = {x=5, y=5, z=5},
	mesh = "multidecor_bathroom_washbasin_door.b3d",
	textures = {"multidecor_" .. ceramic_tiles[1] .. ".png", "multidecor_metal_material.png"},
	use_texture_alpha = true,
	physical = false,
	backface_culling = false,
	selectionbox = {-0.35, -0.3, -0.05, 0.0, 0.3, 0.0},
	static_save = true,
	on_activate = multidecor.shelves.default_on_activate,
	on_rightclick = multidecor.shelves.default_on_rightclick,
	on_step = multidecor.shelves.default_door_on_step,
	get_staticdata = multidecor.shelves.default_get_staticdata
})

minetest.register_entity("modern:bathroom_wall_cabinet_door", {
	visual = "mesh",
	visual_size = {x=5, y=5, z=5},
	mesh = "multidecor_bathroom_wall_cabinet_door.b3d",
	textures = {"multidecor_" .. ceramic_tiles[1] .. ".png", "multidecor_metal_material.png"},
	use_texture_alpha = true,
	physical = false,
	backface_culling = false,
	selectionbox = {-0.5, -0.53, 0.0, 0, 0.53, 0.05},
	static_save = true,
	on_activate = multidecor.shelves.default_on_activate,
	on_rightclick = multidecor.shelves.default_on_rightclick,
	on_step = multidecor.shelves.default_door_on_step,
	get_staticdata = multidecor.shelves.default_get_staticdata
})

minetest.register_entity("modern:bathroom_wall_set_with_mirror_door", {
	visual = "mesh",
	visual_size = {x=5, y=5, z=5},
	mesh = "multidecor_bathroom_wall_set_with_mirror_door.b3d",
	textures = {"multidecor_" .. ceramic_tiles[1] .. ".png", "multidecor_metal_material.png"},
	use_texture_alpha = true,
	physical = false,
	backface_culling = false,
	selectionbox = {-0.35, -0.8, 0, 0, 0.7, 0.075},
	static_save = true,
	on_activate = multidecor.shelves.default_on_activate,
	on_rightclick = multidecor.shelves.default_on_rightclick,
	on_step = multidecor.shelves.default_door_on_step,
	get_staticdata = multidecor.shelves.default_get_staticdata
})

minetest.register_entity("modern:underwear_tank_cover", {
	visual = "mesh",
	visual_size = {x=5, y=5, z=5},
	mesh = "multidecor_underwear_tank_cover.b3d",
	textures = {"multidecor_shred.png", "multidecor_metal_material.png"},
	physical = false,
	backface_culling = false,
	selectionbox = {-0.4, 0.0, 0.05, 0.4, 0.15, 0.55},
	static_save = true,
	on_activate = multidecor.shelves.default_on_activate,
	on_rightclick = multidecor.shelves.default_on_rightclick,
	on_step = multidecor.shelves.default_door_on_step,
	get_staticdata = multidecor.shelves.default_get_staticdata
})
