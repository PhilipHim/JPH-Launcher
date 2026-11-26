package jph;

import net.minecraft.client.gui.GuiGraphicsExtractor;
import net.minecraft.client.gui.screens.Screen;
import net.minecraft.client.input.KeyEvent;
import net.minecraft.client.input.MouseButtonEvent;
import net.minecraft.network.chat.Component;

/** Black list, gold only where a hack is on. Right Shift closes it. The list scrolls. */
public final class JphScreen extends Screen {
    private static final int INK = 0xFFE6E8EC;
    private static final int MUTED = 0xFF8E939C;
    private static final int GOLD = 0xFFA18B70;
    private static final int LIGHT = 0xFFF2C14A;
    private static final int LINE = 0xFF2A2C30;
    private static final int PAPER = 0xF007080C;

    private int panelX;
    private int panelY;
    private int panelW;
    private int panelHeight;
    private int rowH;
    private double scroll;
    private int drag = -1;
    private boolean barDrag;

    public JphScreen() {
        super(Component.literal("JPH"));
    }

    @Override
    public boolean isPauseScreen() {
        return false;
    }

    @Override
    public void extractBackground(GuiGraphicsExtractor graphics, int mouseX, int mouseY, float partialTick) {}

    @Override
    public void extractRenderState(GuiGraphicsExtractor graphics, int mouseX, int mouseY, float partialTick) {
        layout();
        graphics.fill(0, 0, width, height, 0x88000000);
        graphics.fill(panelX, panelY, panelX + panelW, panelY + panelHeight, PAPER);

        graphics.text(font, "JPH", panelX + 18, panelY + 16, INK, false);
        int word = font.width("JPH");
        graphics.fill(panelX + 18, panelY + 28, panelX + 18 + word, panelY + 30, GOLD);
        String hint = "Right Shift";
        graphics.text(font, hint, panelX + panelW - 18 - font.width(hint), panelY + 16, MUTED, false);

        int top = rowsY();
        int view = viewH();
        graphics.enableScissor(panelX, top, panelX + panelW - 12, top + view);
        for (int i = 0; i < Hacks.ALL.size(); i++) {
            int y = top + i * rowH - (int) scroll;
            if (y + rowH < top || y > top + view) {
                continue;
            }
            Hack hack = Hacks.ALL.get(i);
            int color = hack.on ? INK : MUTED;
            if (hack.on) {
                graphics.fill(panelX + 12, y + 4, panelX + 14, y + rowH - 6, LIGHT);
            }
            graphics.text(font, hack.name, panelX + 22, y + 6, color, false);
            String value = hack.label();
            int valueX = panelX + panelW - 28 - font.width(value);
            if (hack.slider()) {
                int track = sliderX();
                int fill = (int) ((hack.value - hack.min) / (hack.max - hack.min) * 110);
                graphics.fill(track, y + 10, track + 110, y + 13, LINE);
                graphics.fill(track, y + 10, track + fill, y + 13, hack.on ? GOLD : MUTED);
                valueX = track - 8 - font.width(value);
            }
            graphics.text(font, value, valueX, y + 6, hack.on ? LIGHT : MUTED, false);
        }
        graphics.disableScissor();
        if (maxScroll() > 0) {
            int thumb = thumbH();
            int travel = Math.max(1, view - thumb);
            int thumbY = top + (int) (travel * scroll / maxScroll());
            graphics.fill(panelX + panelW - 8, top, panelX + panelW - 6, top + view, LINE);
            graphics.fill(panelX + panelW - 8, thumbY, panelX + panelW - 6, thumbY + thumb, GOLD);
        }
    }

    @Override
    public boolean mouseScrolled(double mouseX, double mouseY, double horizontal, double vertical) {
        if (maxScroll() <= 0) {
            return false;
        }
        scroll -= vertical * rowH;
        clampScroll();
        return true;
    }

    @Override
    public boolean mouseClicked(MouseButtonEvent event, boolean doubled) {
        if (event.button() != 1) {
            return super.mouseClicked(event, doubled);
        }
        layout();
        if (onBar(event.x(), event.y())) {
            barDrag = true;
            scrollTo(event.y());
            return true;
        }
        int index = rowAt(event.x(), event.y());
        if (index < 0) {
            return super.mouseClicked(event, doubled);
        }
        Hack hack = Hacks.ALL.get(index);
        if (hack.slider() && event.x() >= sliderX()) {
            drag = index;
            hack.setFrom((event.x() - sliderX()) / 110.0);
        } else {
            hack.on = !hack.on;
        }
        return true;
    }

    @Override
    public boolean mouseDragged(MouseButtonEvent event, double dx, double dy) {
        if (barDrag) {
            scrollTo(event.y());
            return true;
        }
        if (drag >= 0) {
            Hacks.ALL.get(drag).setFrom((event.x() - sliderX()) / 110.0);
            return true;
        }
        return super.mouseDragged(event, dx, dy);
    }

    @Override
    public boolean mouseReleased(MouseButtonEvent event) {
        drag = -1;
        barDrag = false;
        return super.mouseReleased(event);
    }

    @Override
    public boolean keyPressed(KeyEvent event) {
        if (JphClient.MENU.matches(event)) {
            JphClient.closed = true;
            onClose();
            return true;
        }
        return super.keyPressed(event);
    }

    private void layout() {
        panelW = Math.min(440, width - 40);
        rowH = 26;
        int natural = 58 + Hacks.ALL.size() * rowH;
        panelHeight = Math.min(natural, Math.max(160, height - 24));
        panelX = (width - panelW) / 2;
        panelY = Math.max(12, (height - panelHeight) / 2);
        clampScroll();
    }

    private int rowsY() {
        return panelY + 44;
    }

    private int viewH() {
        return panelHeight - 58;
    }

    private int contentH() {
        return Hacks.ALL.size() * rowH;
    }

    private int maxScroll() {
        return Math.max(0, contentH() - viewH());
    }

    private void clampScroll() {
        if (scroll < 0) {
            scroll = 0;
        }
        int max = maxScroll();
        if (scroll > max) {
            scroll = max;
        }
    }

    private int thumbH() {
        int view = viewH();
        int content = contentH();
        if (content <= view) {
            return view;
        }
        return Math.max(18, view * view / content);
    }

    private boolean onBar(double x, double y) {
        return maxScroll() > 0 && x >= panelX + panelW - 14 && x <= panelX + panelW && y >= rowsY() && y < rowsY() + viewH();
    }

    private void scrollTo(double y) {
        int thumb = thumbH();
        double span = viewH() - thumb;
        double fraction = span <= 0 ? 0 : (y - rowsY() - thumb / 2.0) / span;
        scroll = Math.min(1, Math.max(0, fraction)) * maxScroll();
    }

    private int sliderX() {
        return panelX + panelW - 178;
    }

    private int rowAt(double x, double y) {
        if (x < panelX || x > panelX + panelW - 14) {
            return -1;
        }
        if (y < rowsY() || y >= rowsY() + viewH()) {
            return -1;
        }
        int index = (int) ((y - rowsY() + scroll) / rowH);
        if (index < 0 || index >= Hacks.ALL.size()) {
            return -1;
        }
        return index;
    }
}
