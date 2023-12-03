const std = @import("std");
const BinaryNode = @import("TreeTraversal.zig").BinaryNode;

fn bdf(alloc: std.mem.Allocator, head: *BinaryNode(u8), needle: u8) !bool {
    var arena_allocator = std.heap.ArenaAllocator.init(alloc);
    defer arena_allocator.deinit();
    const allocator = arena_allocator.allocator();

    var queue = std.ArrayList(*BinaryNode(u8)).init(allocator);
    try queue.append(head);

    return while (queue.items.len > 0) {
        var next = queue.orderedRemove(0);
        if (next.value == needle) return true;
        if (next.left) |left| try queue.append(left);
        if (next.right) |right| try queue.append(right);
    } else false;
}

test "BreadthFirstSearch" {
    var third_node = BinaryNode(u8){
        .value = 11,
        .left = null,
        .right = null,
    };
    var second_node = BinaryNode(u8){
        .value = 12,
        .left = null,
        .right = null,
    };
    var first_node = BinaryNode(u8){
        .value = 10,
        .left = &second_node,
        .right = &third_node,
    };
    try std.testing.expect(try bdf(std.testing.allocator, &first_node, 11));
}
