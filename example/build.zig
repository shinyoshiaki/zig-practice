const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "exe",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.addIncludePath(.{ .cwd_relative = "/home/shin/code/zig-c-lang/submodules/libdatachannel/include/rtc" });
    exe.linkLibC();
    exe.addObjectFile(.{ .cwd_relative = "/home/shin/code/zig-c-lang/submodules/libdatachannel/build/libdatachannel.so" });
    const mod = b.dependency("mediasoupclient", .{});
    exe.root_module.addImport("mediasoupclient", mod.module("mediasoupclient"));

    exe.addRPath(.{ .path = "../submodules/libdatachannel/build" });

    b.installArtifact(exe);
}
