event = ["send_linkedin"]
priority = 3
input_parameters = ["request"]

--  GET https://api.linkedin.com/v2/people/(id:{person ID})

--  GET https://api.linkedin.com/v2/me

-- local github_response = send_request({
--     uri='',
--     method="get",
--     headers={
--         ["content-type"]="application/json",
--     },
-- })

response = {
    headers = {
        ["content-type"] = "text/html",
    },
    body = render("index.html", {
        dev = "Under development",
        api_sample = settings.api_sample.body
    })
}

return response