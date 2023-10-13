const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn QueueNode(comptime T: type) type {
    return struct {
        value: T,
        next: ?*QueueNode(T),
    };
}

pub fn Queue(comptime T: type) type {
    return struct {
        length: usize = 0,
        head: ?*QueueNode(T),
        tail: ?*QueueNode(T),

        pub fn enqueue(self: *Queue(T), node: *QueueNode(T)) !void {
            self.length += 1;
            if (self.tail == null) {
                self.head = node;
                self.tail = node;
            } else {
                self.tail.?.next = node;
                self.tail = node;
            }
        }

        pub fn deque(self: *Queue(T)) ?T {
            if (self.head == null) return null;

            self.length -= 1;

            var head = self.head.?;
            std.debug.print("head: {any}\n", .{head});
            std.debug.print("self: {any}\n", .{self});
            self.head = self.head.?.next;
            head.next = null;

            return head.value;
        }

        pub fn peek(self: *Queue(T)) ?T {
            if (self.tail) |tail| {
                return tail.value;
            } else {
                return null;
            }
        }
    };
}

test "Queue" {
    var allocator = std.testing.allocator;
    var usize_queue = Queue(usize){
        .length = 0,
        .tail = null,
        .head = null,
    };

    var usize_node = try allocator.create(QueueNode(usize));
    usize_node.* = QueueNode(usize){ .value = 10, .next = null };
    defer allocator.destroy(usize_node);
    try usize_queue.enqueue(usize_node);
    try std.testing.expectEqual(@as(usize, 1), usize_queue.length);

    _ = usize_queue.deque();
    try std.testing.expectEqual(@as(usize, 0), usize_queue.length);

    var value: ?usize = usize_queue.peek();
    try std.testing.expectEqual(@as(usize, 10), value orelse 0);

    var array_queue = Queue([]const u8){
        .length = 0,
        .tail = null,
        .head = null,
    };
    var array_node = try allocator.create(QueueNode([]const u8));
    defer allocator.destroy(array_node);
    array_node.* = QueueNode([]const u8){ .value = &[_]u8{ 10, 20, 30 }, .next = null };
    try array_queue.enqueue(array_node);
    try std.testing.expectEqual(@as(usize, 1), array_queue.length);
    _ = array_queue.deque();
    try std.testing.expectEqual(@as(usize, 0), array_queue.length);
    var array_value = array_queue.peek();
    std.debug.print("array_value: {any}\n", .{array_value});
    try std.testing.expect(array_value != null);
}
