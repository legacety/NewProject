local requests = require('requests')
local encoding = require('encoding')
encoding.default = 'CP1251'
local u8 = encoding.UTF8
script_version("1.61")

function checkUpdate()
    lua_thread.create(function()
        local ok, response = pcall(requests.get, "https://raw.githubusercontent.com/legacety/NewProject/refs/heads/main/update.json")
        if ok and response.status_code == 200 then
            local data = response.json()
            if data and data.info and data.info.version then
                local newVersion = tonumber(data.info.version)
                local currentVersion = tonumber(thisScript().version)
                if newVersion > currentVersion then
                    sampAddChatMessage(u8:decode(string.format("{00FF00}[Update] {FFFFFF}Найдено обновление! С версии {FF0000}%s {FFFFFF}до {00FF00}%s{FFFFFF}. Загрузка...", thisScript().version, data.info.version)), -1)
                    downloadUpdate(data.info.url)
                end
            end
        end
    end)
end

function downloadUpdate(url)
    lua_thread.create(function()
        local ok, response = pcall(requests.get, url)
        if ok and response.status_code == 200 then
            local file = io.open(thisScript().path, "wb")
            if file then
                file:write(response.content)
                file:close()
                sampAddChatMessage(u8:decode("{00FF00}[Update] {FFFFFF}Скрипт успешно обновлен и перезагружен!"), -1)
                thisScript():reload()
            end
        else
            sampAddChatMessage(u8:decode("{FF0000}[Update] {FFFFFF}Ошибка при скачивании обновления."), -1)
        end
    end)
end

function main()
    while not isSampAvailable() do wait(100) end
    checkUpdate()
    wait(-1)
end