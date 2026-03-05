const std = @import("std");
const builtin = @import("builtin");
const c = switch (builtin.os.tag) {
    .windows => @import("c/vulkan_windows.zig"),
    .linux => @import("c/vulkan_linux.zig"),
    else => @compileError("unsupported platform"),
};
const Ezel = @import("Ezel.zig");
const Window = Ezel.Window;

const Vulkan = @This();

instance: c.VkInstance = null,
debug_messenger: c.VkDebugUtilsMessengerEXT = null,
physical_device: c.VkPhysicalDevice = null,
device: c.VkDevice = null,
graphics_queue: c.VkQueue = null,
graphics_family: u32 = undefined,
present_queue: c.VkQueue = null,
present_family: u32 = undefined,
queue_indices: [2]u32,
surface: c.VkSurfaceKHR = null,
swapchain: c.VkSwapchainKHR = null,
swapchain_images: ?[]c.VkImage = null,
swapchain_image_format: c.VkFormat = c.VK_FORMAT_UNDEFINED,
swapchain_extent: c.VkExtent2D = .{},
swapchain_image_views: ?[]c.VkImageView = null,

pub fn init(
    allocator: std.mem.Allocator,
    window: *Window,
) InitializationError!*Vulkan {
    var required_layers: std.ArrayList([*:0]const u8) = .empty;
    defer required_layers.deinit(allocator);
    var required_extensions = try std.ArrayList([*:0]const u8).initCapacity(
        allocator,
        1,
    );
    defer required_extensions.deinit(allocator);

    try required_extensions.append(
        allocator,
        c.VK_KHR_GET_SURFACE_CAPABILITIES_2_EXTENSION_NAME,
    );
    try required_extensions.append(
        allocator,
        c.VK_KHR_SURFACE_EXTENSION_NAME,
    );

    switch (builtin.os.tag) {
        .windows => {
            try required_extensions.append(
                allocator,
                c.VK_KHR_WIN32_SURFACE_EXTENSION_NAME,
            );
        },
        else => @compileError("unsupported platform"),
    }

    const config: Config = .{
        .required_extensions = &required_extensions,
        .required_layers = &required_layers,
    };

    var vulkan = try allocator.create(Vulkan);
    errdefer vulkan.deinit(allocator);

    try vulkan.createInstance(allocator, config);

    if (config.debug) {
        try vulkan.setupDebugMessenger();
    }

    try vulkan.createSurface(window);

    try vulkan.pickPhysicalDevice(allocator);

    try vulkan.createLogicalDevice(allocator);

    const dimensions = window.GetSize() catch
        return InitializationError.CouldNotGetDimensions;

    try vulkan.createSwapchain(allocator, dimensions);

    try vulkan.createImageViews(allocator);

    return vulkan;
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

    if (vulkan.swapchain_image_views) |views| {
        for (views) |view| {
            if (view) |v| {
                c.vkDestroyImageView(vulkan.device, v, null);
            }
        }
        allocator.free(views);
    }

    if (vulkan.swapchain_images) |images| {
        allocator.free(images);
    }

    if (vulkan.swapchain) |swapchain| {
        c.vkDestroySwapchainKHR(vulkan.device, swapchain, null);
    }

    if (vulkan.surface) |surface| {
        c.vkDestroySurfaceKHR(vulkan.instance, surface, null);
    }

    if (vulkan.device) |device| {
        c.vkDestroyDevice(device, null);
    }

    if (vulkan.instance) |instance| {
        c.vkDestroyInstance(instance, null);
    }
    allocator.destroy(vulkan);
}

fn createInstance(
    vulkan: *Vulkan,
    allocator: std.mem.Allocator,
    config: Config,
) InitializationError!void {
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
        else => |err| {
            std.log.err(
                "vulkan error while enumerating extensions: {d}",
                .{err},
            );
            return InitializationError.CouldNotCreateInstance;
        },
    }

    switch (c.vkEnumerateInstanceLayerProperties(
        &available_layer_count,
        null,
    )) {
        c.VK_SUCCESS, c.VK_INCOMPLETE => {},
        else => |err| {
            std.log.err(
                "vulkan error while enumerating layers: {d}",
                .{err},
            );
            return InitializationError.CouldNotCreateInstance;
        },
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
        else => |err| {
            std.log.err(
                "vulkan error while retrieving extensions: {d}",
                .{err},
            );
            return InitializationError.CouldNotCreateInstance;
        },
    }

    switch (c.vkEnumerateInstanceLayerProperties(
        &available_layer_count,
        available_layers_properties.ptr,
    )) {
        c.VK_SUCCESS => {},
        c.VK_INCOMPLETE => {
            std.log.warn("Unable to retrieve all layer properties", .{});
        },
        else => |err| {
            std.log.err(
                "vulkan error while retrieving layers: {d}",
                .{err},
            );
            return InitializationError.CouldNotCreateInstance;
        },
    }

    for (required_extensions.items) |e| {
        const found = for (available_extensions_properties) |p| {
            const name = std.mem.sliceTo(&p.extensionName, 0);
            if (std.mem.eql(u8, name, std.mem.span(e))) {
                break true;
            }
        } else false;

        if (!found) {
            return InitializationError.MissingRequiredExtension;
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
            return InitializationError.MissingRequiredLayer;
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

    switch (c.vkCreateInstance(
        &instance_create_info,
        null,
        &vulkan.instance,
    )) {
        c.VK_SUCCESS => {},
        else => |err| {
            std.log.err(
                "vulkan error while creating instance: {d}",
                .{err},
            );
            return InitializationError.CouldNotCreateInstance;
        },
    }
}

fn createSurface(
    vulkan: *Vulkan,
    window: *Window,
) InitializationError!void {
    switch (builtin.os.tag) {
        .windows => {
            const surface_create_info: c.VkWin32SurfaceCreateInfoKHR = .{
                .sType = c.VK_STRUCTURE_TYPE_WIN32_SURFACE_CREATE_INFO_KHR,
                .hwnd = @ptrCast(window.hwnd),
                .hinstance = @ptrCast(window.hinstance),
            };

            switch (c.vkCreateWin32SurfaceKHR(
                vulkan.instance,
                &surface_create_info,
                null,
                &vulkan.surface,
            )) {
                c.VK_SUCCESS => {},
                else => |err| {
                    std.log.err(
                        "vulkan error while creating surface: {d}",
                        .{err},
                    );
                    return InitializationError.CouldNotCreateSurface;
                },
            }
        },
        else => @compileError("unsupported platform"),
    }
}

fn createSwapchain(
    vulkan: *Vulkan,
    allocator: std.mem.Allocator,
    dimensions: Ezel.Dimensions,
) InitializationError!void {
    const surface_info: c.VkPhysicalDeviceSurfaceInfo2KHR = .{
        .sType = c.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SURFACE_INFO_2_KHR,
        .surface = vulkan.surface,
    };

    var extended_capabilities: c.VkSurfaceCapabilities2KHR = .{
        .sType = c.VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_2_KHR,
    };

    switch (c.vkGetPhysicalDeviceSurfaceCapabilities2KHR(
        vulkan.physical_device,
        &surface_info,
        &extended_capabilities,
    )) {
        c.VK_SUCCESS => {},
        else => |err| {
            std.log.err(
                "vulkan error while retrieving surface capabilities: {d}",
                .{err},
            );
            return InitializationError.CouldNotCreateSwapchain;
        },
    }

    const format_info = vulkan.ChooseSurfaceFormat(
        allocator,
        surface_info,
    ) catch |err| {
        if (err == error.OutOfMemory) {
            return err;
        }

        return InitializationError.CouldNotCreateSwapchain;
    };

    const present_mode = vulkan.ChoosePresentMode(allocator) catch |err| {
        if (err == error.OutOfMemory) {
            return err;
        }

        return InitializationError.CouldNotCreateSwapchain;
    };

    if (extended_capabilities.surfaceCapabilities.currentExtent.width !=
        std.math.maxInt(u32))
    {
        vulkan.swapchain_extent =
            extended_capabilities.surfaceCapabilities.currentExtent;
    } else {
        vulkan.swapchain_extent.width =
            std.math.clamp(
                dimensions.width,
                extended_capabilities.surfaceCapabilities.minImageExtent.width,
                extended_capabilities.surfaceCapabilities.maxImageExtent.width,
            );
        vulkan.swapchain_extent.height =
            std.math.clamp(
                dimensions.height,
                extended_capabilities.surfaceCapabilities.minImageExtent.height,
                extended_capabilities.surfaceCapabilities.maxImageExtent.height,
            );
    }

    const image_count_floor: u32 = @max(
        3,
        extended_capabilities.surfaceCapabilities.minImageCount,
    );
    const min_image_count: u32 =
        if (extended_capabilities
            .surfaceCapabilities
            .maxImageCount > 0 and
        image_count_floor > extended_capabilities
            .surfaceCapabilities
            .maxImageCount)
            extended_capabilities.surfaceCapabilities.maxImageCount
        else
            image_count_floor;

    var swapchain_create_info: c.VkSwapchainCreateInfoKHR = .{
        .sType = c.VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR,
        .surface = vulkan.surface,
        .minImageCount = min_image_count,
        .imageFormat = format_info.surfaceFormat.format,
        .imageColorSpace = format_info.surfaceFormat.colorSpace,
        .imageExtent = vulkan.swapchain_extent,
        .imageArrayLayers = 1,
        .imageUsage = c.VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT,
        .imageSharingMode = c.VK_SHARING_MODE_EXCLUSIVE,
        .preTransform = extended_capabilities
            .surfaceCapabilities
            .currentTransform,
        .compositeAlpha = c.VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR,
        .presentMode = present_mode,
        .clipped = c.VK_TRUE,
    };

    if (vulkan.graphics_family != vulkan.present_family) {
        swapchain_create_info.imageSharingMode = c.VK_SHARING_MODE_CONCURRENT;
        swapchain_create_info.queueFamilyIndexCount = 2;
        swapchain_create_info.pQueueFamilyIndices = &vulkan.queue_indices;
    }

    vulkan.swapchain_image_format = format_info.surfaceFormat.format;

    switch (c.vkCreateSwapchainKHR(
        vulkan.device,
        &swapchain_create_info,
        null,
        &vulkan.swapchain,
    )) {
        c.VK_SUCCESS => {},
        else => |err| {
            std.log.err(
                "vulkan error while creating swapchain: {d}",
                .{err},
            );
            return InitializationError.CouldNotCreateSwapchain;
        },
    }

    var image_count: u32 = 0;
    switch (c.vkGetSwapchainImagesKHR(
        vulkan.device,
        vulkan.swapchain,
        &image_count,
        null,
    )) {
        c.VK_SUCCESS => {},
        else => |err| {
            std.log.err(
                "vulkan error while enumerating swapchain images: {d}",
                .{err},
            );
            return InitializationError.CouldNotCreateSwapchain;
        },
    }

    vulkan.swapchain_images = try allocator.alloc(
        c.VkImage,
        image_count,
    );

    switch (c.vkGetSwapchainImagesKHR(
        vulkan.device,
        vulkan.swapchain,
        &image_count,
        vulkan.swapchain_images.?.ptr,
    )) {
        c.VK_SUCCESS => {},
        c.VK_INCOMPLETE => {
            std.log.warn(
                "Unable to retrieve all swapchain images",
                .{},
            );
        },
        else => |err| {
            std.log.err(
                "vulkan error while retrieving swapchain images: {d}",
                .{err},
            );
            return InitializationError.CouldNotCreateSwapchain;
        },
    }
}

fn createImageViews(
    vulkan: *Vulkan,
    allocator: std.mem.Allocator,
) InitializationError!void {
    var create_info: c.VkImageViewCreateInfo = .{
        .sType = c.VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO,
        .viewType = c.VK_IMAGE_VIEW_TYPE_2D,
        .format = vulkan.swapchain_image_format,
        .subresourceRange = .{
            .aspectMask = c.VK_IMAGE_ASPECT_COLOR_BIT,
            .baseMipLevel = 0,
            .levelCount = 1,
            .baseArrayLayer = 0,
            .layerCount = 1,
        },
    };

    vulkan.swapchain_image_views = try allocator.alloc(
        c.VkImageView,
        vulkan.swapchain_images.?.len,
    );

    for (vulkan.swapchain_images.?, 0..) |image, i| {
        create_info.image = image;

        switch (c.vkCreateImageView(
            vulkan.device,
            &create_info,
            null,
            &vulkan.swapchain_image_views.?.ptr[i],
        )) {
            c.VK_SUCCESS => {},
            else => |err| {
                std.log.err(
                    "vulkan error while creating image views: {d}",
                    .{err},
                );
                return InitializationError.CouldNotCreateImageViews;
            },
        }
    }
}

fn ChoosePresentMode(
    vulkan: *Vulkan,
    allocator: std.mem.Allocator,
) !c.VkPresentModeKHR {
    var available_present_mode_count: u32 = 0;

    switch (c.vkGetPhysicalDeviceSurfacePresentModesKHR(
        vulkan.physical_device,
        vulkan.surface,
        &available_present_mode_count,
        null,
    )) {
        c.VK_SUCCESS, c.VK_INCOMPLETE => {},
        else => |err| {
            std.log.err(
                "vulkan error while enumerating present modes: {d}",
                .{err},
            );
            return error.CouldNotChoosePresentMode;
        },
    }

    var available_present_modes = try allocator.alloc(
        c.VkPresentModeKHR,
        available_present_mode_count,
    );
    defer allocator.free(available_present_modes);

    switch (c.vkGetPhysicalDeviceSurfacePresentModesKHR(
        vulkan.physical_device,
        vulkan.surface,
        &available_present_mode_count,
        available_present_modes.ptr,
    )) {
        c.VK_SUCCESS => {},
        c.VK_INCOMPLETE => {
            std.log.warn("Unable to retrieve all present modes", .{});
        },
        else => |err| {
            std.log.err(
                "vulkan error while retrieving present modes: {d}",
                .{err},
            );
            return error.CouldNotChoosePresentMode;
        },
    }

    for (available_present_modes) |mode| {
        if (mode == c.VK_PRESENT_MODE_MAILBOX_KHR) {
            return mode;
        }
    }

    return c.VK_PRESENT_MODE_FIFO_KHR;
}

fn ChooseSurfaceFormat(
    vulkan: *Vulkan,
    allocator: std.mem.Allocator,
    surface_info: c.VkPhysicalDeviceSurfaceInfo2KHR,
) !c.VkSurfaceFormat2KHR {
    var available_surface_format_count: u32 = 0;

    switch (c.vkGetPhysicalDeviceSurfaceFormats2KHR(
        vulkan.physical_device,
        &surface_info,
        &available_surface_format_count,
        null,
    )) {
        c.VK_SUCCESS, c.VK_INCOMPLETE => {},
        else => |err| {
            std.log.err(
                "vulkan error while enumerating surface formats: {d}",
                .{err},
            );
            return error.CouldNotChooseSurfaceFormat;
        },
    }

    var available_surface_format_info = try allocator.alloc(
        c.VkSurfaceFormat2KHR,
        available_surface_format_count,
    );
    defer allocator.free(available_surface_format_info);

    for (available_surface_format_info) |*info| {
        info.* = .{
            .sType = c.VK_STRUCTURE_TYPE_SURFACE_FORMAT_2_KHR,
        };
    }

    switch (c.vkGetPhysicalDeviceSurfaceFormats2KHR(
        vulkan.physical_device,
        &surface_info,
        &available_surface_format_count,
        available_surface_format_info.ptr,
    )) {
        c.VK_SUCCESS => {},
        c.VK_INCOMPLETE => {
            std.log.warn("Unable to retrieve all surface formats", .{});
        },
        else => |err| {
            std.log.err(
                "vulkan error while retrieving surface formats: {d}",
                .{err},
            );
            return error.CouldNotChooseSurfaceFormat;
        },
    }

    for (available_surface_format_info) |info| {
        if (info.surfaceFormat.format == c.VK_FORMAT_B8G8R8A8_SRGB and
            info.surfaceFormat.colorSpace == c.VK_COLOR_SPACE_SRGB_NONLINEAR_KHR)
        {
            return info;
        }
    }

    return available_surface_format_info[0];
}

fn pickPhysicalDevice(vulkan: *Vulkan, allocator: std.mem.Allocator) InitializationError!void {
    var available_device_count: u32 = 0;

    switch (c.vkEnumeratePhysicalDevices(
        vulkan.instance,
        &available_device_count,
        null,
    )) {
        c.VK_SUCCESS, c.VK_INCOMPLETE => {},
        else => |err| {
            std.log.err(
                "vulkan error while enumerating physical devices: {d}",
                .{err},
            );
            return InitializationError.CouldNotPickPhysicalDevice;
        },
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
        else => |err| {
            std.log.err(
                "vulkan error while retrieving physical devices: {d}",
                .{err},
            );
            return InitializationError.CouldNotPickPhysicalDevice;
        },
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
            else => |err| {
                std.log.err(
                    "vulkan error while enumerating device extensions: {d}",
                    .{err},
                );
                return InitializationError.CouldNotPickPhysicalDevice;
            },
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
            else => |err| {
                std.log.err(
                    "vulkan error while retrieving device extensions: {d}",
                    .{err},
                );
                return InitializationError.CouldNotPickPhysicalDevice;
            },
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
        return InitializationError.CouldNotPickPhysicalDevice;
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
    if (CreateDebugMessenger == null) return InitializationError.CouldNotCreateDebugMessenger;

    switch (CreateDebugMessenger.?(
        vulkan.instance,
        &messenger_create_info,
        null,
        &vulkan.debug_messenger,
    )) {
        c.VK_SUCCESS => {},
        else => |err| {
            std.log.err(
                "vulkan error while creating debug messenger: {d}",
                .{err},
            );
            return InitializationError.CouldNotCreateDebugMessenger;
        },
    }
}

fn createLogicalDevice(vulkan: *Vulkan, allocator: std.mem.Allocator) InitializationError!void {
    const queue_families = try vulkan.getPhysicalDeviceQueueFamilies(allocator);
    defer allocator.free(queue_families);

    vulkan.graphics_family =
        for (queue_families, 0..) |q, i| {
            const supports_graphics =
                (q.queueFamilyProperties.queueFlags &
                    c.VK_QUEUE_GRAPHICS_BIT) != 0;

            if (supports_graphics) {
                break @intCast(i);
            }
        } else return InitializationError.CouldNotCreateLogicalDevice;

    vulkan.present_family =
        if (try vulkan.getSurfaceSupport(vulkan.graphics_family))
            vulkan.graphics_family
        else
            @truncate(queue_families.len);

    if (vulkan.present_family == queue_families.len) {
        for (queue_families, 0..) |q, i| {
            const supports_graphics =
                (q.queueFamilyProperties.queueFlags &
                    c.VK_QUEUE_GRAPHICS_BIT) != 0;
            const supports_present = try vulkan.getSurfaceSupport(@truncate(i));

            if (supports_graphics and supports_present) {
                vulkan.graphics_family = @truncate(i);
                vulkan.present_family = @truncate(i);
                break;
            }
        }

        if (vulkan.present_family == queue_families.len) {
            for (queue_families, 0..) |_, i| {
                const supports_present = try vulkan
                    .getSurfaceSupport(@truncate(i));

                if (supports_present) {
                    vulkan.present_family = @truncate(i);
                    break;
                }
            } else return InitializationError.CouldNotCreateLogicalDevice;
        }
    }

    vulkan.queue_indices[0] = vulkan.graphics_family;
    vulkan.queue_indices[1] = vulkan.present_family;

    const priority: f32 = 0.5;

    const device_queue_create_info: c.VkDeviceQueueCreateInfo = .{
        .sType = c.VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO,
        .queueFamilyIndex = @intCast(vulkan.graphics_family),
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
        else => |err| {
            std.log.err(
                "vulkan error while retrieving surface support: {d}",
                .{err},
            );
            return InitializationError.CouldNotCreateLogicalDevice;
        },
    }

    c.vkGetDeviceQueue(
        vulkan.device,
        vulkan.graphics_family,
        0,
        &vulkan.graphics_queue,
    );

    c.vkGetDeviceQueue(
        vulkan.device,
        vulkan.present_family,
        0,
        &vulkan.present_queue,
    );
}

fn getPhysicalDeviceQueueFamilies(
    vulkan: *Vulkan,
    allocator: std.mem.Allocator,
) InitializationError![]c.VkQueueFamilyProperties2 {
    var queue_family_property_count: u32 = 0;

    c.vkGetPhysicalDeviceQueueFamilyProperties2(
        vulkan.physical_device,
        &queue_family_property_count,
        null,
    );

    var queue_families = try allocator.alloc(
        c.VkQueueFamilyProperties2,
        queue_family_property_count,
    );

    for (queue_families) |*props| {
        props.* = .{
            .sType = c.VK_STRUCTURE_TYPE_QUEUE_FAMILY_PROPERTIES_2,
            .queueFamilyProperties = undefined,
        };
    }

    c.vkGetPhysicalDeviceQueueFamilyProperties2(
        vulkan.physical_device,
        &queue_family_property_count,
        queue_families.ptr,
    );

    return queue_families;
}

fn getSurfaceSupport(vulkan: *Vulkan, index: u32) InitializationError!bool {
    var has_surface_support: c.VkBool32 = c.VK_FALSE;

    switch (c.vkGetPhysicalDeviceSurfaceSupportKHR(
        vulkan.physical_device,
        index,
        vulkan.surface,
        &has_surface_support,
    )) {
        c.VK_SUCCESS => {},
        else => |err| {
            std.log.err(
                "vulkan error while retrieving surface support: {d}",
                .{err},
            );
            return InitializationError.CouldNotGetSurfaceSupport;
        },
    }

    if (has_surface_support == c.VK_TRUE) {
        return true;
    }

    return false;
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

pub const Config = struct {
    debug: bool = true,
    required_extensions: *std.ArrayList([*:0]const u8),
    required_layers: *std.ArrayList([*:0]const u8),
};

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

const InitializationError = error{
    CouldNotCreateInstance,
    CouldNotCreateSurface,
    CouldNotCreateSwapchain,
    CouldNotPickPhysicalDevice,
    CouldNotChooseSurfaceFormat,
    CouldNotCreateImageViews,
    CouldNotCreateDebugMessenger,
    CouldNotCreateLogicalDevice,
    CouldNotGetQueueFamilies,
    CouldNotGetSurfaceSupport,
    CouldNotGetDimensions,
    CouldNotChoosePresentMode,
    MissingRequiredExtension,
    MissingRequiredLayer,
} || error{OutOfMemory};
