minetest.register_node("custom_nodes:dark_brick", {
    description = "Dark Brick",
    tiles = {"dark_brick.png"},
    is_ground_content = true,
    groups = {cracky = 3},
    sounds = default.node_sound_stone_defaults(),
})
-- Другий блок: Армоване скло
minetest.register_node("custom_nodes:reinforced_glass", {
    description = "Reinforced Glass",
    drawtype = "glasslike", -- Магія! Це робить блок прозорим
    tiles = {"reinforced_glass.png"},
    paramtype = "light",
    sunlight_propagates = true, -- Світло проходить крізь нього
    use_texture_alpha = "blend", 
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    sounds = default.node_sound_glass_defaults(),
})
