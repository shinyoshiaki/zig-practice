const std = @import("std");
const testing = std.testing;

const rtc = @cImport({
    @cInclude("rtc.h");
});

const BUFFER_SIZE: usize = 2048;

pub fn add(_: i32, _: i32) i32 {
    // return a + b;
    return rtc.RTC_CODEC_OPUS;
}

pub fn one() i32 {
    return 1;
}

pub fn opus() i32 {
    return rtc.RTC_CODEC_OPUS;
}

const PeerContext = struct {
    offer: [:0]const u8,
    allocator: *const std.mem.Allocator,
};

pub const Peer = struct {
    const Self = @This();
    pc: c_int,
    ctx: *PeerContext,
    ctxAllocator: *const std.mem.Allocator,

    pub fn create() !Peer {
        const config: rtc.rtcConfiguration = .{};
        const _pc = rtc.rtcCreatePeerConnection(&config);

        const ctxAllocator = std.heap.page_allocator;
        const ctx = try ctxAllocator.create(PeerContext);

        return .{ .pc = _pc, .ctx = ctx, .ctxAllocator = &ctxAllocator };
    }

    pub fn init(self: Self) void {
        self.ctx.offer = "some";
        self.ctx.allocator = &std.heap.page_allocator;
        rtc.rtcSetUserPointer(self.pc, self.ctx);
    }

    pub fn createOffer(self: Self) void {
        _ = rtc.rtcSetLocalDescriptionCallback(self.pc, struct {
            pub fn f(_: c_int, sdp: [*c]const u8, _: [*c]const u8, ptr: ?*anyopaque) callconv(.C) void {
                std.debug.print("{s}\n", .{sdp});

                const ctx: *PeerContext = @ptrCast(@alignCast(ptr));
                const span: [:0]const u8 = std.mem.span(sdp);

                const slice = ctx.allocator.allocSentinel(u8, span.len, 0) catch |err| {
                    std.debug.print("failed to allocate: {}\n", .{err});
                    return;
                };

                @memcpy(slice, span);
                ctx.offer = slice;
            }
        }.f);

        const dc = rtc.rtcCreateDataChannel(self.pc, "test");
        _ = rtc.rtcSetMessageCallback(dc, struct {
            pub fn f(id: c_int, message: [*c]const u8, size: c_int, _: ?*anyopaque) callconv(.C) void {
                std.debug.print("{d} {s} {d}\n", .{ id, message, size });
            }
        }.f);
    }

    pub fn setRemoteDescription(self: Self, sdp: [:0]const u8, kind: []const u8) !void {
        if (std.mem.eql(u8, kind, "offer")) {
            const res = rtc.rtcSetRemoteDescription(self.pc, sdp, "offer");
            std.debug.print("srd {d}\n", .{res});
        } else {
            const res = rtc.rtcSetRemoteDescription(self.pc, sdp, "answer");
            std.debug.print("srd {d}\n", .{res});
        }

        const str: [*c]u8 = undefined;
        const res = rtc.rtcGetRemoteDescription(self.pc, str, BUFFER_SIZE);
        std.debug.print("res {d}\n", .{res});
    }
};

test "basic add functionality" {
    try testing.expect(add(3, 7) == 10);
}
