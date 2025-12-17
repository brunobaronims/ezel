const std = @import("std");
const builtin = @import("builtin");
const c = @import("vulkan_c");

const Self = @This();

instance: c.VkInstance = null,
debug_messenger: c.VkDebugUtilsMessengerEXT = null,
physical_device: c.VkPhysicalDevice = null,

pub fn init(allocator: std.mem.Allocator, config: Config) !*Self {
    var vk = try allocator.create(Self);
    errdefer allocator.destroy(vk);

    var required_extensions = config.required_extensions;
    var required_layers = config.required_layers;
    if (config.debug) {
        for (validation_layers) |layer| {
            try required_layers.append(allocator, layer);
        }

        try required_extensions.append(allocator, c.VK_EXT_DEBUG_UTILS_EXTENSION_NAME);
    }

    var available_extension_count: u32 = 0;
    var available_layer_count: u32 = 0;

    switch (c.vkEnumerateInstanceExtensionProperties(
        null,
        &available_extension_count,
        null,
    )) {
        c.VK_SUCCESS, c.VK_INCOMPLETE => {},
        c.VK_ERROR_OUT_OF_HOST_MEMORY => return error.OutOfHostMemory,
        c.VK_ERROR_OUT_OF_DEVICE_MEMORY => return error.OutOfDeviceMemory,
        else => return error.Unknown,
    }

    switch (c.vkEnumerateInstanceLayerProperties(
        &available_layer_count,
        null,
    )) {
        c.VK_SUCCESS, c.VK_INCOMPLETE => {},
        c.VK_ERROR_OUT_OF_HOST_MEMORY => return error.OutOfHostMemory,
        c.VK_ERROR_OUT_OF_DEVICE_MEMORY => return error.OutOfDeviceMemory,
        else => return error.Unknown,
    }

    var available_extensions_properties = try allocator.alloc(
        c.VkExtensionProperties,
        available_extension_count,
    );
    defer allocator.free(available_extensions_properties);

    var available_layers_properties = try allocator.alloc(
        c.VkLayerProperties,
        available_layer_count,
    );
    defer allocator.free(available_layers_properties);

    switch (c.vkEnumerateInstanceExtensionProperties(
        null,
        &available_extension_count,
        available_extensions_properties.ptr,
    )) {
        c.VK_SUCCESS => {},
        c.VK_INCOMPLETE => {
            std.log.warn("Unable to retrieve all extension properties", .{});
        },
        c.VK_ERROR_OUT_OF_HOST_MEMORY => return error.OutOfHostMemory,
        c.VK_ERROR_OUT_OF_DEVICE_MEMORY => return error.OutOfDeviceMemory,
        else => return error.Unknown,
    }

    switch (c.vkEnumerateInstanceLayerProperties(
        &available_layer_count,
        available_layers_properties.ptr,
    )) {
        c.VK_SUCCESS => {},
        c.VK_INCOMPLETE => {
            std.log.warn("Unable to retrieve all layer properties", .{});
        },
        c.VK_ERROR_OUT_OF_HOST_MEMORY => return error.OutOfHostMemory,
        c.VK_ERROR_OUT_OF_DEVICE_MEMORY => return error.OutOfDeviceMemory,
        else => return error.Unknown,
    }

    for (required_extensions.items) |e| {
        var found = false;
        for (available_extensions_properties) |p| {
            const name = std.mem.sliceTo(&p.extensionName, 0);
            if (std.mem.eql(u8, name, std.mem.span(e))) {
                found = true;
                break;
            }
        }

        if (!found) {
            return error.MissingRequiredExtension;
        }
    }

    for (required_layers.items) |l| {
        var found = false;
        for (available_layers_properties) |p| {
            const name = std.mem.sliceTo(&p.layerName, 0);
            if (std.mem.eql(u8, name, std.mem.span(l))) {
                found = true;
                break;
            }
        }

        if (!found) {
            return error.MissingRequiredLayer;
        }
    }

    const app_info: c.VkApplicationInfo = .{
        .sType = c.VK_STRUCTURE_TYPE_APPLICATION_INFO,
        .pApplicationName = "Tutorial",
        .applicationVersion = c.VK_MAKE_VERSION(1, 0, 0),
        .pEngineName = "No Engine",
        .engineVersion = c.VK_MAKE_VERSION(1, 0, 0),
        .apiVersion = c.VK_API_VERSION_1_4,
    };

    const instance_create_info: c.VkInstanceCreateInfo = .{
        .sType = c.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
        .enabledExtensionCount = @intCast(required_extensions.items.len),
        .pApplicationInfo = &app_info,
        .ppEnabledExtensionNames = required_extensions.items.ptr,
        .enabledLayerCount = @intCast(required_layers.items.len),
        .ppEnabledLayerNames = required_layers.items.ptr,
        .flags = 0,
    };

    switch (c.vkCreateInstance(&instance_create_info, null, &vk.instance)) {
        c.VK_SUCCESS => {},
        c.VK_ERROR_OUT_OF_HOST_MEMORY => return error.OutOfHostMemory,
        c.VK_ERROR_OUT_OF_DEVICE_MEMORY => return error.OutOfDeviceMemory,
        c.VK_ERROR_INITIALIZATION_FAILED => return error.InitializationFailed,
        c.VK_ERROR_LAYER_NOT_PRESENT => return error.LayerNotPresent,
        c.VK_ERROR_EXTENSION_NOT_PRESENT => return error.ExtensionNotPresent,
        c.VK_ERROR_INCOMPATIBLE_DRIVER => return error.IncompatibleDriver,
        else => return error.Unknown,
    }

    // var available_device_count: u32 = 0;
    // switch (c.vkEnumeratePhysicalDevices(
    //     vk.instance,
    //     &available_device_count,
    //     null,
    // )) {
    //     c.VK_SUCCESS, c.VK_INCOMPLETE => {},
    //     c.VK_ERROR_INITIALIZATION_FAILED => return error.InitializationFailed,
    //     c.VK_ERROR_OUT_OF_HOST_MEMORY => return error.OutOfHostMemory,
    //     c.VK_ERROR_OUT_OF_DEVICE_MEMORY => return error.OutOfDeviceMemory,
    //     else => return error.Unknown,
    // }
    //
    // var available_devices = try allocator.alloc(
    //     c.VkPhysicalDevice,
    //     available_device_count,
    // );
    // switch (c.vkEnumeratePhysicalDevices(
    //     vk.instance,
    //     &available_device_count,
    //     &available_devices,
    // )) {
    //     c.VK_SUCCESS => {},
    //     c.VK_INCOMPLETE => {
    //         std.log.warn("Unable to retrieve all physical devices", .{});
    //     },
    //     c.VK_ERROR_INITIALIZATION_FAILED => return error.InitializationFailed,
    //     c.VK_ERROR_OUT_OF_HOST_MEMORY => return error.OutOfHostMemory,
    //     c.VK_ERROR_OUT_OF_DEVICE_MEMORY => return error.OutOfDeviceMemory,
    // }

    if (!config.debug) {
        return vk;
    }

    const severity_flags = c.VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT | c.VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT | c.VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT;

    const message_type_flags = c.VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT | c.VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT | c.VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT;

    var messenger_create_info: c.VkDebugUtilsMessengerCreateInfoEXT = .{
        .sType = c.VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT,
        .messageSeverity = severity_flags,
        .messageType = message_type_flags,
        .pfnUserCallback = debugCallback,
    };

    const CreateDebugMessenger: c.PFN_vkCreateDebugUtilsMessengerEXT = @ptrCast(
        c.vkGetInstanceProcAddr(
            vk.instance,
            "vkCreateDebugUtilsMessengerEXT",
        ),
    );
    if (CreateDebugMessenger == null) return error.ExtensionNotPresent;

    switch (CreateDebugMessenger.?(
        vk.instance,
        &messenger_create_info,
        null,
        &vk.debug_messenger,
    )) {
        c.VK_SUCCESS => {},
        c.VK_ERROR_OUT_OF_HOST_MEMORY => return error.OutOfHostMemory,
        else => return error.Unknown,
    }

    return vk;
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    if (self.debug_messenger) |messenger| {
        const DestroyDebugMessenger: c.PFN_vkDestroyDebugUtilsMessengerEXT = @ptrCast(
            c.vkGetInstanceProcAddr(
                self.instance,
                "vkDestroyDebugUtilsMessengerEXT",
            ),
        );
        DestroyDebugMessenger.?(self.instance, messenger, null);
    }

    c.vkDestroyInstance(self.instance, null);
    allocator.destroy(self);
}

fn debugCallback(
    severity: c.VkDebugUtilsMessageSeverityFlagsEXT,
    message_type: c.VkDebugUtilsMessageTypeFlagsEXT,
    p_callback_data: ?*const c.VkDebugUtilsMessengerCallbackDataEXT,
    p_user_data: ?*anyopaque,
) callconv(VKAPI_CALL) c.VkBool32 {
    _ = severity;
    _ = p_user_data;

    const data = p_callback_data.?;

    if (data.pMessage) |msg| {
        std.debug.print("validation layer: type {}, msg: {s}\n", .{
            message_type,
            msg,
        });
    }

    return 0;
}

const VKAPI_CALL = if (builtin.os.tag == .windows)
    std.builtin.CallingConvention.winapi
else
    std.builtin.CallingConvention.c;
const validation_layers = [_][*:0]const u8{
    "VK_LAYER_KHRONOS_validation",
};

pub const Config = struct {
    debug: bool = true,
    required_extensions: *std.ArrayList([*:0]const u8),
    required_layers: *std.ArrayList([*:0]const u8),
};
