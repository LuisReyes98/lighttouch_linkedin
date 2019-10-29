priority = 1
input_parameter = "request"
events_table = ["file_test"]

request.method == "GET"
and
#request.path_segments == 1
and
request.path_segments[1] == "file_test"
or
request.query.filename
