const std = @import("std");
const print = std.debug.print;

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
    advanced_type_pointer();
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

pub fn make(x: i32) i32 {
    return x + 1;
}
