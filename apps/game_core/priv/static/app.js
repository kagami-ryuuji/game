function test()
{
  ws.connection.send(enc(tuple(atom('control'), tuple(atom('item'), number(12)))));
}
