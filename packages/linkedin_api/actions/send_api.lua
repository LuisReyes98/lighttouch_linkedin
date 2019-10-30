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

function add_request_param_array( url, param_array )
    for k,param in pairs(param_array) do
        url = add_request_param(url, param.name, param.value )
    end
    return url
end


function save_doc(fields)
    local document_uuid = uuid.v4()
    local store = contentdb.home

    contentdb.write_file (store, document_uuid, fields, '')
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

-- api token request url
local token_linkedin_uri = 'https://www.linkedin.com/oauth/v2/accessToken'

-- api get user info url
local me_linkedin_uri = 'https://api.linkedin.com/v2/me'

--redirection url (this site url)
local redirect_uri = settings.redirect_uri

local access_token = false

local code = false
if request.query.code then
    code = request.query.code
end
local response
local user_response = false
local token_params = {}
local token_file = {}

local param_table = {
    {
        name = 'response_type',
        value = 'code',
    },
    {
        name = 'client_id',
        value = client_id,
    },
    {
        name = 'redirect_uri',
        value = redirect_uri,
    },
    {
        name = 'state',
        value = state,
    },
    {
        name = 'scope',
        value = scope,
    },
}

signin_linkedin_uri = add_request_param_array(
    signin_linkedin_uri,
    param_table
)

--  GET https://api.linkedin.com/v2/people/(id:{person ID})

--  GET https://api.linkedin.com/v2/me

if code then
    token_params = {
        {
            name = 'grant_type',
            value = 'authorization_code',
        },
        {
            name = 'client_id',
            value = client_id,
        },
        {
            name = 'client_secret',
            value = client_secret,
        },
        {
            name = 'redirect_uri',
            value = redirect_uri,
        },
        {
            name = 'code',
            value = code,
        },
        {
            name = 'state',
            value = state,
        },
    }
    token_linkedin_uri = add_request_param_array(
        token_linkedin_uri,
        token_params
    )

    response = send_request({
        uri=token_linkedin_uri,
        method="post",
    })

    if not response.body.error then
        access_token = response.body.access_token
    else
        log.debug('LinkedIn API error: ' .. response.body.error)
    end

end

if access_token then
    me_linkedin_uri = add_request_param(
        me_linkedin_uri,
        'oauth2_access_token',
        access_token
    )

    -- getting user info
    user_response = send_request({
        uri=me_linkedin_uri,
        method="get",
    }).body

    -- log.debug(jsong.from_table(user_response.body))
    token_file['user_id'] = user_response.id
    token_file['access_token'] = access_token
    -- saving access token to file
    save_doc(token_file)
end


response = {
    headers = {
        ["content-type"] = "text/html",
    },
    body = render("index.html", {
        user_info = user_response,
        signin_linkedin_uri = signin_linkedin_uri,
    })
}

return response