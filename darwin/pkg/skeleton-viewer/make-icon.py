#!/usr/bin/env python3
import sys
import xml.etree.ElementTree as ET


def main(input_svg: str, output_svg: str) -> None:
    svg = ET.parse(input_svg)
    root = svg.getroot()

    paths = []
    seen = set()
    for path in root.iter("{http://www.w3.org/2000/svg}path"):
        cls = path.get("class")
        d = path.get("d")
        if cls and "st1" in cls and d and d not in seen:
            paths.append(d)
            seen.add(d)

    W, H = 1024, 1024
    R = 220

    # Approximate bounds of the Spine vertebrae shape in the original 200x200 badge.
    min_x, max_x = 60, 130
    min_y, max_y = 5, 188
    orig_w = max_x - min_x
    orig_h = max_y - min_y

    target_h = H * 0.68
    scale = target_h / orig_h
    target_w = orig_w * scale

    cx = (W - target_w) / 2 - min_x * scale
    cy = (H - target_h) / 2 - min_y * scale

    # Small "Viewer" badge in the bottom-right corner.
    badge_cx, badge_cy = 894, 894
    badge_r = 90
    badge_v = "M 862,860 L 894,920 L 926,860"

    svg_parts = [
        '<?xml version="1.0" encoding="UTF-8"?>',
        f'<svg width="{W}" height="{H}" viewBox="0 0 {W} {H}" xmlns="http://www.w3.org/2000/svg">',
        "  <defs>",
        '    <linearGradient id="bg" x1="0%" y1="0%" x2="0%" y2="100%">',
        '      <stop offset="0%" style="stop-color:#2d2d2d;stop-opacity:1" />',
        '      <stop offset="100%" style="stop-color:#1c1c1c;stop-opacity:1" />',
        "    </linearGradient>",
        '    <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">',
        '      <feDropShadow dx="0" dy="12" stdDeviation="20" flood-color="#000000" flood-opacity="0.3"/>',
        "    </filter>",
        '    <filter id="badgeShadow" x="-50%" y="-50%" width="200%" height="200%">',
        '      <feDropShadow dx="0" dy="6" stdDeviation="8" flood-color="#000000" flood-opacity="0.35"/>',
        "    </filter>",
        "  </defs>",
        f'  <rect x="0" y="0" width="{W}" height="{H}" rx="{R}" ry="{R}" fill="url(#bg)" filter="url(#shadow)"/>',
        f'  <g transform="translate({cx}, {cy}) scale({scale})" fill="#FF4000">',
    ]
    for d in paths:
        svg_parts.append(f'    <path d="{d}"/>')
    svg_parts.extend(
        [
            "  </g>",
            f'  <circle cx="{badge_cx}" cy="{badge_cy}" r="{badge_r}" fill="#FF4000" filter="url(#badgeShadow)"/>',
            f'  <path d="{badge_v}" fill="none" stroke="#FFFFFF" stroke-width="18" stroke-linecap="round" stroke-linejoin="round"/>',
            "</svg>",
        ]
    )

    with open(output_svg, "w") as f:
        f.write("\n".join(svg_parts))
        f.write("\n")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("usage: make-icon.py <input_badge.svg> <output_icon.svg>", file=sys.stderr)
        sys.exit(1)
    main(sys.argv[1], sys.argv[2])
