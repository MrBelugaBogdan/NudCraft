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
-- 3. Стрибучий блок (Батут)
minetest.register_node("custom_nodes:trampoline", {
    description = "Super Trampoline",
    tiles = {"trampoline.png"},
    groups = {snappy = 3, choppy = 2}, -- Його легко зламати сокирою або мечем
    sounds = default.node_sound_wood_defaults(),
    
    -- МАГІЯ СТРИБКА:
    on_step = function(pos, player)
        -- Перевіряємо, чи це гравець
        if player:is_player() then
            -- Отримуємо поточну швидкість гравця
            local vel = player:get_velocity()
            -- Даємо потужний стусан вгору (швидкість 12)
            player:set_velocity({x = vel.x, y = 12, z = vel.z})
        end
    end,
})
