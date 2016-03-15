module Network {
  var socket: WebSocket;
  var handler: any;
  socket = new WebSocket('ws://localhost:8000/ws');
  socket.onopen = function () { console.log('OPEN'); };
  socket.onclose = function () { console.log('CLOSED'); };
  socket.onmessage = function (msg) {
    if ('string' == typeof msg.data) {
      console.log('TEXT ' + msg.data);
    } else {
      var buf: ArrayBuffer;
      var f = new FileReader();
      f.onload = function() {
        buf = f.result;
        var m = new Bert.Decoder(buf);
        handler.message(m.result);
      }
      f.readAsArrayBuffer(msg.data);
    }
  };
  export function register(h) {
    handler = h;
  }
  export function send(msg) {
    socket.send(msg);
  }
}
