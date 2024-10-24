-- local log = require 'log'
-- log.outfile = "D:\\aux_code.log"

_G.kRejected, _G.kAccepted, _G.kNoop = 0, 1, 2

local tags = { 'english', 'pinyin' }

local function check_tag(context)
    local composition = context.composition
    if (not composition:empty()) then
        local segment = composition:back()
        for _, x in ipairs(tags) do
            if segment:has_tag(x) then
                return true
            end
        end
    end
    return false
end

local function processor(key, env)
    local engine = env.engine
    local context = engine.context
    local repr = key:repr()
    local input = context.input
    -- log.info(repr, input, env.trigger_key)

    if check_tag(context) and repr == 'Return' then
        engine:commit_text(string.sub(input, 2))
        context.input = ''
        return kAccepted
    end

    return kNoop
end

return processor