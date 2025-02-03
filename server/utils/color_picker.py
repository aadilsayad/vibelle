import requests
import io
import numpy as np
from PIL import Image
from sklearn.cluster import KMeans
from collections import Counter
import colorsys

def rgb_to_hex(rgb):
    """Convert RGB tuple to hex color code."""
    return ''.join(f'{int(x):02x}' for x in rgb)

def extract_track_colors(artwork_url, num_colors=20):
    """
    Extract dominant and contrasting colors from an image URL.
    
    Args:
        artwork_url (str): URL of the track's artwork
        num_colors (int, optional): Number of colors to cluster. Defaults to 100.
    
    Returns:
        dict: Dictionary with primary and secondary colors in hex format
    """
    try:
        # Download image from URL
        response = requests.get(artwork_url)
        img = Image.open(io.BytesIO(response.content)).convert('RGB')
        
        # Convert image to numpy array
        np_img = np.array(img)
        pixels = np_img.reshape(-1, 3)
        
        # Perform K-means clustering
        kmeans = KMeans(n_clusters=num_colors, random_state=42)
        kmeans.fit(pixels)
        
        # Process colors
        colors = np.round(kmeans.cluster_centers_).astype(int)
        labels = kmeans.labels_
        color_counts = Counter(labels)
        
        # Sort colors by frequency
        sorted_colors = sorted(
            [(tuple(color), color_counts[i]) for i, color in enumerate(colors)], 
            key=lambda x: x[1], 
            reverse=True
        )
        
        # Select dominant and contrasting colors
        def calculate_contrast(color1, color2):
            hsv1 = colorsys.rgb_to_hsv(*[x/255.0 for x in color1])
            hsv2 = colorsys.rgb_to_hsv(*[x/255.0 for x in color2])
            
            hue_diff = min(abs(hsv1[0] - hsv2[0]), 1 - abs(hsv1[0] - hsv2[0]))
            sat_diff = abs(hsv1[1] - hsv2[1])
            val_diff = abs(hsv1[2] - hsv2[2])
            
            return hue_diff * 0.5 + sat_diff * 0.25 + val_diff * 0.25
        
        dominant_color = sorted_colors[0][0]
        contrast_color = max(
            sorted_colors[1:20], 
            key=lambda x: calculate_contrast(dominant_color, x[0])
        )[0]
        
        return {
            'primary_color': rgb_to_hex(dominant_color),
            'secondary_color': rgb_to_hex(contrast_color)
        }
    
    except Exception as e:
        # Fallback to default colors if extraction fails
        return {
            'primary_color': '5360FD', 
            'secondary_color': '000000'
        }