const std = @import("std");
const AutoHashMap = std.AutoHashMap;

pub const Point = struct {
    x: u8,
    y: u8,
};

const directions = [_][2]i8{
    [2]i8{ -1, 0 },
    [2]i8{ 1, 0 },
    [2]i8{ 0, -1 },
    [2]i8{ 0, 1 },
};

pub fn walk(maze: [][]const u8, wall: u8, curr: Point, end: Point, seen: *AutoHashMap(Point, void), path: *AutoHashMap(Point, void)) !bool {
    std.debug.print("curr: {any}\n", .{curr});
    std.debug.print("maze: {any}\n", .{maze});
    // Off the map
    if ((curr.x < 0 or curr.x >= maze[0].len) or (curr.y < 0 or curr.y >= maze.len)) {
        std.debug.print("Off the map\n", .{});
        std.debug.print("(curr.x < 0 or curr.x >= maze[0].len) or (curr.y < 0 or curr.y >= maze.len): {any}\n", .{(curr.x < 0 or curr.x >= maze[0].len) or (curr.y < 0 or curr.y >= maze.len)});
        return false;
    }

    // On a wall
    if (maze[curr.y][curr.x] == wall) {
        std.debug.print("maze[curr.y]: {any}\n", .{maze[curr.y]});
        std.debug.print("On a wall\n", .{});
        std.debug.print("maze[curr.y][curr.x] == wall: {any}\n", .{maze[curr.y][curr.x] == wall});
        return false;
    }

    // Found the end
    if (curr.x == end.x and curr.y == end.y) {
        std.debug.print("Found the end\n", .{});
        std.debug.print("curr.x == end.x and curr.y == end.y: {any}\n", .{curr.x == end.x and curr.y == end.y});
        try path.put(curr, {});
        return true;
    }

    // Hits a seen block
    if (seen.contains(curr)) {
        std.debug.print("Hits a seen block\n", .{});
        std.debug.print("seen.contains(curr): {any}\n", .{seen.contains(curr)});
        return false;
    }

    // 3 recurse steps

    // pre
    try seen.put(curr, {});
    try path.put(curr, {});

    // recurse
    for (directions) |direction| {
        std.debug.print("direction: {any}\n", .{direction});

        var new_x: u8 = undefined;
        if (curr.x == 0 and direction[0] < 0) {
            new_x = @as(u8, 0);
        } else {
            new_x = @intCast(@as(i9, curr.x) + direction[0]);
        }

        var new_y: u8 = undefined;
        if (curr.y == 0 and direction[1] < 0) {
            new_y = @as(u8, 0);
        } else {
            new_y = @intCast(@as(i9, curr.y) + direction[1]);
        }

        var new_point = Point{ .x = new_x, .y = new_y };
        std.debug.print("curr: {any}\n", .{curr});
        std.debug.print("new_point: {any}\n", .{new_point});
        if (try walk(maze, wall, new_point, end, seen, path)) {
            std.debug.print("after curr: {any}\n", .{curr});
            std.debug.print("recursivo true\n", .{});
            return true;
        }
    }

    // post
    _ = path.remove(curr);

    return false;
}

pub fn solve(alloc: std.mem.Allocator, maze: [][]const u8, wall: u8, curr: Point, end: Point) ![]Point {
    var seen = AutoHashMap(Point, void).init(alloc);
    defer seen.deinit();

    var path = AutoHashMap(Point, void).init(alloc);
    defer path.deinit();

    std.debug.print("before path: {any}\n", .{path});
    const deu_boa = try walk(maze, wall, curr, end, &seen, &path);
    std.debug.print("deu_boa: {any}\n", .{deu_boa});
    std.debug.print("after path: {any}\n", .{path});

    std.debug.print("path.count(): {any}\n", .{path.count()});
    var iterator = path.keyIterator();

    std.debug.print("iterator.items: {any}\n", .{iterator.items});
    std.debug.print("iterator.items: {any}\n", .{iterator.items[0]});
    std.debug.print("iterator.items: {any}\n", .{iterator.items[1]});
    std.debug.print("iterator.items: {any}\n", .{iterator.items[2]});
    std.debug.print("iterator.items: {any}\n", .{iterator.items[3]});
    std.debug.print("iterator.items: {any}\n", .{iterator.items[4]});
    std.debug.print("iterator.items: {any}\n", .{iterator.items[5]});
    std.debug.print("iterator.items: {any}\n", .{iterator.items[6]});
    std.debug.print("iterator.items: {any}\n", .{iterator.items[7]});
    std.debug.print("iterator.items: {any}\n", .{iterator.items[8]});
    std.debug.print("iterator.items: {any}\n", .{iterator.items[9]});
    std.debug.print("iterator.items: {any}\n", .{iterator.items[10]});
    std.debug.print("iterator.items: {any}\n", .{iterator.items[11]});
    std.debug.print("iterator.items: {any}\n", .{iterator.items[12]});
    std.debug.print("iterator.items: {any}\n", .{iterator.items[13]});
    std.debug.print("iterator.items: {any}\n", .{iterator.items[14]});
    std.debug.print("iterator.items: {any}\n", .{iterator.items[15]});
    std.debug.print("iterator.items: {any}\n", .{iterator.items[16]});

    var point = [_]Point{Point{ .x = 10, .y = 20 }};
    return &point;
}

test "Maze Solver" {
    var maze = [_][]const u8{
        "############## #",
        "#              #",
        "# ##############",
    };
    var start = Point{ .x = 14, .y = 0 };
    var end = Point{ .x = 1, .y = 2 };

    var expected_result = [_]Point{
        Point{ .x = 10, .y = 20 },
    };
    try std.testing.expectEqualSlices(Point, &expected_result, try solve(std.testing.allocator, &maze, '#', start, end));
}
