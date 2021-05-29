local REPORT = {}
REPORT.__index = REPORT
debug.getregistry().MyReport = REPORT

function myreports.New(author, text)
    return setmetatable({
        _id         = #myreports.data + 1,
        _author     = author:UserID(),
        _messages   = {
            myreports.NewMessage(author, text)
        },
        _closed     = false,
        _claimer    = nil
    }, REPORT)
end

AccessorFunc(REPORT, "_author", "Author", FORCE_NUMBER)
AccessorFunc(REPORT, "_messages", "Messages")
AccessorFunc(REPORT, "_id", "ID", FORCE_NUMBER)
AccessorFunc(REPORT, "_closed", "Closed", FORCE_BOOL)
AccessorFunc(REPORT, "_claimer", "Claimer", FORCE_NUMBER)

function REPORT:GetAuthor()
    return Player(self._author)
end

function REPORT:__tostring()
    return "report[" .. self:GetID() .. "]"
end
