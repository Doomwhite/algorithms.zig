const std = @import("std");

fn bubbleSort(arr: []i32) void {
    var n = arr.len;
    while (n > 1) {
        var new_n: usize = 0;
        for (arr[0 .. n - 1], 0..) |value, i| {
            if (value > arr[i + 1]) {
                std.mem.swap(i32, &arr[i], &arr[i + 1]);
                new_n = i + 1;
            }
        }
        // After each iteration the biggest element bubbles up the array
        n = new_n;
    }
}

const arr_size = 7;

test "Bubble sort" {
    // const y: usize = 9;
    // var haha = @constCast(&y);
    // _ = haha;

    // const unsorted_arr = [arr_size]i32{ 3, 4, 7, 9, 42, 69, 420 };
    // for (unsorted_arr) |value| {
    //     std.mem.swap(i32, value, 20);
    //     std.debug.print("@constCast(&i32): {any}\n", .{@constCast(&i32)});
    //     std.debug.print("value: {any}\n", .{value});
    // }

    var arr = [arr_size]i32{ 3, 4, 7, 9, 42, 69, 420 };
    bubbleSort(&arr);
    const expected_arr = [arr_size]i32{ 3, 4, 7, 9, 42, 69, 420 };

    try std.testing.expectEqualSlices(i32, &expected_arr, &arr);
}
