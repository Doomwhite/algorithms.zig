const std = @import("std");
const bubbleSort = @import("BubbleSort.zig");
const TwoCrystalProblem = @import("TwoCrystalProblem.zig");

pub fn main() !void {
    var arr = [_]bool{ false, false, false, false, false, false, false, true, true, true, true };
    std.debug.print("TwoCrystalProblem.TwoCrystalProblem(&arr): {any}\n", .{TwoCrystalProblem.TwoCrystalProblem(&arr)});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
