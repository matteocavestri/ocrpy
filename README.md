# ocrpy

A simple OCR program written in python.

The program runs in both single core and multithread mode. Multithread mode is the default, if you want to use single core, pass the argument `--single` during execution.

Examples:

```bash
python3 ocrpy.py # Multithread execution
python3 ocrpy.py --single # Single core execution
python3 run_cython.py # Multithread Cython execution
python3 run_cython.py --single # Single core Cython execution
```

### Dependencies

- python3
- cython
- tesseract-ocr

Example of installation for Fedora (RPM based)

```bash
sudo dnf install python3 python3-cython tesseract
```

### How to use it --> **Python**

1. Create a Virtual environment

   ```bash
   mkdir venv
   python3 -m venv venv
   ```

2. Install the requirements

   ```bash
   source venv/bin/activate
   pip install -r requirements.txt
   ```

3. Create a folder `input` and copy the files into it

   ```bash
   mkdir input
   ```

4. Run the command `python3 ocrpy.py`

### How to use it --> **Cython**

1. Follow the first three steps of running with Python

2. Compile the Cython code

   ```bash
   python3 setup.py build_ext --inplace
   ```

3. Run the command `python3 run_cython.py`
