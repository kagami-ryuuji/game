module Network {
  var socket: WebSocket;
  socket = new WebSocket('ws://localhost:8080/websocket');
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
      }
      f.readAsArrayBuffer(msg.data);
      var m = new Bert.Decoder(buf);
    }
  };
  export function send(msg) {
    socket.send(msg);
  }
}
