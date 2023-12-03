const std = @import("std");
const BinaryNode = @import("TreeTraversal.zig").BinaryNode;

pub fn compare(a: ?*BinaryNode(u8), b: ?*BinaryNode(u8)) bool {
    if (a == null and b == null) return true;
    if (a == null or b == null) return false;
    if (a.?.value != b.?.value) return false;
    return compare(a.?.left, b.?.left) and compare(a.?.right, b.?.right);
}

test "BinaryTreeComparison" {
    var first = BinaryNode(u8){
        .value = 11,
        .left = null,
        .right = null,
    };
    var second = BinaryNode(u8){
        .value = 12,
        .left = null,
        .right = null,
    };
    var third = BinaryNode(u8){
        .value = 10,
        .left = &first,
        .right = &second,
    };
    try std.testing.expect(compare(&third, &third));
    try std.testing.expect(!compare(&third, &second));
    var fourth = BinaryNode(u8){
        .value = 11,
        .left = null,
        .right = null,
    };
    var fifth = BinaryNode(u8){
        .value = 12,
        .left = null,
        .right = null,
    };
    var sixth = BinaryNode(u8){
        .value = 10,
        .left = &fourth,
        .right = &fifth,
    };
    try std.testing.expect(compare(&third, &sixth));
}
