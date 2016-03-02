var Bert;
(function (Bert) {
    var Decoder = (function () {
        function Decoder(packet) {
            this.i = 0;
            this.b = packet;
            this.d = new DataView(packet);
            if (131 == this.d.getUint8(this.i++)) {
                this.result = this.decode();
            }
            else {
                throw 'Not BERT';
            }
        }
        Decoder.prototype.decode = function () {
            var tag = this.d.getUint8(this.i++);
            var r;
            switch (tag) {
                case 97:
                    r = this.d.getUint8(this.i++);
                    break;
                case 98:
                    r = this.d.getUint32(this.i);
                    this.i += 4;
                    break;
                case 100:
                    r = this.decodeAtom();
                    break;
                case 104:
                    r = this.decodeSmallTuple();
                    break;
                case 105:
                    r = this.decodeLargeTuple();
                    break;
                case 106: r = undefined;
                case 107:
                    r = this.decodeString();
                    break;
                case 108:
                    r = this.decodeList();
                    break;
                case 109:
                    r = this.decodeBinary();
                    break;
                case 110:
                    r = this.decodeSmallBigNum();
                    break;
                case 111:
                    r = this.decodeLargeBigNum();
                    break;
                case 115:
                    r = this.decodeSmallAtom();
                    break;
                case 116:
                    r = this.decodeMap();
                    break;
                case 118:
                    r = this.decodeAtom();
                    break;
                case 119:
                    r = this.decodeSmallAtom();
                    break;
            }
            return r;
        };
        Decoder.prototype.decodeAtom = function () {
            var length = this.d.getUint16(this.i);
            this.i += 2;
            var dec = new Utf8.Decoder(this.b.slice(this.i, this.i + length));
            this.i += length;
            return dec.result;
        };
        Decoder.prototype.decodeSmallAtom = function () {
            var length = this.d.getUint8(this.i++);
            var dec = new Utf8.Decoder(this.b.slice(this.i, this.i + length));
            this.i += length;
            return dec.result;
        };
        Decoder.prototype.decodeString = function () {
            var length = this.d.getUint16(this.i);
            this.i += 2;
            var dec = new Utf8.Decoder(this.b.slice(this.i, this.i + length));
            this.i += length;
            return dec.result;
        };
        Decoder.prototype.decodeBinary = function () {
            var length = this.d.getUint32(this.i);
            this.i += 4;
            var dec = new Utf8.Decoder(this.b.slice(this.i, this.i + length));
            this.i += length;
            return dec.result;
        };
        Decoder.prototype.decodeSmallBigNum = function () {
            var length = this.d.getUint8(this.i++);
            var sign = (0 == this.d.getUint8(this.i++) ? 1 : -1);
            var r = 0;
            for (var i = 0; i < length; i++) {
                r += this.d.getUint8(this.i++) * Math.pow(256, i);
            }
            this.i += length;
            return sign * r;
        };
        Decoder.prototype.decodeLargeBigNum = function () {
            var length = this.d.getUint32(this.i);
            this.i += 4;
            var sign = (0 == this.d.getUint8(this.i++) ? 1 : -1);
            var r = 0;
            for (var i = 0; i < length; i++) {
                r += this.d.getUint8(this.i++) * Math.pow(256, i);
            }
            this.i += length;
            return sign * r;
        };
        Decoder.prototype.decodeSmallTuple = function () {
            var arity = this.d.getUint8(this.i++);
            var r = [];
            for (var i = 0; i < arity; i++) {
                r.push(this.decode());
            }
            return r;
        };
        Decoder.prototype.decodeLargeTuple = function () {
            var arity = this.d.getUint32(this.i);
            this.i += 4;
            var r = [];
            for (var i = 0; i < arity; i++) {
                r.push(this.decode());
            }
            return r;
        };
        Decoder.prototype.decodeList = function () {
            var length = this.d.getUint32(this.i);
            this.i += 4;
            var r = [];
            for (var i = 0; i < length; i++) {
                r.push(this.decode());
            }
            if (106 != this.d.getUint8(this.i)) {
                r.push(this.decode());
            }
            else {
                this.i++;
            }
            return r;
        };
        Decoder.prototype.decodeMap = function () {
            var arity = this.d.getUint32(this.i);
            this.i += 4;
            var r = [];
            for (var i = 0; i < arity; i++) {
                var key = this.decode();
                var value = this.decode();
                var o = {};
                o[key] = value;
                r.push(o);
            }
            return r;
        };
        return Decoder;
    }());
    Bert.Decoder = Decoder;
})(Bert || (Bert = {}));
