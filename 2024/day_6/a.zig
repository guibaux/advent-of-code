const std = @import("std");
const ArrayList = std.ArrayList;

const data = @embedFile("input.txt");

const Pos = struct { x: i32, y: i32 };
const Path = struct { pos: Pos, dir: u8 };

const Cop = struct {
    board: ArrayList([]const u8) = undefined,
    res1: u64 = 0,
    res2: u64 = 0,
    running: bool = true,

    dirs: []const Pos = &[_]Pos{ .{ .x = 0, .y = -1 }, .{ .x = 1, .y = 0 }, .{ .x = 0, .y = 1 }, .{ .x = -1, .y = 0 } },
    dir: u8 = 4,
    pos: Pos = undefined,

    fn setInitialPosAndDir(self: *Cop, x: i32, y: i32, dir: u8) void {
        self.pos.x = x;
        self.pos.y = y;

        self.dir = switch (dir) {
            '^' => 0,
            '>' => 1,
            'v' => 2,
            '<' => 3,
            else => 4,
        };
    }
    fn turn(self: *Cop) void {
        if (self.dir == 4) return;

        self.dir = (self.dir + 1) % 4;
    }

    fn step(self: *Cop) void {
        self.pos.x += self.dirs[self.dir].x;
        self.pos.y += self.dirs[self.dir].y;
    }

    fn checkCollision(self: *Cop) bool {
        const nextX = self.pos.x + self.dirs[self.dir].x;
        const nextY = self.pos.y + self.dirs[self.dir].y;

        if (nextX < 0 or nextY < 0 or self.board.items.len <= nextY or self.board.items[0].len <= nextX) {
            return false;
        }

        return self.board.items[@intCast(nextY)][@intCast(nextX)] == '#';
    }

    fn checkBounds(self: *Cop) bool {
        return self.pos.x < 0 or self.pos.y < 0 or self.board.items.len <= self.pos.y or self.board.items[0].len <= self.pos.x;
    }

    pub fn walk(self: *Cop, allocator: std.mem.Allocator, input: []const u8) !void {
        var board = ArrayList([]const u8).init(allocator);
        defer board.deinit();

        var inputIter = std.mem.tokenize(u8, input, "\n");
        var initialised = false;
        var shadow = ArrayList(ArrayList(bool)).init(allocator);
        defer shadow.deinit();

        var map = std.AutoArrayHashMap(Path, bool).init(allocator);
        defer map.deinit();

        var i: u32 = 0;
        while (inputIter.next()) |line| {
            if (!initialised) {
                for (line, 0..) |c, j| {
                    if (c == 'v' or c == '^' or c == '>' or c == '<') {
                        self.setInitialPosAndDir(@intCast(j), @intCast(i), c);
                        initialised = true;
                    }
                }
            }
            try board.append(line);
            i += 1;

            var j: usize = 0;
            var row = ArrayList(bool).init(allocator);
            try row.resize(line.len);
            while (j < line.len) : (j += 1) {
                try row.append(false);
            }
            try shadow.append(row);
        }
        self.board = board;

        while (!self.checkBounds()) {
            try map.put(.{ .pos = self.pos, .dir = self.dir }, true);
            if (self.checkCollision()) {
                self.turn();
            } else {
                const v = &shadow.items[@intCast(self.pos.x)].items[@intCast(self.pos.y)];

                if (!v.*) self.res1 += 1;
                v.* = true;
                self.step();
            }
        }

        for (shadow.items) |row| {
            row.deinit();
        }
    }
};

pub fn main() !void {
    var timer = try std.time.Timer.start();

    var solver = Cop{};
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    try solver.walk(allocator, data);

    std.debug.print("a: {d}\n", .{solver.res1});
    std.debug.print("took: {}\n", .{std.fmt.fmtDuration(timer.read())});
}
