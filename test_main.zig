const std = @import("std");

test "asd" {
    std.debug.print("Hello, {s}!\n", .{"World"});
}
