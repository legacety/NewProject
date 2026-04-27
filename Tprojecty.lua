script_version('3')

function checkUpdate()
    -- Используем стандартный samp.events или другие зависимости, если нужно
    -- Но для загрузки обычно достаточно встроенных функций
    local dlstatus = require('moonloader').download_status
    local url = 'https://raw.githubusercontent.com/legacety/NewProject/refs/heads/main/update.json'
    
    -- Для проверки обновлений лучше использовать asyncHttpRequest, чтобы не «фризить» игру
    -- Но раз в коде requests (библиотека), оставим логику схожей, добавив обработку кодировки текста
    local requests = require('requests')
    
    local response = requests.get(url)
    if response.status_code == 200 then
        local data = decodeJson(response.text)
        local lastver = tostring(data['last'])
        
        -- Сравнение версии
        if lastver ~= thisScript().version then
            sampAddChatMessage('{33AAFF}[Updater]: {FFFFFF}Обнаружено обновление. Загрузка...', -1)
            
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
