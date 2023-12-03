const std = @import("std");
const ArrayList = std.ArrayList;

pub fn BinaryNode(comptime T: type) type {
    return struct {
        value: T,
        right: ?*BinaryNode(T),
        left: ?*BinaryNode(T),
    };
}

fn pre_walk(node: ?*BinaryNode(u8), path: *std.ArrayList(u8)) !void {
    if (node) |node_ptr| {
        try path.*.append(node_ptr.value);
        _ = try pre_walk(node_ptr.left, path);
        _ = try pre_walk(node_ptr.right, path);
    }
}

fn pre_order(alloc: std.mem.Allocator, node: *BinaryNode(u8)) ![]u8 {
    var path = ArrayList(u8).init(alloc);
    try pre_walk(node, &path);
    return path.toOwnedSlice();
}

fn in_walk(node: ?*BinaryNode(u8), path: *std.ArrayList(u8)) !void {
    if (node) |node_ptr| {
        _ = try in_walk(node_ptr.left, path);
        try path.*.append(node_ptr.value);
        _ = try in_walk(node_ptr.right, path);
    }
}

fn in_order(alloc: std.mem.Allocator, node: *BinaryNode(u8)) ![]u8 {
    var path = ArrayList(u8).init(alloc);
    try in_walk(node, &path);
    return path.toOwnedSlice();
}

fn post_walk(node: ?*BinaryNode(u8), path: *std.ArrayList(u8)) !void {
    if (node) |node_ptr| {
        _ = try post_walk(node_ptr.left, path);
        _ = try post_walk(node_ptr.right, path);
        try path.*.append(node_ptr.value);
    }
}

fn post_order(alloc: std.mem.Allocator, node: *BinaryNode(u8)) ![]u8 {
    var path = ArrayList(u8).init(alloc);
    try post_walk(node, &path);
    return path.toOwnedSlice();
}

test "ordering" {
    // Pre ordering
    var node1 = BinaryNode(u8){ .value = 10, .right = null, .left = null };
    var node2 = BinaryNode(u8){ .value = 11, .right = null, .left = null };
    var node3 = BinaryNode(u8){ .value = 12, .right = null, .left = null };
    node1.left = &node2;
    node1.right = &node3;
    var order = try pre_order(std.testing.allocator, &node1);
    try std.testing.expectEqualSlices(u8, &[3]u8{ 10, 11, 12 }, order);
    std.testing.allocator.free(order);
}

test "in ordering" {
    // In ordering
    var node1 = BinaryNode(u8){ .value = 10, .right = null, .left = null };
    var node2 = BinaryNode(u8){ .value = 11, .right = null, .left = null };
    var node3 = BinaryNode(u8){ .value = 12, .right = null, .left = null };
    node1.right = &node3;
    node1.left = &node2;
    var order = try in_order(std.testing.allocator, &node1);
    try std.testing.expectEqualSlices(u8, &[3]u8{ 11, 10, 12 }, order);
    std.testing.allocator.free(order);
}

test "post ordering" {
    // Post ordering
    var node1 = BinaryNode(u8){ .value = 10, .right = null, .left = null };
    var node2 = BinaryNode(u8){ .value = 11, .right = null, .left = null };
    var node3 = BinaryNode(u8){ .value = 12, .right = null, .left = null };
    node1.right = &node3;
    node1.left = &node2;
    var order = try post_order(std.testing.allocator, &node1);
    try std.testing.expectEqualSlices(u8, &[3]u8{ 11, 12, 10 }, order);
    std.testing.allocator.free(order);
}
