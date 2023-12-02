const std = @import("std");

pub fn DoublyLinkedList(comptime T: type) type {
    return struct {
        const Node = struct {
            value: T,
            prev: ?*Node,
            next: ?*Node,
        };
        const This = @This();

        allocator: std.mem.Allocator,
        length: usize = 0,
        head: ?*Node,
        tail: ?*Node,

        pub fn init(allocator: std.mem.Allocator) This {
            return This{
                .allocator = allocator,
                .length = 0,
                .head = null,
                .tail = null,
            };
        }

        pub fn prepend(this: *This, item: T) !void {
            var node: *Node = try this.allocator.create(Node);
            node.* = Node{ .value = item, .prev = null, .next = null };

            this.length += 1;
            if (this.head) |*head| {
                node.next = head.*;
                head.*.prev = node;
                head.* = node;
            } else {
                this.head = node;
                this.tail = node;
            }
        }

        pub fn insertAt(this: *This, index: usize, value: T) anyerror!void {
            if (index == 0) {
                try this.prepend(value);
                return;
            } else if (index == this.length) {
                try this.append(value);
                return;
            } else if (index > this.length) {
                return error.IndexOutOfRange;
            }

            var node_at = this.getAt(index);
            if (node_at) |node_at_ptr| {
                if (node_at_ptr.prev) |prev_ptr| {
                    var node: *Node = try this.allocator.create(Node);
                    node.* = Node{ .value = value, .prev = prev_ptr, .next = node_at_ptr };
                    prev_ptr.next = node;
                    node_at_ptr.prev = node;
                    this.length += 1;
                } else {
                    return error.IndexOutOfRange;
                }
            }
        }

        pub fn append(this: *This, value: T) !void {
            this.length += 1;
            var node = try this.allocator.create(Node);
            node.* = Node{ .value = value, .prev = null, .next = null };

            if (this.tail) |_| {
                node.prev = this.tail;
                this.tail.?.next = node;
                this.tail = node;
            } else {
                this.head = node;
                this.tail = node;
            }
        }

        pub fn remove(this: *This, value: T) ?T {
            if (this.head) |head| {
                var node = findNodeByVal(head, value);
                if (node) |node_ptr| {
                    return this.removeNode(node_ptr);
                } else {
                    return null;
                }
            } else {
                return null;
            }
        }

        pub fn removeAt(this: *This, index: usize) ?T {
            var node = this.getAt(index);
            return if (node) |node_ptr| {
                return this.removeNode(node_ptr);
            } else null;
        }

        pub fn getAt(this: *This, index: usize) ?*Node {
            if (index == 0) return this.head;
            var node: ?*Node = this.head;
            for (0..index) |_| {
                if (node.?.next) |node_value| {
                    node = node_value;
                }
            }
            return node;
        }

        fn removeNode(this: *This, node_ptr: *Node) ?T {
            const node_value = node_ptr.*.value;
            this.length -= 1;
            if (this.length == 0) {
                return if (this.head) |out| {
                    const new_out = out.value;
                    this.allocator.destroy(node_ptr);
                    this.head = null;
                    this.tail = null;
                    return new_out;
                } else null;
            }

            if (node_ptr == this.head) {
                this.head = node_ptr.next;
            }
            if (node_ptr == this.tail) {
                this.tail = node_ptr.prev;
            }
            if (node_ptr.next) |_| {
                node_ptr.next.?.prev = node_ptr.prev;
            }
            if (node_ptr.prev) |_| {
                node_ptr.prev.?.next = node_ptr.next;
            }

            this.allocator.destroy(node_ptr);
            return node_value;
        }

        fn findNodeByVal(node: *Node, value: T) ?*Node {
            if (node.value == value) return node;

            if (node.next) |next_node| {
                if (next_node.value == value) {
                    return next_node;
                } else {
                    return findNodeByVal(next_node, value);
                }
            } else {
                return null;
            }
        }
    };
}

test "Doubly Linked List" {
    // var arena_allocator = std.heap.ArenaAllocator.init(std.testing.allocator);
    // defer arena_allocator.deinit();
    // var allocator = arena_allocator.allocator();
    var allocator = std.testing.allocator;
    var linked_list = DoublyLinkedList(u8).init(allocator);
    try linked_list.prepend(10);
    try linked_list.prepend(11);
    try linked_list.prepend(12);
    try linked_list.prepend(13);
    try linked_list.prepend(14);
    try std.testing.expectEqual(linked_list.getAt(0).?.value, 14);
    try std.testing.expectEqual(linked_list.getAt(1).?.value, 13);
    try std.testing.expectEqual(linked_list.getAt(2).?.value, 12);
    try std.testing.expectEqual(linked_list.getAt(3).?.value, 11);
    try std.testing.expectEqual(linked_list.getAt(4).?.value, 10);
    _ = linked_list.remove(10);
    _ = linked_list.remove(13);
    _ = linked_list.remove(12);
    _ = linked_list.remove(14);
    _ = linked_list.remove(11);

    try linked_list.append(10);
    try linked_list.append(11);
    try linked_list.append(12);
    try linked_list.append(13);
    try linked_list.append(14);
    try std.testing.expectEqual(linked_list.getAt(0).?.value, 10);
    try std.testing.expectEqual(linked_list.getAt(1).?.value, 11);
    try std.testing.expectEqual(linked_list.getAt(2).?.value, 12);
    try std.testing.expectEqual(linked_list.getAt(3).?.value, 13);
    try std.testing.expectEqual(linked_list.getAt(4).?.value, 14);
    _ = linked_list.removeAt(4);
    _ = linked_list.removeAt(3);
    _ = linked_list.removeAt(2);
    _ = linked_list.removeAt(1);
    _ = linked_list.removeAt(0);

    try linked_list.insertAt(0, 10);
    try linked_list.insertAt(1, 11);
    try std.testing.expectEqual(linked_list.getAt(0).?.value, 10);
    try std.testing.expectEqual(linked_list.getAt(1).?.value, 11);
    _ = linked_list.removeAt(0);
    _ = linked_list.removeAt(1);
}
