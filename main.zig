const std = @import("std");

pub fn main() !void {
    const file = std.fs.cwd().openFile("./aoc-1-input", .{}) catch |err| {
        std.log.err("Failed to open file: {s}", .{@errorName(err)});
        return;
    };

    defer file.close();

    // var gpa = std.heap.GeneralPurposeAllocator(.{ .thread_safe = true }){};
    // const allocator = gpa.allocator();
    //
    // defer if (gpa.deinit() == .leak) {
    //     std.log.err("Memory leak", .{});
    // };

    var lineAllocatorI = std.heap.GeneralPurposeAllocator(.{}){};
    var listAllocatorI = std.heap.GeneralPurposeAllocator(.{}){};

    const lineAllocator = lineAllocatorI.allocator();
    const listAllocator = listAllocatorI.allocator();

    // defer {
    //     const deinit_status = lineAllocatorI.deinit();
    //     const deinit_status2 = listAllocatorI.deinit();
    //
    //     //fail test; can't try in defer as defer is executed after we return
    //     if (deinit_status == .leak or deinit_status2 == .leak) {
    //         std.log.err("Memory leak", .{});
    //     }
    // }

    // const bytes = try allocator.alloc(u8, 100);
    // defer allocator.free(bytes);

    // const test_allocator = std.testing.allocator;

    var first_all = std.ArrayList([]const u8).init(listAllocator);
    var second_all = std.ArrayList([]const u8).init(listAllocator);

    defer {
        // second_all.deinit();
        // first_all.deinit();

        // listAllocatorI.deinit();
        // lineAllocatorI.allocator().free();
        // lineAllocatorI.deinit();
        // listAllocator.deinit();

        // listAllocator.free(second_all);
        // listAllocator.free(first_all);
    }

    while (file.reader().readUntilDelimiterOrEofAlloc(lineAllocator, '\n', std.math.maxInt(usize)) catch |err| {
        std.log.err("Failed to read line: {s}", .{@errorName(err)});
        return;
    }) |line| {
        // defer lineAllocator.free(line);

        const delim = "   ";

        std.debug.print("delim len {d}", .{delim.len});

        var tokenizer = std.mem.tokenize(u8, line, delim);

        const empty: []u8 = "";

        const first = tokenizer.next() orelse empty;
        const second = tokenizer.next() orelse empty;

        if (!std.mem.eql(u8, first, empty) and !std.mem.eql(u8, second, empty)) {
            try first_all.append(first);
            try second_all.append(second);

            std.debug.print("Found and appended split strings to lists, {s} and {s}!\n", .{ first, second });
        } else {
            std.debug.print("Error parsing line {s}", .{line});
            std.debug.panic("Eror parsing line", .{});
        }
    }

    std.debug.print("List 1 {any}", .{first_all});
    std.debug.print("List 2 {any}", .{second_all});
}
