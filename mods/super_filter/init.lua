-- Список "заборонених коренів"
local toxic_roots = {"ебан", "уїбан", "хуй", "нахуй", "пздц", "йоб", "трах" , "бля", "пізда", "гондон", "ебало", "сука", "хуе" , "гей", "ебло", "даун", "пизда", "курв"
   "хуй", "пизд", "пізд", "бля", "йоб", "їб", "єб", "сук", 
    "курв", "мудак", "підар", "підор", "гандон", "залуп"
-- Англійська (EN)
"fuck", "fuk", "shyt", "shit", "bitch", "dick", "nigg", "assh",
   "cunt", "bastard","fuck", "fuk", "fck", "bitch", "shit", "sh1t", "dick", "pussy", "asshole", "nigger", "nigga", "bastard", "slut", "whore"
   
 -- Польська (PL) - бо вони часто грають на таких серверах
"kurw", "pierdol", "jeb", "huj",
        
-- Трансліт (коли пишуть наші мати англійськими буквами)
"pizd", "ebat", "huy", "blya", "suka", "yob"

minetest.register_on_chat_message(function(name, message)
    local low_message = message:lower()
    
    -- Прибираємо крапки, пробіли та символи, якими намагаються обійти фільтр
    local clean_message = low_message:gsub("[%s%p%d]", "") 

    for _, root in ipairs(toxic_roots) do
        if clean_message:find(root) then
            -- Що ми робимо з порушником:
            minetest.chat_send_all("🚫 Гравець " .. name .. " намагався бути занадто 'розумним', але фільтр не пройдеш!")
            
            -- Замість бана можна дати МУТ (заборону писати) на 5 хвилин
            local privs = minetest.get_privs(name)
            privs.shout = nil -- Забираємо право кричати (писати в чат)
            minetest.set_privs(name, privs)
            
            minetest.chat_send_player(name, "🤫 Тобі видано мут на 5 хвилин за матюки!")
            
            -- Повертаємо доступ через 300 секунд
            minetest.after(300, function()
                local p = minetest.get_privs(name)
                p.shout = true
                minetest.set_privs(name, p)
                minetest.chat_send_player(name, "🗣️ Мут знято. Пиши культурно!")
            end)

            return true -- Повідомлення не з'явиться в чаті
        end
    end
end)
-- СПИСОК ЗАБОРОНЕНИХ ДОМЕНІВ (можна додавати свої)
local link_patterns = {
    "http://", "https://", "www%.", "%.com", "%.net", "%.org", 
    "%.ru", "%.ua", "%.gg", "%.me", "%.tk", "%.xyz"
}

minetest.register_on_chat_message(function(name, message)
    local low_message = string.lower(message)
    
    -- Перевіряємо повідомлення на наявність посилань
    for _, pattern in ipairs(link_patterns) do
        if string.find(low_message, pattern) then
            -- 1. Пишемо попередження самому гравцю
            minetest.chat_send_player(name, "🚫 Реклама та посилання ЗАБОРОНЕНІ! Не роби так більше.")
            
            -- 2. (Опціонально) Пишемо адмінам або в загальний чат про порушника
            minetest.log("action", "Гравець " .. name .. " намагався скинути лінк: " .. message)
            
            -- 3. Блокуємо відправку повідомлення
            return true 
        end
    end
end)
   local last_chat_time = {} -- Тут зберігаємо час останнього повідомлення кожного гравця
local chat_delay = 3      -- Затримка в секундах (можеш змінити на 5, якщо спамлять сильно)

minetest.register_on_chat_message(function(name, message)
    local now = os.time()
    
    -- Перевіряємо, чи писав гравець нещодавно
    if last_chat_time[name] and (now - last_chat_time[name]) < chat_delay then
        local wait_time = chat_delay - (now - last_chat_time[name])
        minetest.chat_send_player(name, "⏳ Не спам! Зачекай ще " .. wait_time .. " сек.")
        return true -- Блокуємо повідомлення
    end
    
    -- Оновлюємо час останнього повідомлення
    last_chat_time[name] = now
end)
   minetest.register_on_dieplayer(function(player)
    local name = player:get_player_name()
    local pos = player:get_pos()
    
    -- Округляємо координати для зручності
    local x = math.floor(pos.x)
    local y = math.floor(pos.y)
    local z = math.floor(pos.z)
    
    -- Повідомлення для всіх (або можна зробити тільки для адміна)
    local death_msg = "💀 Гравець " .. name .. " загинув на координатах: X=" .. x .. " Y=" .. y .. " Z=" .. z
    
    minetest.chat_send_all(death_msg)
    
    -- Записуємо в системний лог сервера (видно в консолі)
    minetest.log("action", death_msg)
end)
