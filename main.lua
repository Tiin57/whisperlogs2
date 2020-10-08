function WL2.init()
  local frame = CreateFrame("FRAME", WL2.ADDON_NAME .. "_Frame")

  for eventName in pairs(WL2.eventHandlers) do
    frame:RegisterEvent(eventName)
  end

  frame:SetScript("OnEvent", function(self, evt, ...)
    local handler = WL2.eventHandlers[evt]
    if not handler then
      return
    end
    handler({ ... })
  end)
end

WL2.init()
