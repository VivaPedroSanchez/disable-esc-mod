package com.disableesc;

import net.fabricmc.api.ClientModInitializer;
import net.fabricmc.fabric.api.client.event.lifecycle.v1.ClientTickEvents;
import net.fabricmc.fabric.api.client.keybinding.v1.KeyBindingHelper;
import net.minecraft.client.MinecraftClient;
import net.minecraft.client.option.KeyBinding;
import net.minecraft.client.util.InputUtil;
import net.minecraft.text.Text;
import org.lwjgl.glfw.GLFW;

public class DisableEscMod implements ClientModInitializer {

    private static KeyBinding altCloseKey;

    @Override
    public void onInitializeClient() {
        // Registra keybind alternativa (por defecto F12)
        altCloseKey = KeyBindingHelper.registerKeyBinding(new KeyBinding(
                "key.disableesc.alt_close",
                InputUtil.Type.KEYSYM,
                GLFW.GLFW_KEY_F12,
                "category.disableesc.keys"
        ));

        // Listener para tecla alternativa
        ClientTickEvents.END_CLIENT_TICK.register(client -> {
            while (altCloseKey.wasPressed()) {
                if (client.currentScreen != null) {
                    client.setScreen(null);
                    client.inGameHud.getChatHud().addMessage(Text.of("[DisableEsc] Cerrado con tecla alternativa"));
                }
            }
        });

        // Bloquea el ESC original
        ClientTickEvents.END_CLIENT_TICK.register(client -> {
            suppressEscape(client);
        });
    }

    private void suppressEscape(MinecraftClient client) {
        if (client == null || client.getWindow() == null) return;

        long handle = client.getWindow().getHandle();
        if (InputUtil.isKeyPressed(handle, GLFW.GLFW_KEY_ESCAPE)) {
            // Consumir tecla ESC (no hacer nada)
        }
    }
}
