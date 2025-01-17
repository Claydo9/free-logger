F_LOGGER = {}
F_LOGGER.sqlAddress = "freelogger_log_data"
local sqlAddres = F_LOGGER.sqlAddress
F_LOGGER.sqlInterval = 200
F_LOGGER.sqlQueryQueue = {}

F_LOGGER.maxLogs = CreateConVar( "freelogger_max_log_count", 10000, {FCVAR_ARCHIVE, FCVAR_PROTECTED}, "Sets the maximum amount of logs that can exsit at any time.", 1, 100000000 ):GetInt()
F_LOGGER.useSQL = CreateConVar( "freelogger_use_sql", 1, {FCVAR_ARCHIVE, FCVAR_PROTECTED}, "Sets whether or not logs should be persisted between sessions using SQL. [REQUIRES A SERVER RESTART]", 0, 1 ):GetBool()
F_LOGGER.useULX = ulx == nil and false or true
F_LOGGER.hooks = {}

F_LOGGER.supportedGamemodes = {
    ["unsupported"] = 0,
    ["sandbox"] = 1
}
F_LOGGER.serverGamemode = F_LOGGER.supportedGamemodes[string.lower( engine.ActiveGamemode() )] or F_LOGGER.supportedGamemodes.unsupported

F_LOGGER.logCategories = {
    ["Invalid"] = 0,
    ["PvP"] = 1,
    ["Entity"] = 2,
    ["Weapon"] = 3,
    ["Connection"] = 4,
    ["Communication"] = 5
}

F_LOGGER.dataStruct = {
    ["data"] = {}, -- Actual values being logged.
    ["category"] = F_LOGGER.logCategories.Invalid, -- The category the log falls under.
    ["owner"] = nil -- The players action(s) that are being logged. (nil if server.)
}

local function sqlQueueTick()
    if #F_LOGGER.sqlQueryQueue > 0 then
        local totalRows = tonumber( sql.Query( string.format( "SELECT COUNT( id, owner, data ) FROM %s", sqlAddres ) ) )
        local remainingRows = F_LOGGER.maxLogs - totalRows
        
        sql.Begin()
        if remainingRows < F_LOGGER.sqlQueryQueue then
            for i = 1, #F_LOGGER.sqlQueryQueue do
                sql.Query( "")
            end
        end
        
        for i, v in pairs( F_LOGGER.sqlQueryQueue ) do
            local query = string.format( "INSERT INTO %s( id, owner, data ) VALUES( %s, %s )", sqlAddres, tostring( v.owner) == "nil" and "SERVER", tostring( v.data ) )
            sql.Query( query )
            table.remove( F_LOGGER.sqlQueryQueue, i )
        end
        sql.Commit()
    end

    timer.Simple( F_LOGGER.sqlInterval, sqlQueueTick )
end


local function initSQL()
    if not sql.TableExists( sqlAddres ) then
        local query = string.format( "CREATE TABLE %s( id, NUMBER owner TEXT, data TEXT )", sqlAddres )
        sql.Query( query )
        sqlQueueTick()
    end
end

local function initialize()
    if F_LOGGER.useSQL then
        initSQL()
    else
        F_LOGGER.logData = {}

        for i, v in pairs( F_LOGGER.logCategories ) do
            F_LOGGER.logData[i] = {}
        end
    end
end

-- This function expects a dataStruct
local function _log( dataStruct )
    local data, category, owner = dataStruct.data, dataStruct.category, dataStruct.owner
    if F_LOGGER.useSQL then
        table.insert( F_LOGGER.sqlQueryQueue,
            { tostring( owner ), tostring( data ) }
        )
    else
        table.insert( F_LOGGER.logData[category or F_LOGGER.logCategories.Invalid], data )
    end
end

local function logConnection( data )


end

function F_LOGGER:AddLog( data, category )

end

hook.Add( "initialize", "freelogger_gm_initialize", initialize )