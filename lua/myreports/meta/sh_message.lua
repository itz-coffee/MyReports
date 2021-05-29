local MESSAGE = {}
MESSAGE.__index = MESSAGE
debug.getregistry().MyMessage = MESSAGE

function myreports.NewMessage(author, text)
    return setmetatable({
        _author = author:UserID(),
        _text   = text
    }, MESSAGE)
end

AccessorFunc(MESSAGE, "_author", "Author")
AccessorFunc(MESSAGE, "_text", "Text")

function MESSAGE:GetAuthor()
    return Player(self._author)
end

function MESSAGE:__tostring()
    return "message[" .. self:GetID() .. "]"
end
