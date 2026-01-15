const std = @import("std");
const builtin = @import("builtin");
const c = @import("vulkan_c");

const Self = @This();

instance: c.VkInstance = null,
debug_messenger: c.VkDebugUtilsMessengerEXT = null,
physical_device: c.VkPhysicalDevice = null,
device: c.VkDevice = null,
graphics_queue: c.VkQueue = null,

pub fn init(allocator: std.mem.Allocator, config: Config) !*Self {
    var vk = try allocator.create(Self);
    errdefer allocator.destroy(vk);

    try vk.createInstance(allocator, config);
    errdefer c.vkDestroyInstance(vk.instance, null);

    if (config.debug) {
        try vk.setupDebugMessenger();
    }

    try vk.pickPhysicalDevice(allocator);

    try vk.createLogicalDevice(allocator);

    return vk;
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    if (self.debug_messenger) |messenger| {
        const DestroyDebugMessenger: c.PFN_vkDestroyDebugUtilsMessengerEXT =
            @ptrCast(
                c.vkGetInstanceProcAddr(
                    self.instance,
                    "vkDestroyDebugUtilsMessengerEXT",
                ),
            );
        DestroyDebugMessenger.?(self.instance, messenger, null);
    }

    c.vkDestroyDevice(self.device, null);
    c.vkDestroyInstance(self.instance, null);
    allocator.destroy(self);
}

fn createInstance(self: *Self, allocator: std.mem.Allocator, config: Config) !void {
    var required_extensions = config.required_extensions;
    var required_layers = config.required_layers;
    if (config.debug) {
        for (validation_layers) |layer| {
            try required_layers.append(allocator, layer);
        }

        try required_extensions.append(
            allocator,
            c.VK_EXT_DEBUG_UTILS_EXTENSION_NAME,
        );
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
        const found = for (available_extensions_properties) |p| {
            const name = std.mem.sliceTo(&p.extensionName, 0);
            if (std.mem.eql(u8, name, std.mem.span(e))) {
                break true;
            }
        } else false;

        if (!found) {
            return error.MissingRequiredExtension;
        }
    }

    for (required_layers.items) |l| {
        const found = for (available_layers_properties) |p| {
            const name = std.mem.sliceTo(&p.layerName, 0);
            if (std.mem.eql(u8, name, std.mem.span(l))) {
                break true;
            }
        } else false;

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

    switch (c.vkCreateInstance(&instance_create_info, null, &self.instance)) {
        c.VK_SUCCESS => {},
        c.VK_ERROR_OUT_OF_HOST_MEMORY => return error.OutOfHostMemory,
        c.VK_ERROR_OUT_OF_DEVICE_MEMORY => return error.OutOfDeviceMemory,
        c.VK_ERROR_INITIALIZATION_FAILED => return error.InitializationFailed,
        c.VK_ERROR_LAYER_NOT_PRESENT => return error.LayerNotPresent,
        c.VK_ERROR_EXTENSION_NOT_PRESENT => return error.ExtensionNotPresent,
        c.VK_ERROR_INCOMPATIBLE_DRIVER => return error.IncompatibleDriver,
        else => return error.Unknown,
    }
}

fn pickPhysicalDevice(self: *Self, allocator: std.mem.Allocator) !void {
    var available_device_count: u32 = 0;

    switch (c.vkEnumeratePhysicalDevices(
        self.instance,
        &available_device_count,
        null,
    )) {
        c.VK_SUCCESS, c.VK_INCOMPLETE => {},
        c.VK_ERROR_INITIALIZATION_FAILED => return error.InitializationFailed,
        c.VK_ERROR_OUT_OF_HOST_MEMORY => return error.OutOfHostMemory,
        c.VK_ERROR_OUT_OF_DEVICE_MEMORY => return error.OutOfDeviceMemory,
        else => return error.Unknown,
    }

    var available_devices = try allocator.alloc(
        c.VkPhysicalDevice,
        available_device_count,
    );
    defer allocator.free(available_devices);

    switch (c.vkEnumeratePhysicalDevices(
        self.instance,
        &available_device_count,
        available_devices.ptr,
    )) {
        c.VK_SUCCESS => {},
        c.VK_INCOMPLETE => {
            std.log.warn("Unable to retrieve all physical devices", .{});
        },
        c.VK_ERROR_INITIALIZATION_FAILED => return error.InitializationFailed,
        c.VK_ERROR_OUT_OF_HOST_MEMORY => return error.OutOfHostMemory,
        c.VK_ERROR_OUT_OF_DEVICE_MEMORY => return error.OutOfDeviceMemory,
        else => return error.Unknown,
    }

    const found_suitable_gpu = for (available_devices) |d| {
        var queue_family_property_count: u32 = 0;

        c.vkGetPhysicalDeviceQueueFamilyProperties2(
            d,
            &queue_family_property_count,
            null,
        );

        var queue_families = try allocator.alloc(
            c.VkQueueFamilyProperties2,
            queue_family_property_count,
        );
        defer allocator.free(queue_families);

        for (queue_families) |*props| {
            props.* = .{
                .sType = c.VK_STRUCTURE_TYPE_QUEUE_FAMILY_PROPERTIES_2,
                .queueFamilyProperties = undefined,
            };
        }

        c.vkGetPhysicalDeviceQueueFamilyProperties2(
            d,
            &queue_family_property_count,
            queue_families.ptr,
        );

        var device: c.VkPhysicalDeviceProperties2 = .{
            .sType = c.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROPERTIES_2,
        };

        c.vkGetPhysicalDeviceProperties2(
            d,
            &device,
        );

        var is_suitable = device.properties.apiVersion >= c.VK_API_VERSION_1_3;

        const supports_graphics = for (queue_families) |q| {
            if ((q.queueFamilyProperties.queueFlags &
                c.VK_QUEUE_GRAPHICS_BIT) != 0)
            {
                break true;
            }
        } else false;

        is_suitable = is_suitable and supports_graphics;

        var device_extension_property_count: u32 = 0;

        switch (c.vkEnumerateDeviceExtensionProperties(
            d,
            null,
            &device_extension_property_count,
            null,
        )) {
            c.VK_SUCCESS, c.VK_INCOMPLETE => {},
            c.VK_ERROR_OUT_OF_HOST_MEMORY => return error.OutOfHostMemory,
            c.VK_ERROR_OUT_OF_DEVICE_MEMORY => return error.OutOfDeviceMemory,
            else => return error.Unknown,
        }

        var available_extension_properties = try allocator.alloc(
            c.VkExtensionProperties,
            device_extension_property_count,
        );
        defer allocator.free(available_extension_properties);

        switch (c.vkEnumerateDeviceExtensionProperties(
            d,
            null,
            &device_extension_property_count,
            available_extension_properties.ptr,
        )) {
            c.VK_SUCCESS => {},
            c.VK_INCOMPLETE => {
                std.log.warn("Unable to retrieve all physical devices", .{});
            },
            c.VK_ERROR_OUT_OF_HOST_MEMORY => return error.OutOfHostMemory,
            c.VK_ERROR_OUT_OF_DEVICE_MEMORY => return error.OutOfDeviceMemory,
            else => return error.Unknown,
        }

        var found = std.bit_set.StaticBitSet(device_extensions.len).initEmpty();

        for (device_extensions, 0..) |extension_name, i| {
            for (available_extension_properties) |p| {
                const name = std.mem.sliceTo(&p.extensionName, 0);
                if (std.mem.eql(u8, name, std.mem.span(extension_name))) {
                    found.set(i);
                    break;
                }
            }
        }

        is_suitable = is_suitable and (found.count() == device_extensions.len);

        if (is_suitable) {
            self.physical_device = d;
            break is_suitable;
        }
    } else false;

    if (!found_suitable_gpu) {
        return error.SuitableGpuNotFound;
    }
}

fn setupDebugMessenger(self: *Self) !void {
    const severity_flags =
        c.VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT |
        c.VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT |
        c.VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT;

    const message_type_flags =
        c.VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT |
        c.VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT |
        c.VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT;

    var messenger_create_info: c.VkDebugUtilsMessengerCreateInfoEXT = .{
        .sType = c.VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT,
        .messageSeverity = severity_flags,
        .messageType = message_type_flags,
        .pfnUserCallback = debugCallback,
    };

    const CreateDebugMessenger: c.PFN_vkCreateDebugUtilsMessengerEXT =
        @ptrCast(
            c.vkGetInstanceProcAddr(
                self.instance,
                "vkCreateDebugUtilsMessengerEXT",
            ),
        );
    if (CreateDebugMessenger == null) return error.ExtensionNotPresent;

    switch (CreateDebugMessenger.?(
        self.instance,
        &messenger_create_info,
        null,
        &self.debug_messenger,
    )) {
        c.VK_SUCCESS => {},
        c.VK_ERROR_OUT_OF_HOST_MEMORY => return error.OutOfHostMemory,
        else => return error.Unknown,
    }
}

fn createLogicalDevice(self: *Self, allocator: std.mem.Allocator) !void {
    const index = try findGraphicsQueueFamily(allocator, self.physical_device);
    if (index == -1) {
        return error.NoGraphicsQueueFamily;
    }
    const priority: f32 = 0.5;

    const device_queue_create_info: c.VkDeviceQueueCreateInfo = .{
        .sType = c.VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO,
        .queueFamilyIndex = @intCast(index),
        .pQueuePriorities = &priority,
        .queueCount = 1,
    };

    var dynamic_state_features: c
        .VkPhysicalDeviceExtendedDynamicStateFeaturesEXT = .{
        .sType = c
            .VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTENDED_DYNAMIC_STATE_FEATURES_EXT,
        .extendedDynamicState = 1,
    };
    var vulkan_13_features: c.VkPhysicalDeviceVulkan13Features = .{
        .sType = c.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_1_3_FEATURES,
        .dynamicRendering = 1,
        .pNext = @ptrCast(&dynamic_state_features),
    };
    var device_features: c.VkPhysicalDeviceFeatures2 = .{
        .sType = c.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FEATURES_2,
        .pNext = @ptrCast(&vulkan_13_features),
    };

    const device_create_info: c.VkDeviceCreateInfo = .{
        .sType = c.VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO,
        .pNext = @ptrCast(&device_features),
        .queueCreateInfoCount = 1,
        .pQueueCreateInfos = &device_queue_create_info,
        .enabledExtensionCount = @intCast(device_extensions.len),
        .ppEnabledExtensionNames = &device_extensions,
    };

    switch (c.vkCreateDevice(
        self.physical_device,
        &device_create_info,
        null,
        &self.device,
    )) {
        c.VK_SUCCESS => {},
        c.VK_ERROR_DEVICE_LOST => return error.DeviceLost,
        c.VK_ERROR_OUT_OF_HOST_MEMORY => return error.OutOfHostMemory,
        c.VK_ERROR_EXTENSION_NOT_PRESENT => return error.ExtensionNotPresent,
        c.VK_ERROR_FEATURE_NOT_PRESENT => return error.FeatureNotPresent,
        c.VK_ERROR_OUT_OF_DEVICE_MEMORY => return error.OutOfDeviceMemory,
        c.VK_ERROR_TOO_MANY_OBJECTS => return error.TooManyObjects,
        c.VK_ERROR_VALIDATION_FAILED => return error.ValidationFailed,
        else => return error.Unknown,
    }

    c.vkGetDeviceQueue(
        self.device,
        @intCast(index),
        0,
        &self.graphics_queue,
    );
}

fn findGraphicsQueueFamily(allocator: std.mem.Allocator, physical_device: c.VkPhysicalDevice) !isize {
    var queue_family_property_count: u32 = 0;

    c.vkGetPhysicalDeviceQueueFamilyProperties2(
        physical_device,
        &queue_family_property_count,
        null,
    );

    var queue_families = try allocator.alloc(
        c.VkQueueFamilyProperties2,
        queue_family_property_count,
    );
    defer allocator.free(queue_families);

    for (queue_families) |*props| {
        props.* = .{
            .sType = c.VK_STRUCTURE_TYPE_QUEUE_FAMILY_PROPERTIES_2,
            .queueFamilyProperties = undefined,
        };
    }

    c.vkGetPhysicalDeviceQueueFamilyProperties2(
        physical_device,
        &queue_family_property_count,
        queue_families.ptr,
    );

    return for (queue_families, 0..) |q, i| {
        if ((q.queueFamilyProperties.queueFlags &
            c.VK_QUEUE_GRAPHICS_BIT) != 0)
        {
            break @intCast(i);
        }
    } else -1;
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
const device_extensions = [_][*:0]const u8{
    c.VK_KHR_SWAPCHAIN_EXTENSION_NAME,
    c.VK_KHR_SPIRV_1_4_EXTENSION_NAME,
    c.VK_KHR_SYNCHRONIZATION_2_EXTENSION_NAME,
    c.VK_KHR_CREATE_RENDERPASS_2_EXTENSION_NAME,
};

pub const Config = struct {
    debug: bool = true,
    required_extensions: *std.ArrayList([*:0]const u8),
    required_layers: *std.ArrayList([*:0]const u8),
};
