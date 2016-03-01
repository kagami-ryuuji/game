module Bert {
  export class Decoder {
    private b: ArrayBuffer;
    private d: DataView;
    private i: number = 0;
    result: any;
    constructor(packet: ArrayBuffer) {
      this.b = packet;
      this.d = new DataView(packet);
      if (131 == this.d.getUint8(this.i++)) {
        this.result = this.decode();
      } else {
        throw 'Not BERT';
      }
    }
    decode() {
      var tag = this.d.getUint8(this.i++);
      console.log("Tag: " + tag);
      var r: any;
      switch (tag) {
        case 97: r = this.d.getUint8(this.i++); break;
        case 98: r = this.d.getUint32(this.i); this.i += 4; break;
        case 100: r = this.decodeAtom(); break;
        case 104: r = this.decodeSmallTuple(); break;
        case 105: r = this.decodeLargeTuple(); break;
        case 106: r = undefined; // nil
        case 107: r = this.decodeString(); break;
        case 108: r = this.decodeList(); break;
        case 109: r = this.decodeBinary(); break;
        case 110: r = this.decodeSmallBigNum(); break;
        case 111: r = this.decodeLargeBigNum(); break;
        case 115: r = this.decodeSmallAtom(); break;
        case 116: r = this.decodeMap(); break;
        case 118: r = this.decodeAtom(); break;
        case 119: r = this.decodeSmallAtom(); break;
      }
      return r;
    }
    decodeAtom() {
      var length = this.d.getUint16(this.i);
      this.i += 2;
      var dec = new Utf8.Decoder(this.b.slice(this.i, this.i + length));
      this.i += length;
      return dec.result;
    }
    decodeSmallAtom() {
      var length = this.d.getUint8(this.i++);
      var dec = new Utf8.Decoder(this.b.slice(this.i, this.i + length));
      this.i += length;
      return dec.result;
    }
    decodeString() {
      var length = this.d.getUint16(this.i);
      this.i += 2;
      var dec = new Utf8.Decoder(this.b.slice(this.i, this.i + length));
      this.i += length;
      return dec.result;
    }
    decodeBinary() {
      var length = this.d.getUint32(this.i);
      this.i += 4;
      var dec = new Utf8.Decoder(this.b.slice(this.i, this.i + length));
      this.i += length;
      return dec.result;
    }
    decodeSmallBigNum() {
      var length = this.d.getUint8(this.i++);
      var sign = (0 == this.d.getUint8(this.i++) ? 1 : -1);
      var r: number = 0;
      for (var i = 0; i < length; i++) {
        r += this.d.getUint8(this.i++) * Math.pow(256, i);
      }
      this.i += length;
      return sign * r;
    }
    decodeLargeBigNum() {
      var length = this.d.getUint32(this.i);
      this.i += 4;
      var sign = (0 == this.d.getUint8(this.i++) ? 1 : -1);
      var r: number = 0;
      for (var i = 0; i < length; i++) {
        r += this.d.getUint8(this.i++) * Math.pow(256, i);
      }
      this.i += length;
      return sign * r;
    }
    decodeSmallTuple() {
      var arity = this.d.getUint8(this.i++);
      var r: any[] = [];
      for (var i = 0; i < arity; i++) {
        r.push(this.decode());
      }
      return r;
    }
    decodeLargeTuple() {
      var arity = this.d.getUint32(this.i);
      this.i += 4;
      var r: any[] = [];
      for (var i = 0; i < arity; i++) {
        r.push(this.decode());
      }
      return r;
    }
    decodeList() {
      var length = this.d.getUint32(this.i);
      this.i += 4;
      var r: any[] = [];
      for (var i = 0; i < length; i++) {
        r.push(this.decode());
      }
      if (106 != this.d.getUint8(this.i)) {
        r.push(this.decode());
      } else {
        this.i++;
      }
      return r;
    }
    decodeMap() {
      var arity = this.d.getUint32(this.i);
      this.i += 4;
      var r: any[] = [];
      for (var i = 0; i < arity; i++) {
        var key = this.decode();
        var value = this.decode();
        var o = {}; o[key] = value;
        r.push(o);
      }
      return r;
    }
  }
}
