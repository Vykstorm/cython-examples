'''
Example extracted from the official documentation of Cython: https://cython.readthedocs.io/en/latest/src/tutorial/cython_tutorial.html
Execute python setup.py build_ext --inplace to build the extension in the working directory,
and then run this command: python -c "from fib import fib; fib(15)" to test the fibbonaci function defined in the extension

You can do both things with a single command: python setup.py build_ext --inplace && python -c "from fib import fib; fib(15)"
'''

from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize


setup(
    ext_modules=cythonize([
        # Set annotate=True to generate an html that shows C-python interactions
        # annotate=True,
        Extension('queue', ['queue.pyx'],
            # We need to tell distutils the dynamic libraries to use
            # by pointing library locations with the compile flag LDFLAGS
            # or with LD_LIBRARY_PATH environment variable
            libraries=['calg'])
    ])
)
