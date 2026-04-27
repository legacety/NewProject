script_version('4')

-- Подключаем библиотеку для работы с кодировками
local encoding = require('encoding')
encoding.default = 'CP1251'
local u8 = encoding.UTF8

function checkUpdate()
    local dlstatus = require('moonloader').download_status
    local url = 'https://raw.githubusercontent.com/legacety/NewProject/refs/heads/main/update.json'
    
    local requests = require('requests')
    
    -- Выполняем запрос
    local response = requests.get(url)
    
    if response.status_code == 200 then
        -- Конвертируем полученный текст из UTF-8 (стандарт GitHub) в Windows-1251
        local json_text = u8:decode(response.text)
        local data = decodeJson(json_text)
        
        local lastver = tostring(data['last'])
        
        -- Сравнение версии
        if lastver ~= thisScript().version then
            sampAddChatMessage('{33AAFF}[Updater]: {FFFFFF}Обнаружено обновление. Загрузка...', -1)
            
            -- Скачивание файла
            downloadUrlToFile(data['url'], thisScript().path, function(id, status, p1, p2)
                if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                    sampAddChatMessage('{33AAFF}[Updater]: {FFFFFF}Скрипт обновлен, перезагрузка...', -1)
                    thisScript():reload()
                end
            end)
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
