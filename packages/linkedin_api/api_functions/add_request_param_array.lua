function lkn.add_request_param_array( url, param_array )
    for k,param in pairs(param_array) do
        url = lkn.add_request_param(url, param.name, param.value )
    end
    return url
end
