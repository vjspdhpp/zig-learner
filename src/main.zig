const std = @import("std");

pub fn main() !void {
    try hello_world();
    variables();
    try basic_variable_type();
    const closure = closure_fn(1);
    const three = closure(4);
    std.debug.print("closure(3)={}", .{three});
    _ = addFortyTwo(1);
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
