script_version("5.0")

local dlstatus = require('moonloader').download_status

function main()
    while not isSampAvailable() do wait(100) end
    check_update()
    wait(-1)
end

function check_update()
    -- Ссылка на твой основной JSON файл
    local json_url = "https://raw.githubusercontent.com/legacety/NewProject/refs/heads/main/update.json"
    local path = os.getenv('TEMP') .. '\\update_tmp.json'

    downloadUrlToFile(json_url, path, function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            local f = io.open(path, 'r')
            if f then
                local content = f:read('*a')
                f:close()
                os.remove(path)
                
                -- Используем структуру из твоего файла: {"info": {"version": "...", "url": "..."}}
                local data = decodeJson(content)
                if data and data.info and data.info.version ~= thisScript().version then
                    sampAddChatMessage("{3399FF}[Update]{FFFFFF} Найдена новая версия: " .. data.info.version, -1)
                    -- Качаем по прямой ссылке из JSON (data.info.url)
                    downloadUrlToFile(data.info.url, thisScript().path, function(id, status, p1, p2)
                        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                            sampAddChatMessage("{3399FF}[Update]{FFFFFF} Скрипт успешно обновлен. Перезагрузка...", -1)
                            thisScript():reload()
                        end
                    end)
                end
            end
        end
    end)
end
