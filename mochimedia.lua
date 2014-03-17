local url_count = 0
local tries = 0


wget.callbacks.httploop_result = function(url, err, http_stat)
  -- NEW for 2014: Slightly more verbose messages because people keep
  -- complaining that it's not moving or not working
  url_count = url_count + 1
  io.stdout:write(url_count .. "=" .. url["url"] .. ".  \r")
  io.stdout:flush()

  local status_code = http_stat["statcode"]

  if status_code >= 500 and tries < 10 then
    io.stdout:write("\nServer returned "..http_stat.statcode..". Sleeping.\n")
    io.stdout:flush()

    if not string.match(url['url'], "mochimedia%.com/")
    and not string.match(url['url'], "mochiads%.com/") then
      tries = tries + 1
    end

    os.execute("sleep 60")
    return wget.actions.CONTINUE
  end

  return wget.actions.NOTHING
end
