priority = 3
input_parameter = "request"
events_table = ["send_linkedin"]

request.method == "GET"
and
#request.path_segments == 1
and
request.path_segments[1] == "linkedin_api"
or
request.query.code
or
request.query.state