const std = @import("std");
const builtin = @import("builtin");
const c = @import("vulkan_c");
const Platform = @import("Ezel.zig").Platform;
const Windows = @import("Windows.zig");

const Vulkan = @This();

instance: c.VkInstance = null,
debug_messenger: c.VkDebugUtilsMessengerEXT = null,
physical_device: c.VkPhysicalDevice = null,
device: c.VkDevice = null,
graphics_queue: c.VkQueue = null,
surface: c.VkSurfaceKHR = null,

pub fn init(allocator: std.mem.Allocator, config: Config, platform: *Platform) !void {
    var vk = try allocator.create(Vulkan);
    errdefer allocator.destroy(vk);

    try vk.createInstance(allocator, config);
    errdefer c.vkDestroyInstance(vk.instance, null);

    if (config.debug) {
        try vk.setupDebugMessenger();
    }

    switch (platform.*) {
        .windows => |win| {
            try vk.createWindowsSurface(win);
            win.vk = vk;
        },
    }

    try vk.pickPhysicalDevice(allocator);

    try vk.createLogicalDevice(allocator);
}

pub fn deinit(vulkan: *Vulkan, allocator: std.mem.Allocator) void {
    if (vulkan.debug_messenger) |messenger| {
        const DestroyDebugMessenger: c.PFN_vkDestroyDebugUtilsMessengerEXT =
            @ptrCast(
                c.vkGetInstanceProcAddr(
                    vulkan.instance,
                    "vkDestroyDebugUtilsMessengerEXT",
                ),
            );
        DestroyDebugMessenger.?(vulkan.instance, messenger, null);
    }

    c.vkDestroyDevice(vulkan.device, null);
    c.vkDestroySurfaceKHR(vulkan.instance, vulkan.surface, null);
    c.vkDestroyInstance(vulkan.instance, null);
    allocator.destroy(vulkan);
}

pub fn createWindowsSurface(vulkan: *Vulkan, windows: *Windows) !void {
    const surface_create_info: c.VkWin32SurfaceCreateInfoKHR = .{
        .sType = c.VK_STRUCTURE_TYPE_WIN32_SURFACE_CREATE_INFO_KHR,
        .hwnd = @ptrCast(windows.hwnd),
        .hinstance = @ptrCast(windows.hinstance),
    };

    switch (c.vkCreateWin32SurfaceKHR(
        vulkan.instance,
        &surface_create_info,
        null,
        &vulkan.surface,
    )) {
        c.VK_SUCCESS => {},
        else => |err| return try handleVulkanError(err),
    }
}

fn createInstance(vulkan: *Vulkan, allocator: std.mem.Allocator, config: Config) !void {
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
        else => |err| return try handleVulkanError(err),
    }

    switch (c.vkEnumerateInstanceLayerProperties(
        &available_layer_count,
        null,
    )) {
        c.VK_SUCCESS, c.VK_INCOMPLETE => {},
        else => |err| return try handleVulkanError(err),
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
        else => |err| return try handleVulkanError(err),
    }

    switch (c.vkEnumerateInstanceLayerProperties(
        &available_layer_count,
        available_layers_properties.ptr,
    )) {
        c.VK_SUCCESS => {},
        c.VK_INCOMPLETE => {
            std.log.warn("Unable to retrieve all layer properties", .{});
        },
        else => |err| return try handleVulkanError(err),
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

    switch (c.vkCreateInstance(&instance_create_info, null, &vulkan.instance)) {
        c.VK_SUCCESS => {},
        else => |err| return try handleVulkanError(err),
    }
}

fn pickPhysicalDevice(vulkan: *Vulkan, allocator: std.mem.Allocator) !void {
    var available_device_count: u32 = 0;

    switch (c.vkEnumeratePhysicalDevices(
        vulkan.instance,
        &available_device_count,
        null,
    )) {
        c.VK_SUCCESS, c.VK_INCOMPLETE => {},
        else => |err| return try handleVulkanError(err),
    }

    var available_devices = try allocator.alloc(
        c.VkPhysicalDevice,
        available_device_count,
    );
    defer allocator.free(available_devices);

    switch (c.vkEnumeratePhysicalDevices(
        vulkan.instance,
        &available_device_count,
        available_devices.ptr,
    )) {
        c.VK_SUCCESS => {},
        c.VK_INCOMPLETE => {
            std.log.warn("Unable to retrieve all physical devices", .{});
        },
        else => |err| return try handleVulkanError(err),
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
            else => |err| return try handleVulkanError(err),
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
            else => |err| return try handleVulkanError(err),
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
            vulkan.physical_device = d;
            break is_suitable;
        }
    } else false;

    if (!found_suitable_gpu) {
        return error.SuitableGpuNotFound;
    }
}

fn setupDebugMessenger(vulkan: *Vulkan) !void {
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
                vulkan.instance,
                "vkCreateDebugUtilsMessengerEXT",
            ),
        );
    if (CreateDebugMessenger == null) return error.ExtensionNotPresent;

    switch (CreateDebugMessenger.?(
        vulkan.instance,
        &messenger_create_info,
        null,
        &vulkan.debug_messenger,
    )) {
        c.VK_SUCCESS => {},
        else => |err| return try handleVulkanError(err),
    }
}

fn createLogicalDevice(vulkan: *Vulkan, allocator: std.mem.Allocator) !void {
    const index = try findGraphicsQueueFamily(allocator, vulkan.physical_device);
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
        vulkan.physical_device,
        &device_create_info,
        null,
        &vulkan.device,
    )) {
        c.VK_SUCCESS => {},
        else => |err| return try handleVulkanError(err),
    }

    c.vkGetDeviceQueue(
        vulkan.device,
        @intCast(index),
        0,
        &vulkan.graphics_queue,
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

inline fn handleVulkanError(result: c.VkResult) !void {
    switch (result) {
        c.VK_SUCCESS, c.VK_NOT_READY, c.VK_TIMEOUT, c.VK_EVENT_SET, c.VK_EVENT_RESET, c.VK_INCOMPLETE => {},
        c.VK_ERROR_OUT_OF_HOST_MEMORY => return error.OutOfHostMemory,
        c.VK_ERROR_OUT_OF_DEVICE_MEMORY => return error.OutOfDeviceMemory,
        c.VK_ERROR_INITIALIZATION_FAILED => return error.InitializationFailed,
        c.VK_ERROR_DEVICE_LOST => return error.DeviceLost,
        c.VK_ERROR_MEMORY_MAP_FAILED => return error.MemoryMapFailed,
        c.VK_ERROR_LAYER_NOT_PRESENT => return error.LayerNotPresent,
        c.VK_ERROR_EXTENSION_NOT_PRESENT => return error.ExtensionNotPresent,
        c.VK_ERROR_FEATURE_NOT_PRESENT => return error.FeatureNotPresent,
        c.VK_ERROR_INCOMPATIBLE_DRIVER => return error.IncompatibleDriver,
        c.VK_ERROR_TOO_MANY_OBJECTS => return error.TooManyObjects,
        c.VK_ERROR_FORMAT_NOT_SUPPORTED => return error.FormatNotSupported,
        c.VK_ERROR_FRAGMENTED_POOL => return error.FragmentedPool,
        c.VK_ERROR_UNKNOWN => return error.Unknown,
        c.VK_ERROR_VALIDATION_FAILED => return error.ValidationFailed,
        c.VK_ERROR_OUT_OF_POOL_MEMORY => return error.OutOfPoolMemory,
        c.VK_ERROR_INVALID_EXTERNAL_HANDLE => return error.InvalidExternalHandle,
        c.VK_ERROR_INVALID_OPAQUE_CAPTURE_ADDRESS => return error.InvalidOpaqueCaptureAddress,
        c.VK_ERROR_FRAGMENTATION => return error.Fragmentation,
        c.VK_PIPELINE_COMPILE_REQUIRED => return error.PipelineCompileRequired,
        c.VK_ERROR_NOT_PERMITTED => return error.NotPermitted,
        c.VK_ERROR_SURFACE_LOST_KHR => return error.SurfaceLostKhr,
        c.VK_ERROR_NATIVE_WINDOW_IN_USE_KHR => return error.NativeWindowInUseKhr,
        c.VK_SUBOPTIMAL_KHR => return error.SuboptimalKhr,
        c.VK_ERROR_OUT_OF_DATE_KHR => return error.OutOfDateKhr,
        c.VK_ERROR_INCOMPATIBLE_DISPLAY_KHR => return error.IncompatibleDisplayKhr,
        c.VK_ERROR_INVALID_SHADER_NV => return error.InvalidShaderNv,
        c.VK_ERROR_IMAGE_USAGE_NOT_SUPPORTED_KHR => return error.ImageUsageNotSupportedKhr,
        c.VK_ERROR_VIDEO_PICTURE_LAYOUT_NOT_SUPPORTED_KHR => return error.VideoPictureLayoutNotSupportedKhr,
        c.VK_ERROR_VIDEO_PROFILE_OPERATION_NOT_SUPPORTED_KHR => return error.VideoProfileOperationNotSupportedKhr,
        c.VK_ERROR_VIDEO_PROFILE_FORMAT_NOT_SUPPORTED_KHR => return error.VideoProfileFormatNotSupportedKhr,
        c.VK_ERROR_VIDEO_PROFILE_CODEC_NOT_SUPPORTED_KHR => return error.VideoProfileCodecNotSupportedKhr,
        c.VK_ERROR_VIDEO_STD_VERSION_NOT_SUPPORTED_KHR => return error.VideoStdVersionNotSupportedKhr,
        c.VK_ERROR_INVALID_DRM_FORMAT_MODIFIER_PLANE_LAYOUT_EXT => return error.InvalidDrmFormatModifierPlaneLayoutExt,
        c.VK_ERROR_FULL_SCREEN_EXCLUSIVE_MODE_LOST_EXT => return error.FullScreenExclusiveModeLostExt,
        c.VK_THREAD_IDLE_KHR => return error.ThreadIdleKhr,
        c.VK_THREAD_DONE_KHR => return error.ThreadDoneKhr,
        c.VK_OPERATION_DEFERRED_KHR => return error.OperationDeferredKhr,
        c.VK_OPERATION_NOT_DEFERRED_KHR => return error.OperationNotDeferredKhr,
        c.VK_ERROR_INVALID_VIDEO_STD_PARAMETERS_KHR => return error.InvalidVideoStdParametersKhr,
        c.VK_ERROR_COMPRESSION_EXHAUSTED_EXT => return error.CompressionExhaustedExt,
        c.VK_INCOMPATIBLE_SHADER_BINARY_EXT => return error.IncompatibleShaderBinaryExt,
        c.VK_PIPELINE_BINARY_MISSING_KHR => return error.PipelineBinaryMissingKhr,
        c.VK_ERROR_NOT_ENOUGH_SPACE_KHR => return error.NotEnoughSpaceKhr,
        else => return error.Unknown,
    }
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
