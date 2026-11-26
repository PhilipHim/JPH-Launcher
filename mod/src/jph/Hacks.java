package jph;

import java.util.List;
import net.minecraft.client.Minecraft;
import net.minecraft.server.MinecraftServer;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.world.effect.MobEffectInstance;
import net.minecraft.world.effect.MobEffects;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.ai.attributes.AttributeInstance;
import net.minecraft.world.entity.ai.attributes.Attributes;
import net.minecraft.world.entity.player.Abilities;
import net.minecraft.world.level.GameType;
import net.minecraft.world.phys.EntityHitResult;
import net.minecraft.world.phys.Vec3;

/** Applies the list on the integrated server. A real server never sees this. */
public final class Hacks {
    public static final Hack FLIGHT = new Hack("Flight", 1, 5, 2, "x");
    public static final Hack SPEED = new Hack("Speed", 1, 4, 1.6, "x");
    public static final Hack REACH = new Hack("Reach", 3, 8, 5, "");
    public static final Hack VELOCITY = new Hack("Velocity", 0, 100, 80, "%");
    public static final Hack STEP = new Hack("Step", 1, 3, 1.5, "");
    public static final Hack JUMP = new Hack("Jump", 1, 3, 1.5, "x");
    public static final Hack NO_FALL = new Hack("No Fall");
    public static final Hack FAST_MINE = new Hack("Fast Mine", 1, 8, 3, "x");
    public static final Hack NO_HUNGER = new Hack("No Hunger");
    public static final Hack SPRINT = new Hack("Sprint");
    public static final Hack GRAVITY = new Hack("Low Gravity", 0.2, 1, 0.4, "x");
    public static final Hack JESUS = new Hack("Jesus");
    public static final Hack FULLBRIGHT = new Hack("Fullbright");
    public static final Hack TIMER = new Hack("Timer", 0.5, 3, 1, "x");
    public static final Hack TRIGGER = new Hack("Trigger");

    public static final List<Hack> ALL = List.of(
            FLIGHT, SPEED, REACH, VELOCITY, FULLBRIGHT, STEP, JUMP, NO_FALL, FAST_MINE,
            NO_HUNGER, SPRINT, GRAVITY, JESUS, TIMER, TRIGGER);

    private static final double VANILLA_FLY = 0.05;
    private static boolean night;
    private static float timer = 20;

    private Hacks() {}

    public static void client(Minecraft minecraft) {
        if (minecraft.player == null || minecraft.getSingleplayerServer() == null) {
            return;
        }
        trigger(minecraft);
        MinecraftServer server = minecraft.getSingleplayerServer();
        server.executeIfPossible(() -> world(server, minecraft.player.getUUID()));
    }

    private static void trigger(Minecraft minecraft) {
        if (!TRIGGER.on || minecraft.gui.screen() != null || minecraft.gameMode == null) {
            return;
        }
        if (!(minecraft.hitResult instanceof EntityHitResult hit)) {
            return;
        }
        if (!(hit.getEntity() instanceof LivingEntity living) || !living.isAlive()) {
            return;
        }
        if (minecraft.player.getAttackStrengthScale(0) < 0.92f) {
            return;
        }
        minecraft.gameMode.attack(minecraft.player, living);
        minecraft.player.resetAttackStrengthTicker();
    }

    private static void world(MinecraftServer server, java.util.UUID id) {
        ServerPlayer player = server.getPlayerList().getPlayer(id);
        if (player == null) {
            return;
        }
        flight(player);
        base(player, Attributes.MOVEMENT_SPEED, SPEED.on ? 0.1 * SPEED.value : 0.1);
        base(player, Attributes.ENTITY_INTERACTION_RANGE, REACH.on ? REACH.value : 3);
        base(player, Attributes.BLOCK_INTERACTION_RANGE, REACH.on ? REACH.value + 1.5 : 4.5);
        base(player, Attributes.KNOCKBACK_RESISTANCE, VELOCITY.on ? VELOCITY.value / 100.0 : 0);
        base(player, Attributes.STEP_HEIGHT, STEP.on ? STEP.value : 0.6);
        base(player, Attributes.JUMP_STRENGTH, JUMP.on ? 0.42 * JUMP.value : 0.42);
        base(player, Attributes.SAFE_FALL_DISTANCE, NO_FALL.on ? 1024 : 3);
        base(player, Attributes.BLOCK_BREAK_SPEED, FAST_MINE.on ? FAST_MINE.value : 1);
        base(player, Attributes.GRAVITY, GRAVITY.on ? 0.08 * GRAVITY.value : 0.08);
        if (NO_FALL.on) {
            player.fallDistance = 0;
        }
        if (NO_HUNGER.on) {
            player.getFoodData().setFoodLevel(20);
            player.getFoodData().setSaturation(5);
        }
        if (SPRINT.on && player.onGround() && !player.isCrouching()) {
            player.setSprinting(true);
        }
        if (FULLBRIGHT.on) {
            MobEffectInstance current = player.getEffect(MobEffects.NIGHT_VISION);
            if (current == null || current.getDuration() < 120) {
                player.addEffect(new MobEffectInstance(MobEffects.NIGHT_VISION, 400, 0, false, false, true));
            }
            night = true;
        } else if (night) {
            player.removeEffect(MobEffects.NIGHT_VISION);
            night = false;
        }
        if (JESUS.on && player.isInWater()) {
            Vec3 motion = player.getDeltaMovement();
            player.setDeltaMovement(motion.x, Math.max(motion.y, 0.11), motion.z);
            player.setOnGround(true);
        }
        float rate = TIMER.on ? (float) (20 * TIMER.value) : 20f;
        if (rate != timer) {
            server.tickRateManager().setTickRate(rate);
            timer = rate;
        }
    }

    private static void flight(ServerPlayer player) {
        Abilities abilities = player.getAbilities();
        GameType mode = player.gameMode();
        boolean creative = mode.isCreative() || mode == GameType.SPECTATOR;
        if (FLIGHT.on) {
            float speed = (float) (VANILLA_FLY * FLIGHT.value);
            boolean changed = !abilities.mayfly || abilities.getFlyingSpeed() != speed;
            abilities.mayfly = true;
            abilities.setFlyingSpeed(speed);
            if (changed) {
                player.onUpdateAbilities();
                abilities.mayfly = true;
                abilities.setFlyingSpeed(speed);
            }
            return;
        }
        abilities.setFlyingSpeed((float) VANILLA_FLY);
        if (!creative && (abilities.mayfly || abilities.flying)) {
            abilities.mayfly = false;
            abilities.flying = false;
            player.onUpdateAbilities();
        }
    }

    private static void base(ServerPlayer player, net.minecraft.core.Holder<net.minecraft.world.entity.ai.attributes.Attribute> attribute, double value) {
        AttributeInstance instance = player.getAttribute(attribute);
        if (instance != null && instance.getBaseValue() != value) {
            instance.setBaseValue(value);
        }
    }
}
