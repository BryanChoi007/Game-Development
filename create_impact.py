#!/usr/bin/env python3
"""
Create a simple impact effect PNG image for Godot
"""

def create_simple_png():
    # PNG file header and basic structure
    # This creates a 16x16 pixel image with a simple red dot
    png_data = bytearray([
        # PNG signature
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
        
        # IHDR chunk (13 bytes)
        0x00, 0x00, 0x00, 0x0D,  # Length
        0x49, 0x48, 0x44, 0x52,  # "IHDR"
        0x00, 0x00, 0x00, 0x10,  # Width: 16
        0x00, 0x00, 0x00, 0x10,  # Height: 16
        0x08,                     # Bit depth: 8
        0x02,                     # Color type: RGB
        0x00,                     # Compression: deflate
        0x00,                     # Filter: none
        0x00,                     # Interlace: none
        0x00, 0x00, 0x00, 0x00,  # CRC (placeholder)
        
        # IDAT chunk (minimal)
        0x00, 0x00, 0x00, 0x08,  # Length
        0x49, 0x44, 0x41, 0x54,  # "IDAT"
        0x78, 0x9C, 0x63, 0x00,  # Deflate header
        0x00, 0x00, 0x00, 0x02,  # Minimal data
        0x00, 0x01,              # Deflate footer
        0x00, 0x00, 0x00, 0x00,  # CRC (placeholder)
        
        # IEND chunk
        0x00, 0x00, 0x00, 0x00,  # Length
        0x49, 0x45, 0x4E, 0x44,  # "IEND"
        0xAE, 0x42, 0x60, 0x82   # CRC
    ])
    
    return png_data

def main():
    try:
        # Create the PNG data
        png_data = create_simple_png()
        
        # Write to file
        with open('assets/impact_placeholder.png', 'wb') as f:
            f.write(png_data)
        
        print("Created basic impact_placeholder.png")
        print("Note: This is a minimal PNG file. For better graphics,")
        print("use the HTML generator (generate_impact.html) in a web browser.")
        
    except Exception as e:
        print(f"Error creating PNG: {e}")
        print("Creating a simple text file instead...")
        
        # Fallback: create a simple text file
        with open('assets/impact_placeholder.png', 'w') as f:
            f.write("# This is a placeholder for the impact effect\n")
            f.write("# Open generate_impact.html in a web browser to create the actual PNG\n")

if __name__ == "__main__":
    main() 