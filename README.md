![Uploading vision.png…]()
# VisionAI — See the World Through AI

<p align="center">
  <strong>An AI-powered computer vision platform that helps computers understand images.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/AI-Computer%20Vision-black?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Frontend-React-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Backend-FastAPI-green?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Language-Python-yellow?style=for-the-badge" />
</p>

---

## Overview

**VisionAI** is an AI-powered computer vision application designed to bring multiple image-understanding capabilities together in one platform.

From detecting objects and classifying images to extracting text and generating AI-powered descriptions, VisionAI makes it possible to perform several computer vision tasks through a unified interface.

The project combines modern web technologies with machine learning and deep learning models to create an accessible image analysis experience.

## Features

### 1. Object Detection
- Detect objects present in uploaded images.
- Display bounding boxes around detected objects.
- Identify multiple objects in a single image.
- Powered by YOLO-based detection technology.

### 2. Image Classification
- Predict the category of an uploaded image.
- Generate classification results.
- Display prediction information.

### 3. Optical Character Recognition (OCR)
- Extract text from images.
- Process screenshots, documents, and other text-containing images.
- Powered by EasyOCR.

### 4. AI Image Captioning
- Generate natural-language descriptions of images.
- Interpret visual content using an image captioning model.
- Powered by BLIP.

### 5. Flexible Execution
- CPU-based execution support.
- Optional CUDA acceleration on compatible hardware.
- Multiple AI capabilities integrated into one application.

---

## Technology Stack

| Technology | Purpose |
|---|---|
| React 18 | Frontend interface |
| TypeScript | Type-safe frontend development |
| Vite | Frontend development and build tool |
| Python | Backend and AI integration |
| FastAPI | Backend API framework |
| PyTorch | Deep learning framework |
| YOLO11 | Object detection |
| EasyOCR | Text recognition |
| BLIP | Image captioning |

---

## Project Architecture

```text
VisionAI/
│
├── backend/
│   ├── scripts/
│   ├── models/
│   └── ...
│
├── frontend/
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── ...
│
├── models/
│
├── setup.bat
├── run.bat
├── dev.bat
├── test.bat
│
└── README.md
```

*The architecture above is a simplified overview; individual files may vary.*

---

## Getting Started

### Prerequisites

Before installing VisionAI, make sure you have:

- Windows 10 or 11
- Python 3.10–3.12 (64-bit)
- Node.js 18 or newer
- npm
- Approximately 6 GB of available disk space

**Note:** AI model downloads and dependency installation may require additional storage and time. Initial setup can take 10–25 minutes or longer depending on your internet speed and hardware.

### 1. Clone the repository

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

```bash
cd VisionAI
```

### 2. Install dependencies and prepare models

For CPU execution:

```bash
setup.bat cpu
```

For CUDA execution on a compatible NVIDIA GPU:

```bash
setup.bat cuda
```

### 3. Run VisionAI

```bash
run.bat
```

Open the application at:

```text
http://localhost:8000
```

### Development Mode

To run the frontend development server:

```bash
cd frontend
npm install
npm run dev
```

The Vite development server will normally be available at:

```text
http://localhost:5173
```

---

## Performance & Benchmarks

VisionAI includes documented evaluations for individual AI components.

| Evaluation | Result |
|---|---:|
| Object Detection — COCO128 Precision | 0.80 |
| Object Detection — COCO128 Recall | 0.65 |
| Object Detection — COCO128 F1 Score | 0.72 |
| Object Detection — mAP50 | 80.6% |
| Object Detection — mAP50-95 | 63.4% |
| Image Classification — Imagenette Top-1 | 81.5% |
| Image Classification — Imagenette Top-5 | 95.8% |

**Important:** These results represent specific evaluation datasets and tests. They should not be interpreted as a single overall accuracy score for VisionAI.

The OCR documentation also includes a synthetic test with 0% Character Error Rate (CER) and Word Error Rate (WER). This is not a real-world OCR accuracy benchmark.

---

## Screenshots

Add screenshots of the actual application here.

| Dashboard | Object Detection |
|---|---|
| `Add dashboard screenshot` | `Add detection screenshot` |

| OCR | Image Captioning |
|---|---|
| `Add OCR screenshot` | `Add captioning screenshot` |

---

## Roadmap

VisionAI is a project that can continue to evolve.

- [x] Object detection integration
- [x] Image classification integration
- [x] OCR integration
- [x] AI image captioning integration
- [x] CPU execution support
- [x] Optional CUDA support
- [ ] Real-time camera analysis
- [ ] Video understanding
- [ ] More advanced image recognition
- [ ] Improved model performance
- [ ] Additional computer vision capabilities

---

## Why VisionAI?

The idea behind VisionAI is simple:

**Bring multiple computer vision technologies together into one application.**

Instead of building separate applications for object detection, image classification, OCR, and image captioning, VisionAI combines these capabilities into a unified experience.

It is also an exploration of how modern frontend development, backend engineering, and artificial intelligence can work together to create useful software.

---

## Contributing

Contributions, ideas, suggestions, and feedback are welcome.

If you would like to improve VisionAI:

1. Fork the repository.
2. Create a new branch.
3. Make your changes.
4. Submit a pull request.

---


<p align="center">
  <strong>VISIONAI</strong><br/>
  See the World Through AI.
  <br/><br/>
  Built with curiosity, code, and artificial intelligence.
</p>


## Project Owner

**VisionAI** is developed and maintained by **Arsh Nehal**.

- **Discord:** `arsh_nehal`

Feel free to connect for feedback, suggestions, and discussions about the project.
