const std = @import("std");
const BinaryNode = @import("TreeTraversal.zig").BinaryNode;
const compare = @import("BinaryTreeComparison.zig").compare;

pub fn main() !void {
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
