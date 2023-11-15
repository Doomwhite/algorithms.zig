const std = @import("std");

pub fn LinkedList(comptime T: type) type {
    return struct {
        const Node = struct {
            value: T,
            prev: ?Node(T),
            next: ?Node(T),
        };
        const This = @This();

        allocator: std.Allocator,
        length: usize = 0,
        head: ?Node(T),

        fn init(allocator: std.mem.Allocator) This {
            return This{
                .allocator = allocator,
                .length = 0,
                .head = null,
                .prev = null,
            };
        }

        fn length() usize {
            return 0;
        }

        fn insertAt(item: LinkedList, index: usize) void {
            _ = index;
            _ = item;
        }

        fn remove(item: LinkedList) ?LinkedList {
            _ = item;
            return null;
        }

        fn removeAt(index: usize) ?LinkedList {
            _ = index;
            return null;
        }

        fn append(item: LinkedList) void {
            _ = item;
        }

        fn prepend(item: LinkedList) void {
            _ = item;
        }

        fn get(index: usize) ?LinkedList {
            _ = index;
            return null;
        }
    };
}

test "Linked List" {}
