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

        fn init(allocator: std.mem.Allocator) This {
            return This{
                .allocator = allocator,
                .length = 0,
                .head = null,
                .tail = null,
            };
        }

        fn prepend(this: *This, item: T) !void {
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

        // fn insertAt(this: *This, value: T, index: usize) error{ IndexOutOfRange, OutOfMemory }!void {
        //     if (index > this.length) {
        //         return .IndexOutOfRange;
        //     } else if (index == this.length) {
        //         this.append(value);
        //         return;
        //     } else if (index == 0) {
        //         this.prepend(value);
        //         return;
        //     }
        //
        //     var curr = this.head;
        //     for (0..index) |_| {
        //         curr = curr.next;
        //     }
        //     var node = this.allocator.create(Node) catch return .OutOfMemory;
        //     node.* = Node{ .value = value, .prev = curr.?.prev, .next = curr };
        //     curr.prev = node;
        //
        //     // TODO
        //     // curr.?.prev.?.next = curr;
        //
        //     this.length += 1;
        // }

        // fn append(this: *This, item: DoublyLinkedList) void {
        //     this.length += 1;
        //     var node = try this.allocator.create(Node);
        //     node.* = Node{ .value = value, .prev = null, .next = null };
        //
        //     if (this.tail == null orelse this.head) {
        //         this.head = node;
        //         this.tail = node;
        //     }
        //
        //     node.*.prev = this.tail;
        //     this.tail.?.next = node;
        //     this.tail = node;
        // }

        fn remove(this: *This, value: T) ?T {
            if (this.head) |head| {
                var node = findNodeByVal(head, value);
                if (node) |node_ptr| {
                    const node_value = node_ptr.*.value;
                    this.length -= 1;
                    if (this.length == 0) {
                        return if (this.head) |out| {
                            this.allocator.destroy(node_ptr);
                            // this.head = null;
                            // this.tail = null;
                            return out.value;
                        } else null;
                    }

                    if (node_ptr.prev) |_| {
                        node_ptr.prev = node_ptr.next;
                    }
                    if (node_ptr.next) |_| {
                        node_ptr.next = node_ptr.prev;
                    }

                    if (node_ptr == this.head) {
                        this.head = node_ptr.next;
                    }
                    if (node_ptr == this.tail) {
                        this.tail = node_ptr.prev;
                    }

                    node_ptr.prev = null;
                    node_ptr.next = null;
                    this.allocator.destroy(node_ptr);
                    return node_value;
                } else {
                    return null;
                }
            } else {
                return null;
            }
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

        fn removeAt(this: *This, index: usize) !?T {
            _ = this;
            _ = index;
            return null;
        }

        fn get(this: *This, index: usize) ?DoublyLinkedList {
            _ = this;
            _ = index;
            return null;
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
    try std.testing.expectEqual(linked_list.head.?.value, 10);

    try linked_list.prepend(11);
    try std.testing.expectEqual(linked_list.head.?.value, 11);

    _ = linked_list.remove(10);
    try std.testing.expectEqual(linked_list.length, 1);

    std.debug.print("linked_list: {any}\n", .{linked_list});

    _ = linked_list.remove(11);
    try std.testing.expectEqual(linked_list.length, 0);

    std.debug.print("linked_list: {any}\n", .{linked_list});
}
