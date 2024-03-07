const std = @import("std");

pub fn build(b: *std.Build) void {
    const mod = b.addModule("mediasoupclient", .{
        .root_source_file = .{ .path = "src/main.zig" },
    });
    mod.addIncludePath(.{ .cwd_relative = "/home/shin/code/zig-c-lang/submodules/libdatachannel/include/rtc" });
    mod.link_libc = true;
    mod.addObjectFile(.{ .cwd_relative = "/home/shin/code/zig-c-lang/submodules/libdatachannel/build/libdatachannel.so" });
}
