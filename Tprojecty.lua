script_version("2.0")

function main()
    while not isSampAvailable() do wait(100) end
    
    -- Создаем поток, чтобы запросы не фризили игру
    lua_thread.create(function()
        local status, requests = pcall(require, 'requests')
        if not status then return print("Library 'requests' not found") end

        local url = "https://raw.githubusercontent.com/legacety/NewProject/refs/heads/main/update.json"
        local res = requests.get(url)

        if res.status_code == 200 then
            -- Декодируем всё сразу в одну переменную 'data'
            local data = decodeJson(res.text)
            
            if data and data.info and data.info.version ~= thisScript().version then
                sampAddChatMessage("{3399FF}[Update]{FFFFFF} Новая версия: " .. data.info.version, -1)
                
                -- Загружаем сам файл обновления поверх текущего
                downloadUrlToFile(data.info.url, thisScript().path, function(id, dlstatus, p1, p2)
                    if dlstatus == 58 then -- STATUS_ENDDOWNLOADDATA
                        sampAddChatMessage("{3399FF}[Update]{FFFFFF} Обновлено. Перезагрузка...", -1)
                        thisScript():reload()
                    end
                end)
            end
        end
    end)
    
    wait(-1)
end
