script_version('8')

local encoding = require('encoding')
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local requests = require('requests')

function checkUpdate()
    local url = 'https://raw.githubusercontent.com/legacety/NewProject/refs/heads/main/update.json'
    
    local response = requests.get(url)
    if response.status_code == 200 then
        local data = decodeJson(u8:decode(response.text))
        
        local Ver = thisScript().version
        local newVer = tostring(data['version'])
        
        if newVer ~= Ver then
            local res = requests.get(data['url'])
            if res.status_code == 200 then
                local file = io.open(thisScript().path, 'wb')
                if file then
                    file:write(u8:decode(res.text))
                    file:close()
                    
                    sampAddChatMessage(string.format('{00FFFF}[Updater]: {FFFFFF}Обновлено: {00FFFF}%s {FFFFFF}-> {00FFFF}%s', Ver, newVer), -1)
                    thisScript():reload()
                end
            end
        else
            sampAddChatMessage('{00FFFF}[Updater]: {FFFFFF}У вас актуальная версия: {00FFFF}' .. Ver, -1)
        end
    end
end

function main()
    while not isSampAvailable() do wait(100) end
    checkUpdate()
    wait(-1)
end
