event = ["file_test"]
priority = 1
input_parameters = ["request"]


local document_uuid = uuid.v4()
local store = contentdb.home

fields = {
    token = 'dsafsfsa',
    user_id = 'Luis',
}

contentdb.write_file (store, document_uuid, fields, '')


response = {
    headers = {
        ["content-type"] = "text/html",
    },
    body = render("index.html", {
        signin_linkedin_uri = '#',
    })
}

return response