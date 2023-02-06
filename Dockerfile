# YOLOv5 🚀 by Ultralytics, GPL-3.0 license
# Image is CPU-optimized for ONNX, OpenVINO and PyTorch YOLOv5 deployments

# Start FROM Ubuntu image https://hub.docker.com/_/ubuntu
FROM ubuntu:20.04

# Downloads to user config dir
ADD https://ultralytics.com/assets/Arial.ttf https://ultralytics.com/assets/Arial.Unicode.ttf /root/.config/Ultralytics/

# Install linux packages
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt install -y tzdata
RUN apt install --no-install-recommends -y python3-pip git zip curl htop libgl1-mesa-glx libglib2.0-0 libpython3.8-dev
# RUN alias python=python3

# Install pip packages
COPY requirements.txt .
RUN python3 -m pip install --upgrade pip wheel
RUN pip install --no-cache -r requirements.txt albumentations gsutil notebook \
    coremltools onnx onnx-simplifier onnxruntime openvino-dev tensorflow-cpu tensorflowjs \
    --extra-index-url https://download.pytorch.org/whl/cpu

# Create working directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy contents
# COPY . /usr/src/app  (issues as not a .git directory)
RUN git clone https://github.com/ultralytics/yolov5 /usr/src/app

COPY . .

CMD ["python3", "app.py"]