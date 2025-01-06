const std = @import("std");

pub fn main() void {
    const file = std.fs.cwd().openFile("./aoc-1-input", .{}) catch |err| {
        std.log.err("Failed to open file: {s}", .{@errorName(err)});
        return;
    };

    defer file.close();

    var gpa = std.heap.GeneralPurposeAllocator(.{ .thread_safe = true }){};
    const allocator = gpa.allocator();

    defer if (gpa.deinit() == .leak) {
        std.log.err("Memory leak", .{});
    };

    while (file.reader().readUntilDelimiterOrEofAlloc(allocator, '\n', std.math.maxInt(usize)) catch |err| {
        std.log.err("Failed to read line: {s}", .{@errorName(err)});
        return;
    }) |line| {
        defer allocator.free(line);

        const delim = "   ";
        std.debug.print("delim len {d}", .{delim.len});

        var tokenizer = std.mem.tokenize(u8, line, delim);

        const first = tokenizer.next();
        const second = tokenizer.next();

        if (first != null and second != null) {
            std.debug.print("Found split strings, {s} and {s}!\n", .{ first.?, second.? });
        } else {
            std.debug.print("Error parsing line {s}", .{line});
        }
    }
    std.debug.print("Done", .{});
}
