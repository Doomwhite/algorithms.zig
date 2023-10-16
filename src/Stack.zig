const std = @import("std");

pub fn Stack(comptime T: type) type {
    return struct {
        const This = @This();
        const Node = struct {
            value: T,
            prev: ?*Node,
        };

        gpa: std.mem.Allocator,
        length: usize,
        head: ?*Node,

        fn init(gpa: std.mem.Allocator) This {
            return This{
                .gpa = gpa,
                .length = 0,
                .head = null,
            };
        }

        fn push(this: *This, item: T) !void {
            var node = try this.gpa.create(Node);
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
            this.length = @max(0, this.length - 1);
            if (this.length == 0) {
                var head = this.head;
                this.head = null;
                return head;
            }

            var head = this.head;
            this.head = head.?.prev;
            defer this.gpa.destroy(head);
            return head.value;
        }

        fn peek() ?T {
            return null;
        }
    };
}

test "Stack" {
    var stack = Stack(u8).init(std.testing.allocator);
    try stack.push(@as(u8, 10));
    try std.testing.expectEqual(@as(usize, 1), stack.length);
}
