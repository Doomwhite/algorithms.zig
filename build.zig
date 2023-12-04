const std = @import("std");
const builtin = std.builtin;
const Build = std.Build;
const Step = Build.Step;
const Run = Step.Run;
const Compile = Build.Step.Compile;
const CrossTarget = std.zig.CrossTarget;

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target: CrossTarget = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize: builtin.OptimizeMode = b.standardOptimizeOption(.{});

    const exe: *Compile = b.addExecutable(.{
        .name = "algorithms.zig",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe);
    const run_cmd: *Run = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    // This allows the user to pass arguments to the application in the build
    // command itself, like this: `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // This creates a build step. It will be visible in the `zig build --help` menu,
    // and can be selected like this: `zig build run`
    // This will evaluate the `run` step rather than the default, which is "install".
    const run_step: *Step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const test_step: *Step = b.step("test", "Run unit tests");
    var test_steps_file_names = [_][]const u8{
        "src/main.zig",
        "src/BubbleSort.zig",
        "src/LinkedList.zig",
        "src/Queue.zig",
        "src/TwoCrystalProblem.zig",
        "src/Stack.zig",
        "src/MazeSolver.zig",
        "src/QuickSort.zig",
        "src/BinarySearch.zig",
        "src/DoublyLinkedList.zig",
        "src/TreeTraversal.zig",
        "src/BreadthFirstSearch.zig",
        "src/BinaryTreeComparison.zig",
    };

    inline for (test_steps_file_names) |test_step_file_name| {
        populateTestSteps(b, test_step, b.addTest(.{
            .root_source_file = .{ .path = test_step_file_name },
            .target = target,
            .optimize = optimize,
        }));
    }
}

fn populateTestSteps(b: *Build, test_step: *Step, compile: *Compile) void {
    var run_tests: *Run = b.addRunArtifact(compile);
    test_step.dependOn(&run_tests.step);
}
