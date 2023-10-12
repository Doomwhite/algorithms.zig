const std = @import("std");

pub const LinkedList = struct {
    pub fn insertAt(item: LinkedList, index: usize) void {
        _ = index;
        _ = item;
    }

    pub fn remove(item: LinkedList) ?LinkedList {
        _ = item;
        return null;
    }

    pub fn removeAt(index: usize) ?LinkedList {
        _ = index;
        return null;
    }

    pub fn append(item: LinkedList) void {
        _ = item;
    }

    pub fn prepend(item: LinkedList) void {
        _ = item;
    }

    pub fn get(index: usize) ?LinkedList {
        _ = index;
        return null;
    }

    pub fn length() usize {
        return 0;
    }
};

test "Linked List" {}
