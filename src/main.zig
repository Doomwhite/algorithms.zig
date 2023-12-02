const std = @import("std");
const DoublyLinkedList = @import("DoublyLinkedList.zig").DoublyLinkedList;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.detectLeaks();

    var linked_list = DoublyLinkedList(u8).init(allocator);
    try linked_list.prepend(10);
    try linked_list.prepend(11);
    try linked_list.prepend(12);
    try linked_list.prepend(13);
    try linked_list.prepend(14);
    _ = linked_list.getAt(0);
    _ = linked_list.getAt(1);
    _ = linked_list.getAt(2);
    _ = linked_list.getAt(3);
    _ = linked_list.getAt(4);
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
    _ = linked_list.getAt(0);
    _ = linked_list.getAt(1);
    _ = linked_list.getAt(2);
    _ = linked_list.getAt(3);
    _ = linked_list.getAt(4);
    _ = linked_list.removeAt(4);
    _ = linked_list.removeAt(3);
    _ = linked_list.removeAt(2);
    _ = linked_list.removeAt(1);
    _ = linked_list.removeAt(0);

    try linked_list.insertAt(0, 10);
    try linked_list.insertAt(1, 10);
    _ = linked_list.getAt(0);
    _ = linked_list.getAt(1);
    _ = linked_list.removeAt(0);
    _ = linked_list.removeAt(1);
}
