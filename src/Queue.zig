const std = @import("std");
const Allocator = std.mem.Allocator;

pub const QueueNode = struct {
    value: usize,
    next: ?*QueueNode,
};

pub const Queue = struct {
    length: usize = 0,
    head: ?*QueueNode,
    tail: ?*QueueNode,

    pub fn enqueue(self: *Queue, allocator: Allocator, item: usize) !void {
        var node = try allocator.create(QueueNode);
        node.* = QueueNode{ .value = item, .next = null };
        self.length += 1;
        if (self.tail == null) {
            self.head = node;
            self.tail = node;
        } else {
            self.tail.?.next = node;
            self.tail = node;
        }
    }

    pub fn deque(self: *Queue) ?usize {
        if (self.head == null) return null;

        self.length -= 1;

        var head = self.head.?;
        self.head = self.head.?.next;
        head.next = null;

        return head.value;
    }

    pub fn peek(self: *Queue) ?usize {
        if (self.tail) |tail| {
            return tail.value;
        } else {
            return null;
        }
    }
};

test "Queue" {
    var allocator = std.testing.allocator;
    var queue = Queue{
        .length = 0,
        .tail = null,
        .head = null,
    };
    try queue.enqueue(allocator, 10);
    try std.testing.expectEqual(@as(usize, 1), queue.length);
    try queue.enqueue(allocator, 10);
    try std.testing.expectEqual(@as(usize, 2), queue.length);
    _ = queue.deque();
    try std.testing.expectEqual(@as(usize, 1), queue.length);
    std.debug.print("queue: {any}\n", .{queue});
    // var value = queue.peek();
    // try std.testing.expectEqual(@as(usize, 10), value orelse 0);
}
