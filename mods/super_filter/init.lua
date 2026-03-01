-- Список "заборонених коренів"
local toxic_roots = {"ебан", "уїбан", "хуй", "нахуй", "пздц", "йоб", "трах" , "бля", "пізда", "гондон", "ебало", "сука", "хуе" , "гей", "ебло", "даун", "пизда", "курв"
-- Англійська (EN)
"fuck", "fuk", "shyt", "shit", "bitch", "dick", "nigg", "assh", "cunt", "bastard",
   
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
