const std = @import("std");

pub fn main() !void {
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
    variables();
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
}

fn itoa(init: u8, output: []u8) void {
    for (output, init..) |*e, v| {
        e.* = @intCast(v);
    }
}
