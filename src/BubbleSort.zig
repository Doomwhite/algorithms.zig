const std = @import("std");

pub fn bubbleSort(arr: []i32) void {
    var n: usize = arr.len;
    while (n > 1) {
        var new_n: usize = 0;
        for (arr[0 .. n - 1], arr[1..n], 0..) |*ptr, *next_ptr, i| {
            const value: i32 = ptr.*;
            const next_value: i32 = next_ptr.*;
            if (value > next_value) {
                std.mem.swap(i32, ptr, next_ptr);
                new_n = i + 1;
            }
        }
        n = new_n;
    }
}

const arr_size = 7;

test "Bubble sort" {
    var arr = [arr_size]i32{ 4, 3, 42, 7, 69, 9, 420 };
    bubbleSort(&arr);
    const expected_arr = [arr_size]i32{ 3, 4, 7, 9, 42, 69, 420 };

    try std.testing.expectEqualSlices(i32, &expected_arr, &arr);
}
