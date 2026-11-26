import AppKit

// shortcut: the app looks for the project on the Desktop, move both together if the folder moves
let project = URL(fileURLWithPath: "/Users/philiphimmeroder/Desktop/jph/JPH Launcher")
let python = project.appendingPathComponent(".venv/bin/python")
let script = project.appendingPathComponent("jph_launch.py")
let gameDir = project.appendingPathComponent("game")

let paper = NSColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
let ink = NSColor(srgbRed: 0xe6 / 255, green: 0xe8 / 255, blue: 0xec / 255, alpha: 1)
let muted = NSColor(srgbRed: 0x8e / 255, green: 0x93 / 255, blue: 0x9c / 255, alpha: 1)
let gold = NSColor(srgbRed: 0xa1 / 255, green: 0x8b / 255, blue: 0x70 / 255, alpha: 1)
let lightGold = NSColor(srgbRed: 0xf2 / 255, green: 0xc1 / 255, blue: 0x4a / 255, alpha: 1)
let line = NSColor(srgbRed: 0x2a / 255, green: 0x2c / 255, blue: 0x30 / 255, alpha: 1)
let studioSite = URL(string: "https://jphwebsite.vercel.app")!

struct SkinItem {
    let id: String
    let title: String
    let texture: NSImage
    let preview: NSImage
}

struct Instance: Codable {
    var name: String
    var version: String
    var folder: String
}

struct ModOffer {
    let title: String
    let slug: String
    let caption: String
    let fileHint: String
}

let modCatalog: [ModOffer] = [
    ModOffer(title: "JPH Mod", slug: "jph", caption: "Right Shift. Fly, reach, velocity, and the rest.", fileHint: "jph-mod"),
    ModOffer(title: "Fabric API", slug: "fabric-api", caption: "JPH Mod needs this.", fileHint: "fabric-api"),
    ModOffer(title: "Sodium", slug: "sodium", caption: "Faster rendering.", fileHint: "sodium-fabric"),
    ModOffer(title: "Lithium", slug: "lithium", caption: "Faster game logic.", fileHint: "lithium"),
    ModOffer(title: "Entity Culling", slug: "entityculling", caption: "Skips entities you cannot see.", fileHint: "entityculling"),
    ModOffer(title: "ImmediatelyFast", slug: "immediatelyfast", caption: "Faster HUD and text.", fileHint: "immediatelyfast"),
    ModOffer(title: "Krypton", slug: "krypton", caption: "Faster networking.", fileHint: "krypton"),
    ModOffer(title: "Dynamic FPS", slug: "dynamic-fps", caption: "Lowers the frame rate when the window is idle.", fileHint: "dynamic-fps"),
    ModOffer(title: "FerriteCore", slug: "ferrite-core", caption: "Uses less memory.", fileHint: "ferritecore"),
    ModOffer(title: "Mod Menu", slug: "modmenu", caption: "A list of mods inside the game.", fileHint: "modmenu"),
    ModOffer(title: "Jade", slug: "jade", caption: "Names the block you are looking at.", fileHint: "jade"),
    ModOffer(title: "AppleSkin", slug: "appleskin", caption: "Shows hunger and saturation.", fileHint: "appleskin"),
    ModOffer(title: "Xaero's Minimap", slug: "xaeros-minimap", caption: "A minimap.", fileHint: "xaerominimap"),
    ModOffer(title: "Xaero's World Map", slug: "xaeros-world-map", caption: "A world map.", fileHint: "xaeroworldmap"),
    ModOffer(title: "LambDynamicLights", slug: "lambdynamiclights", caption: "Held lights glow.", fileHint: "lambdynamiclights"),
    ModOffer(title: "Continuity", slug: "continuity", caption: "Connected glass and bookshelves.", fileHint: "continuity"),
    ModOffer(title: "3D Skin Layers", slug: "3dskinlayers", caption: "The second skin layer has depth.", fileHint: "skinlayers3d"),
    ModOffer(title: "Not Enough Animations", slug: "not-enough-animations", caption: "More player animations.", fileHint: "notenoughanimations"),
    ModOffer(title: "Wavey Capes", slug: "wavey-capes", caption: "Capes move.", fileHint: "waveycapes"),
    ModOffer(title: "Falling Leaves", slug: "fallingleaves", caption: "Leaves fall.", fileHint: "fallingleaves"),
    ModOffer(title: "Presence Footsteps", slug: "presence-footsteps", caption: "Footsteps match the block.", fileHint: "presencefootsteps"),
    ModOffer(title: "Sound Physics Remastered", slug: "sound-physics-remastered", caption: "Sound bounces in rooms.", fileHint: "sound-physics-remastered"),
    ModOffer(title: "AmbientSounds", slug: "ambientsounds", caption: "Extra background sound.", fileHint: "ambientsounds"),
    ModOffer(title: "Visuality", slug: "visuality", caption: "Small particles.", fileHint: "visuality"),
    ModOffer(title: "Mouse Tweaks", slug: "mouse-tweaks", caption: "Drag to move stacks.", fileHint: "mousetweaks"),
    ModOffer(title: "Shulker Box Tooltip", slug: "shulkerboxtooltip", caption: "See what is in a shulker.", fileHint: "shulkerboxtooltip"),
    ModOffer(title: "Controlling", slug: "controlling", caption: "Search the key binds.", fileHint: "controlling"),
    ModOffer(title: "BetterF3", slug: "betterf3", caption: "A cleaner debug screen.", fileHint: "betterf3"),
    ModOffer(title: "Capes", slug: "capes", caption: "Capes from other sites.", fileHint: "capes-"),
    ModOffer(title: "Cloth Config", slug: "cloth-config", caption: "Settings screens for other mods.", fileHint: "cloth-config"),
    ModOffer(title: "YACL", slug: "yacl", caption: "Settings screens for Sodium Extra.", fileHint: "yet_another_config_lib"),
    ModOffer(title: "Sodium Extra", slug: "sodium-extra", caption: "More Sodium options.", fileHint: "sodium-extra"),
    ModOffer(title: "Reese's Sodium Options", slug: "reeses-sodium-options", caption: "A different Sodium settings screen.", fileHint: "reeses-sodium-options"),
]

func mix(_ a: NSColor, _ b: NSColor, _ t: CGFloat) -> NSColor {
    let t = min(1, max(0, t))
    let a = a.usingColorSpace(.sRGB) ?? a
    let b = b.usingColorSpace(.sRGB) ?? b
    return NSColor(
        srgbRed: a.redComponent + (b.redComponent - a.redComponent) * t,
        green: a.greenComponent + (b.greenComponent - a.greenComponent) * t,
        blue: a.blueComponent + (b.blueComponent - a.blueComponent) * t,
        alpha: 1
    )
}

func bundledSkins() -> [SkinItem] {
    let specs = [("ReplayClips", "Your skin"), ("Steve", "Steve"), ("Alex", "Alex")]
    return specs.compactMap { id, title in
        guard let textureURL = Bundle.main.url(forResource: id, withExtension: "png", subdirectory: "skins"),
              let previewURL = Bundle.main.url(forResource: id, withExtension: "png", subdirectory: "previews"),
              let texture = NSImage(contentsOf: textureURL),
              let preview = NSImage(contentsOf: previewURL) else { return nil }
        return SkinItem(id: id, title: title, texture: texture, preview: preview)
    }
}

func installedVersions() -> [String] {
    let root = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent("Library/Application Support/minecraft/versions")
    let urls = (try? FileManager.default.contentsOfDirectory(at: root, includingPropertiesForKeys: nil)) ?? []
    return urls.compactMap { url -> String? in
        let id = url.lastPathComponent
        guard !id.hasSuffix(".json"), !id.hasPrefix("fabric-loader-") else { return nil }
        let ok = FileManager.default.fileExists(atPath: url.appendingPathComponent("\(id).json").path)
            && FileManager.default.fileExists(atPath: url.appendingPathComponent("\(id).jar").path)
        return ok ? id : nil
    }.sorted { a, b in
        if a.contains("snapshot") != b.contains("snapshot") { return !a.contains("snapshot") }
        return a > b
    }
}

func minecraftRunning() -> Bool {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/usr/bin/pgrep")
    task.arguments = ["-f", "KnotClient|net.minecraft.client.main.Main"]
    task.standardOutput = Pipe()
    try? task.run()
    task.waitUntilExit()
    return task.terminationStatus == 0
}

func applySkin(_ image: NSImage, folder: URL) {
    guard let data = image.tiffRepresentation,
          let rep = NSBitmapImageRep(data: data),
          let png = rep.representation(using: .png, properties: [:]) else { return }
    let root = folder.appendingPathComponent("resourcepacks/jph-skin")
    let bodies = [
        "assets/minecraft/textures/entity/player/wide/steve.png",
        "assets/minecraft/textures/entity/player/wide/alex.png",
        "assets/minecraft/textures/entity/player/slim/steve.png",
        "assets/minecraft/textures/entity/player/slim/alex.png",
    ]
    for path in bodies {
        let file = root.appendingPathComponent(path)
        try? FileManager.default.createDirectory(at: file.deletingLastPathComponent(), withIntermediateDirectories: true)
        try? png.write(to: file)
    }
    let meta = """
    {"pack":{"pack_format":97,"min_format":[97,0],"max_format":[97,1],"description":"JPH"}}
    """
    try? meta.write(to: root.appendingPathComponent("pack.mcmeta"), atomically: true, encoding: .utf8)
    let options = folder.appendingPathComponent("options.txt")
    var text = (try? String(contentsOf: options, encoding: .utf8)) ?? ""
    let line = "resourcePacks:[\"vanilla\",\"file/jph-skin\"]"
    let lines = text.split(separator: "\n", omittingEmptySubsequences: false).map { row -> String in
        row.hasPrefix("resourcePacks:") ? line : String(row)
    }
    text = lines.joined(separator: "\n")
    if !text.contains("resourcePacks:") {
        if !text.isEmpty && !text.hasSuffix("\n") { text += "\n" }
        text += line + "\n"
    }
    try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
    try? text.write(to: options, atomically: true, encoding: .utf8)
}

final class WordButton: NSView {
    var title = "Play"
    var fontSize: CGFloat = 32
    var onClick: (() -> Void)?
    private var hover: CGFloat = 0
    private var hoverTimer: Timer?
    private var morph: CGFloat = 0
    private var morphTarget: CGFloat = 0
    private var shown: CGFloat = 0
    private var fraction: CGFloat = 0
    private var loadTimer: Timer?

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        updateTrackingAreas()
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach(removeTrackingArea)
        addTrackingArea(NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .activeInKeyWindow, .inVisibleRect, .cursorUpdate], owner: self))
    }

    override var mouseDownCanMoveWindow: Bool { false }
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }
    override func cursorUpdate(with event: NSEvent) {
        if morphTarget > 0 { NSCursor.arrow.set() } else { NSCursor.pointingHand.set() }
    }
    override func mouseDown(with event: NSEvent) { if morphTarget == 0 { animateHover(to: 1) } }
    override func mouseEntered(with event: NSEvent) { if morphTarget == 0 { animateHover(to: 1) } }
    override func mouseExited(with event: NSEvent) { animateHover(to: 0) }
    override func mouseUp(with event: NSEvent) {
        guard morphTarget == 0, bounds.contains(convert(event.locationInWindow, from: nil)) else { return }
        onClick?()
    }

    func beginLoading() {
        fraction = 0.04
        shown = 0
        morphTarget = 1
        startLoadTimer()
    }

    func setFraction(_ value: CGFloat) {
        fraction = min(1, max(0, value))
        startLoadTimer()
    }

    func endLoading() {
        morphTarget = 0
        fraction = 0
        startLoadTimer()
    }

    private func animateHover(to target: CGFloat) {
        hoverTimer?.invalidate()
        let start = hover
        let began = Date()
        hoverTimer = Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true) { [weak self] timer in
            guard let self else { timer.invalidate(); return }
            let t = min(1, Date().timeIntervalSince(began) / 0.18)
            let eased = 1 - pow(1 - t, 3)
            self.hover = start + (target - start) * eased
            self.needsDisplay = true
            if t >= 1 { timer.invalidate() }
        }
    }

    private func startLoadTimer() {
        if loadTimer != nil { return }
        loadTimer = Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true) { [weak self] timer in
            guard let self else { timer.invalidate(); return }
            self.morph += (self.morphTarget - self.morph) * 0.18
            self.shown += (self.fraction - self.shown) * 0.1
            if abs(self.morph - self.morphTarget) < 0.004 { self.morph = self.morphTarget }
            if abs(self.shown - self.fraction) < 0.004 { self.shown = self.fraction }
            self.needsDisplay = true
            if self.morph == self.morphTarget && self.shown == self.fraction && self.morphTarget == 0 {
                timer.invalidate()
                self.loadTimer = nil
            }
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        if morph < 0.98 {
            let text = title as NSString
            let attrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: fontSize, weight: .semibold),
                .foregroundColor: mix(ink, lightGold, hover).withAlphaComponent(1 - morph),
                .kern: 1.2,
            ]
            let size = text.size(withAttributes: attrs)
            let x = (bounds.width - size.width) / 2
            let y = (bounds.height - size.height) / 2 + hover * 5 + morph * 10
            text.draw(at: NSPoint(x: x, y: y), withAttributes: attrs)
            mix(gold, lightGold, hover).withAlphaComponent(1 - morph).setFill()
            NSRect(x: x, y: y - 8, width: size.width, height: 1).fill()
        }
        if morph > 0.02 {
            let trackW = bounds.width - 48
            let track = NSRect(x: 24, y: bounds.midY - 1.5, width: trackW, height: 3)
            line.withAlphaComponent(morph).setFill()
            track.fill()
            lightGold.withAlphaComponent(morph).setFill()
            NSRect(x: track.minX, y: track.minY, width: trackW * shown, height: 3).fill()
            let label = "\(Int((shown * 100).rounded()))%" as NSString
            let attrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 15, weight: .semibold),
                .foregroundColor: ink.withAlphaComponent(morph),
                .kern: 1.1,
            ]
            let size = label.size(withAttributes: attrs)
            label.draw(at: NSPoint(x: (bounds.width - size.width) / 2, y: track.maxY + 12), withAttributes: attrs)
        }
    }
}

final class TabLabel: NSView {
    var title = ""
    var active = false
    var onClick: (() -> Void)?

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach(removeTrackingArea)
        addTrackingArea(NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .activeInKeyWindow, .inVisibleRect, .cursorUpdate], owner: self))
    }

    override var mouseDownCanMoveWindow: Bool { false }
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }
    override func cursorUpdate(with event: NSEvent) { NSCursor.pointingHand.set() }
    override func mouseDown(with event: NSEvent) {}
    override func mouseUp(with event: NSEvent) { onClick?() }

    override func draw(_ dirtyRect: NSRect) {
        let text = title as NSString
        let attrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 13, weight: .medium),
            .foregroundColor: active ? ink : muted,
            .kern: 0.8,
        ]
        let size = text.size(withAttributes: attrs)
        let origin = NSPoint(x: (bounds.width - size.width) / 2, y: 6)
        text.draw(at: origin, withAttributes: attrs)
        if active {
            gold.setFill()
            NSRect(x: origin.x, y: 2, width: size.width, height: 1).fill()
        }
    }
}

final class LogoButton: NSView {
    var image: NSImage?
    var onClick: (() -> Void)?
    private var lift: CGFloat = 0
    private var timer: Timer?

    override var mouseDownCanMoveWindow: Bool { false }
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach(removeTrackingArea)
        addTrackingArea(NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .activeInKeyWindow, .inVisibleRect, .cursorUpdate], owner: self))
    }

    override func cursorUpdate(with event: NSEvent) { NSCursor.pointingHand.set() }
    override func mouseEntered(with event: NSEvent) { animate(to: 4) }
    override func mouseExited(with event: NSEvent) { animate(to: 0) }
    override func mouseDown(with event: NSEvent) {}
    override func mouseUp(with event: NSEvent) {
        guard bounds.contains(convert(event.locationInWindow, from: nil)) else { return }
        onClick?()
    }

    private func animate(to target: CGFloat) {
        timer?.invalidate()
        let start = lift
        let began = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true) { [weak self] timer in
            guard let self else { timer.invalidate(); return }
            let t = min(1, Date().timeIntervalSince(began) / 0.18)
            let eased = 1 - pow(1 - t, 3)
            self.lift = start + (target - start) * eased
            self.needsDisplay = true
            if t >= 1 { timer.invalidate() }
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        guard let image, image.size.width > 0, image.size.height > 0 else { return }
        let slot = NSRect(x: 0, y: lift, width: bounds.width, height: bounds.height - 6)
        let scale = min(slot.width / image.size.width, slot.height / image.size.height)
        let fitted = NSSize(width: image.size.width * scale, height: image.size.height * scale)
        let rect = NSRect(x: slot.midX - fitted.width / 2, y: slot.midY - fitted.height / 2, width: fitted.width, height: fitted.height)
        image.draw(in: rect, from: .zero, operation: .sourceOver, fraction: 1)
    }
}

final class VersionPicker: NSView {
    var titles: [String] = []
    var selected = "26.3"
    var onChange: ((String) -> Void)?
    private var open = false
    private var hover: String?
    private var monitor: Any?
    private let rowH: CGFloat = 30
    private let buttonH: CGFloat = 28

    var preferredWidth: CGFloat {
        let font = NSFont.systemFont(ofSize: 13, weight: .medium)
        let longest = titles.map { ($0 as NSString).size(withAttributes: [.font: font]).width }.max() ?? 48
        return max(120, longest + 40)
    }

    var preferredMenuHeight: CGFloat { CGFloat(max(titles.count, 1)) * rowH + 12 }

    var closedWidth: CGFloat {
        let font = NSFont.systemFont(ofSize: 13, weight: .medium)
        return (selected as NSString).size(withAttributes: [.font: font]).width + 28
    }

    override var mouseDownCanMoveWindow: Bool { false }
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach(removeTrackingArea)
        addTrackingArea(NSTrackingArea(rect: bounds, options: [.mouseMoved, .mouseEnteredAndExited, .activeInKeyWindow, .inVisibleRect, .cursorUpdate], owner: self))
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
        let local = convert(point, from: superview)
        if buttonRect.contains(local) { return self }
        if open, menuRect.contains(local) { return self }
        return nil
    }

    override func cursorUpdate(with event: NSEvent) { NSCursor.pointingHand.set() }
    override func mouseDown(with event: NSEvent) {}
    override func mouseExited(with event: NSEvent) {
        hover = nil
        needsDisplay = true
    }

    override func mouseMoved(with event: NSEvent) {
        guard open else { return }
        let local = convert(event.locationInWindow, from: nil)
        let next = title(at: local)
        if next != hover {
            hover = next
            needsDisplay = true
        }
    }

    override func mouseUp(with event: NSEvent) {
        let local = convert(event.locationInWindow, from: nil)
        if buttonRect.contains(local) {
            setOpen(!open)
            return
        }
        if let title = title(at: local) {
            selected = title
            setOpen(false)
            onChange?(title)
        }
    }

    private var buttonRect: NSRect {
        NSRect(x: 0, y: bounds.height - buttonH, width: bounds.width, height: buttonH)
    }

    private var menuRect: NSRect {
        let height = preferredMenuHeight
        return NSRect(x: 0, y: bounds.height - buttonH - 8 - height, width: bounds.width, height: height)
    }

    private func title(at point: NSPoint) -> String? {
        guard open, menuRect.contains(point) else { return nil }
        let index = Int((menuRect.maxY - 6 - point.y) / rowH)
        guard titles.indices.contains(index) else { return nil }
        return titles[index]
    }

    private func setOpen(_ value: Bool) {
        open = value
        hover = nil
        if open, monitor == nil {
            monitor = NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown, .keyDown]) { [weak self] event in
                guard let self else { return event }
                if event.type == .keyDown, event.keyCode == 53 {
                    self.setOpen(false)
                    return nil
                }
                if event.type == .leftMouseDown, event.window == self.window {
                    let local = self.convert(event.locationInWindow, from: nil)
                    if !self.buttonRect.contains(local), !self.menuRect.contains(local) {
                        self.setOpen(false)
                    }
                }
                return event
            }
        }
        if !open, let monitor {
            NSEvent.removeMonitor(monitor)
            self.monitor = nil
        }
        needsDisplay = true
    }

    override func draw(_ dirtyRect: NSRect) {
        let label = selected as NSString
        let labelAttrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 13, weight: .medium),
            .foregroundColor: open ? ink : muted,
            .kern: 0.4,
        ]
        let labelSize = label.size(withAttributes: labelAttrs)
        let chevron = NSRect(x: buttonRect.maxX - 12, y: buttonRect.midY - 2.5, width: 8, height: 5)
        label.draw(at: NSPoint(x: chevron.minX - 8 - labelSize.width, y: buttonRect.midY - labelSize.height / 2), withAttributes: labelAttrs)
        let mark = NSBezierPath()
        mark.move(to: NSPoint(x: chevron.minX, y: open ? chevron.minY : chevron.maxY))
        mark.line(to: NSPoint(x: chevron.midX, y: open ? chevron.maxY : chevron.minY))
        mark.line(to: NSPoint(x: chevron.maxX, y: open ? chevron.minY : chevron.maxY))
        mark.lineWidth = 1
        (open ? gold : muted).setStroke()
        mark.stroke()

        guard open else { return }
        let menu = menuRect
        let panel = NSBezierPath(roundedRect: menu.insetBy(dx: 0.5, dy: 0.5), xRadius: 2, yRadius: 2)
        paper.setFill()
        panel.fill()
        line.setStroke()
        panel.lineWidth = 1
        panel.stroke()
        for (index, title) in titles.enumerated() {
            let row = NSRect(x: menu.minX, y: menu.maxY - 6 - CGFloat(index + 1) * rowH, width: menu.width, height: rowH)
            let on = title == selected
            let text = title as NSString
            let attrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 13, weight: .medium),
                .foregroundColor: on ? ink : (title == hover ? ink : muted),
                .kern: 0.4,
            ]
            let size = text.size(withAttributes: attrs)
            let origin = NSPoint(x: row.minX + 14, y: row.midY - size.height / 2)
            text.draw(at: origin, withAttributes: attrs)
            if on {
                gold.setFill()
                NSRect(x: origin.x, y: origin.y - 3, width: size.width, height: 1).fill()
            }
        }
    }
}

final class GearButton: NSView {
    var on = false
    var onClick: (() -> Void)?

    override var mouseDownCanMoveWindow: Bool { false }
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }
    override func mouseDown(with event: NSEvent) {}
    override func mouseUp(with event: NSEvent) { onClick?() }
    override func cursorUpdate(with event: NSEvent) { NSCursor.pointingHand.set() }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach(removeTrackingArea)
        addTrackingArea(NSTrackingArea(rect: bounds, options: [.activeInKeyWindow, .inVisibleRect, .cursorUpdate], owner: self))
    }

    override func draw(_ dirtyRect: NSRect) {
        guard let image = NSImage(systemSymbolName: "gearshape", accessibilityDescription: "Settings") else { return }
        let symbol = image.withSymbolConfiguration(.init(pointSize: 16, weight: .medium)) ?? image
        let tinted = NSImage(size: symbol.size, flipped: false) { rect in
            symbol.draw(in: rect)
            (self.on ? gold : muted).set()
            rect.fill(using: .sourceAtop)
            return true
        }
        let side: CGFloat = 18
        tinted.draw(in: NSRect(x: (bounds.width - side) / 2, y: (bounds.height - side) / 2, width: side, height: side))
    }
}

final class RowButton: NSView {
    var title = ""
    var detail = ""
    var caption = ""
    var project = ""
    var marked = false
    var rule = false
    var onClick: (() -> Void)?

    override var mouseDownCanMoveWindow: Bool { false }
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }
    override func mouseDown(with event: NSEvent) {}
    override func mouseUp(with event: NSEvent) { onClick?() }
    override func cursorUpdate(with event: NSEvent) { NSCursor.pointingHand.set() }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach(removeTrackingArea)
        addTrackingArea(NSTrackingArea(rect: bounds, options: [.activeInKeyWindow, .inVisibleRect, .cursorUpdate], owner: self))
    }

    override func draw(_ dirtyRect: NSRect) {
        let text = title as NSString
        let attrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 15, weight: .medium),
            .foregroundColor: marked ? ink : muted,
        ]
        let size = text.size(withAttributes: attrs)
        let titleY = caption.isEmpty ? (bounds.height - size.height) / 2 : bounds.height - size.height - 8
        text.draw(at: NSPoint(x: 0, y: titleY), withAttributes: attrs)
        var sideWidth: CGFloat = 0
        if !detail.isEmpty {
            let side = detail as NSString
            let sideColor: NSColor = detail == "In" ? lightGold : (detail == "Add" ? muted : (marked ? gold : ink))
            let sideAttrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 13, weight: .medium),
                .foregroundColor: sideColor,
            ]
            let sideSize = side.size(withAttributes: sideAttrs)
            sideWidth = sideSize.width
            side.draw(at: NSPoint(x: bounds.width - sideSize.width - 8, y: titleY), withAttributes: sideAttrs)
        }
        if !caption.isEmpty {
            let style = NSMutableParagraphStyle()
            style.lineBreakMode = .byTruncatingTail
            let cap = caption as NSString
            let capWidth = bounds.width - sideWidth - 24
            cap.draw(in: NSRect(x: 0, y: 8, width: max(40, capWidth), height: 16), withAttributes: [
                .font: NSFont.systemFont(ofSize: 12, weight: .regular),
                .foregroundColor: muted,
                .paragraphStyle: style,
            ])
        }
        if marked {
            gold.setFill()
            NSRect(x: 0, y: titleY - 3, width: size.width, height: 1).fill()
        }
        if rule {
            line.setFill()
            NSRect(x: 0, y: 0, width: bounds.width, height: 1).fill()
        }
    }
}

final class FlippedList: NSView {
    override var isFlipped: Bool { true }
}

final class SettingsPanel: NSView {
    let accountTitle = SettingsPanel.heading("Account")
    let accountBody = NSTextField(wrappingLabelWithString: "Signed out")
    let accountButton = TabLabel()
    let ramTitle = SettingsPanel.heading("RAM")
    let fullTitle = SettingsPanel.heading("Fullscreen")
    let instanceTitle = SettingsPanel.heading("Instances")
    let logTitle = SettingsPanel.heading("Log")
    var ramButtons: [TabLabel] = []
    let fullOn = TabLabel()
    let fullOff = TabLabel()
    var rows: [RowButton] = []
    let add = TabLabel()
    let log = NSTextField(wrappingLabelWithString: "")
    var onRam: ((String) -> Void)?
    var onFull: ((Bool) -> Void)?
    var onInstance: ((Int) -> Void)?
    var onAdd: (() -> Void)?
    var onAccount: (() -> Void)?

    static func heading(_ text: String) -> NSTextField {
        let label = NSTextField(labelWithString: text)
        label.textColor = muted
        label.font = NSFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        let values = ["2G", "4G", "6G", "8G"]
        for (index, title) in ["2 GB", "4 GB", "6 GB", "8 GB"].enumerated() {
            let button = TabLabel()
            button.title = title
            let value = values[index]
            button.onClick = { [weak self] in self?.onRam?(value) }
            ramButtons.append(button)
        }
        fullOn.title = "On"
        fullOff.title = "Off"
        fullOn.onClick = { [weak self] in self?.onFull?(true) }
        fullOff.onClick = { [weak self] in self?.onFull?(false) }
        add.title = "New"
        add.onClick = { [weak self] in self?.onAdd?() }
        accountBody.textColor = ink
        accountBody.font = NSFont.systemFont(ofSize: 13, weight: .regular)
        accountBody.maximumNumberOfLines = 3
        accountButton.title = "Sign in"
        accountButton.onClick = { [weak self] in self?.onAccount?() }
        log.textColor = muted
        log.font = NSFont.monospacedSystemFont(ofSize: 11, weight: .regular)
        log.maximumNumberOfLines = 12
        log.isSelectable = true
        for view in [accountTitle, accountBody, accountButton, ramTitle, fullTitle, instanceTitle, logTitle, fullOn, fullOff, add, log] as [NSView] + ramButtons {
            addSubview(view)
        }
    }

    required init?(coder: NSCoder) { nil }

    func reload(instances: [(String, String)], active: Int, ram: String, fullscreen: Bool, logText: String, account: String?) {
        let values = ["2G", "4G", "6G", "8G"]
        for (index, button) in ramButtons.enumerated() {
            button.active = values[index] == ram
            button.needsDisplay = true
        }
        fullOn.active = fullscreen
        fullOff.active = !fullscreen
        fullOn.needsDisplay = true
        fullOff.needsDisplay = true
        rows.forEach { $0.removeFromSuperview() }
        rows = instances.enumerated().map { index, item in
            let row = RowButton()
            row.title = item.0
            row.detail = item.1
            row.marked = index == active
            row.onClick = { [weak self] in self?.onInstance?(index) }
            addSubview(row)
            return row
        }
        log.stringValue = logText
        accountBody.stringValue = account ?? "Signed out"
        accountButton.title = account == nil ? "Sign in" : "Sign out"
        accountButton.needsDisplay = true
        needsLayout = true
    }

    override func layout() {
        super.layout()
        let width = bounds.width
        var y = bounds.height - 8
        accountTitle.frame = NSRect(x: 0, y: y - 16, width: 160, height: 16)
        y -= 20
        accountBody.frame = NSRect(x: 0, y: y - 36, width: width - 108, height: 36)
        accountButton.frame = NSRect(x: width - 92, y: y - 32, width: 88, height: 28)
        y -= 52
        ramTitle.frame = NSRect(x: 0, y: y - 16, width: 160, height: 16)
        y -= 24
        for (index, button) in ramButtons.enumerated() {
            button.frame = NSRect(x: CGFloat(index) * 78, y: y - 28, width: 72, height: 28)
        }
        y -= 46
        fullTitle.frame = NSRect(x: 0, y: y - 16, width: 160, height: 16)
        y -= 24
        fullOn.frame = NSRect(x: 0, y: y - 28, width: 56, height: 28)
        fullOff.frame = NSRect(x: 64, y: y - 28, width: 56, height: 28)
        y -= 46
        instanceTitle.frame = NSRect(x: 0, y: y - 16, width: 160, height: 16)
        y -= 24
        for row in rows {
            row.frame = NSRect(x: 0, y: y - 30, width: min(460, width), height: 30)
            y -= 32
        }
        add.frame = NSRect(x: 0, y: y - 28, width: 64, height: 28)
        y -= 46
        logTitle.frame = NSRect(x: 0, y: y - 16, width: 160, height: 16)
        let logTop = y - 32
        log.frame = NSRect(x: 0, y: 12, width: width, height: max(48, logTop - 12))
    }
}

final class ModsPanel: NSView, NSTextFieldDelegate {
    let field = NSTextField()
    let status = NSTextField(labelWithString: "")
    let scroll = NSScrollView()
    let list = FlippedList()
    var rows: [RowButton] = []
    var onSearch: ((String) -> Void)?
    var onPick: ((String) -> Void)?
    var onHave: ((String) -> Void)?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        field.isBezeled = false
        field.drawsBackground = false
        field.focusRingType = .none
        field.textColor = ink
        field.font = NSFont.systemFont(ofSize: 18, weight: .medium)
        field.placeholderAttributedString = NSAttributedString(
            string: "Find a mod",
            attributes: [.foregroundColor: muted, .font: field.font as Any]
        )
        field.delegate = self
        status.textColor = muted
        status.font = NSFont.systemFont(ofSize: 12, weight: .regular)
        scroll.drawsBackground = false
        scroll.borderType = .noBorder
        scroll.hasVerticalScroller = true
        scroll.hasHorizontalScroller = false
        scroll.autohidesScrollers = true
        scroll.documentView = list
        for view in [field, status, scroll] as [NSView] {
            addSubview(view)
        }
    }

    required init?(coder: NSCoder) { nil }

    func controlTextDidChange(_ obj: Notification) {
        onSearch?(field.stringValue)
    }

    func show(hits: [(String, String, String, Bool)]) {
        rows.forEach { $0.removeFromSuperview() }
        rows = hits.map { hit in
            let row = RowButton()
            row.title = hit.0
            row.project = hit.1
            row.caption = hit.2
            row.marked = hit.3
            row.rule = true
            row.detail = hit.3 ? "In" : "Add"
            row.onClick = { [weak self, weak row] in
                guard let row else { return }
                if row.marked { self?.onHave?(row.project) } else { self?.onPick?(row.project) }
            }
            list.addSubview(row)
            return row
        }
        needsLayout = true
        layoutSubtreeIfNeeded()
        scroll.contentView.scroll(to: .zero)
        scroll.reflectScrolledClipView(scroll.contentView)
    }

    override func layout() {
        super.layout()
        field.frame = NSRect(x: 0, y: bounds.height - 32, width: bounds.width, height: 28)
        let statusH: CGFloat = status.stringValue.isEmpty ? 0 : 18
        status.frame = NSRect(x: 0, y: field.frame.minY - 8 - statusH, width: bounds.width, height: statusH)
        let top = (statusH == 0 ? field.frame.minY : status.frame.minY) - 14
        scroll.frame = NSRect(x: 0, y: 0, width: bounds.width, height: max(0, top))
        let width = scroll.contentSize.width
        let rowH: CGFloat = 52
        list.frame = NSRect(x: 0, y: 0, width: width, height: CGFloat(rows.count) * rowH)
        for (index, row) in rows.enumerated() {
            row.frame = NSRect(x: 0, y: CGFloat(index) * rowH, width: width, height: rowH)
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        gold.withAlphaComponent(0.8).setFill()
        NSRect(x: field.frame.minX, y: field.frame.minY - 3, width: field.frame.width, height: 1).fill()
    }
}

final class Stage: NSView {
    var canvas = paper
    let logo = LogoButton()
    let versions = VersionPicker()
    let startTab = TabLabel()
    let skinsTab = TabLabel()
    let modsTab = TabLabel()
    let gear = GearButton()
    let settings = SettingsPanel()
    let mods = ModsPanel()
    let emblem = NSImageView()
    let play = WordButton()
    let change = WordButton()
    let skinView = NSImageView()
    let status = NSTextField(labelWithString: "")

    override func draw(_ dirtyRect: NSRect) {
        canvas.setFill()
        bounds.fill()
    }

    override func layout() {
        super.layout()
        let w = bounds.width
        let h = bounds.height
        let bar = h - 64
        logo.frame = NSRect(x: 72, y: bar - 8, width: 92, height: 40)
        startTab.frame = NSRect(x: 188, y: bar, width: 64, height: 28)
        skinsTab.frame = NSRect(x: 252, y: bar, width: 64, height: 28)
        modsTab.frame = NSRect(x: 316, y: bar, width: 64, height: 28)
        let menuH = versions.preferredMenuHeight
        let pickerW = versions.preferredWidth
        versions.frame = NSRect(x: w - 24 - pickerW, y: bar - 8 - menuH, width: pickerW, height: 28 + 8 + menuH)
        gear.frame = NSRect(x: versions.frame.maxX - versions.closedWidth - 36, y: bar, width: 28, height: 28)
        let page = NSRect(x: 72, y: 36, width: w - 144, height: bar - 52)
        settings.frame = page
        mods.frame = page
        var emblemH: CGFloat = 560
        var emblemW = emblemH * (1024 / 682)
        let maxW = w - 80
        if emblemW > maxW {
            emblemW = maxW
            emblemH = emblemW * (682 / 1024)
        }
        let emblemTop = bar - 16
        var emblemY = emblemTop - emblemH
        let artworkBottom = emblemY + emblemH * (84 / 682)
        var playY = artworkBottom - 80
        if playY < 28 {
            emblemY += 28 - playY
            playY = 28
        }
        play.frame = NSRect(x: (w - 320) / 2, y: playY, width: 320, height: 64)
        emblem.frame = NSRect(x: (w - emblemW) / 2, y: emblemY, width: emblemW, height: emblemH)
        status.frame = NSRect(x: 40, y: play.frame.minY - 22, width: w - 80, height: 18)
        let skinH = min(420, h - 220)
        let skinW = skinH * (220 / 528)
        skinView.frame = NSRect(x: (w - skinW) / 2, y: h * 0.34, width: skinW, height: skinH)
        change.frame = NSRect(x: (w - 280) / 2, y: h / 6 - 24, width: 280, height: 64)
    }
}

final class Launcher: NSObject, NSApplicationDelegate {
    let stage = Stage()
    var window: NSWindow?
    var skins: [SkinItem] = []
    var instances: [Instance] = []
    var activeInstance = 0
    var selected = "ReplayClips"
    enum Page { case start, skins, mods, settings }
    var page: Page = .start
    var loadWatch: Timer?
    var launchedAt = Date.distantPast
    var loginTask: Process?
    var loginBuffer = ""
    var keepLoginNote = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1040, height: 740),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.title = "JPH Launcher"
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.appearance = NSAppearance(named: .darkAqua)
        window.backgroundColor = paper
        window.isMovableByWindowBackground = true
        window.acceptsMouseMovedEvents = true
        window.minSize = NSSize(width: 860, height: 640)
        window.center()

        if let url = Bundle.main.url(forResource: "logo-alpha", withExtension: "png") {
            stage.logo.image = NSImage(contentsOf: url)
        }
        stage.logo.onClick = { NSWorkspace.shared.open(studioSite) }

        let versions = installedVersions()
        let savedVersion = UserDefaults.standard.string(forKey: "version")
        let chosen = versions.contains(savedVersion ?? "") ? savedVersion! : (versions.contains("26.3") ? "26.3" : versions.first ?? "26.3")
        stage.versions.titles = versions
        stage.versions.selected = chosen
        stage.versions.onChange = { [weak self] version in self?.setVersion(version) }
        loadInstances(fallback: chosen)

        stage.startTab.title = "Start"
        stage.skinsTab.title = "Skins"
        stage.modsTab.title = "Mods"
        stage.startTab.onClick = { [weak self] in self?.show(.start) }
        stage.skinsTab.onClick = { [weak self] in self?.show(.skins) }
        stage.modsTab.onClick = { [weak self] in self?.show(.mods) }
        stage.gear.onClick = { [weak self] in self?.show(self?.page == .settings ? .start : .settings) }
        stage.settings.onRam = { [weak self] value in
            UserDefaults.standard.set(value, forKey: "ram")
            self?.refreshSettings()
        }
        stage.settings.onFull = { [weak self] value in
            UserDefaults.standard.set(value, forKey: "fullscreen")
            self?.refreshSettings()
        }
        stage.settings.onInstance = { [weak self] index in self?.selectInstance(index) }
        stage.settings.onAdd = { [weak self] in self?.addInstance() }
        stage.settings.onAccount = { [weak self] in self?.toggleAccount() }
        stage.mods.onSearch = { [weak self] query in self?.searchMods(query) }
        stage.mods.onPick = { [weak self] id in self?.addMod(id) }
        stage.mods.onHave = { [weak self] id in self?.removeMod(id) }

        if let url = Bundle.main.url(forResource: "emblem", withExtension: "png") {
            stage.emblem.image = NSImage(contentsOf: url)
        }
        stage.emblem.imageScaling = .scaleProportionallyUpOrDown
        stage.play.title = "Play"
        stage.play.fontSize = 32
        stage.play.onClick = { [weak self] in self?.play() }
        stage.change.title = "Change"
        stage.change.fontSize = 26
        stage.change.onClick = { [weak self] in self?.wechseln() }
        stage.skinView.imageScaling = .scaleProportionallyUpOrDown
        stage.status.alignment = .center
        stage.status.textColor = muted
        stage.status.font = NSFont.systemFont(ofSize: 13, weight: .regular)

        skins = bundledSkins()
        selected = UserDefaults.standard.string(forKey: "skin") ?? "ReplayClips"
        if !skins.contains(where: { $0.id == selected }) { selected = skins.first?.id ?? "ReplayClips" }
        stage.skinView.image = skins.first { $0.id == selected }?.preview
        for view in [stage.emblem, stage.skinView, stage.settings, stage.mods, stage.logo, stage.startTab, stage.skinsTab, stage.modsTab, stage.versions, stage.gear, stage.play, stage.change, stage.status] as [NSView] {
            stage.addSubview(view)
        }
        if let current = skins.first(where: { $0.id == selected }) { applySkin(current.texture, folder: instanceFolder()) }
        show(.start)
        window.contentView = stage
        window.makeKeyAndOrderFront(nil)
        self.window = window
        NSApp.activate()
    }

    func show(_ page: Page) {
        self.page = page
        stage.startTab.active = page == .start
        stage.skinsTab.active = page == .skins
        stage.modsTab.active = page == .mods
        stage.gear.on = page == .settings
        stage.emblem.isHidden = page != .start
        stage.play.isHidden = page != .start
        stage.status.isHidden = page != .start
        stage.skinView.isHidden = page != .skins
        stage.change.isHidden = page != .skins
        stage.settings.isHidden = page != .settings
        stage.mods.isHidden = page != .mods
        stage.canvas = paper
        window?.backgroundColor = paper
        stage.skinView.image = self.skins.first { $0.id == selected }?.preview
        if page == .settings { refreshSettings() }
        if page == .mods { searchMods(stage.mods.field.stringValue) }
        stage.startTab.needsDisplay = true
        stage.skinsTab.needsDisplay = true
        stage.modsTab.needsDisplay = true
        stage.gear.needsDisplay = true
        stage.needsDisplay = true
    }

    func currentTexture() -> NSImage {
        skins.first { $0.id == selected }?.texture ?? NSImage()
    }

    func wechseln() {
        guard let index = skins.firstIndex(where: { $0.id == selected }) else { return }
        choose(skins[(index + 1) % skins.count])
    }

    func choose(_ item: SkinItem) {
        selected = item.id
        UserDefaults.standard.set(item.id, forKey: "skin")
        applySkin(item.texture, folder: instanceFolder())
        show(.skins)
    }

    func instanceFolder() -> URL {
        let folder = instances.indices.contains(activeInstance) ? instances[activeInstance].folder : "game"
        return project.appendingPathComponent(folder)
    }

    func loadInstances(fallback: String) {
        if let data = UserDefaults.standard.data(forKey: "instances"),
           let saved = try? JSONDecoder().decode([Instance].self, from: data), !saved.isEmpty {
            let names = ["Standard": "Default", "Zweite": "Second", "Dritte": "Third", "Vierte": "Fourth", "Fünfte": "Fifth"]
            instances = saved.map { item in
                var copy = item
                if let name = names[item.name] { copy.name = name }
                return copy
            }
            activeInstance = min(UserDefaults.standard.integer(forKey: "instance"), instances.count - 1)
            if instances.map(\.name) != saved.map(\.name) { saveInstances() }
        } else {
            instances = [Instance(name: "Default", version: fallback, folder: "game")]
            activeInstance = 0
            saveInstances()
        }
        let version = instances[activeInstance].version
        if stage.versions.titles.contains(version) { stage.versions.selected = version }
    }

    func saveInstances() {
        if let data = try? JSONEncoder().encode(instances) {
            UserDefaults.standard.set(data, forKey: "instances")
        }
        UserDefaults.standard.set(activeInstance, forKey: "instance")
    }

    func selectInstance(_ index: Int) {
        guard instances.indices.contains(index) else { return }
        activeInstance = index
        let version = instances[index].version
        if stage.versions.titles.contains(version) { stage.versions.selected = version }
        stage.versions.needsDisplay = true
        saveInstances()
        refreshSettings()
    }

    func setVersion(_ version: String) {
        UserDefaults.standard.set(version, forKey: "version")
        guard instances.indices.contains(activeInstance) else { return }
        instances[activeInstance].version = version
        saveInstances()
    }

    func addInstance() {
        let names = ["Second", "Third", "Fourth", "Fifth"]
        guard instances.count <= names.count else { return }
        let name = names[instances.count - 1]
        instances.append(Instance(name: name, version: stage.versions.selected, folder: "game/instances/\(name.lowercased())"))
        activeInstance = instances.count - 1
        saveInstances()
        refreshSettings()
    }

    func refreshSettings() {
        let ram = UserDefaults.standard.string(forKey: "ram") ?? "4G"
        let fullscreen = UserDefaults.standard.object(forKey: "fullscreen") as? Bool ?? true
        stage.settings.reload(
            instances: instances.map { ($0.name, $0.version) },
            active: activeInstance,
            ram: ram,
            fullscreen: fullscreen,
            logText: logText(),
            account: accountName()
        )
    }

    func logText() -> String {
        let folder = instanceFolder()
        let latest = folder.appendingPathComponent("logs/latest.log")
        let local = folder.appendingPathComponent("jph.log")
        let url = FileManager.default.fileExists(atPath: latest.path) ? latest : local
        guard let handle = try? FileHandle(forReadingFrom: url) else { return "No launch yet." }
        defer { try? handle.close() }
        let size = handle.seekToEndOfFile()
        if size == 0 { return "No launch yet." }
        handle.seek(toFileOffset: size > 6000 ? size - 6000 : 0)
        let text = String(data: handle.readDataToEndOfFile(), encoding: .utf8) ?? ""
        let lines = text.split(separator: "\n").suffix(12)
        return lines.isEmpty ? "No launch yet." : lines.joined(separator: "\n")
    }

    func installedModNames() -> [String] {
        let folder = instanceFolder().appendingPathComponent("mods")
        let urls = (try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil)) ?? []
        return urls.map(\.lastPathComponent).filter { !$0.hasPrefix(".") }.sorted()
    }

    func fileHint(for slug: String) -> String {
        modCatalog.first { $0.slug == slug }?.fileHint ?? slug
    }

    func owns(slug: String) -> Bool {
        let hint = fileHint(for: slug).lowercased()
        let remembered = (UserDefaults.standard.dictionary(forKey: "modFiles") as? [String: String])?[slug]
        return installedModNames().contains { name in
            if let remembered, name == remembered { return true }
            return name.lowercased().contains(hint)
        }
    }

    func remember(slug: String, file: String) {
        var map = UserDefaults.standard.dictionary(forKey: "modFiles") as? [String: String] ?? [:]
        map[slug] = file
        UserDefaults.standard.set(map, forKey: "modFiles")
    }

    func refreshMarks() {
        for row in stage.mods.rows {
            let on = owns(slug: row.project)
            row.marked = on
            row.detail = on ? "In" : "Add"
            row.needsDisplay = true
        }
    }

    func removeMod(_ slug: String) {
        let hint = fileHint(for: slug).lowercased()
        let remembered = (UserDefaults.standard.dictionary(forKey: "modFiles") as? [String: String])?[slug]
        let names = installedModNames()
        let name = names.first { $0 == remembered } ?? names.first { $0.lowercased().contains(hint) }
        guard let name else { return }
        try? FileManager.default.removeItem(at: instanceFolder().appendingPathComponent("mods").appendingPathComponent(name))
        refreshMarks()
    }

    func offers(matching query: String) -> [ModOffer] {
        let looking = query.trimmingCharacters(in: .whitespaces)
        let jph = modCatalog[0]
        let rest = modCatalog.dropFirst().filter { offer in
            looking.isEmpty
                || offer.title.localizedCaseInsensitiveContains(looking)
                || offer.caption.localizedCaseInsensitiveContains(looking)
        }
        return [jph] + rest
    }

    var searchWork: DispatchWorkItem?

    func searchMods(_ query: String) {
        let looking = query.trimmingCharacters(in: .whitespaces)
        let local = offers(matching: looking)
        stage.mods.status.stringValue = ""
        stage.mods.show(hits: local.map { ($0.title, $0.slug, $0.caption, owns(slug: $0.slug)) })
        searchWork?.cancel()
        guard looking.count >= 2 else { return }
        let known = Set(local.map(\.slug))
        let work = DispatchWorkItem { [weak self] in self?.fetchMods(looking, known: known) }
        searchWork = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: work)
    }

    func fetchMods(_ query: String, known: Set<String>) {
        var parts = URLComponents(string: "https://api.modrinth.com/v2/search")!
        parts.queryItems = [
            URLQueryItem(name: "limit", value: "12"),
            URLQueryItem(name: "facets", value: "[[\"project_type:mod\"]]"),
            URLQueryItem(name: "query", value: query),
        ]
        guard let url = parts.url else { return }
        var request = URLRequest(url: url)
        request.setValue("JPHLauncher/0.1", forHTTPHeaderField: "User-Agent")
        URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            let hits = Self.modHits(from: data)
            DispatchQueue.main.async {
                guard let self else { return }
                let current = self.stage.mods.field.stringValue.trimmingCharacters(in: .whitespaces)
                guard current == query else { return }
                let extra = hits.filter { !known.contains($0.1) }
                let local = self.offers(matching: query)
                var rows = local.map { ($0.title, $0.slug, $0.caption, self.owns(slug: $0.slug)) }
                rows += extra.map { ($0.0, $0.1, $0.2, self.owns(slug: $0.1)) }
                self.stage.mods.status.stringValue = extra.isEmpty && local.count == 1 ? "Nothing else under that name." : ""
                self.stage.mods.show(hits: rows)
            }
        }.resume()
    }

    static func modHits(from data: Data?) -> [(String, String, String)] {
        guard let data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let hits = json["hits"] as? [[String: Any]] else { return [] }
        return hits.compactMap { hit in
            guard let title = hit["title"] as? String, let id = hit["project_id"] as? String else { return nil }
            let raw = (hit["description"] as? String) ?? ""
            let clean = raw.replacingOccurrences(of: "\n", with: " ")
            let blurb = clean.count <= 90 ? clean : String(clean.prefix(90)).trimmingCharacters(in: .whitespaces) + "…"
            return (title, id, blurb)
        }
    }

    func addMod(_ id: String) {
        if id == "jph" {
            installLocalJph()
            return
        }
        let version = stage.versions.selected.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: "https://api.modrinth.com/v2/project/\(id)/version?game_versions=%5B%22\(version)%22%5D&loaders=%5B%22fabric%22%5D") else { return }
        var request = URLRequest(url: url)
        request.setValue("JPHLauncher/0.1", forHTTPHeaderField: "User-Agent")
        URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            guard let self else { return }
            let file = Self.modFile(from: data)
            DispatchQueue.main.async {
                guard let file else {
                    self.stage.mods.status.stringValue = "No file for \(self.stage.versions.selected)."
                    return
                }
                self.download(file.0, name: file.1, slug: id)
            }
        }.resume()
    }

    static func modFile(from data: Data?) -> (URL, String)? {
        guard let data, let versions = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { return nil }
        for version in versions {
            guard let files = version["files"] as? [[String: Any]] else { continue }
            let file = files.first { $0["primary"] as? Bool == true } ?? files.first
            if let file, let raw = file["url"] as? String, let url = URL(string: raw), let name = file["filename"] as? String {
                return (url, name)
            }
        }
        return nil
    }

    func installLocalJph() {
        let source = project.appendingPathComponent("mod/jph-mod-1.0.0.jar")
        let folder = instanceFolder().appendingPathComponent("mods")
        let dest = folder.appendingPathComponent("jph-mod-1.0.0.jar")
        do {
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            if !FileManager.default.fileExists(atPath: dest.path) {
                try FileManager.default.copyItem(at: source, to: dest)
            }
            remember(slug: "jph", file: dest.lastPathComponent)
            stage.mods.status.stringValue = ""
            refreshMarks()
        } catch {
            stage.mods.status.stringValue = "JPH Mod file is missing."
        }
    }

    func download(_ url: URL, name: String, slug: String) {
        var request = URLRequest(url: url)
        request.setValue("JPHLauncher/0.1", forHTTPHeaderField: "User-Agent")
        let folder = instanceFolder().appendingPathComponent("mods")
        URLSession.shared.downloadTask(with: request) { [weak self] location, _, _ in
            guard let location else { return }
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            let dest = folder.appendingPathComponent(name)
            try? FileManager.default.removeItem(at: dest)
            try? FileManager.default.moveItem(at: location, to: dest)
            DispatchQueue.main.async {
                guard let self else { return }
                self.remember(slug: slug, file: name)
                self.stage.mods.status.stringValue = ""
                self.refreshMarks()
            }
        }.resume()
    }

    @objc func play() {
        if let current = skins.first(where: { $0.id == selected }) { applySkin(current.texture, folder: instanceFolder()) }
        let version = stage.versions.selected
        setVersion(version)
        if minecraftRunning() {
            stage.status.stringValue = "Already running"
            return
        }
        let ram = UserDefaults.standard.string(forKey: "ram") ?? "4G"
        let fullscreen = UserDefaults.standard.object(forKey: "fullscreen") as? Bool ?? true
        let task = Process()
        task.executableURL = python
        task.arguments = [script.path, version, "--ram", ram, fullscreen ? "--fullscreen" : "--window", "--game", instanceFolder().path]
        task.currentDirectoryURL = project
        let logURL = instanceFolder().appendingPathComponent("jph.log")
        try? Data().write(to: logURL)
        task.standardOutput = try? FileHandle(forWritingTo: logURL)
        task.standardError = task.standardOutput
        stage.status.stringValue = ""
        stage.play.beginLoading()
        launchedAt = Date()
        task.terminationHandler = { [weak self] _ in
            DispatchQueue.main.async {
                let text = (try? String(contentsOf: project.appendingPathComponent("session.txt"), encoding: .utf8)) ?? ""
                let line = text.trimmingCharacters(in: .whitespacesAndNewlines)
                if !line.isEmpty && line != "online" {
                    self?.stage.status.stringValue = line
                }
            }
        }
        do {
            try task.run()
            watchLoad()
        } catch {
            stage.play.endLoading()
            stage.status.stringValue = "Couldn't start"
        }
    }

    func accountName() -> String? {
        let text = pythonLine(["--name"])
        return text == "signed-out" || text.isEmpty ? nil : text
    }

    func toggleAccount() {
        if accountName() != nil {
            _ = pythonLine(["--sign-out"])
            refreshSettings()
            return
        }
        guard loginTask == nil else { return }
        keepLoginNote = false
        stage.settings.accountBody.stringValue = "Waiting for Microsoft…"
        let task = Process()
        task.executableURL = python
        task.arguments = [script.path, "--login"]
        task.currentDirectoryURL = project
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = FileHandle.nullDevice
        loginBuffer = ""
        pipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            guard !data.isEmpty, let text = String(data: data, encoding: .utf8) else { return }
            DispatchQueue.main.async { self?.takeLogin(text) }
        }
        task.terminationHandler = { [weak self] _ in
            pipe.fileHandleForReading.readabilityHandler = nil
            DispatchQueue.main.async {
                guard let self else { return }
                self.loginTask = nil
                if self.keepLoginNote {
                    self.stage.settings.accountButton.title = "Sign in"
                    self.stage.settings.accountButton.needsDisplay = true
                } else {
                    self.refreshSettings()
                }
            }
        }
        loginTask = task
        try? task.run()
    }

    func takeLogin(_ text: String) {
        loginBuffer += text
        while let range = loginBuffer.range(of: "\n") {
            let line = String(loginBuffer[..<range.lowerBound])
            loginBuffer.removeSubrange(..<range.upperBound)
            if line.hasPrefix("code ") {
                let code = String(line.dropFirst(5))
                stage.settings.accountBody.stringValue = "Enter \(code) at microsoft.com/link"
            } else if line.hasPrefix("url "), let url = URL(string: String(line.dropFirst(4))) {
                NSWorkspace.shared.open(url)
            } else if line.hasPrefix("error ") {
                keepLoginNote = true
                stage.settings.accountBody.stringValue = String(line.dropFirst(6))
            } else if line.hasPrefix("ok ") {
                keepLoginNote = false
            }
        }
    }

    func pythonLine(_ arguments: [String]) -> String {
        let task = Process()
        task.executableURL = python
        task.arguments = [script.path] + arguments
        task.currentDirectoryURL = project
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = FileHandle.nullDevice
        try? task.run()
        task.waitUntilExit()
        return (String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func watchLoad() {
        loadWatch?.invalidate()
        loadWatch = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] timer in
            guard let self else { timer.invalidate(); return }
            let state = self.loadState()
            if state < 0 {
                self.stage.play.endLoading()
                self.stage.status.stringValue = "Couldn't start"
                timer.invalidate()
                return
            }
            self.stage.play.setFraction(state)
            let running = minecraftRunning()
            let age = Date().timeIntervalSince(self.launchedAt)
            if !running && age > 15 && state < 1 {
                self.stage.play.endLoading()
                self.stage.status.stringValue = "Couldn't start"
                timer.invalidate()
            } else if !running && state >= 1 {
                self.stage.play.endLoading()
                timer.invalidate()
            }
        }
    }

    func loadState() -> CGFloat {
        let url = instanceFolder().appendingPathComponent("logs/latest.log")
        guard let attrs = try? FileManager.default.attributesOfItem(atPath: url.path),
              let modified = attrs[.modificationDate] as? Date,
              modified >= launchedAt.addingTimeInterval(-1),
              let text = try? String(contentsOf: url, encoding: .utf8) else { return 0.04 }
        if text.contains("Minecraft Crash Report") || text.contains("Failed to start Minecraft") {
            return -1
        }
        let marks: [(String, CGFloat)] = [
            ("Setting user", 0.14),
            ("with Fabric Loader", 0.30),
            ("Backend library", 0.48),
            ("Created window", 0.60),
            ("Reloading ResourceManager", 0.74),
            ("Sound engine started", 0.88),
            ("blocks.png-atlas", 1),
        ]
        var best: CGFloat = 0.08
        for (needle, value) in marks where text.contains(needle) { best = max(best, value) }
        return best
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
}

func installMenu() {
    let appMenu = NSMenu()
    let quit = NSMenuItem(title: "Quit JPH Launcher", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
    quit.keyEquivalentModifierMask = [.command]
    appMenu.addItem(quit)
    let appItem = NSMenuItem()
    appItem.submenu = appMenu
    let main = NSMenu()
    main.addItem(appItem)
    NSApp.mainMenu = main
}

let launcher = Launcher()
let app = NSApplication.shared
app.setActivationPolicy(.regular)
app.delegate = launcher
installMenu()
app.run()
