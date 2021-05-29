function myreports.Fetch(id)
    net.Start("MyReports.Fetch")
        net.WriteUInt(id or 0, 32)
    net.SendToServer()
end

function myreports.Update(report)
    local compressed = util.Compress(util.TableToJSON(report))
    net.Start("MyReports.Update")
        net.WriteUInt(#compressed, 32)
        net.WriteData(compressed)
    net.SendToServer()
end

function myreports.Create(text)
    net.Start("MyReports.Create")
        net.WriteString(text)
    net.SendToServer()
end

net.Receive("MyReports.FetchCallback", function()
    local length        = net.ReadUInt(32)
    local compressed    = net.ReadData(length)
    local multiple      = net.ReadBool()
    local reports       = util.JSONToTable(util.Decompress(compressed))
    local output        = {}

    if multiple then
        for ID, report in pairs(reports) do
            local outputReport = setmetatable(report, FindMetaTable("MyReport"))

            for messageID, message in pairs(outputReport:GetMessages()) do
                message = setmetatable(message, FindMetaTable("MyMessage"))
                outputReport:GetMessages()[messageID] = message
            end
            output[ID] = outputReport
        end
    else
        output = setmetatable(reports, FindMetaTable("MyReport"))
    end

    myreports.data = output
end)

concommand.Add("myreports", function()
    vgui.Create("MyReportsList")
end)
