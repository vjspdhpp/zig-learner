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
}
