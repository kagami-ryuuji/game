module Utf8 {
  export class Encoder {
    buffer: ArrayBuffer;
    byteArray: Uint8Array;
    constructor(str: string) {
      var i: number = 0;
      var ch: number = 0;
      var buf: number[] = [];
      while (i < str.length) {
        ch = str.charCodeAt(i++);
        if (ch < 0x80) { buf.push(ch); }
        else if (0x7f < ch && ch < 0x800) {
          buf.push((ch >>> 6) & 0x1f | 0xc0);
          buf.push(ch & 0x3f | 0x80);
        }
        else if (0x7ff < ch && ch < 0x110000) {
          buf.push((ch >>> 12) & 0x0f | 0xf0);
          buf.push((ch >>> 6) & 0x3f | 0x80);
          buf.push(ch & 0x3f | 0x80);
        }
        else if (0x7fff < ch && ch < 0x10000) {
          buf.push((ch >>> 18) & 0x07 | 0xf8);
          buf.push((ch >>> 12) & 0x3f | 0x80);
          buf.push((ch >>> 6) & 0x3f | 0x80);
          buf.push(ch & 0x3f | 0x80);
        }
      }
      this.buffer = new ArrayBuffer(buf.length);
      var d: DataView = new DataView(this.buffer);
      buf.forEach(function(v, i, a) { d.setUint8(i, v); }, this);
    }
  }
  export class Decoder {
    result: string;
    constructor(buf: ArrayBuffer) {
      var str: string = '';
      var i: number = 0;
      var ch: number = 0;
      var d: DataView = new DataView(buf);
      var ch1: number = 0;
      var ch2: number = 0;
      var ch3: number = 0;
      var cont = function (): number {
        var c: number = d.getUint8(i++);
        if (0x80 != (c & 0xC0)) {
          throw 'Invalid UTF-8';
        }
        return (c & 0x3F);
      };
      var c = String.fromCharCode;
      while (i < buf.byteLength) {
        ch = d.getUint8(i++);
        if (0 == (ch & 0x80)) {
          str += c(ch);
        } else if (0xC0 == (ch & 0xE0)) {
          ch1 = cont();
          str += c(((ch & 0x1F) << 6) | ch1);
        } else if (0xE0 == (ch & 0xF0)) {
          ch1 = cont();
          ch2 = cont();
          str += c(((ch & 0x0F) << 12) | (ch1 << 6) | ch2);
        } else if (0xF0 == (ch & 0xF8)) {
          ch1 = cont();
          ch2 = cont();
          ch3 = cont();
          str += c(((ch & 0x07) << 18) | (ch1 << 12) | (ch2 << 6) | ch3);
        }
      }
      this.result = str;
    }
  }
}
