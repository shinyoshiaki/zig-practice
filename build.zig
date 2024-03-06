const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zig-c-lang",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.addIncludePath(.{ .path = "c-src" });

    exe.linkLibrary(b.addSharedLibrary(.{
        .name = "libdatachannel",
        .root_source_file = .{ .path = "submodules/libdatachannel/build/libdatachannel.so" },
        .target = target,
        .optimize = optimize,
    }));
    exe.addIncludePath(.{ .path = "submodules/libdatachannel/include/rtc" });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
