# Use an NVIDIA CUDA base image with Python 3 for GPU support
FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    COMFYUI_PORT=8188 \
    COMFYUI_DIR=/app/ComfyUI

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    python3-venv \
    git \
    build-essential \
    libgl1 \
    && rm -rf /var/lib/apt/lists/*

# Clone ComfyUI repository
RUN git clone https://github.com/sokaikai/ComfyUI.git

# Install Python dependencies
WORKDIR ${COMFYUI_DIR}
RUN python3 -m pip install --upgrade pip && \
    pip install -r requirements.txt

# Optional: Install torch manually for your specific GPU (e.g., CUDA 12.x)
# You can pin specific versions if needed
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Expose port for ComfyUI
EXPOSE ${COMFYUI_PORT}

CMD ["python3", "main.py", "--listen", "0.0.0.0"]