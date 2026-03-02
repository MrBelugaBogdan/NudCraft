local storage = minetest.get_mod_storage()

-- Функція для отримання балансу
local function get_balance(name)
    return storage:get_int(name) or 0
end

-- Функція для додавання монет
local function add_money(name, amount)
    local bal = get_balance(name)
    storage:set_int(name, bal + amount)
end

-- 1. ЩОДЕННИЙ БОНУС ПРИ ВХОДІ
minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    add_money(name, 10)
    minetest.chat_send_player(name, "💰 Привіт! Твій щоденний бонус +10 монет! Баланс: " .. get_balance(name))
end)

-- 2. МОНЕТИ ЗА ЧАС У ГРІ (Кожні 5 хвилин)
local timer = 0
minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    if timer >= 300 then -- 300 секунд = 5 хвилин
        for _, player in ipairs(minetest.get_connected_players()) do
            local name = player:get_player_name()
            add_money(name, 1)
            minetest.chat_send_player(name, "💵 +1 монета за активну гру!")
        end
        timer = 0
    end
end)

-- 3. КОМАНДА ДЛЯ ПЕРЕВІРКИ БАЛАНСУ
minetest.register_chatcommand("money", {
    description = "Перевірити свій баланс",
    func = function(name)
        return true, "💳 Твій баланс: " .. get_balance(name) .. " монет."
    end,
})
minetest.register_chatcommand("buy", {
    params = "<назва_товару>",
    description = "Купити ексклюзивний товар",
    func = function(name, param)
        local bal = get_balance(name)
        local player = minetest.get_player_by_name(name)
        
        if param == "heal" then -- Зілька лікування
            if bal >= 50 then
                add_money(name, -50)
                player:set_hp(20) -- Повне здоров'я
                return true, "🧪 Ти купив миттєве лікування за 50 монет!"
            else
                return false, "❌ Недостатньо монет! Треба 50."
            end
        elseif param == "sword" then -- Алмазний меч
            if bal >= 200 then
                add_money(name, -200)
                player:get_inventory():add_item("main", "default:sword_diamond")
                return true, "⚔️ Ти купив Алмазний меч за 200 монет!"
            else
                return false, "❌ Недостатньо монет! Треба 200."
            end
        end
        
        return false, "🛒 Доступні товари: heal (50), sword (200). Пиши /buy <назва>"
    end,
})
