#!/usr/bin/env python3
"""
Generate impact effect sprite for Master Chief's Adventure game
Creates a 16x16 pixel explosion/impact effect with radial gradient
"""

from PIL import Image, ImageDraw
import math

def create_impact_sprite():
    # Create a 16x16 image with RGBA support
    img = Image.new('RGBA', (16, 16), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Color definitions
    colors = {
        'center': (255, 255, 0, 255),      # Bright yellow
        'inner': (255, 140, 0, 255),       # Orange
        'middle': (255, 0, 0, 255),        # Red
        'outer': (139, 0, 0, 255),         # Dark red
        'edge': (0, 0, 0, 0)               # Transparent
    }
    
    center_x, center_y = 8, 8  # Center of 16x16 image
    
    # Draw radial gradient
    for y in range(16):
        for x in range(16):
            # Calculate distance from center
            distance = math.sqrt((x - center_x)**2 + (y - center_y)**2)
            
            # Determine color based on distance
            if distance <= 2:
                color = colors['center']
            elif distance <= 4:
                color = colors['inner']
            elif distance <= 6:
                color = colors['middle']
            elif distance <= 8:
                color = colors['outer']
            else:
                color = colors['edge']
            
            # Draw pixel
            draw.point((x, y), color)
    
    # Add some variation for more realistic explosion
    # Add bright spots randomly
    import random
    random.seed(42)  # For consistent results
    
    for _ in range(8):
        x = random.randint(4, 12)
        y = random.randint(4, 12)
        distance = math.sqrt((x - center_x)**2 + (y - center_y)**2)
        if distance <= 6:
            # Make some pixels brighter
            current_color = img.getpixel((x, y))
            if current_color[3] > 0:  # If not transparent
                brighter = tuple(min(255, c + 50) for c in current_color[:3]) + (current_color[3],)
                draw.point((x, y), brighter)
    
    return img

def main():
    # Generate the impact sprite
    impact_sprite = create_impact_sprite()
    
    # Save as PNG
    output_path = "assets/impact_placeholder.png"
    impact_sprite.save(output_path, "PNG")
    
    print(f"Impact sprite generated and saved to {output_path}")
    print("Image size: 16x16 pixels")
    print("Format: PNG with transparency")

if __name__ == "__main__":
    main() 