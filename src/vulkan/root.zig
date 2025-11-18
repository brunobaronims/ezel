const vk = @import("vulkan");
const std = @import("std");

extern "vulkan" fn vkGetInstanceProcAddr(
    instance: vk.Instance,
    p_name: [*:0]const u8,
) callconv(vk.vulkan_call_conv) vk.PfnVoidFunction;

pub const Api = struct {
    base: vk.BaseWrapper,
    inst_wrapper: vk.InstanceWrapper,
    instance: vk.Instance,

    pub fn init(allocator: std.mem.Allocator) !Api {
        const base = vk.BaseWrapper.load(vkGetInstanceProcAddr);
        if (base.dispatch.vkGetInstanceProcAddr == null)
            return error.VulkanLoaderUnavailable;

        const version_1_0: u32 = @bitCast(vk.makeApiVersion(0, 1, 0, 0));
        const api_v1_4: u32 = @bitCast(vk.API_VERSION_1_4);

        const app_info: vk.ApplicationInfo = .{
            .p_application_name = "Ezel",
            .application_version = version_1_0,
            .p_engine_name = "No Engine",
            .engine_version = version_1_0,
            .api_version = api_v1_4,
        };

        const extensions = [_][*:0]const u8{
            "VK_KHR_surface",
            "VK_KHR_win32_surface",
        };

        const props = try base.enumerateInstanceExtensionPropertiesAlloc(null, allocator);
        defer allocator.free(props);

        for (extensions) |ext| {
            var found = false;
            for (props) |prop| {
                if (std.mem.eql(u8, std.mem.span(@as([*:0]const u8, @ptrCast(&prop.extension_name))), std.mem.sliceTo(ext, 0))) {
                    found = true;
                    break;
                }
            }
            if (!found) return error.ExtensionNotPresent;
        }
        const create_info: vk.InstanceCreateInfo = .{
            .p_application_info = &app_info,
            .enabled_extension_count = extensions.len,
            .pp_enabled_extension_names = &extensions,
        };

        const instance = try base.createInstance(&create_info, null);
        const inst_wrapper = vk.InstanceWrapper.load(instance, base.dispatch.vkGetInstanceProcAddr.?);

        return .{ .base = base, .inst_wrapper = inst_wrapper, .instance = instance };
    }

    pub fn deinit(self: *Api) void {
        self.inst_wrapper.destroyInstance(self.instance, null);
    }
};
