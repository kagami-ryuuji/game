ws = {
  connection: undefined,
  connect: function ()
  {
    this.connection = new WebSocket("ws://localhost:8080/websocket");
    this.connection.onopen = function () { console.log("open"); };
    this.connection.onmessage = function (msg) { console.log(utf8_dec(msg.data)); };
    this.connection.onclose = function () { console.log("close"); };
  }
};
ws.connect();
