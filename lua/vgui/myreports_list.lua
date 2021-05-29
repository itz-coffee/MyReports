local PANEL = {}

function PANEL:Init()
    myreports.reportList = self
    myreports.client = LocalPlayer()

    self:SetSize(ScrW() / 2, ScrH() / 2)
    self:MakePopup()
    self:Center()

    local buttonCanvas = self:Add("Panel")
    buttonCanvas:Dock(BOTTOM)

    -- local Handled = ButtonCanvas:Add("DButton")
    -- Handled:Dock(LEFT)
    -- Handled:SetText("Handled")
    -- Handled.DoClick = function()
    --     self:ShowHandled()
    -- end

    local refresh = buttonCanvas:Add("DButton")
    refresh:Dock(LEFT)
    refresh:SetText("Refresh")
    refresh.DoClick = function()
        myreports.reportList:PopulateReports()
    end

    local create = buttonCanvas:Add("DButton")
    create:Dock(RIGHT)
    create:SetText("Create")
    create.DoClick = function()
        Derma_StringRequest("Alert", "Fill out your report!", "", function(text)
            myreports.Create(text)
        end)

        myreports.reportList:PopulateReports()
    end

    local list = self:Add("DListView")
    list:Dock(FILL)
    list:SetMultiSelect(false)
    list:InvalidateLayout(true)
    list:AddColumn("ID"):SetMaxWidth(50)
    list:AddColumn("Author"):SetMaxWidth(200)
    list:AddColumn("Claimer"):SetMaxWidth(200)
    list:AddColumn("Report")
    list.OnRowSelected = function(panel, rowIndex, row)
        self:ShowReport(
            myreports.data[tonumber(row:GetValue(1))]
        )
    end

    self.list = list
    self:PopulateReports()
end

function PANEL:PopulateReports()
    myreports.Fetch()
    self.list:Clear()

    timer.Simple(1, function()
        for _, report in pairs(myreports.data or {}) do
            if report:GetClosed() then
                continue
            end

            local author = report:GetAuthor()

            self.list:AddLine(
                report:GetID(),
                IsValid(author) and author:Name() or "N/A",
                report:GetClaimer() or "Unclaimed",
                report:GetMessages()[1]:GetText()
            )
        end
    end)
end

function PANEL:ShowReport(report)
    local frame = vgui.Create("MyReportsPanel")
    frame:ShowReport(report)
end

function PANEL:ShowHandled()

end

vgui.Register("MyReportsList", PANEL, "DFrame")
