function myreports.GetReports(client)
    if client:IsAdmin() then
        return myreports.data
    else
        return myreports.Authored(client)
    end
end

function myreports.Authored(client)
    local output = {}

    for ID, report in pairs(myreports.data) do
        if client == report:GetAuthor() then
            output[ID] = report
        end
    end

    return output
end

function myreports.HasOpen(client)
    for ID, report in pairs(myreports.data) do
        if client == report:GetAuthor() and not report:GetClosed() then
            return true
        end
    end

    return false
end

function myreports.Create(author, text)
    if myreports.HasOpen(author) then
        return author:ChatPrint("You already have a report open!")
    end

    local report = myreports.New(author, text)
    myreports.data[report:GetID()] = report

    author:ChatPrint("Your report has been sent!")

    for _, client in ipairs(player.GetAll()) do
        if client:IsAdmin() then
            client:ChatPrint("[REPORT] " .. author:Name() .. " - " .. text)
        end
    end
end

function myreports.Fetch(client, id)
    local reports
    local multiple

    if id == 0 then
        reports = myreports.GetReports(client)
        multiple = true
    else
        reports = myreports.data[id]
        multiple = false

        if client ~= reports:GetAuthor() then
            return
        end
    end

    local compressed = util.Compress(util.TableToJSON(reports))

    net.Start("MyReports.FetchCallback")
        net.WriteUInt(#compressed, 32)
        net.WriteData(compressed)
        net.WriteBool(multiple)
    net.Send(client)
end

function myreports.Update(client, length, compressed)
    local report = util.JSONToTable(util.Decompress(compressed))
    report = setmetatable(report, FindMetaTable("MyReport"))

    for ID, message in pairs(report:GetMessages()) do
        report._messages[ID] = setmetatable(report._messages[ID], FindMetaTable("MyMessage"))
    end

    myreports.data[report:GetID()] = report
end
