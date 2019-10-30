function lkn.add_request_param( url,name,value)
    --checking if the url has the character ? for parameters
    if string.find(url,"?") then
        -- if it has the ? character then add a new field with an &
        url = url .. "&" .. name .. "=" .. value
    else
        -- if the string url doesn't have the ? character add it
        url = url .. "?" .. name .. "=" .. value
    end
    return url
end