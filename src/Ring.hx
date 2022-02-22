@:generic
class Ring<T> {
	var head:Int;
	var tail:Int;
	var cap:Int;
	var a:haxe.ds.Vector<T>;

	public function new(len) {
		if (len < 4) {
			len = 4;
		} else if (len & len - 1 > 0) {
			len--;
			len |= len >> 1;
			len |= len >> 2;
			len |= len >> 4;
			len |= len >> 8;
			len |= len >> 16;
			len++; // power of 2
		}
		cap = len - 1; // only "len-1" available spaces
		a = new haxe.ds.Vector<T>(len);
		reset();
	}

	public function reset() {
		head = 0;
		tail = 0;
	}

	public function push(v:T) {
		if (space() == 0)
			tail = (tail + 1) & cap;
		a[head] = v;
		head = (head + 1) & cap;
	}

	public function shift():Null<T> {
		var ret:Null<T> = null;
		if (count() > 0) {
			ret = a[tail];
			tail = (tail + 1) & cap;
		}
		return ret;
	}

	public function pop():Null<T> {
		var ret:Null<T> = null;
		if (count() > 0) {
			head = (head - 1) & cap;
			ret = a[head];
		}
		return ret;
	}

	public function unshift(v:T) {
		if (space() == 0)
			head = (head - 1) & cap;
		tail = (tail - 1) & cap;
		a[tail] = v;
	}

	public function toString() {
		return '[head: $head, tail: $tail, capacity: $cap]';
	}

	public inline function count()
		return (head - tail) & cap;

	public inline function space()
		return (tail - head - 1) & cap;
}
