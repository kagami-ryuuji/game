function test()
{
  ws.connection.send(enc(tuple(atom('control'), tuple(atom('item'), number(12)))));
  ws.connection.send(enc(tuple(atom('control'), tuple(atom('skill'), number(255)))));
}
