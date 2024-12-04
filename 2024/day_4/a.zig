const std = @import("std");
const ArrayList = std.ArrayList;

const data = @embedFile("input.txt");

const Solver = struct {
    data: ArrayList([]const u8) = undefined,
    word: []const u8 = undefined,
    res1: u64 = 0,
    res2: u64 = 0,

    fn testCandidate(self: *Solver, dir: [2]isize, x: usize, y: usize) void {
        var candidate: [4]u8 = undefined;

        var i = x;
        var j = y;

        var n: usize = 0;
        while (n < self.word.len) : (n += 1) {
            candidate[n] = self.data.items[i][j];

            if ((i == 0 and dir[0] == -1) or (j == 0 and dir[1] == -1) or (i == self.data.items.len - 1 and dir[0] == 1) or (j == self.data.items[0].len - 1 and dir[1] == 1)) {
                break;
            }

            if (dir[0] == 1) {
                i += 1;
            } else if (dir[0] == -1) {
                i -= 1;
            }

            if (dir[1] == 1) {
                j += 1;
            } else if (dir[1] == -1) {
                j -= 1;
            }
        }

        if (std.mem.eql(u8, &candidate, self.word)) {
            self.res1 += 1;
        }
    }

    fn testCandidate2(self: *Solver, i: usize, j: usize) void {
        if ((i == 0) or (j == 0) or (i == self.data.items.len - 1) or (j == self.data.items[0].len - 1)) return;

        const d = self.data.items;

        const x = (d[i - 1][j - 1] == 'M' and d[i + 1][j - 1] == 'M' and d[i - 1][j + 1] == 'S' and d[i + 1][j + 1] == 'S');
        const m = (d[i - 1][j - 1] == 'S' and d[i + 1][j - 1] == 'S' and d[i - 1][j + 1] == 'M' and d[i + 1][j + 1] == 'M');
        const a = (d[i - 1][j - 1] == 'M' and d[i + 1][j - 1] == 'S' and d[i - 1][j + 1] == 'M' and d[i + 1][j + 1] == 'S');
        const s = (d[i - 1][j - 1] == 'S' and d[i + 1][j - 1] == 'M' and d[i - 1][j + 1] == 'S' and d[i + 1][j + 1] == 'M');

        const xmas = x or m or a or s;
        if (xmas) {
            self.res2 += 1;
        }
    }

    pub fn solve(self: *Solver, allocator: std.mem.Allocator, input: []const u8, word: []const u8) !void {
        var lines = ArrayList([]const u8).init(allocator);
        defer lines.deinit();
        var readIter = std.mem.tokenize(u8, input, "\n");
        while (readIter.next()) |line| {
            try lines.append(line);
        }
        self.data = lines;
        self.res1 = 0;
        self.word = word;

        // directions
        // +x right
        // -x left
        // -y up
        // +y down
        // +x +y diag ^>
        // -x +y diag ^<
        // +x -y diag v>
        // -x -y diag v<
        // as vectors:
        const dir_vecs = [8][2]isize{
            [_]isize{ 1, 0 },
            [_]isize{ -1, 0 },
            [_]isize{ 0, -1 },
            [_]isize{ 0, 1 },
            [_]isize{ 1, 1 },
            [_]isize{ -1, 1 },
            [_]isize{ 1, -1 },
            [_]isize{ -1, -1 },
        };

        var i: usize = 0;
        while (i < lines.items.len) : (i += 1) {
            const line = lines.items[i];
            for (line, 0..) |_, j| {
                const c = lines.items[i][j];
                if (c == 'A') {
                    self.testCandidate2(i, j);
                }

                for (dir_vecs) |dir| {
                    if (c == 'X') {
                        self.testCandidate(dir, i, j);
                    }
                }
            }
        }
    }
};

pub fn main() !void {
    var timer = try std.time.Timer.start();

    var solver = Solver{};
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    try solver.solve(allocator, data, "XMAS");

    std.debug.print("a: {d}\n", .{solver.res1});
    std.debug.print("b: {d}\n", .{solver.res2});
    std.debug.print("took: {}\n", .{std.fmt.fmtDuration(timer.read())});
}
