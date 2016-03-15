# Bert

## Encoder

* 1 -> 1
* true -> true
* false -> false
* undefined -> []
* '#atom' -> atom
* ' string' -> <<"string">>
* '.string' -> "string"
* [x, y] -> [x, y]
* {$:[x, y]} -> {x, y}
* {$:{k: v}} -> #{k => v}

### Atoms

```javascript
function atom(atomString) {
  var len = atomString.length;
  var buf = (new Utf8.Encoder(atomString)).bytes;
  var tag;
  if (len < 256 && len == buf.byteLength) { // small latin1 atom
    tag = [115, len];
  }
  else if (len < 256 && len < buf.byteLength) { // small utf8 atom
    tag = [119, len];
  }
  else if (len == buf.byteLength) { // latin1 atom
    tag = [100, len >>> 24, len >>> 16, len >>> 8, len & 255];
  }
  else { // utf8 atom
    tag = [118, len >>> 24, len >>> 16, len >>> 8, len & 255];
  }
  var result = new Uint8Array(tag.length + buf.byteLength);
  result.set(tag, 0);
  result.set(buf, tag.length);
  return result;
}
```

### Strings

```javascript
function string(string) {
  var len = string.length;
  var buf = (new Utf8.Encoder(string)).bytes;
  var tag;
  if (buf.byteLength > 0xffff) { // list
    tag = [108, len >>> 24, len >>> 16, len >>> 8, len & 255];
  }
  else { // string
    tag = [107, len >>> 8, len & 255];
  }
  var result = new Uint8Array(tag.length + buf.byteLength);
  result.set(tag, 0);
  result.set(buf, tag.length);
  return result;
}
```

```javascript
function binaryString(string) {
  var len = string.length;
  var buf = (new Utf8.Encoder(string)).bytes;
  var tag = [109, len >>> 24, len >>> 16, len >>> 8, len & 255];
  var result = new Uint8Array(tag.length + buf.byteLength);
  result.set(tag, 0);
  result.set(buf, tag.length);
  return result;
}
```

### Numbers

```javascript
function number(num) {
  var tag;
  if (Number.isInteger(num) && num < 256) {
    tag = [97, num];
  }
  else if (Number.isInteger(num)) {
    tag = [98, len >>> 24, len >>> 16, len >>> 8, len & 255];
  }
  var result = new Uint8Array(tag.length);
  result.set(tag, 0);
  return result;
}
```
