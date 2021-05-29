util.AddNetworkString("MyReports.Create")
util.AddNetworkString("MyReports.Fetch")
util.AddNetworkString("MyReports.FetchCallback")
util.AddNetworkString("MyReports.Update")

net.Receive("MyReports.Create", function(_, author)
    myreports.Create(author, net.ReadString())
end)

net.Receive("MyReports.Fetch", function(_, client)
    myreports.Fetch(client, net.ReadUInt(32))
end)

net.Receive("MyReports.Update", function(_, client)
    local length        = net.ReadUInt(32)
    local compressed    = net.ReadData(length)
    myreports.Update(client, length, compressed)
end)