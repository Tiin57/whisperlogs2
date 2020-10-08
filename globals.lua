WL2 = {}
WL2.ADDON_NAME = "WhisperLogs2"
WL2.MESSAGE_LIMIT = 1000
WL2.REALM = GetRealmName():gsub("%s", "")

WL2.COLORS = WL2.COLORS or {}
WL2.COLORS.whisper = "ffDA70D6"

WL2.DEFAULTS = WL2.DEFAULTS or {}
WL2.DEFAULTS.command = "print"
WL2.DEFAULTS.printLogsMax = 10
