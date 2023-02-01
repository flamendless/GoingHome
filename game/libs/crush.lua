--- crush lets you report crashes in LOVE games.
-- This module provides functions that you can use to
-- collect crash reports in your LOVE games.
--
-- The crash reports consists of the error message and stack trace,
-- as well as any additional information that is provided (e.g. version,
-- os, etc.).
--
-- With this module, crashes can be submitted via email, either automatically,
-- or manually via the user's email client.
--
-- The API functions of this module (with the exception of crush.fallback) will
-- never(TM) throw errors themselves, since those will not be handled by the
-- LOVE error handler. Instead, these errors will be handled by the
-- crush.fallback function.
--
-- @module crush
-- @author Moritz Neikes
-- @license Public Domain

local smtp = require("socket.smtp")
local ltn12 = require("ltn12")
local url = require("socket.url")
local mime = require("mime")

local crush = {}

-- The error report will use this name to refer to your game
crush.game_name = "The game"
-- timeout in seconds until crush will give up on sending an email. If not
-- specified (nil), it defaults to the luasocket default timeout, which is quite
-- long.
crush.timeout = 5

-- All strings that are displayed to the user or included in crash reports
crush.strings = {
  -- Titles of the message boxes. Each time, one title will be chosen randomly
  titles = {"Oh no", "Oh boy", "Bad news", "Uh oh"},
  -- Button strings
  yes = "Yes",
  no = "No",
  ok = "OK",

  -- How the error message is displayed to the user. The first string is the
  -- name of the game, the second string is the error message and stack trace.
  display_error = [[
%s crashed with the following error message:

%s

]],

  -- A line underneath the displayed error message when reporting manually
  epilogue_manual = "Would you like to report this crash to the developer so that it can be fixed?",

  -- A line underneath the displayed error message when reporting automatically
  epilogue_auto = "This crash has been reported to the developer.",

  -- This will be used when an error occurs while trying to produce the stack
  -- trace for the crash. The first string will be the original error message.
  -- The second string will be replaced by the error that occurred while trying
  -- to produce the stacktrace.
  error_no_stacktrace = "%s\nA stacktrace could not be produced: %s",

  -- When extra information is provided, but its key or value cannot be
  -- serialized, this string will be used. The string will be replaced by the
  -- error that occurred while trying to serialize the key or value.
  error_extra_info_serialization = "Cannot serialize extra information: %s",

  -- You will see this warning in your crash report if you tried to include
  -- files via the "_files" key, but you used the manual report function.
  -- Files can only be included in automatic reports due to restrictions of the
  -- mailto url scheme (https://tools.ietf.org/html/rfc2368).
  warn_cannot_attach = "No files could be attached to this email.",

  -- How the error message is displayed in the crash report. The first string is
  -- the name of the game, the second string is the error message and stack
  -- trace.
  report_error = [[
%s crashed with the following error message:

%s

]],

  -- This line separates the error message from the extra information
  report_extras = "Additional information:",

  -- The string is the name of the game
  email_subject = "%s crash report",

  -- If an error occurs while trying to report the crash, that error will be
  -- displayed, and the fallback_message will be shown underneath it.
  fallback_message = "Unfortunately, a crash report could not be produced.",
  fallback_button = "Quit",
}

-- If this key is defined in the extra_info table, and its value is a string or
-- a list of strings, then those files will be attached to the email
local files_key = "_files"

local function random_title()
  return crush.strings.titles[love.math.random(#crush.strings.titles)]
end

-- Displays the error_message followed by the epilogue, using
-- love.windows.showMessageBox with the given buttons.
-- Returns the index of the pressed button.
local function display_error(error_message, epilogue, buttons)
  local message = string.format(crush.strings.display_error,
                                crush.game_name, error_message)
  message = message .. epilogue
  return love.window.showMessageBox(random_title(), message, buttons)
end

-- Sends an email to the recipient with the given subject.
-- body contains the plain-text body of the email.
-- smtp_config must be a table containing the keys server and port.
-- The value of server must be a string
-- The value of port must be a number
-- files is an optional argument that specifies which files should be included.
-- The value of files can be either:
--  - the filename of the file to be included, or
--  - a table containing the filename in key "filename", and the file's mime
--    type in key "mimetype", or
--  - a table containing one or more elements. Each element must be either:
--     - the filename of the file to be included, or
--     - a table containing the filename in key "filename", and the file's mime
--       type in key "mimetype".
local function send_email(recipient, subject, body, smtp_config, files)
  assert(smtp_config, "Error: SMTP config is missing")
  assert(smtp_config.server, "Error: SMTP config does not specify a server")
  assert(smtp_config.port  , "Error: SMTP config does not specify a port")

  smtp.TIMEOUT = crush.timeout

  local from = recipient
  local to   = recipient
  local headers = { to      = to,
                    from    = from,
                    subject = subject,
                  }

  -- Normalize line endings
  body = mime.eol(0, body)

  -- Include files if there are any
  if files then
    -- Add email body without headers
    body = {{body = body}}

    -- make sure that files is a list of filenames
    if type(files) == "string" then files = {files} end

    -- If a single file is specified with filename and optionally mime-type,
    -- wrap that in a table.
    if files.filename then files = {files} end

    for _, file in ipairs(files) do
      -- Check if the mime type is specified.
      local filename, mimetype
      if type(file) == "table" then
        filename = file.filename
        mimetype = file.mimetype
      else
        assert(type(file) == "string")
        filename = file
      end
      assert(filename and type(filename) == "string")

      -- Use application/octet-stream as default mime type
      mimetype = mimetype or "application/octet-stream"

      local success, more = pcall(function()
        -- Check if the file exists
        do
          local f=io.open(filename,"r")
          if f~=nil then io.close(f)
          else error("No such file or directory") end
        end
        return {
          headers = {
            ["content-type"] = string.format('%s; name="%s"',
                                             mimetype, filename),
            ["content-disposition"] = string.format('attachment; filename="%s"',
                                                    filename),
            ["content-transfer-encoding"] = "BASE64",
          },
          body = ltn12.source.chain(
            ltn12.source.chain(
              ltn12.source.file(io.open(filename, "rb")),
              mime.encode("base64")),
            mime.wrap("text")
          ),
        }
      end)
      if success then
        table.insert(body, more)
      else
        -- Add error message to email
        table.insert(body,
                     {
                       body = mime.eol(0, string.format("%s: %s\n",
                                                        filename, more))
                     })
      end

    end -- for file in files
  end -- if files

  local source = smtp.message({ headers = headers,
                                body    = body,
                              })

  local r, err = smtp.send({ source   = source,
                             from     = from,
                             rcpt     = to,
                             server   = smtp_config.server,
                             port     = smtp_config.port,
                           })
  if not r then error(err) end
end

local function compose(error_message, extra_info)
  local body_elements = {}
  table.insert(body_elements,
               string.format(crush.strings.report_error,
                             crush.game_name, error_message))

  if extra_info then
    table.insert(body_elements, crush.strings.report_extras)

    for k, v in pairs(extra_info) do
      if k ~= files_key then
        -- When one of the keys or values cannot be serialized, that pair
        -- will be skipped, and an error message will be added to the email body.
        local line
        local success_key  , s_key   = pcall(tostring, k)
        local success_value, s_value = pcall(tostring, v)

        if not success_key then
          line = string.format(crush.strings.error_extra_info_serialization,
                               s_key) -- s_key contains the error message
        elseif not success_value then
          line = string.format(crush.strings.error_extra_info_serialization,
                               s_value) -- s_value contains the error message
        else
          line = string.format("%s: %s", s_key, s_value)
        end
        table.insert(body_elements, line)
      end
    end
  end
  -- add line feed at the end
  table.insert(body_elements, "")

  return table.concat(body_elements, "\n")
end

local function traceback(error_message, stack_offset)
  local stacktrace
  local success, more = pcall(debug.traceback, error_message or "",
                              8 + (stack_offset or 0))

  if success then
    stacktrace = more
  else
    stacktrace = string.format(crush.strings.error_no_stacktrace,
                               error_message or "", more)
  end

  return stacktrace
end

-- fallback function if an error occurs while processing the crash
function crush.fallback(err)
  -- Errors in the fallback are not caught, since this is already plan B.
  local message = crush.strings.display_error .. crush.strings.fallback_message
  message = string.format(message, crush.game_name, err)
  love.window.showMessageBox(random_title(), message,
                             {crush.strings.fallback_button})
end

-- Similar to Lua's pcall, but calls the crush.fallback function in case func
-- fails.
function crush.pcall(func, ...)
  local success, err = pcall(func, ...)
  if not success then crush.fallback(err) end
end

-- Report the crash fully automatically without asking the user first.
function crush.report_automatically(error_message, recipient, smtp_config,
                                    extra_info, stack_offset)
  crush.pcall(function()
    local stacktrace = traceback(error_message, stack_offset)
    local subject = string.format(crush.strings.email_subject, crush.game_name)
    local body = compose(stacktrace, extra_info)
    local success, err = pcall(send_email,
                               recipient, subject, body, smtp_config,
                               extra_info and extra_info[files_key])
    if success then
      local buttons = {crush.strings.ok}
      display_error(stacktrace, crush.strings.epilogue_auto, buttons)
    else
      print(err)
      -- The email could not be sent automatically.
      -- Ask user to submit manually
      crush.report_manually(error_message, recipient, extra_info,
                            4 + (stack_offset or 0))
    end
  end)
end

function crush.report_manually(error_message, recipient, extra_info,
                               stack_offset)
  crush.pcall(function()
    local stacktrace = traceback(error_message, stack_offset)
    local buttons = {crush.strings.yes, crush.strings.no}
    local choice = display_error(stacktrace, crush.strings.epilogue_manual,
                                 buttons)

    if choice == 1 then
      local subject = string.format(crush.strings.email_subject, crush.game_name)
      local body = compose(stacktrace, extra_info)
      local email_url = string.format("mailto:%s?subject=%s&body=%s",
                                      url.escape(recipient),
                                      url.escape(subject),
                                      url.escape(body))
      if extra_info and extra_info[files_key] then
        email_url = email_url .. url.escape(crush.strings.warn_cannot_attach)
      end
      love.system.openURL(email_url)
    end
  end)
end

return crush