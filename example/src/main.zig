// src/main.zig

const std = @import("std");
const mediasoupclient = @import("mediasoupclient");

pub fn main() !void {
    const offer = try mediasoupclient.Peer.create();
    offer.init();
    const ctx = offer.ctx;

    offer.createOffer();
    const answer = try mediasoupclient.Peer.create();

    std.time.sleep(500_000_000);

    std.debug.print("ctx.offer {s}\n", .{
        ctx.offer,
    });
    try answer.setRemoteDescription(ctx.offer, "answer");
}
