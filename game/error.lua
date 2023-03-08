function love.errhand(error_message)
  local app_name = love.window.getTitle()
  local version = "Android-0.1"
  local github_url = "https://github.com/flamendless/goinghome-issues"
  local email = "flamendless8@gmail.com"
  local edition = OS
	local dialog_message = ""
	if edition == "Android" then
		dialog_message = [[
			The game crashed. Sorry.
			Would you like to report this bug to the developer?

			Thank you for helping the developer
		]]
	else

  dialog_message = [[
%s crashed with the following error message:

%s

Would you like to report this crash so that it can be fixed?

THANK YOU SO MUCH FOR HELPING THE DEVELOPER

]]

	end



  local titles = {"Too Bad", "Ooops", "Sorry"}
  local title = titles[love.math.random(#titles)]
  local full_error = debug.traceback(error_message or "")
  local message = string.format(dialog_message, app_name, full_error)
  local buttons = {"Yes, on GitHub", "Yes, by email", "No"}

  local pressedbutton = love.window.showMessageBox(title, message, buttons)

  local function url_encode(text)
    -- This is not complete. Depending on your issue text, you might need to
    -- expand it!
    text = string.gsub(text, "\n", "%%0A")
    text = string.gsub(text, " ", "%%20")
    text = string.gsub(text, "#", "%%23")
    return text
  end

  local issuebody = [[
%s crashed with the following error message:

%s

[If you can, describe what you've been doing when the error occurred]

---
Affects: %s
Edition: %s

THANK YOU SO MUCH FOR HELPING THE DEVELOPER
]]


  if pressedbutton == 1 then
    -- Surround traceback in ``` to get a Markdown code block
    full_error = table.concat({"```",full_error,"```"}, "\n")
    issuebody = string.format(issuebody, app_name, full_error, version, edition)
    issuebody = url_encode(issuebody)

    local subject = string.format("Crash in %s %s", app_name, version)
    local url = string.format("%s/issues/new?title=%s&body=%s",
                              github_url, subject, issuebody)

    love.system.openURL(url)
  elseif pressedbutton == 2 then
    issuebody = string.format(issuebody, app_name, full_error, version, edition)
    issuebody = url_encode(issuebody)

    local subject = string.format("Crash in %s %s", app_name, version)
    local url = string.format("mailto:%s?subject=%s&body=%s",
                              email, subject, issuebody)
    love.system.openURL(url)
  end
end
