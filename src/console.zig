const std = @import("std");
const win = @import("win.zig");
const convas = @import("convas.zig");

//Errors (--
pub const InitError = error{
    ConsoleAlreadyInitialized,
    CreateConsoleWindowFail,
};

pub const DeinitError = error{
    DestroyConsoleWindowFail,
    ConsoleNotInitialized,
};

pub const SetVisibilityError = error{ConsoleNotInitialized};

// --)

pub const window_classname = std.unicode.utf8ToUtf16LeStringLiteral("ConvasWindow");

var window: ?win.HWND = null;

pub fn isInitialized() bool {
    return window != null;
}

pub fn init() InitError!void {
    if (isInitialized()) return InitError.ConsoleAlreadyInitialized;

    window = win.CreateWindowExW(0, window_classname, null, win.WS_OVERLAPPED_WINDOW, 0, 0, 640, 640, null, null, @ptrCast(convas.getModuleHandle()), null);

    if (window == null) return InitError.CreateConsoleWindowFail;
}

pub fn setVisibility(visible: bool) SetVisibilityError!void {
    if (!isInitialized()) return SetVisibilityError.ConsoleNotInitialized;

    if (visible) {
        _ = win.ShowWindow(window.?, 5);
    } else {
        _ = win.ShowWindow(window.?, 0);
    }
}

pub fn show() SetVisibilityError!void {
    try setVisibility(true);
}

pub fn hide() SetVisibilityError!void {
    try setVisibility(false);
}

pub fn deinit() DeinitError!void {
    if (!isInitialized()) return DeinitError.ConsoleNotInitialized;

    if (win.DestroyWindow(window.?) == 0) return DeinitError.DestroyConsoleWindowFail;

    window = null;
}
