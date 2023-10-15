const std = @import("std");
const math = std.math;

const TwoCrystalProblemErrors = error{NotFound};

pub fn TwoCrystalProblem(arr: []bool) TwoCrystalProblemErrors!usize {
    const jmpAmount = math.sqrt(arr.len);

    var i = jmpAmount;
    while (i < arr.len) : (i += jmpAmount) {
        if (arr[i]) {
            break;
        }
    }

    i -= jmpAmount;

    var j: usize = 0;
    while (j <= jmpAmount and i < arr.len) : ({
        i += 1;
        j += 1;
    }) {
        if (arr[i]) {
            return i;
        }
    }

    return TwoCrystalProblemErrors.NotFound;
}

test "TwoCrystalProblem" {
    var empty_arr = [_]bool{false} ** 100000;
    var expectedIndex: usize = 80000;
    var arr = [_]bool{false} ** 100000;
    for (arr[expectedIndex..]) |*haha| {
        haha.* = true;
    }

    try std.testing.expectEqual(expectedIndex, try TwoCrystalProblem(&arr));
    try std.testing.expectError(TwoCrystalProblemErrors.NotFound, TwoCrystalProblem(&empty_arr));
}
