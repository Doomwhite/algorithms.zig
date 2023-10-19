const std = @import("std");

pub fn Stack(comptime T: type) type {
    return struct {
        const This = @This();
        const Node = struct {
            value: T,
            prev: ?*Node,
        };

        allocator: std.mem.Allocator,
        length: usize,
        head: ?*Node,

        fn init(allocator: std.mem.Allocator) This {
            return This{
                .allocator = allocator,
                .length = 0,
                .head = null,
            };
        }

        fn push(this: *This, item: T) !void {
            var node = try this.allocator.create(Node);
            node.* = Node{ .value = item, .prev = null };

            this.length += 1;
            if (this.head == null) {
                this.head = node;
                return;
            }

            node.prev = this.head;
            this.head = node;
        }

        fn pop(this: *This) ?T {
            const head = this.head orelse return null;
            defer this.allocator.destroy(head);
            this.length = @max(0, this.length -% 1);
            this.head = head.prev;
            return head.value;
        }

        fn peek(this: *This) ?T {
            return if (this.head) |head| head.value else null;
        }
    };
}

test "Stack" {
    var stack = Stack(u8).init(std.testing.allocator);
    try stack.push(@as(u8, 10));
    try stack.push(@as(u8, 20));
    try stack.push(@as(u8, 30));
    try stack.push(@as(u8, 40));
    try stack.push(@as(u8, 50));
    try std.testing.expectEqual(@as(usize, 5), stack.length);
    try std.testing.expectEqual(stack.peek(), 50);
    try std.testing.expectEqual(stack.pop(), 50);
    try std.testing.expectEqual(stack.pop(), 40);
    try std.testing.expectEqual(stack.pop(), 30);
    try std.testing.expectEqual(stack.pop(), 20);
    try std.testing.expectEqual(stack.pop(), 10);
    try std.testing.expectEqual(stack.pop(), null);
}
