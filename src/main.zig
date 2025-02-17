const std = @import("std");
const print = std.debug.print;
const mem = @import("std").mem;

pub fn main() !void {
    // try hello_world();
    // variables();
    // try basic_variable_type();
    // const closure = closure_fn(1);
    // const three = closure(4);
    // std.debug.print("closure(3)={}\n", .{three});
    // _ = addFortyTwo(1);
    // advance_type();
    // try advanced_type_vector1();
    // try advanced_type_vector2();
    // try advanced_type_vector3();
    // advanced_type_pointer();
    // advanced_type_slice();
    // advanced_type_str();
    // advanced_type_struct();
    // advanced_type_enum();
    // advanced_type_union();
    // process_control_loop();
    // process_control_switch();
    process_control_defer_unreadchable();
}

fn hello_world() !void {
    const out = std.io.getStdOut().writer();
    const err = std.io.getStdErr().writer();
    var out_buffer = std.io.bufferedWriter(out);
    var err_buffer = std.io.bufferedWriter(err);

    var out_writer = out_buffer.writer();
    var err_writer = err_buffer.writer();

    try out_writer.print("Hello {s}!\n", .{"out"});
    try err_writer.print("Hello {s}!\n", .{"err"});
    try out_buffer.flush();
    try err_buffer.flush();
}

pub fn variables() void {
    var variable: u16 = 0;
    variable = 699;
    std.debug.print("variable:{}\n", .{variable});
    var buffer: [8]u8 = undefined;
    itoa(7, &buffer);
    std.debug.print("{any}\n", .{buffer});
    var z: u32 = undefined;
    // var z: u32 = undefined;
    const x, var y, z = [3]u32{ 1, 2, 3 };
    _ = x; // autofix
    y += 10;
    // x 是 1，y 是 2，z 是 3
    std.debug.print("y={}\n", .{y});
    const w = blk: {
        y += 1;
        break :blk y;
    };
    std.debug.print("{}", .{w});
}

fn closure_fn(comptime x: i32) fn (i32) i32 {
    const res = struct {
        pub fn foo(y: i32) i32 {
            var counter: i32 = 0;
            const start = @as(usize, x);
            const end = @as(usize, @intCast(y));
            std.debug.print("from {} to {}", .{ start, end });
            for (start..end) |i| {
                counter += @intCast(i * i);
            }
            return counter;
        }
    }.foo;
    return res;
}

fn addFortyTwo(x: anytype) @TypeOf(x) {
    return x + 42;
}
fn basic_variable_type() !void {
    const a: u32 = 1;
    const b: u32 = 1;
    const c = a / b;
    std.debug.print("value: {}\n", .{c});
    const me_zh = "我";
    try std.io.getStdOut().writer().print("{s}\n", .{me_zh}); // 使用 {s} 并显式传递切片
}

fn itoa(init: u8, output: []u8) void {
    for (output, init..) |*e, v| {
        e.* = @intCast(v);
    }
}

fn advance_type() void {
    const message = [5]u8{ 'h', 'e', 'l', 'l', 'o' };
    print("{s}\n", .{message});
    print("{c}\n", .{message[0]});
    const matrix_4x4 = [4][4]f32{
        [_]f32{ 1.0, 0.0, 0.0, 0.0 },
        [_]f32{ 0.0, 1.0, 0.0, 0.0 },
        [_]f32{ 0.0, 0.0, 1.0, 0.0 },
        [_]f32{ 0.0, 0.0, 0.0, 1.0 },
    };
    for (matrix_4x4, 0..) |col, i| {
        for (col, 0..) |value, j| {
            print("matrix[{}][{}]={}\n", .{ i, j, value });
        }
    }
    const array = [_:0]u8{ 1, 2, 3, 4 };
    print("array.len={}\n", .{array.len});
    print("array[array.len-1]={}\n", .{array[array.len - 1]});
    print("array[array.len]={}\n", .{array[array.len]});

    const small = [3]i8{ 1, 2, 3 };
    const big: [9]i8 = small ** 3;
    print("{any}\n", .{big});
    const part_one = [_]i32{ 1, 2, 3, 4 };
    const part_two = [_]i32{ 5, 6, 7, 8 };
    const all_of_it = part_one ++ part_two;
    print("{any}\n", .{all_of_it});
    const tick = [_]i32{make(1)} ** 3;
    print("{any}\n", .{tick});
    const fancy_array = init: {
        var initial_value: [10]usize = undefined;
        for (&initial_value, 0..) |*pt, i| {
            pt.* = i;
        }
        break :init initial_value;
    };
    print("{any}\n", .{fancy_array});
}

fn advanced_type_vector1() !void {
    const ele_4 = @Vector(4, i32);
    const a = ele_4{ 1, 2, 3, 4 };
    const b = ele_4{ 1, 2, 3, 4 };
    const c = a * b;
    print("Vector c is {any}\n", .{c});
    print("the third element of Vector c is {}\n", .{c[2]});

    var arr1: [4]f32 = [_]f32{ 1.1, 2.2, 3.3, 4.4 };
    const vec: @Vector(4, f32) = arr1;
    print("Vector vec is {any}\n", .{vec});

    const vec2: @Vector(2, f32) = arr1[1..3].*;
    print("Vector vec2 is {any}\n", .{vec2});
    const scalar: u32 = 5;
    const result: @Vector(4, u32) = @splat(scalar);
    print("result is {any}\n", .{result});

    const V = @Vector(4, i32);
    const value = V{ 1, -1, 1, -1 };
    const result1 = value > @as(V, @splat(0));
    print("result1 is {any}\n", .{result1});

    const is_all_true = @reduce(.And, result1);
    print("is_all_true:{}\n", .{is_all_true});
}

fn advanced_type_vector2() !void {
    const a = @Vector(7, u8){ 'o', 'l', 'h', 'e', 'r', 'z', 'w' };
    const b = @Vector(4, u8){ 'w', 'd', '!', 'x' };
    const mask1 = @Vector(5, i32){ 2, 3, 1, 1, 0 };
    const res1: @Vector(5, u8) = @shuffle(u8, a, undefined, mask1);
    const arr: [5]u8 = res1;

    // 将数组转换为切片
    var slice: []const u8 = &arr;
    print("res1 is {s}\n", .{slice});
    const mask2 = @Vector(6, i32){ -1, 0, 4, 1, -2, -3 };
    const res2: @Vector(6, u8) = @shuffle(u8, a, b, mask2);
    const arr2: [6]u8 = res2;
    slice = &arr2; // autofix
    print("res2 is {s}\n", .{slice});
}

fn advanced_type_vector3() !void {
    const ele_4 = @Vector(4, i32);
    const a = ele_4{ 1, 2, 3, 4 };
    const b = ele_4{ 5, 6, 7, 8 };
    const pred = @Vector(4, bool){
        true, false, false, true,
    };
    const c = @select(i32, pred, a, b);
    print("c is {any}\n", .{c});
}
pub extern "c" fn printf(format: [*:0]const u8, ...) c_int;

fn advanced_type_pointer() void {
    var integer: i16 = 666;
    const ptr = &integer;
    ptr.* = ptr.* + 1;
    print("{}\n", .{integer});
    const array = [_]i32{ 1, 2, 3, 4 };
    const ptrs: [*]const i32 = &array;
    print("{}\n", .{ptrs[0]});
    var array1: [5]u8 = "hello".*;
    const array_poniter = &array1;
    print("{}\n", .{array_poniter.len});

    const slice: []u8 = array1[1..3];
    print("{}\n", .{slice.len});
    _ = printf("Hello, world!!");
}

fn advanced_type_slice() void {
    var array = [_]i32{ 1, 2, 3, 4 };
    const len: usize = 3;
    const slice: []i32 = array[0..len];
    for (slice, 0..) |ele, index| {
        _ = printf("#%d:%d\n", index + 1, ele);
    }
    print("type of slice is {}\n", .{@TypeOf(slice)});
    const slice_2: []i32 = array[0..array.len];
    print("type of slice2 is {}\n", .{@TypeOf(slice_2)});
    print("@TypeOf(&slice[0])={}\n", .{@TypeOf(&slice[0])});

    const str_slice: [:0]const u8 = "hello";
    print("type of str_slice :{}\n", .{@TypeOf(str_slice)});
    var arr = [_]u8{ 3, 2, 1, 0, 1, 2, 3, 0 };
    const runtime_length: usize = 3;
    const slice_3: [:0]u8 = arr[0..runtime_length :0];
    print("type of slice_3 :{}\n", .{@TypeOf(slice_3)});
}

fn advanced_type_str() void {
    const bytes = "hello";
    print("{}\n", .{@TypeOf(bytes)});
    print("{d}\n", .{bytes.len});
    print("{c}\n", .{bytes[0]});
    print("{d}\n", .{bytes[5]});
    print("{}\n", .{'e' == '\x65'});
    print("{d}\n", .{'\u{1f4a9}'});
    print("{d}\n", .{'💯'});
    print("{u}\n", .{'⚡'});
    print("{}\n", .{mem.eql(u8, "hello", "h\x65llo")});
    print("{}\n", .{mem.eql(u8, "💯", "\xf0\x9f\x92\xaf")}); // true
    const invalid_utf8 = "\xff\xfe";
    print("0x{x}\n", .{invalid_utf8[1]});
    print("0x{x}\n", .{"💯"[1]});
    funnyPrint("asdasd");
    const message_1 = "hello";
    _ = message_1; // autofix
    const message_2 = [_]u8{ 'h', 'e', 'l', 'l', 'o' };
    _ = message_2; // autofix
    const message_3: []const u8 = &.{ 'h', 'e', 'l', 'l', 'o' };
    _ = message_3; // autofix

}

fn funnyPrint(msg: []const u8) void {
    print("funnyPrint {s}\n", .{msg});
}

pub fn make(x: i32) i32 {
    return x + 1;
}

const Circle = struct {
    radius: u8,
    const PI: f16 = 3.14;
    pub fn init(radius: u8) Circle {
        return Circle{ .radius = radius };
    }
    pub fn area(self: *Circle) f16 {
        return @as(f16, @floatFromInt(self.radius * self.radius)) * PI;
    }
};

fn advanced_type_struct() void {
    const Tuple = struct { u8, u8 };
    _ = Tuple; // autofix
    const radius: u8 = 5;
    var circle = Circle.init(radius);
    print("area is {}", .{circle.area()});
    const values = .{ @as(u32, 1234), @as(f64, 12.34), true, "hi" };
    const hi = values.@"3";
    _ = hi; // autofix
    const Foo = struct {};
    print("variable: {s}\n", .{@typeName(Foo)});
    print("anonymous: {s}\n", .{@typeName(struct {})});
    print("function: {s}\n", .{@typeName(LinkedList(i32))});
}

fn LinkedList(comptime T: type) type {
    return struct {
        pub const Node = struct {
            prev: ?*Node,
            next: ?*Node,
            data: T,
        };
        first: ?*Node,
        last: ?*Node,
        len: usize,
    };
}

const Type = enum {
    ok,
    not_ok,
};

const Value = enum(u2) {
    zero,
    one,
    two,
};
const Value2 = enum(u32) {
    hundred = 100,
    thousand = 1000,
    million = 1000000,
};
const Value3 = enum(u4) {
    a,
    b = 8,
    c,
    d = 4,
    e,
};

const Suit = enum {
    clubs,
    spades,
    diamonds,
    hearts,

    pub fn isClubs(self: Suit) bool {
        return self == Suit.clubs;
    }
};
const Color = enum {
    auto,
    off,
    on,
};

const Color2 = enum(u4) {
    red,
    green,
    blue,
    _,
};

const Number = enum(u8) {
    one,
    two,
    three,
    _,
};

fn advanced_type_enum() void {
    const c = Type.ok;
    print("c is {}\n", .{c});
    const color1: Color = .auto;
    const color2 = Color.auto;
    print("color1==color2?{}\n", .{color1 == color2});
    const number = Number.one;
    const result = switch (number) {
        .one => true,
        .two, .three => false,
        _ => false,
    };
    print("number is one? {}\n", .{result});
    const is_one = switch (number) {
        .one => true,
        else => false,
    };
    print("number is_one? {}\n", .{is_one});

    const blue: Color2 = @enumFromInt(2);
    print("blue == .blue = {}\n", .{blue == .blue});

    // 未列出的枚举值：8 在 u4 的范围内（0~15）
    const yellow: Color2 = @enumFromInt(8);
    print("@TypeOf(yellow)={}\n", .{@TypeOf(yellow)});
    print("@intFromEnum(yellow)={d}\n", .{@intFromEnum(yellow)});
}

pub const Payload = union {
    int: i64,
    float: f64,
    boolean: bool,
};
const ComplexTypeTag = enum {
    ok,
    not_ok,
};
const ComplexType = union(ComplexTypeTag) {
    ok: u8,
    not_ok: void,
};
const Small2 = union(enum) { a: i32, b: bool, c: u8 };

fn advanced_type_union() void {
    var payload = Payload{ .int = 1234 };
    payload = Payload{ .float = 9 };
    print("{}\n", .{payload.float});
    const payload1: Payload = @unionInit(Payload, "int", 1);
    print("{}\n", .{payload1.int});
    var c = ComplexType{ .ok = 42 };
    print("@as(ComplexTypeTag,c)==ComplexTypeTag.ok {}\n", .{@as(ComplexTypeTag, c) == ComplexTypeTag.ok});
    switch (c) {
        ComplexTypeTag.ok => |value| print("value==42 {}\n", .{value == 42}),
        ComplexTypeTag.not_ok => unreachable,
    }
    print("std.meta.Tag(ComplexType)==ComplexTypeTag {}\n", .{std.meta.Tag(ComplexType) == ComplexTypeTag});
    switch (c) {
        ComplexTypeTag.ok => |*value| {
            value.* = 1;
            print("value==1 {}\n", .{value.* == 1});
        },
        ComplexTypeTag.not_ok => unreachable,
    }
    print("std.meta.Tag(ComplexType)==ComplexTypeTag {}\n", .{std.meta.Tag(ComplexType) == ComplexTypeTag});
    const name = @tagName(Small2.a);
    print("@tagName(Small2.a) = {s}\n", .{name});

    const i: Small2 = .{ .a = 1 };
    print("i = {}\n", .{i});

    const val: ?u32 = null;
    if (val) |real_b| {
        _ = real_b;
        print("||\n", .{});
    } else {
        print("else\n", .{});
    }
    var cc: ?u32 = 3;
    if (cc) |*real_c| {
        real_c.* = 1;
        print("real_c {?}\n", .{cc});
    } else {
        print("else\n", .{});
    }
}

fn process_control_loop() void {
    var items = [_]i32{ 3, 4, 5, 6, 7, 8 };
    var sum: i32 = 0;
    for (items) |value| {
        sum += value;
    }
    for (&items) |*value| {
        value.* += 1;
    }
    for (0..5) |i| {
        _ = i;
    }
    for (items, 0..) |value, i| {
        _ = value;
        _ = i;
    }
    const items2 = [_]usize{ 3, 4, 5, 6, 7, 8 };
    for (items, items2) |i, j| {
        _ = i;
        _ = j;
    }

    const result = for (items) |value| {
        if (value == 5) {
            break value;
        }
    } else 0;
    _ = result; // autofix
    var sum2: usize = 0;
    inline for (items2) |i| {
        const T = switch (i) {
            2 => f32,
            6 => i8,
            8 => bool,
            else => i3,
        };
        print("typeNameLength(T): {}\n", .{typeNameLength(T)});

        sum2 += typeNameLength(T);
    }
    print("sum: {}\n", .{sum2});

    var i: usize = 0;
    while (i < 10) {
        if (i == 5) {
            break;
        }
        print("i is {}\n", .{i});
        i += 1;
    }
    while (i < 10) : (i += 1) {}

    outer: while (i < 100) : (i += 1) {
        while (true) {
            continue :outer;
        }
    }
    comptime var k = 0;
    inline while (k < 3) : (k += 1) {
        const T = switch (k) {
            0 => f32,
            1 => i8,
            2 => bool,
            else => i5,
        };
        sum2 += typeNameLength(T);
    }
    numbers_left = 3;
    while (eventuallyNullSequence()) |value| {
        sum2 += value;
    } else {
        print("meet a null\n", .{});
    }
}

fn typeNameLength(comptime T: type) usize {
    return @typeName(T).len;
}

fn rangeHasNumber(begin: usize, end: usize, number: usize) bool {
    var i = begin;
    return while (i < end) : (i += 1) {
        if (i == number) {
            break true;
        }
    } else false;
}

var numbers_left: u32 = undefined;
fn eventuallyNullSequence() ?u32 {
    return if (numbers_left == 0) null else blk: {
        numbers_left -= 1;
        break :blk numbers_left;
    };
}

fn process_control_switch() void {
    const num = 8;
    switch (num) {
        5 => {
            print("this is 5\n", .{});
        },
        else => {
            print("this is not 5\n", .{});
        },
    }
    const a: u64 = 10;
    const zz: u64 = 103;
    const b = switch (a) {
        1, 2, 3 => 0,
        5...100 => 1,
        101 => blk: {
            const c: u64 = 5;
            break :blk c * 2 + 1;
        },
        zz => zz,
        blk: {
            const d: u32 = 5;
            const e: u32 = 100;
            break :blk d + e;
        } => 107,
        else => 9,
    };
    print("b is {}\n", .{b});
    var aa = Item{ .c = Point{ .x = 1, .y = 2 } };
    const bb = switch (aa) {
        Item.a, Item.e => |item| item,
        Item.c => |*item| blk: {
            item.*.x += 1;
            break :blk 6;
        },
        Item.d => 8,
    };
    print("bb is {any}, aa is {any}\n", .{ bb, aa });
}

const Point = struct {
    x: u8,
    y: u8,
};

const Item = union(enum) {
    a: u32,
    c: Point,
    d,
    e: u32,
};

const U = union(enum) {
    a: u32,
    b: f32,
};

fn getNum(u: U) u32 {
    switch (u) {
        inline else => |num, tag| {
            if (tag == .b) {
                return @intFromFloat(num);
            }
            return num;
        },
    }
}

fn process_control_defer_unreadchable() void {
    defer print("exe third\n", .{});
    if (false) {
        defer print("will not exec\n", .{});
    }
    defer {
        print("exec second\n", .{});
    }
    defer {
        print("exec first\n", .{});
    }
    const x = 1;
    const y = 2;
    if (x + y != 3) {
        unreachable;
    }
}
