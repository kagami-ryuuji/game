-record(nw_state, {
    connection, % websocket connection pid
    character % character pid
}).

-record(http_req, {
	%% Transport.
	socket = undefined,
	transport = undefined,
	connection = keepalive,

	%% Request.
	pid = undefined,
	method = <<"GET">>,
	version = 'HTTP/1.1',
	peer = undefined,
	host = undefined,
	host_info = undefined,
	port = undefined,
	path = undefined,
	path_info = undefined,
	qs = undefined,
	bindings = undefined,
	headers = [],
	meta = [],

	%% Request body.
	body_state = waiting,
	buffer = <<>>,
	multipart = undefined,

	%% Response.
	resp_compress = false,
	resp_state = waiting,
	resp_headers = [],
	resp_body = <<>>,

	%% Functions.
	onresponse = undefined
}).
