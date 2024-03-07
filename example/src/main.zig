// src/main.zig

const std = @import("std");
// const mediasoupclient =
//     @cImport({
//     @cInclude("mediasoupclient.h");
// });
pub extern fn opus() i32;
const mediasoupclient = @import("mediasoupclient");

fn log(comptime format: []const u8, args: anytype) !void {
    var stdout = std.io.getStdOut().writer();
    try stdout.print(format, args);
}

pub fn main() !void {
    try log("{d}\n", .{
        mediasoupclient.add(0, 0),
        // opus(),
    });
}

test "test add" {}
