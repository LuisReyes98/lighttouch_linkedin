event = ["send_linkedin"]
priority = 3
input_parameters = ["request"]

response = {
    headers = {
        ["content-type"] = "text/html",
    },
    body = render("index.html", {
        dev = "Under development"
    })
}

return response