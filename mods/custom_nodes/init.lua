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
-- 4. Стовбур яблуні
minetest.register_node("custom_nodes:apple_tree", {
    description = "Apple Tree Log",
    tiles = {"apple_tree.png"},
    is_ground_content = false,
    groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
    sounds = default.node_sound_wood_defaults(),
})

-- 5. Дошки яблуні (підлога)
minetest.register_node("custom_nodes:apple_planks", {
    description = "Apple Wood Planks",
    tiles = {"apple_planks.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
    sounds = default.node_sound_wood_defaults(),
})

---- КРАФТ ТЕПЕР ПРАВИЛЬНИЙ ----

-- З 1 стовбура яблуні -> 4 дошки яблуні
minetest.register_craft({
    output = "custom_nodes:apple_planks 4",
    recipe = {
        {"custom_nodes:apple_tree"},
    }
})

-- З 2 дошок яблуні -> 4 ЗВИЧАЙНІ ПАЛИЦІ (як ти і хотів)
minetest.register_craft({
    output = "default:stick 4",
    recipe = {
        {"custom_nodes:apple_planks"},
        {"custom_nodes:apple_planks"},
    }
})
-- 7. Магічне Яблуко (Предмет)
minetest.register_craftitem("custom_nodes:magic_apple", {
    description = "Magic Apple (Speed & Jump)",
    inventory_image = "magic_apple.png",
    on_use = function(itemstack, user, pointed_thing)
        if user then
            -- Даємо ефекти (швидкість 2, стрибок 2)
            user:set_physics_override({
                speed = 2.0,
                jump = 2.0,
            })
            
            -- Через 20 секунд повертаємо все як було
            minetest.after(20, function()
                if user:is_player() then
                    user:set_physics_override({
                        speed = 1.0,
                        jump = 1.0,
                    })
                    minetest.chat_send_player(user:get_player_name(), "Ефект магічного яблука закінчився!")
                end
            end)
            
            -- Видаляємо 1 яблуко з руки після їжі
            itemstack:take_item()
            return itemstack
        end
    end,
})

-- КРАФТ: Яблуко з Темної Руди
-- Тобі знадобиться звичайне яблуко і твоя темна руда
minetest.register_craft({
    output = "custom_nodes:magic_apple",
    recipe = {
        {"custom_nodes:dark_brick", "custom_nodes:dark_brick", "custom_nodes:dark_brick"},
        {"custom_nodes:dark_brick", "default:apple",          "custom_nodes:dark_brick"},
        {"custom_nodes:dark_brick", "custom_nodes:dark_brick", "custom_nodes:dark_brick"},
    }
})
-- 1. Скибка кавуна (їжа)
minetest.register_craftitem("custom_nodes:watermelon_slice", {
    description = "Watermelon Slice",
    inventory_image = "watermelon_slice.png",
    on_use = minetest.item_eat(2), -- Відновлює 1 сердечко (2 одиниці HP)
})

-- 2. Блок кавуна
minetest.register_node("custom_nodes:watermelon", {
    description = "Watermelon",
    tiles = {"watermelon_side.png"}, -- З усіх боків буде зелений
    groups = {snappy = 1, oddly_breakable_by_hand = 3},
    sounds = default.node_sound_wood_defaults(),
    
    -- Коли ламаємо блок - випадає 3-5 скибок
    drop = {
        max_items = 5,
        items = {
            {items = {"custom_nodes:watermelon_slice"}, rarity = 1},
            {items = {"custom_nodes:watermelon_slice"}, rarity = 1},
            {items = {"custom_nodes:watermelon_slice"}, rarity = 1},
        }
    },
})

-- 3. КРАФТ (для тесту): 4 палички твого яблука = 1 кавун
minetest.register_craft({
    output = "custom_nodes:watermelon",
    recipe = {
        {"custom_nodes:apple_stick", "custom_nodes:apple_stick"},
        {"custom_nodes:apple_stick", "custom_nodes:apple_stick"},
    }
})
-- 1. БЛОК ПОВЕРХНІ (Трава + Земля)
minetest.register_node("custom_nodes:dirt_with_grass", {
    description = "Земля з травою",
    tiles = {
        "dirt part 1.png",         -- ВЕРХ (тільки зелена трава)
        "dirt part 6.png",         -- НИЗ (твоя чиста земля)
        "dirt part 1 2 3 4.png"    -- БОКИ (твоя картинка з переходом)
    },
    groups = {crumbly = 3},
    sounds = default.node_sound_dirt_defaults(),
})

-- 2. БЛОК ГЛИБИНИ (Тільки земля)
minetest.register_node("custom_nodes:dirt", {
    description = "Dirt",
    tiles = {"dirt.png"},   -- Вона коричнева з усіх сторін
    groups = {crumbly = 3},
    sounds = default.node_sound_dirt_defaults(),
})

-- 3. ПІДМІНА В ГЕНЕРАТОРІ (Найважливіше!)
-- Це змусить гру заповнити весь світ твоїми блоками
minetest.register_alias("default:dirt", "custom_nodes:dirt")
minetest.register_alias("default:dirt_with_grass", "custom_nodes:dirt_with_grass")
-- РЕЄСТРАЦІЯ ТВОЄЇ СКРИНІ (СИНДУКА)
minetest.register_node("custom_nodes:my_chest", {
    description = "Chest",
    tiles = {
        "Syndyk_part_6.png",       -- зверху
        "Syndyk_part_6.png",       -- знизу
        "Syndyk_part_1.png",       -- боки (ліво/право)
        "Syndyk_part_1.png",       -- зад
        "Syndyk_part_5.png"        -- перед (там де защіпка!)
    },
    paramtype2 = "facedir", -- Це дозволяє скрині "повертатися" обличчям до гравця
    groups = {choppy = 2, oddly_breakable_by_hand = 2},
    sounds = default.node_sound_wood_defaults(),
})
-- РЕЄСТРАЦІЯ КАМЕНЮ ТА РУД
-- Камінь (Stone)
minetest.register_node("custom_nodes:stone", {
    description = "Stone",
    tiles = {"stone.png"},
    groups = {cracky = 3, stone = 1},
    sounds = default.node_sound_stone_defaults(),
})

-- Вугілля (Coal)
minetest.register_node("custom_nodes:stone_coal", {
    description = "Coal Ore",
    tiles = {"stone_coal.png"},
    groups = {cracky = 3},
    sounds = default.node_sound_stone_defaults(),
})

-- Залізо (Iron)
minetest.register_node("custom_nodes:stone_iron", {
    description = "Iron Ore",
    tiles = {"stone_iron.png"},
    groups = {cracky = 2}, -- Залізо трохи важче копати
    sounds = default.node_sound_stone_defaults(),
})

-- Золото (Gold)
minetest.register_node("custom_nodes:stone_gold", {
    description = "Gold Ore",
    tiles = {"stone_gold.png"},
    groups = {cracky = 2},
    sounds = default.node_sound_stone_defaults(),
})

-- ПІДМІНА В ГЕНЕРАТОРІ СВІТУ
minetest.register_alias("default:stone", "custom_nodes:stone")
minetest.register_alias("default:stone_with_coal", "custom_nodes:stone_coal")
minetest.register_alias("default:stone_with_iron", "custom_nodes:stone_iron")
