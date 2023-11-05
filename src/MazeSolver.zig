const std = @import("std");
const AutoHashMap = std.AutoHashMap;
const ArrayList = std.ArrayList;

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

pub fn walk(maze: [][]const u8, wall: u8, curr: Point, end: Point, seen: *AutoHashMap(Point, void), path: *ArrayList(Point)) !bool {
    // Off the map
    if ((curr.x < 0 or curr.x >= maze[0].len) or (curr.y < 0 or curr.y >= maze.len)) {
        return false;
    }

    // On a wall
    if (maze[curr.y][curr.x] == wall) {
        return false;
    }

    // Found the end
    if (curr.x == end.x and curr.y == end.y) {
        try path.append(curr);
        return true;
    }

    // Hits a seen block
    if (seen.contains(curr)) {
        return false;
    }

    // 3 recurse steps

    // pre
    try seen.put(curr, {});
    try path.append(curr);

    // recurse
    for (directions) |direction| {
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

        if (try walk(maze, wall, Point{ .x = new_x, .y = new_y }, end, seen, path)) {
            return true;
        }
    }

    // post
    _ = path.pop();

    return false;
}

pub fn solve(alloc: std.mem.Allocator, maze: [][]const u8, wall: u8, curr: Point, end: Point) ![]Point {
    var seen = AutoHashMap(Point, void).init(alloc);
    defer seen.deinit();

    var path = std.ArrayList(Point).init(alloc);
    defer path.deinit();

    _ = try walk(maze, wall, curr, end, &seen, &path);

    // for (path.items) |path_item| {
    //      std.debug.print("path_item: {any}\n", .{path_item});
    // }

    return path.toOwnedSlice();
}

test "Maze Solver" {
    var maze = [_][]const u8{
        "##### #",
        "#   # #",
        "# #   #",
        "# #####",
        "#     #",
        "##### #",
    };

    var start = Point{ .x = 5, .y = 0 };
    var end = Point{ .x = 5, .y = 5 };

    var expected_result = [_]Point{
        Point{ .x = 5, .y = 0 },
        Point{ .x = 5, .y = 1 },
        Point{ .x = 5, .y = 2 },
        Point{ .x = 4, .y = 2 },
        Point{ .x = 3, .y = 2 },
        Point{ .x = 3, .y = 1 },
        Point{ .x = 2, .y = 1 },
        Point{ .x = 1, .y = 1 },
        Point{ .x = 1, .y = 2 },
        Point{ .x = 1, .y = 3 },
        Point{ .x = 1, .y = 4 },
        Point{ .x = 2, .y = 4 },
        Point{ .x = 3, .y = 4 },
        Point{ .x = 4, .y = 4 },
        Point{ .x = 5, .y = 4 },
        Point{ .x = 5, .y = 5 },
    };
    var result = try solve(std.testing.allocator, &maze, '#', start, end);
    var allocator = std.testing.allocator;
    defer allocator.free(result);
    try std.testing.expectEqualSlices(Point, &expected_result, result);
}
