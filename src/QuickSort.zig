const std = @import("std");

pub fn QuickSort(arr: []u16, lo: usize, hi: usize) void {
    if (lo >= hi) {
        return;
    }

    const pivotIndex: usize = partition(arr, lo, hi);
    QuickSort(arr, lo, pivotIndex -| 1);
    QuickSort(arr, pivotIndex +| 1, hi);
}

pub fn partition(arr: []u16, lo: usize, hi: usize) usize {
    const pivot: u16 = arr[hi];

    // Sorts the higher values than the pivot
    // basically a bubbleSort that keeps the index of the last swapped value

    var index: isize = @as(isize, @intCast(lo)) - 1;
    for (lo..hi) |i| {
        if (arr[i] <= pivot) {
            index += 1;
            std.mem.swap(u16, &arr[i], &arr[@intCast(index)]);
        }
    }

    // Swaps the right item to the last swapped item with the pivot

    index += 1;
    arr[hi] = arr[@intCast(index)];
    arr[@intCast(index)] = pivot;

    return @intCast(index);
}

pub fn Sort(arr: []u16) void {
    QuickSort(arr, 0, arr.len - 1);
}

test "Quick sort" {
    var arr = [_]u16{ 9, 3, 7, 4, 69, 420, 42 };
    const result = [_]u16{ 3, 4, 7, 9, 42, 69, 420 };
    Sort(&arr);
    try std.testing.expectEqualSlices(u16, &arr, &result);

    var arr_2 = [_]u16{ 420, 69, 42, 9, 7, 4, 3 };
    const result_2 = [_]u16{ 3, 4, 7, 9, 42, 69, 420 };
    Sort(&arr_2);
    try std.testing.expectEqualSlices(u16, &arr_2, &result_2);

    var arr_3 = [_]u16{ 420, 69, 42, 9, 7, 4, 3, 420, 69, 42, 9, 7, 4, 3 };
    const result_3 = [_]u16{ 3, 3, 4, 4, 7, 7, 9, 9, 42, 42, 69, 69, 420, 420 };
    Sort(&arr_3);
    try std.testing.expectEqualSlices(u16, &arr_3, &result_3);

    var arr_4 = [_]u16{ 420, 69, 42, 9, 7, 4, 3, 420, 69, 42, 9, 7, 4, 3, 420, 69, 42, 9, 7, 4, 3, 420, 69, 42, 9, 7, 4, 3 };
    const result_4 = [_]u16{ 3, 3, 3, 3, 4, 4, 4, 4, 7, 7, 7, 7, 9, 9, 9, 9, 42, 42, 42, 42, 69, 69, 69, 69, 420, 420, 420, 420 };
    Sort(&arr_4);
    try std.testing.expectEqualSlices(u16, &arr_4, &result_4);
}
