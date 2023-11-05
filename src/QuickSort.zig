const std = @import("std");

pub fn QuickSort(arr: []u16, lo: usize, hi: usize) void {
    if (lo >= hi) {
        return;
    }

    const pivotIdx = partition(arr, lo, hi);
    QuickSort(arr, lo, pivotIdx - 1);
    QuickSort(arr, pivotIdx + 1, hi);
}

pub fn partition(arr: []u16, lo: usize, hi: usize) usize {
    const pivot: u16 = arr[hi];

    var idx: usize = undefined;
    if (lo >= 1) {
        idx = lo - 1;
    } else {
        idx = 0;
    }
    for (lo..hi) |i| {
        if (arr[i] <= pivot) {
            idx += 1;
            std.mem.swap(u16, &arr[i], &arr[idx]);
        }
    }

    idx += 1;
    arr[hi] = arr[idx];
    arr[idx] = pivot;

    return idx;
}

test "Quick sort" {
    var arr = [_]u16{ 9, 3, 7, 4, 69, 420, 42 };
    const result = [_]u16{ 3, 4, 7, 9, 42, 69, 420 };
    QuickSort(&arr, 0, arr.len - 1);
    try std.testing.expectEqualSlices(u16, &arr, &result);
}
