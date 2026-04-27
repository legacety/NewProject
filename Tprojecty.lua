script_version("2.0")

local dlstatus = require('moonloader').download_status

function main()
    while not isSampAvailable() do wait(100) end
    
    lua_thread.create(function()
        local status, requests = pcall(require, 'requests')
        if not status then return print("Library 'requests' not found") end

        local url = "https://raw.githubusercontent.com/legacety/NewProject/refs/heads/main/update.json"
        local res = requests.get(url)

        if res.status_code == 200 then
            local data = decodeJson(res.text)
            
            if data and data.info and data.info.version ~= thisScript().version then
                sampAddChatMessage("{3399FF}[Update]{FFFFFF} Новая версия: " .. data.info.version, -1)
                
                downloadUrlToFile(data.info.url, thisScript().path, function(id, status, p1, p2)
                    -- Используем STATUS_ENDDOWNLOADDATA вместо числа 58
                    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                        sampAddChatMessage("{3399FF}[Update]{FFFFFF} Обновлено. Перезагрузка...", -1)
                        thisScript():reload()
                    end
                end)
            end
        end
    end)
    
    wait(-1)
end
