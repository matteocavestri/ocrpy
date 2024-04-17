# Import necessary libraries
import os
import multiprocessing
import argparse
from PIL import Image
import pytesseract
import fitz  # PyMuPDF
import time
from libc.stdlib cimport malloc, free

# Define input and output paths
input_dir = "input"
output_dir = "ocr_output"
png_output_dir = os.path.join(output_dir, "png")
md_output_dir = os.path.join(output_dir, "markdown")
filenames = []

# Function to create output directories if they do not exist
def create_output_directories():
    os.makedirs(png_output_dir, exist_ok=True)
    os.makedirs(md_output_dir, exist_ok=True)

# Function to extract images from a PDF file
def extract_images_from_pdf(char* pdf_file):
    cdef str pdf_path = pdf_file.decode('utf-8')  # Decode to unicode string
    images = []
    cdef int page_num
    with fitz.open(pdf_path) as doc:  # Use the decoded string
        for page_num in range(len(doc)):
            page = doc.load_page(page_num)
            pix = page.get_pixmap()
            image = Image.frombytes("RGB", [pix.width, pix.height], pix.samples)
            image_path = f"{png_output_dir}/{os.path.splitext(os.path.basename(pdf_path))[0]}_page{page_num + 1}.png"
            image.save(image_path)
            images.append(image_path)
    return images

# Function to process an image file using OCR
def process_image_file(char* image_file):
    img = Image.open(image_file)
    text = pytesseract.image_to_string(img)
    base_name = os.path.splitext(os.path.basename(image_file))[0]
    with open(f'{md_output_dir}/{base_name}.md', 'w') as f:
        f.write(text)

# Function to run OCR processing using multiprocessing
def run_multi():
    processes = [multiprocessing.Process(target=process_image_file, args=[filename.encode('utf-8')]) 
                for filename in filenames]
    for process in processes:
        process.start()

    for process in processes:
        process.join()

# Function to run OCR processing in single-core mode
def run_single():
    for filename in filenames:
        process_image_file(filename.encode('utf-8'))

# Main entry point of the script
def main():
    # Parse command-line arguments
    parser = argparse.ArgumentParser(description='OCR processing with multiprocessing or single-core.')
    parser.add_argument('--single', action='store_true', help='Run single-core processing')
    args = parser.parse_args()

    # Create output directories
    create_output_directories()

    # Iterate over files in the input directory
    for file in os.listdir(input_dir):
        file_path = os.path.join(input_dir, file)
        if os.path.isfile(file_path):
            if file.lower().endswith(('.jpg', '.jpeg', '.png')):
                filenames.append(file_path)
            elif file.lower().endswith('.pdf'):
                pdf_images = extract_images_from_pdf(file_path.encode('utf-8'))
                filenames.extend(pdf_images)

    # Run OCR processing based on the chosen mode
    if args.single:
        start = time.perf_counter()
        run_single()
        finish = time.perf_counter()
        print(f'{finish-start: .2f} second(s) for single processing')
    else:
        start = time.perf_counter()
        run_multi()
        finish = time.perf_counter()
        print(f'{finish-start: .2f} second(s) for multiprocessing')

# Call the main function
if __name__ == "__main__":
    main()

