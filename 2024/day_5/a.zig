const std = @import("std");
const ArrayList = std.ArrayList;
const AutoHashMap = std.AutoHashMap;
const data = @embedFile("input.txt");

const Solver = struct {
    word: []const u8 = undefined,
    before: AutoHashMap(i32, ArrayList(i32)) = undefined,
    after: AutoHashMap(i32, ArrayList(i32)) = undefined,
    res1: u64 = 0,
    res2: u64 = 0,

    fn reorder(self: *Solver, allocator: std.mem.Allocator, as: ArrayList(i32)) !ArrayList(i32) {
        // implement a function who sees whos doenst have any before rule to append to the result list, after that
        // append the other who doesnt have to be before the last inserted, return this result
   }

    fn correct(self: *Solver, as: ArrayList(i32)) bool {
        for (as.items, 0..) |curr_page, idx| {
            if (self.before.get(curr_page)) |pages_before| {
                const pages_after = as.items[(idx + 1)..];

                for (pages_after) |page| {
                    if (std.mem.indexOfScalar(i32, pages_before.items, page) == null) {
                        return false;
                    }
                }
            }

            if (self.after.get(curr_page)) |pages_after| {
                const pages_before = as.items[0..idx];

                for (pages_before) |page| {
                    if (std.mem.indexOfScalar(i32, pages_after.items, page) == null) {
                        return false;
                    }
                }
            }
        }

        return true;
    }

    pub fn solve(self: *Solver, allocator: std.mem.Allocator, input: []const u8, updates: []const u8) !void {
        self.before = AutoHashMap(i32, ArrayList(i32)).init(allocator);
        defer self.before.deinit();
        self.after = AutoHashMap(i32, ArrayList(i32)).init(allocator);
        defer self.after.deinit();

        var ordering_iterator = std.mem.tokenizeSequence(u8, input, "\n");
        while (ordering_iterator.next()) |line| {
            var page_iterator = std.mem.tokenizeSequence(u8, line, "|");
            const num1_str = page_iterator.next().?;
            const num2_str = page_iterator.next().?;

            const before = try std.fmt.parseInt(i32, num1_str, 10);
            const after = try std.fmt.parseInt(i32, num2_str, 10);

            var before_list = self.before.get(before) orelse
                ArrayList(i32).init(allocator);
            try before_list.append(after);
            try self.before.put(before, before_list);

            var after_list = self.after.get(after) orelse
                ArrayList(i32).init(allocator);
            try after_list.append(before);
            try self.after.put(after, after_list);
        }

        var update_iterator = std.mem.tokenizeSequence(u8, updates, "\n");
        while (update_iterator.next()) |line| {
            var page_iterator = std.mem.tokenizeSequence(u8, line, ",");

            var update = ArrayList(i32).init(allocator);
            defer update.deinit();

            while (page_iterator.next()) |page_str| {
                const page = try std.fmt.parseInt(i32, page_str, 10);
                try update.append(page);
            }

            if (self.correct(update)) {
                const m_idx = (update.items.len - 1) / 2;
                self.res1 += @intCast(update.items[m_idx]);
            } else {
                const reodered = self.reorder(allocator, update) catch {
                    continue;
                };

                const m_idx = (reodered.items.len - 1) / 2;
                self.res2 += @intCast(reodered.items[m_idx]);
            }
        }

        var before_iterator = self.before.valueIterator();
        var after_iterator = self.after.valueIterator();
        while (before_iterator.next()) |e| {
            e.deinit();
        }
        while (after_iterator.next()) |e| {
            e.deinit();
        }
    }
};

pub fn main() !void {
    var timer = try std.time.Timer.start();
    var solver = Solver{};
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    var readIter = std.mem.tokenizeSequence(u8, data, "\n\n");
    const ordering = readIter.next().?;
    const updates = readIter.next().?;
    try solver.solve(allocator, ordering, updates);

    std.debug.print("a: {d}\n", .{solver.res1});
    std.debug.print("a: {d}\n", .{solver.res2});
    std.debug.print("took: {}\n", .{std.fmt.fmtDuration(timer.read())});
}
