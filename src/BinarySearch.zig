const std = @import("std");

fn binarySearch(arr: []const u32, needle: u32) bool {
    var lo: usize = 0;
    var hi: usize = arr.len;

    while (lo < hi) {
        const m: usize = lo + (hi -| lo) / 2;
        const v: u32 = arr[m];

        if (v == needle) {
            return true;
        } else if (v > needle) {
            hi = m;
        } else {
            lo = m + 1;
        }
    } else {
        return false;
    }
}

test "Binary Search" {
    const arr = [_]u32{ 1, 2, 3, 4, 5, 6, 7 };
    try std.testing.expectEqual(binarySearch(&arr, 8), false);
    try std.testing.expectEqual(binarySearch(&arr, 7), true);
}
