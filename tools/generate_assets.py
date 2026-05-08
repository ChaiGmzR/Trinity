from __future__ import annotations

import math
import subprocess
import tempfile
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
IMAGES = ROOT / "assets" / "images"
VIDEOS = ROOT / "assets" / "videos"

W, H = 720, 540
BG = (16, 18, 22)
PANEL = (26, 29, 35)
GRID = (42, 47, 54)
BODY = (239, 242, 245)
MUSCLE = (229, 83, 56)
ACCENT = (54, 209, 167)
YELLOW = (244, 196, 48)
FLOOR = (89, 96, 106)


PATTERNS: dict[str, tuple[str, str]] = {
    "pushup": ("Empuje horizontal", "Pecho, hombro, tríceps"),
    "squat": ("Sentadilla", "Cuádriceps, glúteo"),
    "lunge": ("Zancada", "Pierna unilateral"),
    "hinge": ("Bisagra de cadera", "Isquios, glúteo, espalda"),
    "row": ("Remo", "Espalda, bíceps"),
    "pullup": ("Dominada", "Dorsal, bíceps"),
    "overhead_press": ("Press vertical", "Hombro, tríceps"),
    "curl": ("Curl", "Bíceps y antebrazo"),
    "core": ("Core dinámico", "Abdomen, flexores"),
    "plank": ("Plancha", "Core anti-extensión"),
    "bridge": ("Puente / hip thrust", "Glúteo, isquios"),
    "superman": ("Extensión dorsal", "Erectores, glúteo"),
    "calf_raise": ("Elevación de talón", "Pantorrilla"),
    "cardio": ("Condición", "Potencia y respiración"),
    "carry": ("Carga", "Agarre, core, postura"),
    "mobility": ("Movilidad", "Rango y control"),
    "band_pull": ("Banda elástica", "Escápulas, deltoide posterior"),
}


def font(size: int, bold: bool = False) -> ImageFont.ImageFont:
    names = [
        "arialbd.ttf" if bold else "arial.ttf",
        "segoeuib.ttf" if bold else "segoeui.ttf",
        "DejaVuSans-Bold.ttf" if bold else "DejaVuSans.ttf",
    ]
    for name in names:
        try:
            return ImageFont.truetype(name, size=size)
        except OSError:
            continue
    return ImageFont.load_default()


FONT_TITLE = font(32, bold=True)
FONT_SUB = font(20)
FONT_BADGE = font(18, bold=True)


def phase(frame: int, total: int) -> float:
    t = frame / max(total - 1, 1)
    return 0.5 - 0.5 * math.cos(2 * math.pi * t)


def lerp(a: float, b: float, p: float) -> float:
    return a + (b - a) * p


def point(a: tuple[float, float], b: tuple[float, float], p: float) -> tuple[int, int]:
    return int(lerp(a[0], b[0], p)), int(lerp(a[1], b[1], p))


def draw_line(draw: ImageDraw.ImageDraw, pts, color=BODY, width=13):
    draw.line([(int(x), int(y)) for x, y in pts], fill=color, width=width, joint="curve")
    for x, y in pts:
        draw.ellipse((x - width / 2, y - width / 2, x + width / 2, y + width / 2), fill=color)


def draw_weight(draw: ImageDraw.ImageDraw, x: float, y: float, color=ACCENT):
    draw.rounded_rectangle((x - 22, y - 12, x + 22, y + 12), radius=5, fill=color)
    draw.rectangle((x - 4, y - 18, x + 4, y + 18), fill=(16, 18, 22))


def draw_arrow(draw: ImageDraw.ImageDraw, start, end, color=YELLOW):
    draw.line([start, end], fill=color, width=5)
    sx, sy = start
    ex, ey = end
    angle = math.atan2(ey - sy, ex - sx)
    for delta in (2.55, -2.55):
        ax = ex + 18 * math.cos(angle + delta)
        ay = ey + 18 * math.sin(angle + delta)
        draw.line([(ex, ey), (ax, ay)], fill=color, width=5)


def base_canvas(title: str, subtitle: str) -> Image.Image:
    img = Image.new("RGB", (W, H), BG)
    draw = ImageDraw.Draw(img)

    for x in range(-W, W * 2, 42):
        draw.line((x, 0, x + W, H), fill=GRID, width=1)
    draw.rectangle((0, 0, W, 86), fill=PANEL)
    draw.text((28, 20), title, font=FONT_TITLE, fill=(252, 252, 252))
    draw.text((30, 58), subtitle, font=FONT_SUB, fill=(178, 186, 197))
    draw.rounded_rectangle((W - 186, 22, W - 28, 62), radius=8, fill=(44, 51, 61))
    draw.text((W - 166, 33), "OFFLINE DEMO", font=FONT_BADGE, fill=ACCENT)
    draw.line((36, H - 76, W - 36, H - 76), fill=FLOOR, width=4)
    return img


def draw_standing(draw: ImageDraw.ImageDraw, p: float, mode: str) -> None:
    hip = (360, 342)
    shoulder = (360, 222)
    head = (360, 154)
    knee_l, knee_r = (305, 432), (415, 432)
    foot_l, foot_r = (275, 465), (445, 465)
    elbow_l, elbow_r = (302, 282), (418, 282)
    hand_l, hand_r = (288, 352), (432, 352)

    if mode == "squat":
        hip = (360, lerp(320, 386, p))
        shoulder = (360, lerp(205, 268, p))
        head = (360, lerp(138, 200, p))
        knee_l = (296, lerp(404, 438, p))
        knee_r = (424, lerp(404, 438, p))
        hand_l, hand_r = (286, lerp(260, 295, p)), (434, lerp(260, 295, p))
        draw_arrow(draw, (486, 330), (486, 395))
    elif mode == "lunge":
        hip = (360, lerp(316, 372, p))
        shoulder = (360, lerp(210, 258, p))
        head = (360, lerp(142, 190, p))
        knee_l = (278, lerp(385, 437, p))
        foot_l = (230, 465)
        knee_r = (450, lerp(420, 455, p))
        foot_r = (504, 465)
        hand_l, hand_r = (310, lerp(280, 338, p)), (410, lerp(280, 338, p))
        draw_arrow(draw, (220, 385), (275, 425))
    elif mode == "overhead_press":
        elbow_l = point((304, 286), (312, 160), p)
        elbow_r = point((416, 286), (408, 160), p)
        hand_l = point((286, 348), (292, 106), p)
        hand_r = point((434, 348), (428, 106), p)
        draw_weight(draw, *hand_l)
        draw_weight(draw, *hand_r)
        draw_arrow(draw, (474, 330), (474, 132))
    elif mode == "curl":
        elbow_l, elbow_r = (310, 286), (410, 286)
        hand_l = point((294, 372), (302, 275), p)
        hand_r = point((426, 372), (418, 275), p)
        draw_weight(draw, *hand_l)
        draw_weight(draw, *hand_r)
        draw_arrow(draw, (464, 366), (446, 282))
    elif mode == "carry":
        sway = math.sin(p * math.pi) * 10
        hip = (360 + sway, 342)
        shoulder = (360 + sway, 222)
        head = (360 + sway, 154)
        elbow_l, elbow_r = (306 + sway, 286), (414 + sway, 286)
        hand_l, hand_r = (280 + sway, 405), (440 + sway, 405)
        draw_weight(draw, *hand_l)
        draw_weight(draw, *hand_r)
        draw_arrow(draw, (250, 444), (472, 444))
    elif mode == "calf_raise":
        lift = 24 * p
        hip = (360, 342 - lift)
        shoulder = (360, 222 - lift)
        head = (360, 154 - lift)
        knee_l, knee_r = (310, 424 - lift), (410, 424 - lift)
        foot_l, foot_r = (285, 465), (435, 465)
        hand_l, hand_r = (302, 350 - lift), (418, 350 - lift)
        draw_arrow(draw, (485, 416), (485, 350))
    elif mode == "band_pull":
        elbow_l = point((312, 282), (270, 240), p)
        elbow_r = point((408, 282), (450, 240), p)
        hand_l = point((334, 270), (230, 232), p)
        hand_r = point((386, 270), (490, 232), p)
        draw.line([hand_l, hand_r], fill=ACCENT, width=6)
        draw_arrow(draw, (335, 196), (252, 196))
        draw_arrow(draw, (385, 196), (468, 196))

    draw.ellipse((head[0] - 34, head[1] - 34, head[0] + 34, head[1] + 34), fill=BODY)
    draw_line(draw, [shoulder, hip], color=BODY, width=16)
    draw_line(draw, [shoulder, elbow_l, hand_l], color=MUSCLE if mode in {"overhead_press", "curl", "band_pull"} else BODY)
    draw_line(draw, [shoulder, elbow_r, hand_r], color=MUSCLE if mode in {"overhead_press", "curl", "band_pull"} else BODY)
    draw_line(draw, [hip, knee_l, foot_l], color=MUSCLE if mode in {"squat", "lunge", "calf_raise"} else BODY)
    draw_line(draw, [hip, knee_r, foot_r], color=MUSCLE if mode in {"squat", "lunge", "calf_raise"} else BODY)


def draw_pushup(draw: ImageDraw.ImageDraw, p: float, plank: bool = False) -> None:
    shoulder = (260, lerp(310, 350, p if not plank else 0))
    hip = (455, lerp(320, 340, p if not plank else 0))
    ankle = (590, lerp(355, 370, p if not plank else 0))
    head = (210, lerp(298, 338, p if not plank else 0))
    elbow = (278, lerp(388, 420, p if not plank else 0))
    hand = (314, 446)
    draw_arrow(draw, (178, 270), (178, 348)) if not plank else draw_arrow(draw, (460, 282), (600, 282))
    draw.ellipse((head[0] - 30, head[1] - 30, head[0] + 30, head[1] + 30), fill=BODY)
    draw_line(draw, [shoulder, hip, ankle], color=MUSCLE if plank else BODY, width=16)
    draw_line(draw, [shoulder, elbow, hand], color=MUSCLE if not plank else BODY, width=13)
    draw_line(draw, [(368, lerp(318, 337, p)), (374, 447)], color=BODY, width=13)
    draw_line(draw, [hip, (575, 448)], color=BODY, width=13)


def draw_hinge(draw: ImageDraw.ImageDraw, p: float, row: bool = False) -> None:
    hip = (370, 358)
    shoulder = point((360, 220), (255, 300), p)
    head = point((360, 150), (205, 250), p)
    knee_l, knee_r = (315, 426), (420, 426)
    foot_l, foot_r = (285, 465), (455, 465)
    elbow_l = point((316, 280), (280, 350), p)
    elbow_r = point((404, 280), (340, 350), p)
    hand_l = point((295, 360), (288, 420), p)
    hand_r = point((425, 360), (348, 420), p)
    if row:
        hand_l = point((290, 422), (315, 330), p)
        hand_r = point((350, 422), (370, 330), p)
        draw_weight(draw, *hand_l)
        draw_weight(draw, *hand_r)
        draw_arrow(draw, (250, 420), (304, 335))
    else:
        draw_arrow(draw, (500, 210), (428, 330))
    draw.ellipse((head[0] - 32, head[1] - 32, head[0] + 32, head[1] + 32), fill=BODY)
    draw_line(draw, [shoulder, hip], color=MUSCLE, width=16)
    draw_line(draw, [shoulder, elbow_l, hand_l], color=MUSCLE if row else BODY, width=13)
    draw_line(draw, [shoulder, elbow_r, hand_r], color=MUSCLE if row else BODY, width=13)
    draw_line(draw, [hip, knee_l, foot_l], color=BODY, width=13)
    draw_line(draw, [hip, knee_r, foot_r], color=BODY, width=13)


def draw_pullup(draw: ImageDraw.ImageDraw, p: float) -> None:
    draw.line((210, 120, 510, 120), fill=ACCENT, width=10)
    y = lerp(318, 236, p)
    shoulder, hip, head = (360, y), (360, y + 120), (360, y - 64)
    hand_l, hand_r = (280, 120), (440, 120)
    elbow_l, elbow_r = point((314, 220), (302, 172), p), point((406, 220), (418, 172), p)
    draw_arrow(draw, (525, 325), (525, 232))
    draw.ellipse((head[0] - 32, head[1] - 32, head[0] + 32, head[1] + 32), fill=BODY)
    draw_line(draw, [shoulder, hip], color=BODY, width=16)
    draw_line(draw, [hand_l, elbow_l, shoulder], color=MUSCLE, width=13)
    draw_line(draw, [hand_r, elbow_r, shoulder], color=MUSCLE, width=13)
    draw_line(draw, [hip, (315, y + 225)], color=BODY, width=13)
    draw_line(draw, [hip, (405, y + 225)], color=BODY, width=13)


def draw_supine(draw: ImageDraw.ImageDraw, p: float, mode: str) -> None:
    if mode == "bridge":
        shoulder = (246, 392)
        hip = (392, lerp(430, 338, p))
        knee = (514, 430)
        foot = (604, 455)
        head = (190, 386)
        draw_arrow(draw, (438, 430), (438, 342))
        draw.ellipse((head[0] - 32, head[1] - 32, head[0] + 32, head[1] + 32), fill=BODY)
        draw_line(draw, [shoulder, hip, knee, foot], color=MUSCLE, width=16)
        draw_line(draw, [shoulder, (238, 458)], color=BODY, width=13)
        draw_line(draw, [(295, 404), (334, 462)], color=BODY, width=13)
    elif mode == "core":
        hip = (360, 390)
        shoulder = point((252, 425), (300, 300), p)
        head = point((202, 420), (260, 255), p)
        knee = point((500, 420), (470, 345), p)
        foot = point((608, 455), (560, 320), p)
        draw_arrow(draw, (205, 382), (275, 292))
        draw.ellipse((head[0] - 30, head[1] - 30, head[0] + 30, head[1] + 30), fill=BODY)
        draw_line(draw, [shoulder, hip], color=MUSCLE, width=16)
        draw_line(draw, [hip, knee, foot], color=BODY, width=13)
        draw_line(draw, [shoulder, (390, 308)], color=BODY, width=12)
    elif mode == "superman":
        shoulder = (270, lerp(374, 340, p))
        hip = (405, 382)
        head = (214, lerp(382, 342, p))
        hand = (154, lerp(398, 320, p))
        foot = (592, lerp(418, 360, p))
        draw_arrow(draw, (182, 430), (165, 332))
        draw_arrow(draw, (570, 452), (590, 366))
        draw.ellipse((head[0] - 30, head[1] - 30, head[0] + 30, head[1] + 30), fill=BODY)
        draw_line(draw, [hand, shoulder, hip, foot], color=MUSCLE, width=15)
        draw_line(draw, [shoulder, (328, lerp(414, 348, p))], color=BODY, width=12)
        draw_line(draw, [hip, (508, 446)], color=BODY, width=12)


def draw_cardio(draw: ImageDraw.ImageDraw, p: float) -> None:
    hip = (360, 330)
    shoulder = (360, 214)
    head = (360, 146)
    arm_spread = lerp(32, 126, p)
    leg_spread = lerp(40, 128, p)
    hand_l, hand_r = (360 - arm_spread, lerp(300, 120, p)), (360 + arm_spread, lerp(300, 120, p))
    foot_l, foot_r = (360 - leg_spread, 465), (360 + leg_spread, 465)
    draw_arrow(draw, (250, 420), (164, 420))
    draw_arrow(draw, (470, 420), (556, 420))
    draw.ellipse((head[0] - 32, head[1] - 32, head[0] + 32, head[1] + 32), fill=BODY)
    draw_line(draw, [shoulder, hip], color=BODY, width=16)
    draw_line(draw, [shoulder, hand_l], color=MUSCLE, width=13)
    draw_line(draw, [shoulder, hand_r], color=MUSCLE, width=13)
    draw_line(draw, [hip, foot_l], color=MUSCLE, width=13)
    draw_line(draw, [hip, foot_r], color=MUSCLE, width=13)


def draw_mobility(draw: ImageDraw.ImageDraw, p: float) -> None:
    hip = (360, 365)
    shoulder = point((360, 238), (288, 292), p)
    head = point((360, 168), (244, 244), p)
    hand = point((310, 326), (182, 418), p)
    knee_l = (290, 440)
    foot_l = (212, 465)
    knee_r = (462, 402)
    foot_r = (548, 465)
    draw_arrow(draw, (286, 210), (190, 352))
    draw.ellipse((head[0] - 31, head[1] - 31, head[0] + 31, head[1] + 31), fill=BODY)
    draw_line(draw, [shoulder, hip], color=MUSCLE, width=16)
    draw_line(draw, [shoulder, hand], color=BODY, width=13)
    draw_line(draw, [hip, knee_l, foot_l], color=BODY, width=13)
    draw_line(draw, [hip, knee_r, foot_r], color=BODY, width=13)


def draw_pattern(pattern: str, p: float) -> Image.Image:
    title, subtitle = PATTERNS[pattern]
    img = base_canvas(title, subtitle)
    draw = ImageDraw.Draw(img)

    if pattern in {"squat", "lunge", "overhead_press", "curl", "carry", "calf_raise", "band_pull"}:
        draw_standing(draw, p, pattern)
    elif pattern == "pushup":
        draw_pushup(draw, p)
    elif pattern == "plank":
        draw_pushup(draw, p, plank=True)
    elif pattern == "hinge":
        draw_hinge(draw, p, row=False)
    elif pattern == "row":
        draw_hinge(draw, p, row=True)
    elif pattern == "pullup":
        draw_pullup(draw, p)
    elif pattern in {"bridge", "core", "superman"}:
        draw_supine(draw, p, pattern)
    elif pattern == "cardio":
        draw_cardio(draw, p)
    elif pattern == "mobility":
        draw_mobility(draw, p)

    return img


def generate() -> None:
    IMAGES.mkdir(parents=True, exist_ok=True)
    VIDEOS.mkdir(parents=True, exist_ok=True)

    for pattern in PATTERNS:
        draw_pattern(pattern, 0.62).save(IMAGES / f"{pattern}.png", optimize=True)

        video_path = VIDEOS / f"generated_{pattern}.mp4"
        with tempfile.TemporaryDirectory(prefix=f"frames_{pattern}_") as tmp:
            frames = Path(tmp)
            total = 72
            for i in range(total):
                draw_pattern(pattern, phase(i, total)).save(frames / f"frame_{i:04d}.png")
            cmd = [
                "ffmpeg",
                "-y",
                "-hide_banner",
                "-loglevel",
                "error",
                "-framerate",
                "24",
                "-i",
                str(frames / "frame_%04d.png"),
                "-vf",
                "format=yuv420p",
                "-c:v",
                "libx264",
                "-pix_fmt",
                "yuv420p",
                "-movflags",
                "+faststart",
                str(video_path),
            ]
            subprocess.run(cmd, check=True)
        print(f"created {video_path.relative_to(ROOT)}")


if __name__ == "__main__":
    generate()
