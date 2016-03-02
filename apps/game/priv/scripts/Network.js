var Network;
(function (Network) {
    var socket;
    var handler;
    socket = new WebSocket('ws://localhost:8080/ws');
    socket.onopen = function () { console.log('OPEN'); };
    socket.onclose = function () { console.log('CLOSED'); };
    socket.onmessage = function (msg) {
        if ('string' == typeof msg.data) {
            console.log('TEXT ' + msg.data);
        }
        else {
            var buf;
            var f = new FileReader();
            f.onload = function () {
                buf = f.result;
                var m = new Bert.Decoder(buf);
                handler.message(m.result);
            };
            f.readAsArrayBuffer(msg.data);
        }
    };
    function register(h) {
        handler = h;
    }
    Network.register = register;
    function send(msg) {
        socket.send(msg);
    }
    Network.send = send;
})(Network || (Network = {}));
