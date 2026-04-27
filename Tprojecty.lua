script_version('7')

local encoding = require('encoding')
encoding.default = 'CP1251'
local u8 = encoding.UTF8

function checkUpdate()
    local url = 'https://raw.githubusercontent.com/legacety/NewProject/refs/heads/main/update.json'
    local requests = require('requests')
    
    local response = requests.get(url)
    if response.status_code == 200 then
        local data = decodeJson(u8:decode(response.text))
        local lastver = tostring(data['last'])
        local curver = thisScript().version
        
        if lastver ~= curver then
            local res = requests.get(data['url'])
            if res.status_code == 200 then
                local script_content = u8:decode(res.text)
                local f = io.open(thisScript().path, 'wb')
                if f then
                    f:write(script_content)
                    f:close()
                    sampAddChatMessage('{00FFFF}[Updater]: {FFFFFF}Скрипт обновлен с версии {00FFFF}' .. curver .. ' {FFFFFF}до {00FFFF}' .. lastver, -1)
                    thisScript():reload()
                end
            end
        else
            sampAddChatMessage('{00FFFF}[Updater]: {FFFFFF}У вас актуальная версия {00FFFF}' .. curver .. '{FFFFFF}.', -1)
        end
    end
end

function main()
    if not isSampLoaded() or not isSampAvailable() then return end
    checkUpdate()
    wait(-1)
end
