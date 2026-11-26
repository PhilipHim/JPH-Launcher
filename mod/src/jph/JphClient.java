package jph;

import net.fabricmc.api.ClientModInitializer;
import net.fabricmc.fabric.api.client.event.lifecycle.v1.ClientTickEvents;
import net.fabricmc.fabric.api.client.keymapping.v1.KeyMappingHelper;
import net.minecraft.client.KeyMapping;
import com.mojang.blaze3d.platform.InputConstants;

public final class JphClient implements ClientModInitializer {
    public static final KeyMapping MENU = new KeyMapping("key.jph.menu", InputConstants.KEY_RSHIFT, KeyMapping.Category.MISC);
    /** The press that closed the list must not open it again on the same tick. */
    public static boolean closed;

    @Override
    public void onInitializeClient() {
        KeyMappingHelper.registerKeyMapping(MENU);
        ClientTickEvents.END_CLIENT_TICK.register(minecraft -> {
            while (MENU.consumeClick()) {
                if (minecraft.gui.screen() instanceof JphScreen) {
                    minecraft.setScreenAndShow(null);
                    closed = true;
                } else if (minecraft.gui.screen() == null && !closed) {
                    minecraft.setScreenAndShow(new JphScreen());
                }
            }
            closed = false;
            Hacks.client(minecraft);
        });
    }
}
