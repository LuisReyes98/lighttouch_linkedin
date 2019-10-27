event = ["send_linkedin"]
priority = 3
input_parameters = ["request"]

function add_request_param( url,name,value)
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


-- linked in params

-- linked app api client_secret
local client_secret = settings.client_secret

-- linked app api client_id
local client_id = settings.client_id

-- data access that is being requested
-- scoped used r_liteprofile r_basicprofile r_emailaddress w_member_social
local scope = settings.scope

-- ramdom string for this app use to avoid cross bridge
local state = settings.state

-- api access url
local signin_linkedin_uri = 'https://www.linkedin.com/oauth/v2/authorization'
--redirection url (this site url)
local redirect_uri = settings.redirect_uri

local access_token = ''

local code = ""
if request.query.code then
    code = request.query.code
end

signin_linkedin_uri = add_request_param(
    signin_linkedin_uri,
    'response_type',
    'code'
)
signin_linkedin_uri = add_request_param(
    signin_linkedin_uri,
    'client_id',
    client_id
)

signin_linkedin_uri = add_request_param(
    signin_linkedin_uri,
    'redirect_uri',
    redirect_uri
)

signin_linkedin_uri = add_request_param(
    signin_linkedin_uri,
    'state',
    state
)

signin_linkedin_uri = add_request_param(
    signin_linkedin_uri,
    'scope',
    scope
)

--  GET https://api.linkedin.com/v2/people/(id:{person ID})

--  GET https://api.linkedin.com/v2/me


if code then


    local response = send_request({
        uri='https://www.linkedin.com/oauth/v2/accessToken',
        method="POST",
        headers={
            ["content-type"]="application/json",
        },
    })
end

response = {
    headers = {
        ["content-type"] = "text/html",
    },
    body = render("index.html", {
        client_secret = client_secret,
        client_id = client_id,
        scope = scope,
        redirect_uri = redirect_uri,
        code = code,
        signin_linkedin_uri = signin_linkedin_uri,
        -- dev = "Under development",
        -- api_sample = settings.api_sample.body
    })
}

return response