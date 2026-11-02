# VisionAI – image recognition (PyTorch · OpenCV · FastAPI · React + TypeScript)

Upload, drag-and-drop, paste or capture a photo and get:

* **Object detection** – boxes, labels, confidence scores (80 COCO categories: people, animals, vehicles, food, furniture, electronics …)
* **Fine-grained labels** – each detected animal / vehicle / plant / food is re-classified on its crop (e.g. *dog → Samoyed*)
* **Whole-image classification** – top-5 over the 1000 ImageNet classes (dog breeds, birds, vehicle types, some plants and fungi …)
* **OCR** – text with per-line confidence and polygons, in reading order, copy-to-clipboard
* **Description** – an AI caption (BLIP) combined with the detections / classification / OCR text into one description
* **Honest uncertainty** – low-confidence boxes, text and classifications are flagged "uncertain"; blurry / dark / blank / tiny images produce warnings
* GPU (CUDA) when available, automatic CPU fallback; every component fails independently (e.g. no caption model → everything else still works)

## Architecture

```
frontend/ (React 18 + TS + Vite)  ──/api──►  backend/ (FastAPI)
                                               ├─ image_io.py   safe decode: EXIF, alpha, 16-bit, GIF, bomb/size limits, OpenCV quality checks
                                               ├─ models/detector.py    YOLO11 (Ultralytics, PyTorch)
                                               ├─ models/classifier.py  YOLO11-cls (ImageNet-1k) + flip ensemble
                                               ├─ models/ocr.py         EasyOCR (CRAFT + CRNN, PyTorch)
                                               ├─ models/captioner.py   BLIP (Hugging Face Transformers)
                                               ├─ pipeline.py   orchestration, crop refinement, uncertainty rules, fault isolation
                                               └─ manager.py    background model loading, health status, one-at-a-time inference queue
```

| Task | Model | Chosen because |
|---|---|---|
| Detection | `yolo11x` (GPU, 1280 px + TTA) / `yolo11l` (CPU, 640 px) | best COCO accuracy/speed trade-off available as PyTorch weights |
| Classification | `yolo11x-cls` | strongest of its family, tiny cost at 224 px |
| OCR | EasyOCR (English by default) | pure PyTorch, no external binary, 80+ languages |
| Caption | `Salesforce/blip-image-captioning-large` | natural captions, supported natively by Transformers |

## Measured results (real runs – read the caveats)

Measured in the build sandbox: **CPU only (1 thread), no GPU**, detector `yolo11l` @640, server defaults.

| Component | Test | Result |
|---|---|---|
| Detection | COCO128 (128 images, 929 objects), end-to-end through the API, conf ≥ 0.25, IoU ≥ 0.5 | **precision 0.80, recall 0.65, F1 0.72** (603 TP / 150 FP / 326 FN) |
| Detection | same images, standard mAP (conf 0.001) | **mAP50-95 0.634, mAP50 0.806** |
| Classification | 400 Imagenette validation images (10 ImageNet classes, 160 px) | **top-1 81.5 %, top-5 95.8 %**; 34/400 flagged "uncertain", which caught 25 of the 74 errors; accuracy on the un-flagged 366 = 86.6 % |
| OCR | 30 synthetic rendered images (3 fonts, noise, some blur) | CER 0.0 %, WER 0.0 % – **easy test, not a real-world number** |
| OCR | real poster (`ocr_english.png`) and the bus photo | key phrases read correctly (asserted in tests); no real-photo benchmark was run |
| Speed (1 CPU thread) | per image | detect ≈ 0.6–1.1 s, classify ≈ 0.3 s, OCR ≈ 5–13 s (depends on image size) |

**Caveats – do not over-read these numbers**

* COCO128 images come from COCO *train*; Imagenette comes from ImageNet. The models were trained on those datasets, so the numbers are **optimistic**. For unseen data expect lower values; the vendor-published *held-out* figures are mAP50-95 53.4 (YOLO11l) / 54.7 (YOLO11x) on COCO val2017 and 79.5 % top-1 (1000 classes) for YOLO11x-cls on ImageNet val – I did not re-measure those.
* Detection only knows **80 classes**, classification **1000 classes**. Objects outside them (most plant species, brands, rare animals) are missed or mapped to the nearest known class. Plants are the weakest area (ImageNet has only a handful of plant classes).
* Fine-grained crop labels and the generated descriptions were checked on a few images, **not benchmarked**.
* **Not verified in the sandbox** (no network access to huggingface.co, no GPU, no Windows, no browser): BLIP captioning with real weights (the code path and graceful-failure path are tested; the model itself was not run), the CUDA path, `setup.bat`/`run.bat` on a real Windows machine, and the camera. The React UI was verified by type-check, production build, and component tests that render the real app against a *real captured API response* – not by clicking through it in a browser.
* OCR is English by default; set `VISION_OCR_LANGS=en,de` etc. for others.

## Windows installation (step by step)

**Prerequisites**

1. **Python 3.10, 3.11 or 3.12** (64-bit) – <https://www.python.org/downloads/> → tick *“Add python.exe to PATH”* and keep the *py launcher*.
2. **Node.js 18+ (LTS)** – <https://nodejs.org/>
3. *(Optional, for GPU)* an NVIDIA GPU with an up-to-date driver. You do **not** need to install the CUDA toolkit separately.
4. ~6 GB free disk space and an internet connection for the first run (models are downloaded once).

**Install**

1. Unzip the project, e.g. to `C:\visionai`.
2. Open **Command Prompt** in that folder (`cd C:\visionai`).
3. Run `setup.bat` (auto-detects an NVIDIA GPU). Force a mode with `setup.bat cpu` or `setup.bat cuda`.
   It creates `backend\.venv`, installs PyTorch + dependencies, downloads the models and builds the web UI (10–25 min the first time).
   *If the CUDA wheel index in `setup.bat` is rejected for your system, take the matching `pip install … --index-url …` command from <https://pytorch.org/get-started/locally/> and run it with `backend\.venv\Scripts\python.exe -m` in front, then run the remaining steps of setup.bat by hand.*
4. Start the app: `run.bat` – your browser opens <http://localhost:8000>. The status bar shows model loading and whether GPU or CPU is used.

**Day to day**: `run.bat` to start, `Ctrl+C` to stop. `dev.bat` starts the hot-reloading development setup (UI on <http://localhost:5173>). `test.bat` runs all tests.

> The caption model (~1.8 GB) downloads at the end of `setup.bat` (or on first start). If it cannot be downloaded the app still works without captions.

## Configuration (environment variables, set before `run.bat`)

```bat
set VISION_DETECTOR=yolo11x.pt     :: most accurate detector on CPU too (slower). Default: auto (x on GPU, l on CPU)
set VISION_DETECT_IMGSZ=1280       :: better for small objects, slower. Default: auto
set VISION_TTA=on                  :: detector test-time augmentation (slower, slightly more accurate)
set VISION_DEVICE=cpu              :: auto | cpu | cuda | cuda:1
set VISION_ENABLE_CAPTION=0        :: disable BLIP (saves 1.8 GB RAM/disk)
set VISION_ENABLE_OCR=0
set VISION_OCR_LANGS=en,de
set VISION_OCR_MAX_SIDE=2560       :: larger = reads smaller text, slower
set VISION_MAX_UPLOAD_MB=20
```

## API

`POST /api/analyze` (multipart field `file`; query: `tasks=detect,classify,ocr,caption`, `conf`, `iou`, `max_det`, `refine`, `tta`)
`GET /api/health` – model status, device. Interactive docs: <http://localhost:8000/docs>.
Boxes are in **pixels of the original (EXIF-corrected) image** (`image.width × image.height`).
Errors are `{"error":{"code","message"}}`: `invalid_image` 400, `image_too_large` 413, `unsupported_image_type` 415, `image_too_small`/`invalid_options` 422, `server_busy` 429, `models_not_ready` 503. A failing sub-task (e.g. OCR) never fails the request – it is listed in `errors` and the other results are still returned.

## Tests and evaluation

```bat
test.bat                                   :: backend (unit + real-model) and frontend tests
backend\.venv\Scripts\python backend\scripts\fetch_test_data.py --datasets
backend\.venv\Scripts\python backend\scripts\evaluate.py det     :: with the server running (run.bat)
backend\.venv\Scripts\python backend\scripts\evaluate.py cls
backend\.venv\Scripts\python backend\scripts\evaluate.py ocr
backend\.venv\Scripts\python backend\scripts\eval_map.py         :: standard mAP (stop the server first if RAM is tight)
```

## Troubleshooting

* **Status shows “Backend unreachable”** – run.bat is not running or port 8000 is in use.
* **First analysis is slow** – models warm up once; OCR is the slowest step on CPU (untick “Text (OCR)” if not needed).
* **Camera does not start** – allow camera access in the browser; it only works on `localhost` or HTTPS.
* **`CUDA available: False` after setup** – you installed the CPU wheel; re-run `setup.bat cuda` and check your NVIDIA driver (`nvidia-smi`).
* **Out of GPU memory** – the detector automatically retries at 640 px without TTA; otherwise set `VISION_DETECT_IMGSZ=640`.

## Licensing note

Ultralytics YOLO is **AGPL-3.0** (commercial license available from Ultralytics); EasyOCR is Apache-2.0; BLIP weights/code have their own licenses. Check these before distributing or offering the service to others.
