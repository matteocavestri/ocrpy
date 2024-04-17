from setuptools import setup
from Cython.Build import cythonize

setup(
    # Compile the Cython file
    ext_modules=cythonize("ocrpy.pyx", compiler_directives={'language_level': "3"}),
)

