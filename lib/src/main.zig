const std = @import("std");
const testing = std.testing;

const rtc = @cImport({
    @cInclude("rtc.h");
});

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

test "basic add functionality" {
    try testing.expect(add(3, 7) == 10);
}
