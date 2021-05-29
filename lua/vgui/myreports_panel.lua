local PANEL = {}

function PANEL:ShowReport(report)
    myreports.panel = self

    self:SetSize(ScrW() / 2, ScrH() / 2)
    self:MakePopup()
    self:Center()

    local buttonCanvas = self:Add("Panel")
    buttonCanvas:Dock(BOTTOM)

    if myreports.client:IsAdmin() and myreports.client ~= report:GetAuthor() then
        local claim = buttonCanvas:Add("DButton")
        claim:SetText("Claim")
        claim:Dock(LEFT)
        claim.DoClick = function()
            report:SetClaimer(myreports.client)
            myreports.Update(report)
        end
    end

    local refresh = buttonCanvas:Add("DButton")
    refresh:SetText("Refresh")
    refresh:Dock(RIGHT)
    refresh.DoClick = function()
        myreports.Fetch(report:GetID())

        timer.Simple(1, function()
            if IsValid(messageLayout) then
                messageLayout:PopulateMessages()
            end
        end)
    end

    local close = buttonCanvas:Add("DButton")
    close:SetText("Close")
    close:Dock(RIGHT)
    close.DoClick = function()
        report:SetClosed(true)
        myreports.Update(report)
        myreports.panel:Close()
        myreports.reportList:PopulateReports()
    end

    local textCanvas = self:Add("Panel")
    textCanvas:Dock(BOTTOM)

    local messageCanvas = self:Add("DScrollPanel")
    messageCanvas:Dock(FILL)

    local messageLayout = messageCanvas:Add("DListLayout")
    messageLayout:Dock(FILL)
    messageLayout.PopulateMessages = function()
        messageLayout:Clear()

        for _, message in pairs(report:GetMessages()) do
            myreports.panel:AddChat(message:GetAuthor(), message:GetText())
        end

        messageCanvas:InvalidateLayout(true)
        messageCanvas:SizeToChildren(false, true)

        messageLayout:InvalidateLayout(true)
        messageLayout:SizeToChildren(false, true)
    end

    self.messageLayout = messageLayout

    local text = textCanvas:Add("DTextEntry")
    text:Dock(BOTTOM)
    text.OnEnter = function(self, value)
        report:GetMessages()[#report:GetMessages() + 1] = myreports.NewMessage(LocalPlayer(), value)

        text:SetText("")
        messageLayout:PopulateMessages()

        myreports.Update(report)
    end

    messageLayout:PopulateMessages()
end

function PANEL:AddChat(client, message)
    local avatarCanvas = self.messageLayout:Add("Panel")
    avatarCanvas:SetTall(50)
    avatarCanvas:DockPadding(0, 5, 0, 5)
    -- avatarCanvas:Dock(BOTTOM)

    local avatar = avatarCanvas:Add("AvatarImage")
    avatar:SetPlayer(client)
    avatar:Dock(LEFT)
    avatar:InvalidateLayout(true)
    avatar:SetSize(45, 45)

    local label = avatarCanvas:Add("DLabel")
    label:SetContentAlignment(4)
    label:DockMargin(5, 0, 0, 0)
    label:Dock(FILL)
    label:SetText((IsValid(client) and client:Name() or "N/A") .. ": " .. message)
    -- label:SetFont("CloseCaption_Bold")
    -- label:SizeToContents()
end

vgui.Register("MyReportsPanel", PANEL, "DFrame")
