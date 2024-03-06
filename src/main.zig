// src/main.zig

const std = @import("std");

const arithmetic = @cImport({
    @cInclude("arithmetic.c");
});

const rtc = @cImport({
    @cInclude("rtc.h");
});

fn add(x: i32, y: i32) i32 {
    return arithmetic.add(x, y);
}

fn log(comptime format: []const u8, args: anytype) !void {
    var stdout = std.io.getStdOut().writer();
    try stdout.print(format, args);
}

pub fn main() !void {
    const x: i32 = 5;
    const y: i32 = 16;
    const z: i32 = add(x, y);

    try log("{d}\n", .{rtc.RTC_CODEC_OPUS});
    try log("{d} + {d} = {d}\n", .{ x, y, z });
}

test "test add" {
    try std.testing.expectEqual(@as(i32, 21), add(5, 16));
}
