script_version('5')

local encoding = require('encoding')
encoding.default = 'CP1251'
local u8 = encoding.UTF8

function checkUpdate()
    local url = 'https://raw.githubusercontent.com/legacety/NewProject/refs/heads/main/update.json'
    local requests = require('requests')
    
    local response = requests.get(url)
    if response.status_code == 200 then
        -- Парсим JSON (считаем, что в JSON может быть кириллица в UTF-8)
        local data = decodeJson(u8:decode(response.text))
        local lastver = tostring(data['last'])
        
        if lastver ~= thisScript().version then
            sampAddChatMessage('{33AAFF}[Updater]: {FFFFFF}Обнаружено обновление. Загрузка...', -1)
            
            -- Вместо downloadUrlToFile используем requests, чтобы перекодировать содержимое
            local res = requests.get(data['url'])
            if res.status_code == 200 then
                -- Переводим весь скачанный код скрипта из UTF-8 в Windows-1251
                local script_content = u8:decode(res.text)
                
                -- Сохраняем файл вручную в кодировке 1251
                local f = io.open(thisScript().path, 'wb')
                if f then
                    f:write(script_content)
                    f:close()
                    sampAddChatMessage('{33AAFF}[Updater]: {FFFFFF}Скрипт обновлен (CP1251), перезагрузка...', -1)
                    thisScript():reload()
                else
                    sampAddChatMessage('{33AAFF}[Updater]: {FFFFFF}Ошибка записи файла.', -1)
                end
            else
                sampAddChatMessage('{33AAFF}[Updater]: {FFFFFF}Ошибка при скачивании файла обновления.', -1)
            end
        else
            sampAddChatMessage('{33AAFF}[Updater]: {FFFFFF}У вас актуальная версия.', -1)
        end
    else
        sampAddChatMessage('{33AAFF}[Updater]: {FFFFFF}Ошибка проверки обновлений.', -1)
    end
end

function main()
    if not isSampLoaded() or not isSampAvailable() then return end
    checkUpdate()
    wait(-1)
end
