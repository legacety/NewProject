script_version('2')

function checkUpdate()
    local requests = require('requests')
    local dlstatus = require('moonloader').download_status
    local url = 'https://raw.githubusercontent.com/legacety/NewProject/refs/heads/main/update.json'
    
    local response = requests.get(url)
    if response.status_code == 200 then
        local data = decodeJson(response.text)
        local lastver = tostring(data['last'])
        
        if lastver ~= tostring(thisScript().version) then
            sampAddChatMessage('Обнаружено обновление. Загрузка...', -1)
            downloadUrlToFile(data['url'], thisScript().path, function(id, status, p1, p2)
                if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                    sampAddChatMessage('Скрипт обновлен, перезагрузка...', -1)
                    thisScript():reload()
                end
            end)
        else
            sampAddChatMessage('У вас актуальная версия.', -1)
        end
    else
        sampAddChatMessage('Ошибка проверки обновлений.', -1)
    end
end

function main()
    while not isSampAvailable() do wait(100) end
    checkUpdate()
    wait(-1)
end
